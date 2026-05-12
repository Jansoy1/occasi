-- ============================================================
-- OCCASI — COMPLETE DATABASE SETUP
-- Safe to re-run on existing data. Adds missing columns to old tables.
-- Run in Supabase: SQL Editor → New Query → Paste → Run
-- ============================================================

-- 1. DROP EXISTING POLICIES (clean slate for RLS)
do $$
declare r record;
begin
  for r in (
    select schemaname, tablename, policyname
    from pg_policies
    where schemaname = 'public'
  ) loop
    execute format('drop policy if exists %I on %I.%I', r.policyname, r.schemaname, r.tablename);
  end loop;
end $$;

-- 2. CREATE TABLES (if not exists)
create table if not exists public.users (
  id uuid primary key references auth.users on delete cascade,
  email text unique not null,
  full_name text,
  plan text default 'rsvp',
  created_at timestamptz default now()
);

create table if not exists public.sites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  template_name text,
  subdomain text unique,
  status text default 'draft',
  created_at timestamptz default now()
);

create table if not exists public.site_content (
  id uuid primary key default gen_random_uuid(),
  site_id uuid unique,
  partner_1 text,
  partner_2 text,
  wedding_date date,
  rsvp_deadline date,
  venue_name text,
  tagline text,
  invite_size_default integer default 2,
  updated_at timestamptz default now()
);

create table if not exists public.rsvp_responses (
  id uuid primary key default gen_random_uuid(),
  site_id uuid,
  guest_first text,
  guest_last text,
  attending boolean default true,
  invite_size integer default 1,
  created_at timestamptz default now()
);

-- 3. ADD MISSING COLUMNS TO EXISTING TABLES (this fixes the schema cache error!)
alter table public.site_content add column if not exists invite_size_default integer default 2;
alter table public.site_content add column if not exists rsvp_deadline date;
alter table public.site_content add column if not exists tagline text;
alter table public.site_content add column if not exists venue_name text;
alter table public.site_content add column if not exists partner_1 text;
alter table public.site_content add column if not exists partner_2 text;
alter table public.site_content add column if not exists wedding_date date;

alter table public.rsvp_responses add column if not exists attending boolean default true;
alter table public.rsvp_responses add column if not exists invite_size integer default 1;
alter table public.rsvp_responses add column if not exists guest_first text;
alter table public.rsvp_responses add column if not exists guest_last text;

alter table public.sites add column if not exists template_name text;
alter table public.sites add column if not exists subdomain text;
alter table public.sites add column if not exists status text default 'draft';

-- 4. FIX FOREIGN KEYS (point to auth.users directly)
alter table public.sites drop constraint if exists sites_user_id_fkey;
alter table public.sites
  add constraint sites_user_id_fkey
  foreign key (user_id) references auth.users(id) on delete cascade;

alter table public.site_content drop constraint if exists site_content_site_id_fkey;
alter table public.site_content
  add constraint site_content_site_id_fkey
  foreign key (site_id) references public.sites(id) on delete cascade;

alter table public.rsvp_responses drop constraint if exists rsvp_responses_site_id_fkey;
alter table public.rsvp_responses
  add constraint rsvp_responses_site_id_fkey
  foreign key (site_id) references public.sites(id) on delete cascade;

-- 5. ENABLE RLS
alter table public.users enable row level security;
alter table public.sites enable row level security;
alter table public.site_content enable row level security;
alter table public.rsvp_responses enable row level security;

-- 6. POLICIES

-- USERS — users manage own row
create policy "Users own select" on public.users
  for select using (auth.uid() = id);
create policy "Users own insert" on public.users
  for insert with check (auth.uid() = id);
create policy "Users own update" on public.users
  for update using (auth.uid() = id);

-- SITES — owner full access, anyone reads live ones
create policy "Sites owner select" on public.sites
  for select to authenticated using (auth.uid() = user_id);
create policy "Sites public read live" on public.sites
  for select to anon, authenticated using (status = 'live');
create policy "Sites owner insert" on public.sites
  for insert to authenticated with check (auth.uid() = user_id);
create policy "Sites owner update" on public.sites
  for update to authenticated using (auth.uid() = user_id);
create policy "Sites owner delete" on public.sites
  for delete to authenticated using (auth.uid() = user_id);

-- SITE_CONTENT — owner full access, anyone reads for live sites
create policy "Content owner select" on public.site_content
  for select to authenticated using (
    exists (select 1 from public.sites s where s.id = site_content.site_id and s.user_id = auth.uid())
  );
create policy "Content public read live" on public.site_content
  for select to anon, authenticated using (
    exists (select 1 from public.sites s where s.id = site_content.site_id and s.status = 'live')
  );
create policy "Content owner insert" on public.site_content
  for insert to authenticated with check (
    exists (select 1 from public.sites s where s.id = site_content.site_id and s.user_id = auth.uid())
  );
create policy "Content owner update" on public.site_content
  for update to authenticated using (
    exists (select 1 from public.sites s where s.id = site_content.site_id and s.user_id = auth.uid())
  );

-- RSVP_RESPONSES — owners see their own, ANY guest can insert if site is live
create policy "RSVP owner select" on public.rsvp_responses
  for select to authenticated using (
    exists (select 1 from public.sites s where s.id = rsvp_responses.site_id and s.user_id = auth.uid())
  );
create policy "RSVP anyone insert" on public.rsvp_responses
  for insert to anon, authenticated with check (
    exists (select 1 from public.sites s where s.id = rsvp_responses.site_id and s.status = 'live')
  );

-- 7. AUTO-CREATE USER ROW ON SIGNUP
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, email, full_name, plan)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data->>'plan', 'rsvp')
  )
  on conflict (id) do nothing;
  return new;
exception when others then
  raise warning 'handle_new_user failed: %', sqlerrm;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 8. BACKFILL any auth users missing from public.users
insert into public.users (id, email, full_name, plan)
select au.id, au.email,
  coalesce(au.raw_user_meta_data->>'full_name', split_part(au.email, '@', 1)),
  coalesce(au.raw_user_meta_data->>'plan', 'rsvp')
from auth.users au
where not exists (select 1 from public.users u where u.id = au.id)
on conflict (id) do nothing;

-- 9. REFRESH SCHEMA CACHE (forces PostgREST to see new columns immediately)
notify pgrst, 'reload schema';

-- 10. VERIFICATION
select
  (select count(*) from auth.users)            as auth_users,
  (select count(*) from public.users)          as public_users,
  (select count(*) from public.sites)          as sites,
  (select count(*) from public.rsvp_responses) as rsvps,
  (select count(*) from information_schema.columns
    where table_schema = 'public' and table_name = 'site_content'
    and column_name = 'invite_size_default')   as invite_size_col,
  'invite_size_col should = 1 — if so, you are good!' as status;
