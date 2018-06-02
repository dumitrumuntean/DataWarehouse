--------------------------------------------------------------------------------
---------Retrieving new, deleted, changed from tamember source table------------
--------------------------------------------------------------------------------

--Display when extract process was held
select 'Extract process at: ' || to_char(sysdate,'YYYY-MM-DD HH24:MI') 
  as extractTime
  from dual
  ;
  -- Just showing message  'Extract members:'
select 'Extract Members : '    
  from dual
  ;
  -- Just showing message 'Row counts before'
  select 'Row counts before: '  
    from dual
union all
  
  --How many rows there are already in ChangedTaMember (normally should be 0(zero)
  --ad the begging)
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDTAMEMBER
union all
  
  --How many members are in taMember table(this is source table)
  select 'Rows in Members table  : ' || to_char(count(*))
   from taMember
union all
  --how many rows there are in Yesterday Ta Member (yesterday copy of the taMember)
  select 'Rows in Members table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYTAMEMBER
 ;
 
 /*
   Selecting new rows from taMember table.
   new = today PK - yesterday PK
   (Result is to be inserted in CHANGEDTAMEMBER with the operation = 'NEW')
 */
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
            select * from taMember     --memberno is the primary key
            where memberno not in (select memberno from YESTERDAYTAMEMBER)
          )
;


/*
  Selecting deleted member from taMember table;
  deleted = yesterday PK - today PK   ;
  (Result is to be inserted in CHANGEDTAMEMBER with the operation = 'DEL')
*/

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
          )
;

/*
  Selecting rows of the member whose information have been changed
  changed = rows today - rows yesterday - new elements
  (Result is to be inserted in CHANGEDTAMEMBER with the operation = 'CH')
*/

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
          --'minus' operator is comparing each column of row
            select * from (
            select * from taMember                --rows today
            minus                                 --minus
            select * from YESTERDAYTAMEMBER)      -- rows yesterday
            where memberno not in (select memberno from CHANGEDTAMEMBER 
            where operation='NEW'-- minus new
          ));

/*
  Selecting member whose birtday is on the day extract operation was performed
  changed birthday = (rows where sysdate == dateborn) - new elements - changed
  elements
  (Result is to be inserted in CHANGEDTAMEMBER with the operation = 'CH')
*/
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

--removing everithing from yesterday copy table
truncate table YESTERDAYTAMEMBER;

--coping today taMember into yesterday copy table
INSERT INTO YESTERDAYTAMEMBER
SELECT * 
FROM TAMEMBER
;

--commit changes
commit
;

/*
  Reporting how many member where extracted from source table#
  grouped by operation
*/
select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDTAMEMBER
 group by operation
 ;

--------------------------------------------------------------------------------
-------Retrieving new, deleted, changed rows from  taclub source table----------
--------------------------------------------------------------------------------
--showing message 'Extract Club: '
select 'Extract Club : '   
  from dual
  ;
  
  --showing how many rows are already in changedtaclub table
  --normally should be zero before performing extract
  select 'Row counts before: ' 
    from dual
union all
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDTACLUB
union all
  
  --showing how many rows there are in today club table (source table)
  select 'Rows in club table  : ' || to_char(count(*))
   from taClub
union all
  
  --showing how many rows there are in yesterday copy of taClub table
  select 'Rows in CLUB table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYTACLUB
 ;

/*
  Extracting all new rows in from taClub table
  new = PK today - PK yesterday
  (Result is to be inserted in CHANGEDTACLUB table with operation = 'NEW')
*/
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
/*
  Extracting all deleted rows from taClub table
  deleted = PK yesterday - PK today 
  (Result is to be inserted in CHANGEDTACLUB table with operation = 'DEL')
*/
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

/*
  Extracting all rows which have been modified since yesterday from taClub table
  changed = rows today - rows yesterday
  (Result is to be inserted in CHANGEDTACLUB table with operation = 'CH')
*/
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

--Deleting yesterday copy of taClub table
truncate table YESTERDAYTACLUB;

--Copying today taClub table into yesterday cpy
INSERT INTO YESTERDAYTACLUB
SELECT * 
FROM TACLUB
;

--commit changes
commit
;

/*
  Reporting how many taClub table rows have been extracted from source table#
  grouped by operation
*/
select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDTACLUB
 group by operation
 ;

--------------------------------------------------------------------------------
----------Retrieving new, deleted rows from ta Region source table--------------
--------------------------------------------------------------------------------
select 'Extract Region : '  --show message 'Extract Region : '
  from dual
  ;


  select 'Row counts before: '
    from dual
union all

-- Display how many rows are in CHANGEDTAREGION table
--normally should be 0 (zero) before extract operation
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDTAREGION
union all

-- Display how many rows there are in source table 
  select 'Rows in REGION table  : ' || to_char(count(*))
   from taRegion
union all

