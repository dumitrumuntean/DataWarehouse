create or replace directory planesLocation as 'D:\'
;
grant read, write on directory  planesLocation to public
;

drop table extPlanes
;
create table extPlanes
  (
     registration   varchar2(10)
    , competitionNumber varchar2(10)
    , type              varchar2(50)
    , clubOwned         varchar2(10)
    , ownerName         varchar2(100)
  )
  organization external
  (
     type oracle_loader
     default directory planesLocation
     access parameters
        (
            records delimited by newline
             CHARACTERSET WE8ISO8859P1
      STRING SIZES ARE IN CHARACTERS
                        BADFILE 'planes.bad'
    DISCARDFILE 'planes.dis'
    LOGFILE 'planes.log'    
            fields terminated by ';' optionally enclosed by '"'
         )
  location ('fly.csv')
   )
   ;

select * 
  from extPlanes
  ;