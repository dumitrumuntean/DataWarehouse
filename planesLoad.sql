/* THIS FILE IS DEDICATED TO LOAD ONLY NEW ROWS FROM EXTERNARNAL PLANES SOURCE
TABLE */
DECLARE
  CURSOR PLANESCursor
  IS
    (SELECT REGISTRATION,
      COMPETITIONNUMBER,
      TYPE,
      CLUBOWNED,
      OWNERNAME
    FROM CHANGEDEXTPLANES
    WHERE OPERATION='NEW'
    );
  EXTERNAL_CLASS VARCHAR2(20);
BEGIN
  FOR row IN PLANEScursor
  LOOP
    INSERT
    INTO D_PLANE
      (
        REGISTRATION,
        COMPETITIONNO,
        TYPE
      )
      VALUES
      (
        ROW.REGISTRATION,
        ROW.COMPETITIONNUMBER,
        ROW.TYPE
      );
  END LOOP;
END;