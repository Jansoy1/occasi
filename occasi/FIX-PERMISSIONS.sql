-- ============================================================
-- OCCASI — FIX FOR "permission denied for table users"
-- Run this in Supabase SQL Editor (SQL → New Query → paste → Run)
-- Safe to run even if some bits already exist
-- ============================================================

-- 1. Add missing INSERT policy on users table
-- (the auto-create trigger was failing without this)
drop policy if exists "Users can insert own profile" on public.users;
create policy "Users can insert own profile" on public.users
  for insert with check (auth.uid() = id);

-- 2. Make the auto-create trigger more robust + idempotent
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, email, full_name, plan, plan_status, trial_ends_at)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data->>'plan', 'rsvp'),
    'pending',
    case
      when new.raw_user_meta_data->>'trial_ends_at' is not null
      then (new.raw_user_meta_data->>'trial_ends_at')::timestamptz
      else null
    end
  )
  on conflict (id) do nothing;
  return new;
exception
  when others then
    -- log but don't block signup
    raise warning 'handle_new_user failed: %', sqlerrm;
    return new;
end;
$$;

-- 3. Recreate the trigger to use updated function
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 4. BACKFILL — copy any auth users that aren't in public.users yet
-- This catches all the broken signups so far
insert into public.users (id, email, full_name, plan, plan_status)
select
  au.id,
  au.email,
  coalesce(au.raw_user_meta_data->>'full_name', split_part(au.email, '@', 1)),
  coalesce(au.raw_user_meta_data->>'plan', 'rsvp'),
  'pending'
from auth.users au
where not exists (select 1 from public.users u where u.id = au.id)
on conflict (id) do nothing;

-- 5. Verify everything worked
-- (this last query is just informational - it'll show you what got fixed)
select
  (select count(*) from auth.users) as auth_users_count,
  (select count(*) from public.users) as public_users_count,
  (select count(*) from public.sites) as sites_count;
