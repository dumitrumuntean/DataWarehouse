/*
  copying all the member from CHANGEDTAMEMBER into 
  AGETAMEMBER with transformed dateofborn into age
*/
insert into AGETAMEMBER(
         MEMBERNO
       ,INITIALS
       ,NAME
       ,ADDRESS
       ,ZIPCODE
       ,AGE
       ,DATEJOINED
       ,DATELEFT
       ,OWNSPLANEREG
       ,STATUSSTUDENT
       ,STATUSPILOT
       ,STATUSASCAT
       ,STATUSFULLCAT
       ,SEX
       ,CLUB
       ,OPERATION
)
select  MEMBERNO
       ,INITIALS
       ,NAME
       ,ADDRESS
       ,ZIPCODE
       ,case
          when extract (year from(sysdate - dateborn) year to month) < 0 then 0
          else extract (year from(sysdate - dateborn) year to month)
          end
       ,DATEJOINED
       ,DATELEFT
       ,OWNSPLANEREG
       ,STATUSSTUDENT
       ,STATUSPILOT
       ,STATUSASCAT
       ,STATUSFULLCAT
       ,SEX
       ,CLUB
       ,OPERATION
       from CHANGEDTAMEMBER;

truncate table CHANGEDTAMEMBER;
/*
  Select all the members from AGETAMEMBER into VALIDAGETAMEMBER whose
  age is between 18 and 100
*/
insert into VALIDAGETAMEMBER(
         MEMBERNO
       ,INITIALS
       ,NAME
       ,ADDRESS
       ,ZIPCODE
       ,AGE
       ,DATEJOINED
       ,DATELEFT
       ,OWNSPLANEREG
       ,STATUSSTUDENT
       ,STATUSPILOT
       ,STATUSASCAT
       ,STATUSFULLCAT
       ,SEX
       ,CLUB
       ,OPERATION
)
select  MEMBERNO
       ,INITIALS
       ,NAME
       ,ADDRESS
       ,ZIPCODE
       ,AGE
       ,DATEJOINED
       ,DATELEFT
       ,OWNSPLANEREG
       ,STATUSSTUDENT
       ,STATUSPILOT
       ,STATUSASCAT
       ,STATUSFULLCAT
       ,SEX
       ,CLUB
       ,OPERATION
       from AGETAMEMBER where age >= 18
       and age <= 100 ;


/*
  Select all the members from AGETAMEMBER whose age
  is less than 18 or bigger than 100
*/
insert into ERRORAGETAMEMBER(
         MEMBERNO
       ,INITIALS
       ,NAME
       ,ADDRESS
       ,ZIPCODE
       ,AGE
       ,DATEJOINED
       ,DATELEFT
       ,OWNSPLANEREG
       ,STATUSSTUDENT
       ,STATUSPILOT
       ,STATUSASCAT
       ,STATUSFULLCAT
       ,SEX
       ,CLUB
       ,OPERATION
)
select  MEMBERNO
       ,INITIALS
       ,NAME
       ,ADDRESS
       ,ZIPCODE
       ,AGE
       ,DATEJOINED
       ,DATELEFT
       ,OWNSPLANEREG
       ,STATUSSTUDENT
       ,STATUSPILOT
       ,STATUSASCAT
       ,STATUSFULLCAT
       ,SEX
       ,CLUB
       ,OPERATION
       from (
        select * from AGETAMEMBER
        minus
        select * from VALIDAGETAMEMBER
       ) ;
       
/*
  Completing audit table with the result from the process
*/
insert into AGEMEMBERAUDIT(
  A_DATE,
  TOTAL_EXTRACTED,
  DROPPED,
  VALID
)values(
  (select sysdate from dual),
  (select count(*) from AGETAMEMBER),
  (select count(*) from ERRORAGETAMEMBER),
  (select count(*) from VALIDAGETAMEMBER)
);

insert into STATUSTAMEMBER(
        MEMBERNO
       ,INITIALS
       ,NAME
       ,ADDRESS
       ,ZIPCODE
       ,AGE
       ,DATEJOINED
       ,DATELEFT
       ,OWNSPLANEREG
       ,STATUS
       ,SEX
       ,CLUB
       ,OPERATION
)
select  MEMBERNO
       ,INITIALS
       ,NAME
       ,ADDRESS
       ,ZIPCODE
       ,AGE
       ,DATEJOINED
       ,DATELEFT
       ,OWNSPLANEREG
       ,case
          when substr(STATUSSTUDENT || STATUSPILOT || STATUSASCAT || STATUSFULLCAT, 4, 1) = 'Y'
            THEN 'FULL CATEGORY INSTRUCTUR'
          when substr(STATUSSTUDENT || STATUSPILOT || STATUSASCAT || STATUSFULLCAT, 3, 1) = 'Y'
            THEN 'ASSISTENT CATEGORY INSTRUCTUR'
          when substr(STATUSSTUDENT || STATUSPILOT || STATUSASCAT || STATUSFULLCAT, 2, 1) = 'Y'
            THEN 'PILOT'
          ELSE
            'STUDENT'
          END
       ,SEX
       ,CLUB
       ,OPERATION FROM VALIDAGETAMEMBER;
 ------------------------------------------------------------------------------
 insert into LEFTJOINEDTAMEMBER(
        MEMBERNO
       ,INITIALS
       ,NAME
       ,ADDRESS
       ,ZIPCODE
       ,AGE
       ,DATEJOINED
       ,DATELEFT
       ,OWNSPLANEREG
       ,STATUS
       ,SEX
       ,CLUB
       ,OPERATION
)
select  MEMBERNO
       ,INITIALS
       ,NAME
       ,ADDRESS
       ,ZIPCODE
       ,AGE
       ,case
        when datejoined > dateleft and dateleft is not null then dateleft
        else datejoined
        end
       ,case
        when  dateleft < datejoined and dateleft is not null then datejoined
        else dateleft
        end
       ,OWNSPLANEREG
       ,STATUS
       ,SEX
       ,CLUB
       ,OPERATION FROM STATUSTAMEMBER;

/*Clearing tables after performing operation*/
truncate TABLE CHANGEDTAMEMBER;
truncate table AGETAMEMBER;
truncate table STATUSTAMEMBER;
truncate table VALIDAGETAMEMBER;
