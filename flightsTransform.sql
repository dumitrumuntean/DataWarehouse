

SELECT * FROM validDurationTaFlights;
TRUNCATE TABLE validDurationTaFlights;

INSERT
INTO validDurationTaFlights
  (
    LAUNCHTIME,
    LANDINGTIME,
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
SELECT LAUNCHTIME,
  LANDINGTIME,
  PLANEREGISTRATION,
  PILOT1INIT,
  PILOT2INIT,
  LAUNCHAEROTOW,
  LAUNCHWINCH,
  LAUNCHSELFLAUNCH,
  CABLEBREAK,
  CROSSCOUNTRYKM,
  'SG70'
FROM CHANGEDTAFLIGHTSSG70
WHERE 24*(LANDINGTIME - LAUNCHTIME) <= 7
AND 24  *(LANDINGTIME - LAUNCHTIME) >= 0;
INSERT
INTO ERRORDURATIONTAFLIGHTS
  (
    LAUNCHTIME,
    LANDINGTIME,
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
SELECT LAUNCHTIME,
  LANDINGTIME,
  PLANEREGISTRATION,
  PILOT1INIT,
  PILOT2INIT,
  LAUNCHAEROTOW,
  LAUNCHWINCH,
  LAUNCHSELFLAUNCH,
  CABLEBREAK,
  CROSSCOUNTRYKM,
  'VEJLE'
FROM CHANGEDTAFLIGHTSVEJLE
WHERE ( LAUNCHTIME, LANDINGTIME, PLANEREGISTRATION, PILOT1INIT, PILOT2INIT, LAUNCHAEROTOW, LAUNCHWINCH, LAUNCHSELFLAUNCH, CABLEBREAK, CROSSCOUNTRYKM) NOT IN
  (SELECT LAUNCHTIME,
    LANDINGTIME,
    PLANEREGISTRATION,
    PILOT1INIT,
    PILOT2INIT,
    LAUNCHAEROTOW,
    LAUNCHWINCH,
    LAUNCHSELFLAUNCH,
    CABLEBREAK,
    CROSSCOUNTRYKM
  FROM VALIDDURATIONTAFLIGHTS
  );
INSERT
INTO ERRORDURATIONTAFLIGHTS
  (
    LAUNCHTIME,
    LANDINGTIME,
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
SELECT LAUNCHTIME,
  LANDINGTIME,
  PLANEREGISTRATION,
  PILOT1INIT,
  PILOT2INIT,
  LAUNCHAEROTOW,
  LAUNCHWINCH,
  LAUNCHSELFLAUNCH,
  CABLEBREAK,
  CROSSCOUNTRYKM,
  'SG70'
FROM CHANGEDTAFLIGHTSSG70
WHERE ( LAUNCHTIME, LANDINGTIME, PLANEREGISTRATION, PILOT1INIT, PILOT2INIT, LAUNCHAEROTOW, LAUNCHWINCH, LAUNCHSELFLAUNCH, CABLEBREAK, CROSSCOUNTRYKM) NOT IN
  (SELECT LAUNCHTIME,
    LANDINGTIME,
    PLANEREGISTRATION,
    PILOT1INIT,
    PILOT2INIT,
    LAUNCHAEROTOW,
    LAUNCHWINCH,
    LAUNCHSELFLAUNCH,
    CABLEBREAK,
    CROSSCOUNTRYKM
  FROM VALIDDURATIONTAFLIGHTS
  );
INSERT
INTO DURATIONFLIGHTSAUDIT
  (
    A_DATE,
    TOTAL_EXTRACTED,
    DROPPED,
    VALID
  )
  VALUES
  (
    (SELECT sysdate FROM dual
    )
    ,
    (SELECT COUNT(*)
    FROM
      ( SELECT * FROM CHANGEDTAFLIGHTSVEJLE
      UNION ALL
      SELECT * FROM CHANGEDTAFLIGHTSSG70
      )
    ),
    (SELECT COUNT(*) FROM ERRORDURATIONTAFLIGHTS
    ),
    (SELECT COUNT(*) FROM VALIDDURATIONTAFLIGHTS
    )
  );
/**/
@@INSTALL
@@ETL
SELECT COUNT(*) FROM D_MEMBERPROFILE;
SELECT *
FROM TAFLIGHTSVEJLE
WHERE pilot2init NOT IN
  (SELECT INITIALS FROM D_MEMBERPROFILE
  );
SELECT *
FROM TAFLIGHTSVEJLE
WHERE trim(PILOT1INIT) IS NULL
AND trim(PILOT2INIT)   IS NOT NULL;
TRUNCATE TABLE CHANGEDTAFLIGHTSVEJLE;
TRUNCATE TABLE CHANGEDTAFLIGHTSSG70;

`