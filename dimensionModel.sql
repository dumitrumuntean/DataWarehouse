DROP TABLE D_LaunchMethod;
CREATE TABLE D_LaunchMethod
  (
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    launch_method VARCHAR2(20),
    PRIMARY KEY(id)
  );
DROP TABLE d_club CASCADE CONSTRAINTS;
CREATE TABLE d_club
  (
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    club_name VARCHAR2(50),
    address   VARCHAR2(100),
    zipcode   INTEGER,
    region    NUMBER(10,0),
    PRIMARY KEY (id)
  );
DROP TABLE d_member CASCADE CONSTRAINTS;
CREATE TABLE d_member
  ( memberno NUMBER(6,0), PRIMARY KEY(memberno)
  );
DROP TABLE d_memberprofile CASCADE CONSTRAINTS;
CREATE TABLE d_memberprofile
  (
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1) ,
    member_no     NUMBER(6,0) REFERENCES d_member(memberno),
    name          VARCHAR2(60),
    age           DECIMAL(3,1),
    address       VARCHAR(50),
    member_status VARCHAR2(50),
    sex           CHAR(1) CONSTRAINT sex_constraint CHECK(sex IN('M','F')),
    validFrom     NUMBER(10,0),
    validTo       NUMBER(10,0),
    PRIMARY KEY(id)
  );
DROP TABLE d_plane CASCADE CONSTRAINTS;
CREATE TABLE d_plane
  (
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    registration VARCHAR2(20),
    COMPETITIONNO VARCHAR2(10),
    type         VARCHAR2(20),
    PRIMARY KEY (id)
  );
DROP TABLE f_flight CASCADE CONSTRAINTS;
CREATE TABLE f_flight
  (
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    d_club       INTEGER,
    d_plane      INTEGER,
    member_id    NUMBER(6,0),
    launch_time  INTEGER,
    landing_time INTEGER,
    ddate        INTEGER,
    PRIMARY KEY(id),
    CONSTRAINT fk_club FOREIGN KEY(d_club) REFERENCES d_club(id),
    CONSTRAINT fk_plane FOREIGN KEY(d_plane) REFERENCES d_plane(id),
    CONSTRAINT fk_launch FOREIGN KEY (launch_time) REFERENCES d_time(id),
    CONSTRAINT fk_landing FOREIGN KEY (landing_time) REFERENCES d_time(id),
    CONSTRAINT fk_memberidd FOREIGN KEY (member_id) REFERENCES d_memberprofile(id),
    CONSTRAINT fk_date FOREIGN KEY (ddate) REFERENCES d_date(id)
  );
DROP TABLE f_membership CASCADE CONSTRAINTS;
CREATE TABLE f_membership
  (
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    member_id INTEGER,
    club_id   INTEGER,
    date_from INTEGER,
    date_to   INTEGER,
    PRIMARY KEY(id),
    CONSTRAINT fk_memberid FOREIGN KEY(member_id) REFERENCES d_member(memberno),
    CONSTRAINT fk_clubid FOREIGN KEY(club_id) REFERENCES d_club(id),
    CONSTRAINT fk_datefrom FOREIGN KEY(date_from) REFERENCES d_date(id),
    CONSTRAINT fk_dateto FOREIGN KEY(date_to) REFERENCES d_date(id)
  );
DROP TABLE f_ownership CASCADE CONSTRAINTS;
CREATE TABLE f_ownership
  (
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    member_id INTEGER,
    plane_id  INTEGER,
    date_from INTEGER,
    date_to   INTEGER,
    PRIMARY KEY(id),
    CONSTRAINT fk_owner_member FOREIGN KEY(member_id) REFERENCES d_member(memberno),
    CONSTRAINT fk_owns_plane FOREIGN KEY(plane_id) REFERENCES d_plane(id),
    CONSTRAINT fk_from FOREIGN KEY(date_from) REFERENCES d_date(id),
    CONSTRAINT fk_to FOREIGN KEY(date_to) REFERENCES d_date(id)
  );
DROP TABLE f_club_ownership CASCADE CONSTRAINTS;
CREATE TABLE f_club_ownership
  (
    id NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    club_id   INTEGER,
    plane_id  INTEGER,
    date_from INTEGER,
    date_to   INTEGER,
    PRIMARY KEY(id),
    CONSTRAINT fk_clubownership FOREIGN KEY(club_id) REFERENCES d_club(id),
    CONSTRAINT fk_club_owns_plane FOREIGN KEY(plane_id) REFERENCES d_plane(id),
    CONSTRAINT fk_dfrom FOREIGN KEY(date_from) REFERENCES d_date(id),
    CONSTRAINT fk_dto FOREIGN KEY(date_to) REFERENCES d_date(id)
  );
DROP TABLE D_REGION CASCADE CONSTRAINTS;
CREATE TABLE D_REGION
  (
    ID NUMBER GENERATED ALWAYS AS IDENTITY(
    START WITH 1 INCREMENT BY 1),
    NAME VARCHAR2(50),
    PRIMARY KEY(ID)
  );
/*There are only 4(four) launch methods. Therefore,
we find it a resonable decesion to populate the dimension
D_LAUNCHMETHOD manually. */
INSERT
INTO D_LAUNCHMETHOD
  (
    LAUNCH_METHOD
  )
  VALUES
  (
    'LaunchAerotow'
  );
INSERT INTO D_LAUNCHMETHOD
  (LAUNCH_METHOD
  ) VALUES
  ( 'LaunchWinch'
  );
INSERT INTO D_LAUNCHMETHOD
  (LAUNCH_METHOD
  ) VALUES
  ( 'LaunchSelfLaunch'
  );
INSERT INTO D_LAUNCHMETHOD
  (LAUNCH_METHOD
  ) VALUES
  ( 'CableBreak'
  );
