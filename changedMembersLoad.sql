DECLARE
  CURSOR memberCursor
  IS
    (SELECT MEMBERNO ,
      INITIALS ,
      NAME ,
      ADDRESS ,
      ZIPCODE ,
      DATEJOINED ,
      DATELEFT ,
      OWNSPLANEREG ,
      SEX ,
      CLUB ,
      OPERATION ,
      AGE ,
      STATUS
    FROM LEFTJOINEDTAMEMBER
    WHERE operation ='CH'
    );
 
  VALIDFROM         NUMBER(10,0);
  ENDOFTIME         NUMBER(10, 0);
  VALIDTOYESTERDAY  NUMBER(10,0);
BEGIN
    
    SELECT id
    INTO VALIDTOYESTERDAY
    FROM D_DATE
    WHERE d_date = TO_CHAR(SYSDATE - 1, 'DD-MON-YYYY');
  --Selecting id from D_DATE DIMENSION FOR TODAY DATE
  SELECT id
  INTO VALIDFROM
  FROM D_DATE
  WHERE d_date = TO_CHAR(SYSDATE, 'DD-MON-YYYY');
  
  --WE ARE ADDING NEW MEMBERS SO VALIDTO WILL BE SET UP TO THE END OF TIME
  SELECT id INTO ENDOFTIME FROM D_DATE WHERE dayofweek = 'END OF TIME';
  
  
  FOR row IN membercursor
  LOOP
    
    --SET THE LAST VERSION VALID TILL YESTERDAY
    UPDATE D_MEMBERPROFILE
      SET VALIDTO = VALIDTOYESTERDAY
      WHERE id    =
        (SELECT id
        FROM D_MEMBERPROFILE
        WHERE MEMBER_NO = ROW.MEMBERNO
        AND VALIDTO     = ENDOFTIME
        );
    
    --ADD A NEW ROW VALID FROM TODAY TILL THE END OF TIME
    INSERT
    INTO D_MEMBERPROFILE
      (
        MEMBER_NO ,
        NAME ,
        AGE ,
        MEMBER_STATUS ,
        SEX ,
        VALIDFROM ,
        VALIDTO
      )
      VALUES
      (
        ROW.MEMBERNO,
        ROW.NAME,
        ROW.AGE,
        ROW.STATUS,
        ROW.SEX,
        VALIDFROM,
        ENDOFTIME
      );
  END LOOP;
END;