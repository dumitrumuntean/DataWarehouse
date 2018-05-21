/*
  A script to be runned when ETL is to be performed.
*/
--Extract
@@extractOperation

--Tranform
@@transformMEMBER

--Load
@@regionsLoad
@@clubLoad
@@newMembersLoad
@@deletedMembersLoad
@@changedMembersLoad
@@planesLoad

truncate table LEFTJOINEDTAMEMBER;