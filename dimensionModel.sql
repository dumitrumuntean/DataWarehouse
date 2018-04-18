
drop table D_LaunchMethod;
create table D_LaunchMethod(
id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
launch_method varchar2(20),
primary key(id)
);

drop table d_club cascade constraints;

create table d_club(
id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
club_name varchar2(50),
address varchar2(100),
zipcode INTEGER,
region varchar2(50),
primary key (id)
);

drop table d_member cascade constraints;
create table d_member(
id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) ,
primary key(id)
);

drop table d_memberprofile cascade constraints;
create table d_memberprofile(
id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) ,
member_id integer,
first_name varchar2(20),
last_name varchar2(20),
age decimal(3,1),
member_status varchar2(50),
sex char(1) constraint sex_constraint check(sex in('M','F')),
primary key(id)
);

drop table d_plane cascade constraints;
create table d_plane(
id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
registration varchar2(20),
type varchar2(20),
no_of_seats integer,
has_engine char(1) constraint has_engine_constraint check(has_engine in('Y','N')),
class varchar2(20),
primary key (id)
);

drop table f_flight cascade constraints;
create table  f_flight(
id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
d_club integer,
d_plane integer,
launch_time integer,
landing_time integer,
ddate integer,
primary key(id),
constraint fk_club foreign key(d_club) references d_club(id),
constraint fk_plane foreign key(d_plane) references d_plane(id),
constraint fk_launch foreign key (launch_time) references d_time(id),
constraint fk_landing foreign key (landing_time) references d_time(id),
constraint fk_date foreign key (ddate) references d_date(id)
);

drop table f_membership cascade constraints;
create table f_membership(
id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
member_id integer,
club_id integer,
date_from integer,
date_to integer,
primary key(id),
constraint fk_memberid foreign key(member_id) references d_member(id),
constraint fk_clubid foreign key(club_id) references d_club(id),
constraint fk_datefrom foreign key(date_from) references d_date(id),
constraint fk_dateto foreign key(date_to) references d_date(id)
);

drop table f_ownership cascade constraints;
create table f_ownership(
id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
member_id integer,
plane_id integer,
date_from integer,
date_to integer,
primary key(id),
constraint fk_owner_member foreign key(member_id) references d_member(id),
constraint fk_owns_plane foreign key(plane_id) references d_plane(id),
constraint fk_from foreign key(date_from) references d_date(id),
constraint fk_to foreign key(date_to) references d_date(id)
);

drop table f_club_ownership cascade constraints;
create table f_club_ownership(
id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
club_id integer,
plane_id integer,
date_from integer,
date_to integer,
primary key(id),
constraint fk_clubownership foreign key(club_id) references d_club(id),
constraint fk_club_owns_plane foreign key(plane_id) references d_plane(id),
constraint fk_dfrom foreign key(date_from) references d_date(id),
constraint fk_dto foreign key(date_to) references d_date(id)
);

