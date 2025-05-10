-- rls_policies.sql: Idempotent RLS policies for Task 1.2
-- Reference: Context7 Supabase docs (/supabase/supabase)
-- This script is safe to run multiple times; it will not error if policies already exist.

-- Enable RLS if not already enabled
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_policy WHERE polrelid = 'public.profiles'::regclass) THEN
    ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
  END IF;
END
$$ LANGUAGE plpgsql;
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_policy WHERE polrelid = 'public.posts'::regclass) THEN
    ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
  END IF;
END
$$ LANGUAGE plpgsql;
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_policy WHERE polrelid = 'public.org_members'::regclass) THEN
    ALTER TABLE public.org_members ENABLE ROW LEVEL SECURITY;
  END IF;
END
$$ LANGUAGE plpgsql;
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_policy WHERE polrelid = 'public.comments'::regclass) THEN
    ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
  END IF;
END
$$ LANGUAGE plpgsql;

-- Create policies only if they do not exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policy WHERE polname = 'Users can access their own profile' AND polrelid = 'public.profiles'::regclass) THEN
    CREATE POLICY "Users can access their own profile" ON public.profiles
      FOR ALL TO authenticated
      USING ((select auth.uid()) = id);
  END IF;
END
$$ LANGUAGE plpgsql;

-- Posts: Authors can update and delete their posts (split policies)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policy WHERE polname = 'Authors can update their posts' AND polrelid = 'public.posts'::regclass) THEN
    CREATE POLICY "Authors can update their posts" ON public.posts
      FOR UPDATE TO authenticated
      USING ((select auth.uid()) = author_id);
  END IF;
END
$$ LANGUAGE plpgsql;
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policy WHERE polname = 'Authors can delete their posts' AND polrelid = 'public.posts'::regclass) THEN
    CREATE POLICY "Authors can delete their posts" ON public.posts
      FOR DELETE TO authenticated
      USING ((select auth.uid()) = author_id);
  END IF;
END
$$ LANGUAGE plpgsql;
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policy WHERE polname = 'All authenticated can read posts' AND polrelid = 'public.posts'::regclass) THEN
    CREATE POLICY "All authenticated can read posts" ON public.posts
      FOR SELECT TO authenticated
      USING (true);
  END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policy WHERE polname = 'Users can access their org memberships' AND polrelid = 'public.org_members'::regclass) THEN
    CREATE POLICY "Users can access their org memberships" ON public.org_members
      FOR ALL TO authenticated
      USING ((select auth.uid()) = user_id);
  END IF;
END
$$ LANGUAGE plpgsql;

-- Comments: Authors can update and delete their comments (split policies)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policy WHERE polname = 'Authors can update their comments' AND polrelid = 'public.comments'::regclass) THEN
    CREATE POLICY "Authors can update their comments" ON public.comments
      FOR UPDATE TO authenticated
      USING ((select auth.uid()) = author_id);
  END IF;
END
$$ LANGUAGE plpgsql;
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policy WHERE polname = 'Authors can delete their comments' AND polrelid = 'public.comments'::regclass) THEN
    CREATE POLICY "Authors can delete their comments" ON public.comments
      FOR DELETE TO authenticated
      USING ((select auth.uid()) = author_id);
  END IF;
END
$$ LANGUAGE plpgsql;
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policy WHERE polname = 'All authenticated can read comments' AND polrelid = 'public.comments'::regclass) THEN
    CREATE POLICY "All authenticated can read comments" ON public.comments
      FOR SELECT TO authenticated
      USING (true);
  END IF;
END
$$ LANGUAGE plpgsql; 