--Display how many rows there are in yesterday copy of taRegion table
  select 'Rows in REGION table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYTAREGION
 ;

 /*
   Selecting new rows from taRegion table.
   new = today PK - yesterday PK
   (Result is to be inserted in CHANGEDTAREGION with the operation = 'NEW')
 */
insert into CHANGEDTAREGION
select NAME,
      'NEW'
      from(
      /*
        NOTE:
          Since there is only one column in taRegion source table 'minus' 
          operator can be used to perform extraction
      */
        select * from TAREGION
        minus
        select * from YESTERDAYTAREGION
      )
      union all
 /*
   Selecting deleted rows from taMember table.
   deleted = yesterday PK  - today PK
   (Result is to be inserted in CHANGEDTAREGION with the operation = 'DEL')
 */
select NAME,
      'DEL'
      from(
      /*
        NOTE:
          Since there is only one column in taRegion source table 'minus' 
          operator can be used to perform extraction
      */
        select * from YESTERDAYTAREGION
        minus
        select * from TAREGION
      );

--Removing everything from yesterday copy of taRegion table
truncate table YESTERDAYTAREGION;

--copying today taRegion table into yesterday copy
INSERT INTO YESTERDAYTAREGION
SELECT * 
FROM TAREGION
;

--commiy changes
commit
;

/*
  Reporting how many taRegion table rows have been extracted from source table#
  grouped by operation
*/

select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDTAREGION
 group by operation
 ;
/*
  NOTE:
    As you may have noticed we don't extract cahnged rows from taRegion table 
    due o the folowing reasons:
      1. There is a single column in the taRegion table which defines entire row
          PK = ROW therefore NEW = CH
      2. Region are not a dimension that might change in a long perion of time
          (more than 100 years). 
*/ 

--------------------------------------------------------------------------------
-----------Retrieving new rows from TAFLIGHTSVEJLE source table-----------------
--------------------------------------------------------------------------------
select 'Extract FLIGHTS VEJLE : ' -- show message 'Extract FLIGHTS VEJLE'
  from dual
  ;
  
  select 'Row counts before: '
    from dual;

--Display how many rows there are in CHANGEDTAFLIGHTSVEJLE table
--normally should be 0(zero) before performing extract operation
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDTAFLIGHTSVEJLE
union all

--Display how many rows there are in TAFLIGHTSVEJLE source table 
  select 'Rows in FLIGHTS VEJLE table  : ' || to_char(count(*))
   from TAFLIGHTSVEJLE
union all

--Display how many rows there are in YESTERDAYTAFLIGHTSVEJLE table
--it is yesterday copy of TAFLIGHTSVEJLE
  select 'Rows in FLIGHTS VEJLE table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYTAFLIGHTSVEJLE
 ;

 /*
   Selecting new rows from TAFLIGHTSVEJLE table.
   new = today PK - yesterday PK
   (Result is to be inserted in CHANGEDTAFLIGHTSVEJLE with the 
    operation = 'NEW')
 */
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
;

--removing everything from yesterday copy of TAFLIGHTSVEJLE
truncate table YESTERDAYTAFLIGHTSVEJLE;

--copying today TAFLIGHTSVEJLE table into YESTERDAYTAFLIGHTSVEJLE
INSERT INTO YESTERDAYTAFLIGHTSVEJLE
SELECT * 
FROM TAFLIGHTSVEJLE
;

-- commit changes
commit
;

--Reporting how many rows have been extracted from source table
select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDTAFLIGHTSVEJLE
 group by operation
 ;
 
 /*
  NOTE:
    In our dimensional model 'flights' table is present as a fact table. 
    Therefore, rows cannot be deleted or changed in the source table.  
 */

--------------------------------------------------------------------------------
----------Retrieving new from TAFLIGHTSSG70 source table------------------------
--------------------------------------------------------------------------------

select 'Extract FLIGHTS SG70 : ' --show message 'Extract FLIGHTS SG70 :' 
  from dual
  ;

--Display how many rows there are in CHANGEDTAFLIGHTSSG70 table
--normally should be 0(zero) before performing extract operation
  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDTAFLIGHTSSG70
union all

--Display how many rows there are in TAFLIGHTSSG70 source table 
  select 'Rows in FLIGHTS SG70 table  : ' || to_char(count(*))
   from TAFLIGHTSSG70
union all

--Display how many rows there are in YESTERDAYTAFLIGHTSSG70 table
--it is yesterday copy of TAFLIGHTSSG70
  select 'Rows in FLIGHTS SG70 table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYTAFLIGHTSSG70
 ;

 /*
   Selecting new rows from TAFLIGHTSSG70 table.
   new = today PK - yesterday PK
   (Result is to be inserted in CHANGEDTAFLIGHTSG70 with the 
    operation = 'NEW')
 */
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
;

--removing everything from yesterday copy of TAFLIGHTSSG70
truncate table YESTERDAYTAFLIGHTSSG70;

