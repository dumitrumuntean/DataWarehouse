/*
   This file is dedicated to create all the necessary tables
  in order to be able to perform transform operation
*/

/*
  A table which contains information about members 
  who has invalid age.(18 > age > 100)S
*/
drop table errorAgeTaMember;
create table errorAgeTaMember as (select * 
                                        from changedtaMember where 1 = 0);
/*
  drop dateborn column
  add age column
*/
alter table errorAgeTaMember drop column dateborn;
alter table errorAgeTaMember add age integer;

--set primary key
alter table errorAgeTaMember
  add  constraint coPKerrorAgeTaMember
  primary key (MemberNo);

/*
  A table which contains infromation about members 
  who has valid age. (18 < age < 100)
*/

drop table validAgeTaMember;
create table validAgeTaMember as (select * 
                                        from changedtaMember where 1 = 0);
--set primary key
alter table validAgeTaMember
  add  constraint coPKvalidAgeTaMember
  primary key (MemberNo);

/*
  drop dateborn column
  add age column
*/
alter table  validAgeTaMember drop column dateborn;
alter table validAgeTaMember add age integer;

/*
  transform from date of born into age from changed table without validation
  ,negative ages are set to 0(zero)
*/

/*
  A table which conatins all the members from
  CHANGEDTAMEMEBER table with a new column age 
  instead of date of born column
*/
drop table AgeTaMember;
create table AgeTaMember as (select * 
                                        from changedtaMember where 1 = 0);

--set primary key
alter table AgeTaMember
  add  constraint coPKAgeTaMember
  primary key (MemberNo);

/*
  drop dateborn column
  add age column
*/
alter table  AgeTaMember drop column dateborn;
alter table AgeTaMember add age integer;

/*
  Audit table to register how many member had
  invalid age, and how many of them were aproved
*/
drop table ageMemberAudit;
create table ageMemberAudit(
  id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
  a_date date,                --date when ETL was executed
  total_extracted integer,     --total number of new, changed, deleted members
  dropped integer,            --number of members with invalid age
  valid integer,              --number of member with a valid age
  primary key (id)
);

/*
  A table which conatins all the members from
  CHANGEDTAMEMEBER table with a new 'status' column 
  instead of 4 columns representing each status
*/
drop table statusTaMember;
create table statusTaMember as (select * 
                                        from  VALIDAGETAMEMBER where 1 = 0);

--set primary key
alter table statusTaMember
  add  constraint coPKstatusTaMember
  primary key (MemberNo);

alter table statusTamember drop column statusstudent;
alter table statusTamember drop column statuspilot;
alter table statusTamember drop column statusascat;
alter table statusTamember drop column statusfullcat;

alter table statusTamember add status varchar(50);

/*

*/

drop table leftJoinedTaMember;
create table leftJoinedTaMember as (select * 
                                        from  statusTaMember where 1 = 0);
--set primary key
alter table leftJoinedTaMember
  add  constraint coPKleftJoinedTaMember
  primary key (MemberNo);

--end creating tables