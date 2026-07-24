-- Security hardening for an existing SE Price Intelligence Supabase project.
-- Run once in Supabase Dashboard -> SQL Editor.

-- Public Auth signups must not become approved application users.
alter table public.profiles alter column disabled set default true;

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, display_name, disabled)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email,'@',1)),
    true
  )
  on conflict (id) do nothing;
  return new;
end $$;

create or replace function public.is_active_user()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and not disabled
  );
$$;

-- Only the current profile and admins may see profile/email records.
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select to authenticated
  using (id = (select auth.uid()) or (select public.is_admin()));

-- Authentication alone is insufficient: shared commercial data requires an
-- explicitly approved, active profile.
drop policy if exists shared_read on public.shared_kv;
create policy shared_read on public.shared_kv
  for select to authenticated
  using ((select public.is_active_user()));

drop policy if exists user_kv_owner on public.user_kv;
create policy user_kv_owner on public.user_kv
  for all to authenticated
  using (
    owner_id = (select auth.uid())
    and (select public.is_active_user())
  )
  with check (
    owner_id = (select auth.uid())
    and (select public.is_active_user())
  );

drop policy if exists audit_insert on public.audit_log;
create policy audit_insert on public.audit_log
  for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and (select public.is_active_user())
  );
