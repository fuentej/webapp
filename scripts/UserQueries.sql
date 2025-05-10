-- Should return your profile
select * from profiles where id = '<your-user-id>';

-- Should return nothing (if not your id)
select * from profiles where id = '<someone-elses-user-id>';

-- Should succeed (if your id)
update profiles set full_name = 'Test' where id = '<your-user-id>';

-- Should fail (if not your id)
update profiles set full_name = 'Hacked' where id = '<someone-elses-user-id>';