/*
This file is dedicated to create all the necessary tables
in order to be able to perform transform operation
*/
/*
A table which contains information about members
who has invalid age.(18 > age > 100)S
*/
DROP TABLE errorAgeTaMember;
CREATE TABLE errorAgeTaMember AS
  (SELECT * FROM changedtaMember WHERE 1 = 0
  );
/*
drop dateborn column
add age column
*/
ALTER TABLE errorAgeTaMember
DROP column dateborn;
ALTER TABLE errorAgeTaMember ADD age INTEGER;
--set primary key
ALTER TABLE errorAgeTaMember ADD CONSTRAINT coPKerrorAgeTaMember PRIMARY KEY (MemberNo);
/*
A table which contains infromation about members
who has valid age. (18 < age < 100)
*/
DROP TABLE validAgeTaMember;
CREATE TABLE validAgeTaMember AS
  (SELECT * FROM changedtaMember WHERE 1 = 0
  );
--set primary key
ALTER TABLE validAgeTaMember ADD CONSTRAINT coPKvalidAgeTaMember PRIMARY KEY (MemberNo);
/*
drop dateborn column
add age column
*/
ALTER TABLE validAgeTaMember
DROP column dateborn;
ALTER TABLE validAgeTaMember ADD age INTEGER;
/*
transform from date of born into age from changed table without validation
,negative ages are set to 0(zero)
*/
/*
A table which conatins all the members from
CHANGEDTAMEMEBER table with a new column age
instead of date of born column
*/
DROP TABLE AgeTaMember;
CREATE TABLE AgeTaMember AS
  (SELECT * FROM changedtaMember WHERE 1 = 0
  );
--set primary key
ALTER TABLE AgeTaMember ADD CONSTRAINT coPKAgeTaMember PRIMARY KEY (MemberNo);
/*
drop dateborn column
add age column
*/
ALTER TABLE AgeTaMember
DROP column dateborn;
ALTER TABLE AgeTaMember ADD age INTEGER;
/*
Audit table to register how many member had
invalid age, and how many of them were aproved
*/
DROP TABLE ageMemberAudit;
CREATE TABLE ageMemberAudit
  (
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    a_date          DATE,    --date when ETL was executed
    total_extracted INTEGER, --total number of new, changed, deleted members
    dropped         INTEGER, --number of members with invalid age
    valid           INTEGER, --number of member with a valid age
    PRIMARY KEY (id)
  );
/*
A table which conatins all the members from
CHANGEDTAMEMEBER table with a new 'status' column
instead of 4 columns representing each status
*/
DROP TABLE statusTaMember;
CREATE TABLE statusTaMember AS
  (SELECT * FROM VALIDAGETAMEMBER WHERE 1 = 0
  );
--set primary key
ALTER TABLE statusTaMember ADD CONSTRAINT coPKstatusTaMember PRIMARY KEY (MemberNo);
ALTER TABLE statusTamember
DROP column statusstudent;
ALTER TABLE statusTamember
DROP column statuspilot;
ALTER TABLE statusTamember
DROP column statusascat;
ALTER TABLE statusTamember
DROP column statusfullcat;
ALTER TABLE statusTamember ADD status VARCHAR(50);
/* */
DROP TABLE leftJoinedTaMember;
CREATE TABLE leftJoinedTaMember AS
  (SELECT * FROM statusTaMember WHERE 1 = 0
  );
--set primary key
ALTER TABLE leftJoinedTaMember ADD CONSTRAINT coPKleftJoinedTaMember PRIMARY KEY (MemberNo);
--end creating tables
/*------------------------------------------------------------------------*/
/*-------------Tables necessary to perform transform on flights tables----*/
/*------------------------------------------------------------------------*/
DROP TABLE validDurationTaFlights;
CREATE TABLE validDurationTaFlights AS
  (SELECT * FROM taflightsvejle WHERE 1 = 0
  );

ALTER TABLE validDurationTaFlights ADD CLUB VARCHAR2(50);
ALTER TABLE validDurationTaFlights DROP COLUMN LAUNCHTIME;
ALTER TABLE validDurationTaFlights DROP COLUMN LANDINGTIME;

ALTER TABLE validDurationTaFlights ADD LAUNCHDATE DATE;
ALTER TABLE validDurationTaFlights ADD LANDINGDATE DATE;
ALTER TABLE validDurationTaFlights ADD LAUNCHTIME VARCHAR2(50);
ALTER TABLE validDurationTaFlights ADD LANDINGTIME VARCHAR2(50);

DROP TABLE ERRORFLIGHTS;
CREATE TABLE ERRORFLIGHTS AS
  (SELECT * FROM validDurationTaFlights WHERE 1 = 0
  );
  
ALTER TABLE ERRORFLIGHTS ADD ERROR_COMMENT VARCHAR2(200);


DROP TABLE DURATIONFLIGHTSAUDIT;
CREATE TABLE DURATIONFLIGHTSAUDIT
(
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    a_date          DATE,    --date when ETL was executed
    total_extracted INTEGER, --total number of new, changed, deleted members
    dropped         INTEGER, --number of members with invalid age
    valid           INTEGER, --number of member with a valid age
    PRIMARY KEY (id)
);

DROP TABLE PILOT1NULLTAFLIGHTS;
CREATE TABLE pilot1NullTaFlights AS
  (SELECT * FROM validDurationTaFlights WHERE 1 = 0
  );

DROP TABLE pilot12EXISTSTaFlights;
CREATE TABLE pilot12EXISTSTaFlights AS
  (SELECT * FROM validDurationTaFlights WHERE 1 = 0
  );

DROP TABLE pilot2EXISTSTaFlights;
CREATE TABLE pilot2EXISTSTaFlights AS
  (SELECT * FROM validDurationTaFlights WHERE 1 = 0
  );

DROP TABLE validPilotInfoTaFlights;
CREATE TABLE validPilotInfoTaFlights AS
  (SELECT * FROM validDurationTaFlights WHERE 1 = 0
  );

DROP TABLE ERRORPilotInfoTAFLIGHTS;
CREATE TABLE ERRORPilotInfoTAFLIGHTS AS
  (SELECT * FROM validDurationTaFlights WHERE 1 = 0
  );

DROP TABLE PilotInfoFLIGHTSAUDIT;
CREATE TABLE PilotInfoFLIGHTSAUDIT
(
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    a_date          DATE,    --date when ETL was executed
    total_extracted INTEGER, --total number of new, changed, deleted members
    dropped         INTEGER, --number of members with invalid age
    valid           INTEGER, --number of member with a valid age
    PRIMARY KEY (id)
);

