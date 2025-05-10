-- triggers.sql: Trigger functions and triggers for Task 1.2
-- Reference: Context7 Supabase docs (/supabase/supabase)

-- Function to handle new user creation and sync to profiles
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, username, full_name)
  values (new.id, new.raw_user_meta_data ->> 'username', new.raw_user_meta_data ->> 'full_name');
  return new;
end;
$$;

-- Trigger to call handle_new_user after insert on auth.users
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user(); 