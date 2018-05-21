select count(*) from D_MEMBER;

select count(*) from D_MEMBERPROFILE;

insert into taMember (MemberNo, Initials, name, address, zipcode, dateBorn, dateJoined, dateLeft, ownsPlaneReg, statusStudent, statusPilot, statusAsCat, statusFullCat, sex, club ) values(       33333 , 'MUDL' , 'MUDAK MUDAK' , 'Antonigade, Odense V' ,  5200 , to_date('1965-09-29','YYYY-MM-DD') , to_date('2016-02-05','YYYY-MM-DD') , null , '   ' , 'N' , 'Y' , 'N' , 'N' , 'M' , 'SG70' );

delete from TAMEMBER where memberno='33333';

select * from tamember;

delete from taMember;

update taMember set address = 'suka' where memberno='33333';
select * from D_MEMBERPROFILE;
select * from D_MEMBERPROFILE
   join D_DATE d on validto = d.id
  where member_no = '33333';

select * from tamember;

select * from LEFTJOINEDTAMEMBER;

@@ETL
@@install
