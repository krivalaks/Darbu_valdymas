-- Paleiskite šį SQL Supabase projekto SQL Editor lange.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text default '',
  assignee_id uuid references public.profiles(id) on delete set null,
  due_date date not null,
  status text not null default 'open' check (status in ('open','done')),
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.tasks enable row level security;

create policy "Signed-in users can view profiles" on public.profiles
for select to authenticated using (true);
create policy "Users can create own profile" on public.profiles
for insert to authenticated with check (auth.uid() = id);
create policy "Users can update own profile" on public.profiles
for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

create policy "Signed-in users can view tasks" on public.tasks
for select to authenticated using (true);
create policy "Signed-in users can add tasks" on public.tasks
for insert to authenticated with check (auth.uid() = created_by);
create policy "Signed-in users can update tasks" on public.tasks
for update to authenticated using (true) with check (true);
create policy "Signed-in users can delete tasks" on public.tasks
for delete to authenticated using (true);

-- Automatiškai sukuria darbuotojo profilį po registracijos.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', split_part(new.email, '@', 1)));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();