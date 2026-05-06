-- ============================================================
-- OCCASI DATABASE SETUP
-- Run in Supabase SQL Editor (Dashboard → SQL Editor → New Query)
-- ============================================================

-- ── USERS ──
create table public.users (
  id uuid references auth.users(id) on delete cascade primary key,
  full_name text,
  email text,
  plan text default 'rsvp',
  plan_status text default 'pending',
  trial_ends_at timestamptz,
  stripe_customer_id text,
  stripe_subscription_id text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- ── SITES ──
create table public.sites (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.users(id) on delete cascade,
  site_type text default 'rsvp',
  template_name text default 'Garden Romance',
  subdomain text unique,
  custom_domain text,
  status text default 'building',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- ── SITE CONTENT ──
create table public.site_content (
  id uuid default gen_random_uuid() primary key,
  site_id uuid references public.sites(id) on delete cascade unique,
  partner_1 text,
  partner_2 text,
  wedding_date date,
  rsvp_deadline date,
  venue_name text,
  venue_address text,
  rsvp_template text default 'Garden Romance',
  web_template text default 'Elegant Ivory',
  tagline text,
  thankyou text,
  colour_palette text,
  photos jsonb default '[]',
  updated_at timestamptz default now()
);

-- ── RSVP RESPONSES ──
create table public.rsvp_responses (
  id uuid default gen_random_uuid() primary key,
  site_id uuid references public.sites(id) on delete cascade,
  guest_first text not null,
  guest_last text not null,
  invite_size integer default 1,
  submitted_at timestamptz default now()
);

-- ── ORDERS (Stripe) ──
create table public.orders (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.users(id) on delete cascade,
  plan text,
  setup_fee integer default 0,
  monthly_fee integer default 0,
  status text default 'pending',
  stripe_session_id text,
  stripe_subscription_id text,
  stripe_payment_intent_id text,
  created_at timestamptz default now()
);

-- ── TEMPLATES (Content Management) ──
create table public.templates (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  type text default 'rsvp',         -- rsvp | website
  category text default 'wedding',  -- wedding | birthday | corporate | etc
  description text,
  preview_color text,
  preview_image_url text,
  tags text[] default array[]::text[],
  status text default 'active',     -- active | draft | archived
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- ── CATEGORIES (Content Management) ──
create table public.categories (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  slug text unique,
  icon text default '📁',
  description text,
  status text default 'coming_soon',  -- live | coming_soon | hidden
  display_order integer default 0,
  created_at timestamptz default now()
);

-- ── DOWNLOADS (Excel templates, PDFs etc) ──
create table public.downloads (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  description text,
  category text,
  file_url text,
  file_type text,
  preview_image_url text,
  price integer default 0,
  is_free boolean default false,
  download_count integer default 0,
  status text default 'active',
  created_at timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
alter table public.users enable row level security;
alter table public.sites enable row level security;
alter table public.site_content enable row level security;
alter table public.rsvp_responses enable row level security;
alter table public.orders enable row level security;
alter table public.templates enable row level security;
alter table public.categories enable row level security;
alter table public.downloads enable row level security;

-- Users
create policy "Users can view own profile" on public.users for select using (auth.uid() = id);
create policy "Users can update own profile" on public.users for update using (auth.uid() = id);

-- Sites
create policy "Users view own sites" on public.sites for select using (auth.uid() = user_id);
create policy "Users update own sites" on public.sites for update using (auth.uid() = user_id);
create policy "Users insert own sites" on public.sites for insert with check (auth.uid() = user_id);

-- Site content
create policy "Users view own content" on public.site_content for select using (site_id in (select id from public.sites where user_id = auth.uid()));
create policy "Users insert own content" on public.site_content for insert with check (site_id in (select id from public.sites where user_id = auth.uid()));
create policy "Users update own content" on public.site_content for update using (site_id in (select id from public.sites where user_id = auth.uid()));

-- RSVP responses
create policy "Anyone submit RSVP" on public.rsvp_responses for insert with check (true);
create policy "Owners view responses" on public.rsvp_responses for select using (site_id in (select id from public.sites where user_id = auth.uid()));

-- Orders
create policy "Users view own orders" on public.orders for select using (auth.uid() = user_id);

-- Templates & Categories: public read
create policy "Anyone can view templates" on public.templates for select using (status = 'active');
create policy "Anyone can view categories" on public.categories for select using (true);
create policy "Anyone can view downloads" on public.downloads for select using (status = 'active');

-- ── ADMIN POLICIES (full access for jansoy55@hotmail.com) ──
create policy "Admin full users" on public.users for all using ((select email from auth.users where id = auth.uid()) = 'jansoy55@hotmail.com');
create policy "Admin full sites" on public.sites for all using ((select email from auth.users where id = auth.uid()) = 'jansoy55@hotmail.com');
create policy "Admin full content" on public.site_content for all using ((select email from auth.users where id = auth.uid()) = 'jansoy55@hotmail.com');
create policy "Admin full responses" on public.rsvp_responses for all using ((select email from auth.users where id = auth.uid()) = 'jansoy55@hotmail.com');
create policy "Admin full orders" on public.orders for all using ((select email from auth.users where id = auth.uid()) = 'jansoy55@hotmail.com');
create policy "Admin full templates" on public.templates for all using ((select email from auth.users where id = auth.uid()) = 'jansoy55@hotmail.com');
create policy "Admin full categories" on public.categories for all using ((select email from auth.users where id = auth.uid()) = 'jansoy55@hotmail.com');
create policy "Admin full downloads" on public.downloads for all using ((select email from auth.users where id = auth.uid()) = 'jansoy55@hotmail.com');

-- ============================================================
-- AUTO CREATE USER PROFILE ON SIGNUP
-- ============================================================
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.users (id, email, full_name, plan, plan_status, trial_ends_at)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data->>'full_name',
    coalesce(new.raw_user_meta_data->>'plan', 'rsvp'),
    case when new.raw_user_meta_data->>'plan' = 'bundle' then 'trial' else 'pending' end,
    case when new.raw_user_meta_data->>'trial_ends_at' is not null
         then (new.raw_user_meta_data->>'trial_ends_at')::timestamptz else null end
  );
  return new;
end;
$$;

create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

-- ============================================================
-- SEED INITIAL CATEGORIES
-- ============================================================
insert into public.categories (name, slug, icon, description, status, display_order) values
  ('Weddings', 'weddings', '💒', 'Beautiful RSVP forms & full wedding websites', 'live', 1),
  ('Birthdays', 'birthdays', '🎂', 'Party invites, RSVPs & celebration pages', 'coming_soon', 2),
  ('Corporate', 'corporate', '💼', 'Professional event pages & registrations', 'coming_soon', 3),
  ('Graduations', 'graduations', '🎓', 'Celebrate the big milestone in style', 'coming_soon', 4),
  ('Baby Showers', 'baby-showers', '🍼', 'Cute & playful invites for new arrivals', 'coming_soon', 5),
  ('Engagements', 'engagements', '💍', 'Announce your big news beautifully', 'coming_soon', 6),
  ('Excel Tools', 'excel-tools', '📊', 'Smart templates & automated spreadsheets', 'coming_soon', 7),
  ('Templates', 'templates', '📄', 'Professional docs, contracts & more', 'coming_soon', 8);
