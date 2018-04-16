-----------------Retrieving new, deleted, changed member------------------------

-- new = today PK - yesterday PK
insert into CHANGEDTAMEMBER
select    MEMBERNO,
          INITIALS,
          NAME  ,
          ADDRESS,
          ZIPCODE,
          DATEBORN,
          DATEJOINED,
          DATELEFT,
          OWNSPLANEREG,
          STATUSSTUDENT,
          STATUSPILOT,
          STATUSASCAT,
          STATUSFULLCAT,
          SEX,
          CLUB,
          'NEW' 
          from 
          (
            select * from taMember 
            where memberno not in (select memberno from YESTERDAYTAMEMBER)
          );

--deleted = yesterday PK - today PK   
insert into CHANGEDTAMEMBER
select    MEMBERNO,
          INITIALS,
          NAME  ,
          ADDRESS,
          ZIPCODE,
          DATEBORN,
          DATEJOINED,
          DATELEFT,
          OWNSPLANEREG,
          STATUSSTUDENT,
          STATUSPILOT,
          STATUSASCAT,
          STATUSFULLCAT,
          SEX,
          CLUB,
          'DEL' 
          from 
          (
            select * from YESTERDAYTAMEMBEr 
            where memberno not in (select memberno from taMember)
          );

--changed = rows today - rows yesterday - new elements
insert into CHANGEDTAMEMBER
select    MEMBERNO,
          INITIALS,
          NAME  ,
          ADDRESS,
          ZIPCODE,
          DATEBORN,
          DATEJOINED,
          DATELEFT,
          OWNSPLANEREG,
          STATUSSTUDENT,
          STATUSPILOT,
          STATUSASCAT,
          STATUSFULLCAT,
          SEX,
          CLUB,
          'CH' 
          from 
          (
            select * from (
            select * from taMember                --rows today
            minus                                 --minus
            select * from YESTERDAYTAMEMBER)      -- rows yesterday
            where memberno not in (select memberno from CHANGEDTAMEMBER 
            where operation='NEW'-- minus new
          ));
--changed birthday = rows today - rows yesterday - new elements
insert into CHANGEDTAMEMBER
select    MEMBERNO,
          INITIALS,
          NAME  ,
          ADDRESS,
          ZIPCODE,
          DATEBORN,
          DATEJOINED,
          DATELEFT,
          OWNSPLANEREG,
          STATUSSTUDENT,
          STATUSPILOT,
          STATUSASCAT,
          STATUSFULLCAT,
          SEX,
          CLUB,
          'CH' 
          from 
          (
            select * from (
            select * from taMember                --rows today
            minus                                 --minus
            select * from YESTERDAYTAMEMBER)    -- rows yesterday
            where 
            to_number(to_char(DATEBORN, 'MMDD'))=to_number(to_char(sysdate, 'MMDD')) 
            and
             memberno not in (select memberno from CHANGEDTAMEMBER 
            where operation='NEW' or operation = 'CH'-- minus new and changed
          )); 
-------------------Retrieving new, deleted, changed clubs-----------------------
insert into CHANGEDTACLUB
select MANE,
       ADDRESS,
       ZIPCODE,
       REGION,
       'NEW'
       from(
       select * from TACLUB
       where MANE not in(select MANE from YESTERDAYTACLUB)
       )
       union all
select MANE,
       ADDRESS,
       ZIPCODE,
       REGION,
       'DEL'
       from(
       select * from YESTERDAYTACLUB
       where MANE not in (select MANE from TACLUB)
       );
insert into CHANGEDTACLUB
select MANE,
       ADDRESS,
       ZIPCODE,
       REGION,
       'DEL'
       from(select * from(
       select * from TACLUB
       minus 
       select * from YESTERDAYTACLUB)
       where mane not in(select mane from CHANGEDTACLUB where 
       OPERATION='NEW')
       );

----------------------Retrieving new, deleted Region----------------------------
insert into CHANGEDTAREGION
select NAME,
      'NEW'
      from(
        select * from TAREGION
        minus
        select * from YESTERDAYTAREGION
      )
      union all
select NAME,
      'DEL'
      from(
        select * from YESTERDAYTAREGION
        minus
        select * from TAREGION
      );

---------------Retrieving new from TAFLIGHTSVEJLE--------------------------------
insert into CHANGEDTAFLIGHTSVEJLE
select  LAUNCHTIME
       ,LANDINGTIME
       ,PLANEREGISTRATION
       ,PILOT1INIT
       ,PILOT2INIT
       ,LAUNCHAEROTOW
       ,LAUNCHWINCH
       ,LAUNCHSELFLAUNCH
       ,CABLEBREAK
       ,CROSSCOUNTRYKM
       ,'NEW'
        from(
        select * from TAFLIGHTSVEJLE
        where (LaunchTime, LandingTime, PlaneRegistration) not in (
        select LaunchTime, LandingTime, PlaneRegistration 
        from YESTERDAYTAFLIGHTSVEJLE)
        )
        UNION ALL
select  LAUNCHTIME
       ,LANDINGTIME
       ,PLANEREGISTRATION
       ,PILOT1INIT
       ,PILOT2INIT
       ,LAUNCHAEROTOW
       ,LAUNCHWINCH
       ,LAUNCHSELFLAUNCH
       ,CABLEBREAK
       ,CROSSCOUNTRYKM
       ,'DEL'
        from(
        select * from YESTERDAYTAFLIGHTSVEJLE
        where (LaunchTime, LandingTime, PlaneRegistration) not in (
        select LaunchTime, LandingTime, PlaneRegistration 
        from TAFLIGHTSVEJLE)
        );

--copying from today table into yesterday table
--it should be done after new, changed and deleted rows are found
insert into YESTERDAYTAMEMBER
select * from taMember;


-----------------------------------trucate
truncate table YESTERDAYTAMEMBER;
truncate table CHANGEDTAMEMBER;
truncate table CHANGEDTAFLIGHTSVEJLE;

---------------------------------add and remove information for test
Delete from taMember where memberno='10000';
Delete from taMember where memberno='10001';

insert into taMember (MemberNo, Initials, name, address, zipcode, dateBorn, dateJoined, dateLeft, ownsPlaneReg, statusStudent, statusPilot, statusAsCat, statusFullCat, sex, club ) values(       10000 , 'Dima' , 'Marius' , 'Antonigade, Odense V' ,  5200 , to_date('1965-06-15','YYYY-MM-DD') , to_date('2016-02-05','YYYY-MM-DD') , null , '   ' , 'N' , 'Y' , 'N' , 'N' , 'M' , 'SG70' );
insert into taMember (MemberNo, Initials, name, address, zipcode, dateBorn, dateJoined, dateLeft, ownsPlaneReg, statusStudent, statusPilot, statusAsCat, statusFullCat, sex, club ) values(       10001 , 'Dima' , 'Marius' , 'Antonigade, Odense V' ,  5200 , to_date('1965-04-15','YYYY-MM-DD') , to_date('2016-02-05','YYYY-MM-DD') , null , '   ' , 'N' , 'Y' , 'N' , 'N' , 'M' , 'SG70' );

update taMember set address='greg' where memberno='231';
update taMember set address='greg' where memberno='10000';

---------------------------selects
select * from YESTERDAYTAMEMBER;
select * from CHANGEDTAMEMBER;

---------GETING all columns name------------------
select case column_id
        when 1 then 'select  ' || column_name
        else        '       ,' || column_name
        end
from dba_tab_cols
where owner='DWH'
and table_name='TAFLIGHTSVEJLE';
