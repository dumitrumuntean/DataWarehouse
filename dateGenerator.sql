--drop table
drop table D_DATE cascade constraints;

--create a new one
create table D_DATE(
  id  NUMBER(10) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
  d_date date,
  dayOFWeek varchar(10),
  primary key(id)
);

--populate it
declare
 start_date date := to_date('1-JAN-1966'); --the date to begin with
 end_date date := to_date('31-DEC-2030');  -- the date to end with
 begin
  while start_date <= end_date LOOP
    insert into D_DATE(
      D_DATE,
      DAYOFWEEK
    ) values(
      start_date,    --DATE
      to_char(start_date, 'DAY')
    );
    start_date := start_date + 1;
    end LOOP;
    end;  
    /