--copying today TAFLIGHTSSG70 table into YESTERDAYTAFLIGHTSSG70
INSERT INTO YESTERDAYTAFLIGHTSSG70
SELECT * 
FROM TAFLIGHTSSG70
;

--commit changes
commit
;

--Reporting how many rows have been extracted from source table
select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDTAFLIGHTSSG70
 group by operation
 ;
  /*
  NOTE:
    In our dimensional model 'flights' table is present as a fact table. 
    Therefore, rows cannot be deleted or changed in the source table.  
 */

--------------------------------------------------------------------------------
----------Changed, new, deleted external planes source table--------------------
--------------------------------------------------------------------------------

select 'Extract EXTERNAL PLANES : ' --show message 'Extract EXTERNAL PLANES :'
  from dual
  ;

  select 'Row counts before: '
    from dual
union all

--Display how many rows there are in CHANGEDEXTPLANES table
--normally should be 0(zero) before performing extract operation
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDEXTPLANES
union all

--Display how many rows there are in EXTPLANES source table
  select 'Rows in EXTERNAL PLANES table  : ' || to_char(count(*))
   from EXTPLANES
union all

--Display how many rows there are in Yesterday copy of EXTPLANES
  select 'Rows in EXTERNAL PLANES table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYEXTPLANES
 ;


 /*
   Selecting new rows from EXTPLANES table.
   new = today PK - yesterday PK
   (Result is to be inserted in CHANGEDEXTPLANES with the 
    operation = 'NEW')
 */
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

 /*
   Selecting deleted rows from EXTPLANES table.
   new = yesterday PK - today PK
   (Result is to be inserted in CHANGEDEXTPLANES with the 
    operation = 'DEL')
 */
insert into  CHANGEDEXTPLANES
select  REGISTRATION
       ,COMPETITIONNUMBER
       ,TYPE
       ,CLUBOWNED
       ,OWNERNAME
       , 'NEW'
       from(
        select * from YESTERDAYEXTPLANES where REGISTRATION not in (
        select REGISTRATION from EXTPLANES 
        )
       );

 /*
   Selecting changed rows from EXTPLANES table.
   new = today rows - yesterday rows
   (Result is to be inserted in CHANGEDEXTPLANES with the 
    operation = 'CH')
 */
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

--removing everything from yesterday copy of EXTPLANES
truncate table YESTERDAYEXTPLANES;

--copying today EXTPLANES table into YESTERDAYEXTPLANES
INSERT INTO YESTERDAYEXTPLANES
SELECT * 
FROM EXTPLANES
;

--commit changes
commit
;

--Reporting how many rows have been extracted from source table
select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDEXTPLANES
 group by operation
 ;
 
--------------------------------------------------------------------------------
-----------Changed, new , deleted external class source table-------------------
--------------------------------------------------------------------------------

select 'Extract EXTERNAL CLASS : ' -- show message 'Extract EXTERNAL CLASS :' 
  from dual
  ;
  select 'Row counts before: '
    from dual
union all

--Display how many rows there are in CHANGEDEXTCLASS table
--normally should be 0(zero) before performing extract operation
  select 'Rows in extract table before (should be zero) : ' || to_char(count(*))
   from CHANGEDEXTCLASS
union all

--Display how many rows there are in EXTCLASS source table
  select 'Rows in EXTERNAL CLASS table  : ' || to_char(count(*))
   from EXTCLASS
union all

--Display how many rows there are in YESTERDAYEXTCLASS (Yesterday copy)
  select 'Rows in EXTERNAL CLASS table (yesterday copy) : ' || to_char(count(*))
   from YESTERDAYEXTCLASS
 ;
 
 /*
   Selecting new rows from EXTCLASS table.
   new = today PK - yesterday PK
   (Result is to be inserted in CHANGEDEXTCLASS with the 
    operation = 'NEW')
 */
insert into CHANGEDEXTCLASS
select  TYPE
       ,CLASS
       ,'NEW'
       from(
       select * from EXTCLASS
       minus
       select * from YESTERDAYEXTCLASS
       );
 /*
   Selecting deleted rows from EXTCLASS table.
   new = yesterday PK - today PK
   (Result is to be inserted in CHANGEDEXTCLASS with the 
    operation = 'DEL')
 */     
insert into CHANGEDEXTCLASS
select  TYPE
       ,CLASS
       ,'DEL'
       from(
       select * from YESTERDAYEXTCLASS
       minus
       select * from EXTCLASS
       );

--Removing everything from yesterday copy table
truncate table YESTERDAYEXTCLASS;

--Copying today table into yesterday copy
INSERT INTO YESTERDAYEXTCLASS
SELECT * 
FROM EXTCLASS
;

--commit changes
commit
;

--Reporting how many rows have been extracted from source table
select 'Rows in extract table after, by operations type '
 from dual
;
select operation
     , count(*)
from CHANGEDEXTCLASS
 group by operation
 ;
 
   TRUNCATE TABLE ERRORFLIGHTS;