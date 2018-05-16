/*
SOURCE :
https://stackoverflow.com/questions/17549523/populate-time-dim
DATE: 25 April 2018
*/
--

-- drop the table
drop table D_TIME cascade constraints; 

--create a new one
CREATE TABLE D_TIME (
    ID    NUMBER(10)GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) 
        CONSTRAINT NN_TIME_KEY NOT NULL,
    TIME_DESC VARCHAR2(20),
    TIME_IN24_NAME VARCHAR2(20),
    TIME_HOUR24_MINUTE VARCHAR2(40),
    TIME_HOUR_NAME VARCHAR2(10),
    TIME_MINUTE_AMPM VARCHAR2(10),
    TIME_HOUR NUMBER,
    TIME_HOUR24 NUMBER,
    TIME_MINUTE NUMBER,
    TIME_SECOND NUMBER,
    TIME_AMPM_CODE VARCHAR2(2),
    PRIMARY KEY (ID)
);

-- populate it with the necessary data
insert into D_TIME (TIME_DESC,
    TIME_IN24_NAME,
    TIME_HOUR24_MINUTE,
    TIME_HOUR_NAME,
    TIME_MINUTE_AMPM,
    TIME_HOUR,
    TIME_HOUR24,
    TIME_MINUTE,
    TIME_SECOND,
    TIME_AMPM_CODE)
select to_char(t, 'HH:MI:SS AM'),
  to_char(t, 'HH24:MI:SS'),
  to_char(t, 'HH24:MI'),
  to_char(t, 'HH AM'),
  to_char(t, 'HH:MI AM'),
  to_number(to_char(t, 'HH'), '00'),
  to_number(to_char(t, 'HH24'), '00'),
  to_number(to_char(t, 'MI'), '00'),
  to_number(to_char(t, 'SS'), '00'),
  to_char(t, 'AM')
from (
  select trunc(sysdate) + (level - 1)/1440 as t
  from dual
  connect by level <= 1440
);