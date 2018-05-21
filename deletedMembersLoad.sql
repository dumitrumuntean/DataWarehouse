DECLARE
  CURSOR memberProfileCursor
  IS
    (select  ID
       ,MEMBER_NO
       ,NAME
       ,AGE
       ,ADDRESS
       ,MEMBER_STATUS
       ,SEX
       ,VALIDFROM
       ,VALIDTO
    FROM D_MEMBERPROFILE
    WHERE MEMBER_NO IN(
      SELECT MEMBERNO FROM LEFTJOINEDTAMEMBER
          WHERE operation ='DEL'
    )
  );
VALIDTOYESTERDAY Number(10,0);
ENDOFTIME   NUMBER(10, 0);

BEGIN
  --Selecting id from D_DATE DIMENSION FOR TODAY DATE
  SELECT id
  INTO VALIDTOYESTERDAY
  FROM D_DATE
  WHERE d_date = TO_CHAR(SYSDATE - 1, 'DD-MON-YYYY');
  
  SELECT id INTO ENDOFTIME FROM D_DATE WHERE dayofweek = 'END OF TIME';

  --updateing validto column with the date of yesterday for all
  --rows which were found as deleted
  FOR row IN memberProfileCursor
  LOOP
   UPDATE D_MEMBERPROFILE
   SET VALIDTO = VALIDTOYESTERDAY WHERE
   id = (
    select id from D_MEMBERPROFILE where
       MEMBER_NO = ROW.MEMBER_NO AND
       VALIDTO = ENDOFTIME
   );
  END LOOP;
END;