-- schema.sql: Core tables and relationships for Task 1.2
-- Reference: Context7 Supabase docs (/supabase/supabase)

-- Profiles table
create table public.profiles (
  id uuid references auth.users(id) primary key,
  username text unique not null,
  full_name text,
  bio text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Organizations table
create table public.organizations (
  id bigint primary key generated always as identity,
  name text not null,
  slug text unique not null,
  plan_type text not null check (plan_type in ('free', 'pro', 'enterprise')),
  max_posts int not null default 5,
  created_at timestamptz default now()
);

-- Organization members table
create table public.org_members (
  org_id bigint references public.organizations(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  role text not null check (role in ('owner', 'admin', 'editor', 'viewer')),
  created_at timestamptz default now(),
  primary key (org_id, user_id)
);

-- Posts table
create table public.posts (
  id bigint primary key generated always as identity,
  title text not null,
  content text not null,
  author_id uuid references public.profiles(id) not null,
  org_id bigint references public.organizations(id),
  status text not null check (status in ('draft', 'published', 'archived')),
  is_premium boolean default false,
  scheduled_for timestamptz,
  category text,
  view_count int default 0,
  published_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Comments table
create table public.comments (
  id bigint primary key generated always as identity,
  post_id bigint references public.posts(id) on delete cascade,
  author_id uuid references public.profiles(id),
  content text not null,
  is_deleted boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
); 