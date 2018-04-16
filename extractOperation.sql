-----------------Retrieving new, deleted, changed member------------------------
select 'Extract process at: ' || to_char(sysdate,'YYYY-MM-DD HH24:MI') as extractTime
  from dual
  ;

select 'Extract Members : ' 
  from dual
  ;
  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDTAMEMBER
union all
  select 'Rows in Members table  : ' || to_char(count(*))
   from taMember
union all
  select 'Rows in Members table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYTAMEMBER
 ;
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
            select * from taMember                --rows today
            where 
            to_number(to_char(DATEBORN, 'MMDD'))=to_number(to_char(sysdate, 'MMDD')) 
            and
             memberno not in (select memberno from CHANGEDTAMEMBER 
            where operation='NEW' or operation = 'CH'-- minus new and changed
          )); 

truncate table YESTERDAYTAMEMBER;

INSERT INTO YESTERDAYTAMEMBER
SELECT * 
FROM TAMEMBER
;

commit
;

select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDTAMEMBER
 group by operation
 ;
 
-------------------Retrieving new, deleted, changed clubs-----------------------
select 'Extract Club : ' 
  from dual
  ;
  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDTACLUB
union all
  select 'Rows in club table  : ' || to_char(count(*))
   from taClub
union all
  select 'Rows in CLUB table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYTACLUB
 ;

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

truncate table YESTERDAYTACLUB;

INSERT INTO YESTERDAYTACLUB
SELECT * 
FROM TACLUB
;

commit
;

select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDTACLUB
 group by operation
 ;
----------------------Retrieving new, deleted Region----------------------------
select 'Extract Region : ' 
  from dual
  ;
  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDTAREGION
union all
  select 'Rows in REGION table  : ' || to_char(count(*))
   from taRegion
union all
  select 'Rows in REGION table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYTAREGION
 ;

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

truncate table YESTERDAYTAREGION;

INSERT INTO YESTERDAYTAREGION
SELECT * 
FROM TAREGION
;

commit
;

select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDTAREGION
 group by operation
 ;
---------------Retrieving new from TAFLIGHTSVEJLE--------------------------------
select 'Extract FLIGHTS VEJLE : ' 
  from dual
  ;
  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDTAFLIGHTSVEJLE
union all
  select 'Rows in FLIGHTS VEJLE table  : ' || to_char(count(*))
   from TAFLIGHTSVEJLE
union all
  select 'Rows in FLIGHTS VEJLE table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYTAFLIGHTSVEJLE
 ;

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
       ,'CH'
        from(
          select * from(
                    select * from TAFLIGHTSVEJLE
                    minus
                    select * from YESTERDAYTAFLIGHTSVEJLE
          )where (LaunchTime, LandingTime, PlaneRegistration) not in
          (select LaunchTime, LandingTime, PlaneRegistration 
              from CHANGEDTAFLIGHTSVEJLE where operation='NEW')
        );

truncate table YESTERDAYTAFLIGHTSVEJLE;

INSERT INTO YESTERDAYTAFLIGHTSVEJLE
SELECT * 
FROM TAFLIGHTSVEJLE
;

commit
;

select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDTAFLIGHTSVEJLE
 group by operation
 ;
---------------Retrieving new from TAFLIGHTSSG70--------------------------------
select 'Extract FLIGHTS SG70 : ' 
  from dual
  ;
  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDTAFLIGHTSVEJLE
union all
  select 'Rows in FLIGHTS SG70 table  : ' || to_char(count(*))
   from TAFLIGHTSVEJLE
union all
  select 'Rows in FLIGHTS SG70 table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYTAFLIGHTSVEJLE
 ;

insert into CHANGEDTAFLIGHTSSG70
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
        select * from TAFLIGHTSSG70
        where (LaunchTime, LandingTime, PlaneRegistration) not in (
        select LaunchTime, LandingTime, PlaneRegistration 
        from YESTERDAYTAFLIGHTSSG70)
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
        select * from YESTERDAYTAFLIGHTSSG70
        where (LaunchTime, LandingTime, PlaneRegistration) not in (
        select LaunchTime, LandingTime, PlaneRegistration 
        from TAFLIGHTSSG70)
        );

