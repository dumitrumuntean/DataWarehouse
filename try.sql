DECLARE
  CURSOR FLIGHTCURSOR
  IS
    ( SELECT  LAUNCHDATE,
        LAUNCHTIME,
        LANDINGDATE,
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
        FROM VALIDDURATIONTAFLIGHTS
    );
    
    PILOT1NULL INTEGER;
    PILOT2NULL INTEGER;
    PILOT1EXISTS INTEGER;
    PILOT2EXISTS INTEGER;
    
BEGIN
  
  FOR ROW IN FLIGHTCURSOR
  LOOP
    IF TRIM(ROW.PILOT1INIT)IS NULL THEN PILOT1NULL := 1;
    ELSE PILOT1NULL := 0;
    END IF;
    
    IF TRIM(ROW.PILOT2INIT) IS NULL THEN PILOT2NULL := 1;
    ELSE PILOT2NULL := 0;
    END IF;
    
  END LOOP;
END;
