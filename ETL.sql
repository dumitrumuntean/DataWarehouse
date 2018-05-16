/*
  A script to be runned when ETL is to be performed.
*/
--Extract
@@extractOperation

--Tranform
@@transformMEMBER

--Load
@@newMembersLoad
@@deletedMembersLoad
@@changedMembersLoad

truncate table LEFTJOINEDTAMEMBER;
