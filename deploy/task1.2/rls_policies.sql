-- rls_policies.sql: Row Level Security policies for Task 1.2
-- Reference: Context7 Supabase docs (/supabase/supabase)

-- Enable RLS on all user-facing tables
alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.org_members enable row level security;
alter table public.comments enable row level security;

-- Profiles: Only owners can access and modify their profile
create policy "Users can access their own profile" on public.profiles
  for all to authenticated
  using ((select auth.uid()) = id);

-- Posts: Only authors can modify, all authenticated can read
create policy "Authors can modify their posts" on public.posts
  for update, delete to authenticated
  using ((select auth.uid()) = author_id);
create policy "All authenticated can read posts" on public.posts
  for select to authenticated
  using (true);

-- Org Members: Only members can access their org membership
create policy "Users can access their org memberships" on public.org_members
  for all to authenticated
  using ((select auth.uid()) = user_id);

-- Comments: Only authors can modify, all authenticated can read
create policy "Authors can modify their comments" on public.comments
  for update, delete to authenticated
  using ((select auth.uid()) = author_id);
create policy "All authenticated can read comments" on public.comments
  for select to authenticated
  using (true); 