insert into CHANGEDTAFLIGHTSSG70
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
       ,'CH'
        from(
          select * from(
                    select * from TAFLIGHTSSG70
                    minus
                    select * from YESTERDAYTAFLIGHTSSG70
          )where (LaunchTime, LandingTime, PlaneRegistration) not in
          (select LaunchTime, LandingTime, PlaneRegistration 
              from CHANGEDTAFLIGHTSSG70 where operation='NEW')
        );

truncate table YESTERDAYTAFLIGHTSSG70;

INSERT INTO YESTERDAYTAFLIGHTSSG70
SELECT * 
FROM TAFLIGHTSSG70
;
commit
;

select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDTAFLIGHTSSG70
 group by operation
 ;

--------------------Changed, new, deleted external planes-----------------------
select 'Extract EXTERNAL PLANES : ' 
  from dual
  ;
  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDEXTPLANES
union all
  select 'Rows in EXTERNAL PLANES table  : ' || to_char(count(*))
   from EXTPLANES
union all
  select 'Rows in EXTERNAL PLANES table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYEXTPLANES
 ;

insert into  CHANGEDEXTPLANES
select  REGISTRATION
       ,COMPETITIONNUMBER
       ,TYPE
       ,CLUBOWNED
       ,OWNERNAME
       , 'NEW'
       from(
        select * from EXTPLANES where REGISTRATION not in (
        select REGISTRATION from YESTERDAYEXTPLANES 
        )
       );

insert into  CHANGEDEXTPLANES
select  REGISTRATION
       ,COMPETITIONNUMBER
       ,TYPE
       ,CLUBOWNED
       ,OWNERNAME
       , 'CH'
       from(
          select * from (
            select * from EXTPLANES
            minus
            select * from YESTERDAYEXTPLANES
          )where REGISTRATION not in (
            select REGISTRATION from CHANGEDEXTPLANES
            where operation='NEW'
          )
       );
truncate table YESTERDAYEXTPLANES;

INSERT INTO YESTERDAYEXTPLANES
SELECT * 
FROM EXTPLANES
;
commit
;

select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDEXTPLANES
 group by operation
 ;
-----------------Changed, new , deleted external class--------------------------
select 'Extract EXTERNAL CLASS : ' 
  from dual
  ;
  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDEXTCLASS
union all
  select 'Rows in EXTERNAL CLASS table  : ' || to_char(count(*))
   from EXTCLASS
union all
  select 'Rows in EXTERNAL CLASS table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYEXTCLASS
 ;
insert into CHANGEDEXTCLASS
select  TYPE
       ,CLASS
       ,'NEW'
       from(
       select * from EXTCLASS
       minus
       select * from YESTERDAYEXTCLASS
       );
       
insert into CHANGEDEXTCLASS
select  TYPE
       ,CLASS
       ,'DEL'
       from(
       select * from YESTERDAYEXTCLASS
       minus
       select * from EXTCLASS
       );

truncate table YESTERDAYEXTCLASS;

INSERT INTO YESTERDAYEXTCLASS
SELECT * 
FROM EXTCLASS
;

commit
;

select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDEXTCLASS
 group by operation
 ;

-----------------------------------trucate
--truncate table YESTERDAYTAFLIGHTSVEJLE;
--truncate table YESTERDAYTAFLIGHTSSG70;
--truncate table YESTERDAYEXTPLANES;
--truncate table YESTERDAYEXTCLASS;
--truncate table YESTERDAYTACLUB;
--truncate table YESTERDAYTAREGION;
--truncate table YESTERDAYTAMEMBER;

--truncate table CHANGEDTAMEMBER;
--truncate table CHANGEDTAFLIGHTSVEJLE;
--truncate table CHANGEDTAFLIGHTSSG70;
--truncate table CHANGEDEXTPLANES;
--truncate table CHANGEDEXTCLASS;
--truncate table CHANGEDTACLUB;
--truncate table CHANGEDTAREGION;

---------------------------selects
--select * from YESTERDAYTAMEMBER;
--select * from CHANGEDTAMEMBER;
--select * from YESTERDAYTAFLIGHTSSG70;
--select * from TAFLIGHTSSG70;


--select count(*) from TAFLIGHTSSG70;

---------GETING all columns name------------------
--select case column_id
--        when 1 then 'select  ' || column_name
--        else        '       ,' || column_name
--        end
--from dba_tab_cols
--where owner='DWH'
--and table_name='EXTCLASS';
