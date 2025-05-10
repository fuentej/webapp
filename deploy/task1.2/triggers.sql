-- triggers.sql: Idempotent trigger functions and triggers for Task 1.2
-- Reference: Context7 Supabase docs (/supabase/supabase)
-- This script is safe to run multiple times; it will not error if functions or triggers already exist.

-- Create or replace the trigger function
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.profiles (id, username, full_name)
  VALUES (NEW.id, NEW.raw_user_meta_data ->> 'username', NEW.raw_user_meta_data ->> 'full_name');
  RETURN NEW;
END;
$$;

-- Drop and recreate the trigger (idempotent)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user(); 