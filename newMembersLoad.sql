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
    WHERE operation ='NEW'
    );
    
  VALIDFROM NUMBER(10,0);
  VALIDTO   NUMBER(10, 0);
BEGIN
  
  --Selecting id from D_DATE DIMENSION FOR TODAY DATE
  SELECT id
  INTO VALIDFROM
  FROM D_DATE
  WHERE d_date = TO_CHAR(SYSDATE, 'DD-MON-YYYY');
  
  --WE ARE ADDING NEW MEMBERS SO VALIDTO WILL BE SET UP TO THE END OF TIME
  SELECT id INTO VALIDTO FROM D_DATE WHERE dayofweek = 'END OF TIME';
  
  
  FOR row IN membercursor
  LOOP
    INSERT INTO D_MEMBER VALUES
      (ROW.MEMBERNO      
      );
      
    INSERT
    INTO D_MEMBERPROFILe
      (
        MEMBER_NO ,
        NAME ,
        INITIALS,
        AGE ,
        ADDRESS,
        MEMBER_STATUS ,
        SEX ,
        VALIDFROM ,
        VALIDTO
      )
      VALUES
      (
        ROW.MEMBERNO,
        ROW.NAME,
        ROW.INITIALS,
        ROW.AGE,
        ROW.ADDRESS,
        ROW.STATUS,
        ROW.SEX,
        VALIDFROM,
        VALIDTO
      );
  END LOOP;
END;