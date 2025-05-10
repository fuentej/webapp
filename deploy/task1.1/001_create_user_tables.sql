-- 001_create_user_tables.sql
-- User profile and identity tables for Supabase auth (future-proof for social login and account linking)

-- Main user profile table
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Table to track multiple auth identities per user
create table if not exists user_identities (
  id bigserial primary key,
  user_id uuid references profiles(id) on delete cascade,
  provider text not null, -- e.g., 'email', 'google', 'github'
  provider_user_id text not null, -- e.g., sub from OAuth, or email
  email text,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  unique (provider, provider_user_id)
); 

alter table profiles enable row level security;
alter table user_identities enable row level security;

-- Allow users to view their own profile
create policy "Users can view their own profile"
  on profiles
  for select
  using ((select auth.uid()) = id);

-- Allow users to update their own profile
create policy "Users can update their own profile"
  on profiles
  for update
  using ((select auth.uid()) = id);

-- Allow users to insert their own profile (optional, for custom flows)
create policy "Users can insert their own profile"
  on profiles
  for insert
  with check ((select auth.uid()) = id);

-- Allow users to view their own identities
create policy "Users can view their own identities"
  on user_identities
  for select
  using ((select auth.uid()) = user_id);

-- Allow users to update their own identities
create policy "Users can update their own identities"
  on user_identities
  for update
  using ((select auth.uid()) = user_id);

-- Allow users to insert their own identity (optional)
create policy "Users can insert their own identity"
  on user_identities
  for insert
  with check ((select auth.uid()) = user_id);