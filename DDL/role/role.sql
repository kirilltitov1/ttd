create user guest with password 'guest';
create user client with password 'client';
create user admin with password 'admin';

-- GUEST
-- select/insert
create role only_guest;
GRANT select on users to only_guest;
GRANT insert on users to only_guest;

GRANT only_guest TO guest;

create role only_client;

-- CLIENT
-- select
GRANT select on actors to only_client;
GRANT select on filmographies to only_client;
GRANT select on films to only_client;
GRANT select on films_genres to only_client;
GRANT select on genres to only_client;
GRANT select on reviews to only_client;
GRANT select on users to only_client;
GRANT insert on reviews to only_client;
GRANT only_client to client;

create role only_admin;

-- ADMIN

GRANT select on actors to only_admin;
GRANT select on filmographies to only_admin;
GRANT select on films to only_admin;
GRANT select on films_genres to only_admin;
GRANT select on genres to only_admin;
GRANT select on reviews to only_admin;
GRANT select on users to only_admin;

GRANT insert on actors to only_admin;
GRANT insert on filmographies to only_admin;
GRANT insert on films to only_admin;
GRANT insert on films_genres to only_admin;
GRANT insert on genres to only_admin;
GRANT insert on reviews to only_admin;
GRANT insert on users to only_admin;


GRANT delete on actors to only_admin;
GRANT delete on filmographies to only_admin;
GRANT delete on films to only_admin;
GRANT delete on films_genres to only_admin;
GRANT delete on genres to only_admin;
GRANT delete on reviews to only_admin;
GRANT delete on users to only_admin;


