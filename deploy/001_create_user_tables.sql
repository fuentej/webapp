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