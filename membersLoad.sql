
insert into D_MEMBER
select memberno
    from LEFTJOINEDTAMEMBER 
    where operation ='NEW';