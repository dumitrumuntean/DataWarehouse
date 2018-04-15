-- new = today PK - yesterday PK
insert into CHANGEDTAMEMBER
select    MEMBERNO,
          INITIALS,
          NAME  ,
          ADDRESS,
          ZIPCODE,
          DATEBORN,
          DATEJOINED,
          DATELEFT,
          OWNSPLANEREG,
          STATUSSTUDENT,
          STATUSPILOT,
          STATUSASCAT,
          STATUSFULLCAT,
          SEX,
          CLUB,
          'NEW' 
          from 
          (
            select * from taMember where memberno not in (select memberno from YESTERDAYTAMEMBER)
          );

--deleted = yesterday PK - today PK   
insert into CHANGEDTAMEMBER
select    MEMBERNO,
          INITIALS,
          NAME  ,
          ADDRESS,
          ZIPCODE,
          DATEBORN,
          DATEJOINED,
          DATELEFT,
          OWNSPLANEREG,
          STATUSSTUDENT,
          STATUSPILOT,
          STATUSASCAT,
          STATUSFULLCAT,
          SEX,
          CLUB,
          'DEL' 
          from 
          (
            select * from YESTERDAYTAMEMBEr 
            where memberno not in (select memberno from taMember)
          );

--changed = rows today - rows yesterday - new elements
insert into CHANGEDTAMEMBER
select    MEMBERNO,
          INITIALS,
          NAME  ,
          ADDRESS,
          ZIPCODE,
          DATEBORN,
          DATEJOINED,
          DATELEFT,
          OWNSPLANEREG,
          STATUSSTUDENT,
          STATUSPILOT,
          STATUSASCAT,
          STATUSFULLCAT,
          SEX,
          CLUB,
          'CH' 
          from 
          (
            select * from (
            select * from taMember                --rows today
            minus                                 --minus
            select * from YESTERDAYTAMEMBER)      -- rows yesterday
            where memberno not in (select memberno from CHANGEDTAMEMBER 
            where operation='NEW'-- minus new
          ));
          
    select * from CHANGEDTAMEMBER;
   select count(*) from (select memberno from taMember 
          minus 
          select memberno from CHANGEDTAMEMBER);
truncate table YESTERDAYTAMEMBER;
insert into YESTERDAYTAMEMBER
select * from taMember;
truncate table CHANGEDTAMEMBER;


Delete from taMember where memberno='10000';
insert into taMember (MemberNo, Initials, name, address, zipcode, dateBorn, dateJoined, dateLeft, ownsPlaneReg, statusStudent, statusPilot, statusAsCat, statusFullCat, sex, club ) values(       10000 , 'Dima' , 'Marius' , 'Antonigade, Odense V' ,  5200 , to_date('1965-09-29','YYYY-MM-DD') , to_date('2016-02-05','YYYY-MM-DD') , null , '   ' , 'N' , 'Y' , 'N' , 'N' , 'M' , 'SG70' );

update taMember set address='greg' where memberno='231';
update taMember set address='greg' where memberno='10000';

            select * from (
            select * from taMember
            minus
            select * from YESTERDAYTAMEMBER)
            where memberno not in (select memberno from CHANGEDTAMEMBER where operation='NEW') ;

select * from YESTERDAYTAMEMBER;

truncate table YESTERDAYTAMEMBER;

select * from CHANGEDTAMEMBER;