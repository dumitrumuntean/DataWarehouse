select count(*) from D_MEMBER;

select count(*) from D_MEMBERPROFILE;

insert into taMember (MemberNo, Initials, name, address, zipcode, dateBorn, dateJoined, dateLeft, ownsPlaneReg, statusStudent, statusPilot, statusAsCat, statusFullCat, sex, club ) values(       33333 , 'MUDL' , 'MUDAK MUDAK' , 'Antonigade, Odense V' ,  5200 , to_date('1965-09-29','YYYY-MM-DD') , to_date('2016-02-05','YYYY-MM-DD') , null , '   ' , 'N' , 'Y' , 'N' , 'N' , 'M' , 'SG70' );

delete from TAMEMBER where memberno='33333';

select * from tamember;

delete from taMember;

update taMember set address = 'suka' where memberno='33333';
select * from D_MEMBERPROFILE;
select * from D_MEMBERPROFILE
   join D_DATE d on validto = d.id
  where member_no = '33333';

select * from tamember;

select * from LEFTJOINEDTAMEMBER;



SELECT * FROM D_DATE;

@@ETL
@@install

insert into taFlightsVejle (launchTime, landingTime, planeRegistration, pilot1Init, pilot2Init, launchAerotow, launchWinch,launchSelfLaunch, cableBreak, CrossCountryKm)  values ( to_date('2015-05-15 10:34', 'YYYY-MM-DD HH24:MI' ) ,  to_date('2015-05-15 11:54', 'YYYY-MM-DD HH24:MI' ) , 'XXX' , 'LOAH' , '    ' , 'N' , 'N' , 'Y' , 'N' ,    0);

SELECT * FROM D_MEMBERPROFILE;
SELECT * FROM AUDIT_TABLE;
SELECT * FROM CHANGEDTAMEMBER;
select * from DURATIONFLIGHTSAUDIT;
SELECT * FROM LEFTJOINEDTAMEMBER;
truncate table AUDIT_TABLE;
select launchtime, landingtime, 24*(landingtime - launchtime) from taflightsSG70; -- where 24*(landingtime - launchtime) > 10;



DECLARE
  CURSOR VEJLECURSOR
  IS
    (SELECT 
      LAUNCHTIME,
      LANDINGTIME,
      PLANEREGISTRATION,
      PILOT1INIT,
      PILOT2INIT,
      LAUNCHAEROTOW,
      LAUNCHWINCH,
      LAUNCHSELFLAUNCH,
      CABLEBREAK,
      CROSSCOUNTRYKM
    FROM CHANGEDTAFLIGHTSVEJLE
    WHERE 24*(LANDINGTIME - LAUNCHTIME) <= 7
    AND 24  *(LANDINGTIME - LAUNCHTIME) >= 0
    ); 

  LAUNCHDATE  DATE;
  LANDINGDATE DATE;
  LAUNCHTIME  VARCHAR2(50);
  LANDINGTIME VARCHAR2(50);

BEGIN
  
  FOR ROW IN VEJLECURSOR
  LOOP
  
    
    SELECT TRUNC(ROW.LAUNCHTIME) INTO LAUNCHDATE FROM DUAL;
    SELECT TO_CHAR(ROW.LAUNCHTIME, 'HH24:MI:SS') INTO LAUNCHTIME FROM DUAL;
    SELECT TRUNC(ROW.LANDINGTIME) INTO LANDINGDATE FROM DUAL;
    SELECT TO_CHAR(ROW.LANDINGTIME, 'HH24:MI:SS') INTO LANDINGTIME FROM DUAL;
    
    INSERT
    INTO validDurationTaFlights
      (
        PLANEREGISTRATION,
        PILOT1INIT,
        PILOT2INIT,
        LAUNCHAEROTOW,
        LAUNCHWINCH,
        LAUNCHSELFLAUNCH,
        CABLEBREAK,
        CROSSCOUNTRYKM,
        CLUB
      )
      VALUES
      (
        ROW.PLANEREGISTRATION,
        ROW.PILOT1INIT,
        ROW.PILOT2INIT,
        ROW.LAUNCHAEROTOW,
        ROW.LAUNCHWINCH,
        ROW.LAUNCHSELFLAUNCH,
        ROW.CABLEBREAK,
        ROW.CROSSCOUNTRYKM,
        'VEJLE'
      );
  END LOOP;
END;