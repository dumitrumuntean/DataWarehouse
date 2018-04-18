drop table yesterdayTaFlightsSG70;
create table yesterdayTaFlightsSG70 as (select *
                                      from taFlightsSG70 where 1 = 0);
alter table yesterdayTaFlightsSG70
  add  constraint coPKyestedayTaFlightsSG70 
  primary key (LaunchTime, LandingTime, PlaneRegistration);

drop table yesterdayTaFlightsVejle;                                    
create table yesterdayTaFlightsVejle as (select *
                                      from taFlightsVejle where 1 = 0);
alter table yesterdayTaFlightsVejle
  add  constraint coPKyesterdayTaFlightsVejle 
  primary key (LaunchTime, LandingTime, PlaneRegistration);
  
drop table yesterdayTaMember;
create table yesterdayTaMember as (select * 
                                        from taMember where 1 = 0);
alter table yesterdayTaMember
  add  constraint coPKyesterdayTaMember
  primary key (MemberNo);
  
drop table yesterdayTaClub;
create table yesterdayTaClub as (select * 
                                        from taClub where 1 = 0);
alter table yesterdayTaClub
  add  constraint coPKyesterdayTaClub
  primary key (Mane);
  
drop table yesterdayTaRegion;
create table yesterdayTaRegion as (select * 
                                        from taRegion where 1 = 0);
alter table yesterdayTaRegion
  add  constraint coPKyesterdayTaRegion
  primary key (Name);

drop table yesterdayExtPlanes;
create table yesterdayExtPlanes as( select *
                                        from extplanes where 1=0);

drop table yesterdayExtClass;
create table yesterdayExtClass as( select *
                                        from extClass where 1=0);
--------------------------------------------------------------------------
drop table changedTaFlightsSG70;
create table changedTaFlightsSG70 as (select *
                                      from taFlightsSG70 where 1 = 0);
alter table changedTaFlightsSG70 add operation varchar(10);

alter table changedTaFlightsSG70
  add  constraint coPKchangedTaFlightsSG70
  primary key (LaunchTime, LandingTime, PlaneRegistration);

drop table changedTaFlightsVejle;                                    
create table changedTaFlightsVejle as (select *
                                      from taFlightsVejle where 1 = 0);
alter table changedTaFlightsVejle add operation varchar(10);
alter table changedTaFlightsVejle
  add  constraint coPKchangedTaFlightsVejle
  primary key (LaunchTime, LandingTime, PlaneRegistration);

    
drop table changedTaMember;
create table changedTaMember as (select * 
                                        from taMember where 1 = 0);
alter table changedTaMember add operation varchar(10);

alter table changedTaMember
  add  constraint coPKchangedTaMember
  primary key (MemberNo);

drop table changedTaClub;
create table changedTaClub as (select * 
                                        from taClub where 1 = 0);
alter table changedTaClub add operation varchar(10);

alter table changedTaClub
  add  constraint coPKchangedTaClub
  primary key (Mane);

drop table changedTaRegion;
create table changedTaRegion as (select * 
                                        from taRegion where 1 = 0);
alter table changedTaRegion add operation varchar(10);

alter table changedTaRegion
  add  constraint coPKchangedTaRegion
  primary key (Name);

drop table changedExtPlanes;
create table changedExtPlanes as( select *
                                        from extplanes where 1=0);
alter table changedExtPlanes add operation varchar(10);

drop table changedExtClass;
create table changedExtClass as( select *
                                        from extClass where 1=0);
alter table changedExtClass add operation varchar(10);