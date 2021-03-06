DECLARE
  CURSOR FLIGHTSCURSOR
  IS
    (SELECT LAUNCHDATE,
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
    FROM VALIDPILOTINFOTAFLIGHTS
    );
  LAUNCHDATEID   NUMBER(10,0);
  LAUNCHTIMEID   NUMBER(10,0);
  LANDINGTIMEID  NUMBER(10,0);
  LANDINGDATEID  NUMBER(10,0);
  ENDOFTIMEID    NUMBER(10,0);
  CLUBID         NUMBER(10,0);
  PILOT1ID       NUMBER(10,0);
  PILOT2ID       NUMBER(10,0);
  LAUNCHMETHODID NUMBER(10,0);
  COUNTPILOTS    INTEGER;
  ROWNO          INTEGER;
BEGIN
  SELECT id INTO ENDOFTIMEID FROM D_DATE WHERE dayofweek = 'END OF TIME';
  FOR ROW IN FLIGHTSCURSOR
  LOOP
    --GETTING TIME AND DATE ID FROM LAUNCH AND LANGING TIME
    SELECT ID
    INTO LAUNCHDATEID
    FROM D_DATE
    WHERE D_DATE = ROW.LAUNCHDATE;
    SELECT ID INTO LANDINGDATEID FROM D_DATE WHERE D_DATE = ROW.LANDINGDATE;
    SELECT ID INTO LAUNCHTIMEID FROM D_TIME WHERE TIME_IN24_NAME = ROW.LAUNCHTIME;
    SELECT ID
    INTO LANDINGTIMEID
    FROM D_TIME
    WHERE TIME_IN24_NAME = ROW.LANDINGTIME;
    --GETTING CLUBID
    SELECT ID
    INTO CLUBID
    FROM D_CLUB
    WHERE UPPER(CLUB_NAME) = ROW.CLUB;
    --GETTING ID OF THE LAUNCH METHOD
    IF ROW.LAUNCHAEROTOW = 'Y' THEN
      SELECT ID
      INTO LAUNCHMETHODID
      FROM D_LAUNCHMETHOD
      WHERE LAUNCH_METHOD = 'LAUNCHAEROTOW';
    ELSIF ROW.LAUNCHWINCH = 'Y' THEN
      SELECT ID
      INTO LAUNCHMETHODID
      FROM D_LAUNCHMETHOD
      WHERE LAUNCH_METHOD      = 'LAUNCHWINCH';
    ELSIF ROW.LAUNCHSELFLAUNCH = 'Y' THEN
      SELECT ID
      INTO LAUNCHMETHODID
      FROM D_LAUNCHMETHOD
      WHERE LAUNCH_METHOD = 'LAUNCHSELFLAUNCH';
    ELSIF ROW.CABLEBREAK  = 'Y' THEN
      SELECT ID
      INTO LAUNCHMETHODID
      FROM D_LAUNCHMETHOD
      WHERE LAUNCH_METHOD = 'CABLEBREAK';
    END IF;
    DELETE FROM LOAD_MEMBER_PROFILE;
    /*GETTING THE PILOT1ID FROM D_MEMEBRPROFILE*/
    /*STEP 1 : SELECTING ALL THE MEMBERS WHO HAVE THE INITIALS WE ARE LOOKING FOR*/
    INSERT
    INTO LOAD_MEMBER_PROFILE
      (
        ID,
        MEMBER_NO,
        NAME,
        INITIALS,
        AGE,
        ADDRESS,
        MEMBER_STATUS,
        SEX,
        VALIDFROM,
        VALIDTO
      )
    SELECT MP.ID,
      MP.MEMBER_NO,
      MP.NAME,
      MP.INITIALS,
      MP.AGE,
      MP.ADDRESS,
      MP.MEMBER_STATUS,
      MP.SEX,
      MP.VALIDFROM,
      MP.VALIDTO
    FROM D_MEMBERPROFILE MP
    INNER JOIN D_DATE DD
    ON DD.ID            = MP.VALIDTO
    WHERE MP.INITIALS   = ROW.PILOT1INIT
    AND ROW.LAUNCHDATE <= DD.D_DATE;
    SELECT COUNT(*) INTO COUNTPILOTS FROM LOAD_MEMBER_PROFILE;
    IF COUNTPILOTS = 1 THEN
      SELECT ID INTO PILOT1ID FROM LOAD_MEMBER_PROFILE WHERE ROWNUM = 1;
    ELSIF COUNTPILOTS > 1 THEN
      ROWNO          := ROUND(dbms_random.value() * COUNTPILOTS) + 1;
      IF ROWNO       >= COUNTPILOTS THEN
        ROWNO        := COUNTPILOTS - 1;
      END IF;
      IF ROWNO <= 0 THEN
        ROWNO  := 1;
      END IF;
      SELECT ID INTO PILOT1ID FROM LOAD_MEMBER_PROFILE WHERE ROWNUM = ROWNO;
    END IF;
    -------------------------------------------------------------------------
    DELETE
    FROM LOAD_MEMBER_PROFILE;
    /*GETTING THE PILOT1ID FROM D_MEMEBRPROFILE*/
    /*STEP 1 : SELECTING ALL THE MEMBERS WHO HAVE THE INITIALS WE ARE LOOKING FOR*/
    IF TRIM(ROW.PILOT2INIT) IS NOT NULL THEN
      INSERT
      INTO LOAD_MEMBER_PROFILE
        (
          ID,
          MEMBER_NO,
          NAME,
          INITIALS,
          AGE,
          ADDRESS,
          MEMBER_STATUS,
          SEX,
          VALIDFROM,
          VALIDTO
        )
      SELECT MP.ID,
        MP.MEMBER_NO,
        MP.NAME,
        MP.INITIALS,
        MP.AGE,
        MP.ADDRESS,
        MP.MEMBER_STATUS,
        MP.SEX,
        MP.VALIDFROM,
        MP.VALIDTO
      FROM D_MEMBERPROFILE MP
      INNER JOIN D_DATE DD
      ON DD.ID            = MP.VALIDTO
      WHERE MP.INITIALS   = ROW.PILOT2INIT
      AND ROW.LAUNCHDATE <= DD.D_DATE;
      SELECT COUNT(*) INTO COUNTPILOTS FROM LOAD_MEMBER_PROFILE;
      IF COUNTPILOTS = 1 THEN
        SELECT ID INTO PILOT2ID FROM LOAD_MEMBER_PROFILE WHERE ROWNUM = 1;
      ELSIF COUNTPILOTS > 1 THEN
        ROWNO          := ROUND(dbms_random.value() * COUNTPILOTS) + 1;
        IF ROWNO       >= COUNTPILOTS THEN
          ROWNO        := COUNTPILOTS - 1;
        END IF;
        IF ROWNO <= 0 THEN
          ROWNO  := 1;
        END IF;
        SELECT ID INTO PILOT2ID FROM LOAD_MEMBER_PROFILE WHERE ROWNUM = ROWNO;
      END IF;
    END IF;
    /*STEP 2: */
    --  SELECT ID INTO PILOT1ID FROM D_MEMBERPROFILE WHERE INITIALS = ROW.PILOT1INIT and ROWNUM = ROWNO;
    -- SELECT ID INTO PILOT1ID FROM (SELECT ID FROM D_MEMBERPROFILE WHERE VALIDTO = ENDOFTIMEID
    -- )
    INSERT
    INTO F_FLIGHT
      (
        ID,
        D_CLUB,
        D_PLANE,
        LAUNCH_TIME,
        LANDING_TIME,
        LAUNCH_DATE,
        LANDING_DATE,
        LAUNCH_METHOD
      )
      VALUES
      (
        ROW.PLANEREGISTRATION
        || LAUNCHTIMEID
        || LAUNCHDATEID,
        CLUBID,
        ROW.PLANEREGISTRATION,
        LAUNCHTIMEID,
        LANDINGTIMEID,
        LAUNCHDATEID,
        LANDINGDATEID,
        LAUNCHMETHODID
      );
    INSERT
    INTO BRIDGE_FLIGHT_MEMBER
      (
        FLIGHT_ID,
        MEMBER_ID,
        CROSSCOUNTRYKM
      )
      VALUES
      (
        ROW.PLANEREGISTRATION
        || LAUNCHTIMEID
        || LAUNCHDATEID,
        PILOT1ID,
        ROW.CROSSCOUNTRYKM
      );
    IF TRIM(ROW.PILOT2INIT) IS NOT NULL THEN
      INSERT
      INTO BRIDGE_FLIGHT_MEMBER
        (
          FLIGHT_ID,
          MEMBER_ID,
          CROSSCOUNTRYKM
        )
        VALUES
        (
          ROW.PLANEREGISTRATION
          || LAUNCHTIMEID
          || LAUNCHDATEID,
          PILOT2ID,
          ROW.CROSSCOUNTRYKM
        );
    END IF;
  END LOOP;
END;