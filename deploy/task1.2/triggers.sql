-- triggers.sql: Idempotent trigger functions and triggers for Task 1.2
-- Reference: Context7 Supabase docs (/supabase/supabase)
-- This script is safe to run multiple times; it will not error if functions or triggers already exist.

-- Create function only if it does not exist
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_proc WHERE proname = 'handle_new_user' AND pronamespace = 'public'::regnamespace
  ) THEN
    CREATE FUNCTION public.handle_new_user()
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
  END IF;
END $$;

-- Create trigger only if it does not exist
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'on_auth_user_created'
  ) THEN
    CREATE TRIGGER on_auth_user_created
      AFTER INSERT ON auth.users
      FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
  END IF;
END $$; 