create or replace directory classLocation as 'D:\'
;
grant read, write on directory  classLocation to public
;

drop table extClass
;
create table extClass
  (
     type              varchar2(50),
     class             varchar2(50)

  )
  organization external
  (
     type oracle_loader
     default directory classLocation
     access parameters
        (
            records delimited by newline
             CHARACTERSET WE8ISO8859P1
      STRING SIZES ARE IN CHARACTERS
                        BADFILE 'class.bad'
    DISCARDFILE 'planes.dis'
    LOGFILE 'class.log'    
            fields terminated by ';' optionally enclosed by '"'
         )
  location ('Class.csv')
   )
   ;