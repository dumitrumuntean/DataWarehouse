/*
A script to be runned when ETL is to be performed.
*/
--Extract
@@extractOperation
--Tranform
@@transformMEMBER
--Load
@@regionLoad
@@clubLoad
@@newMembersLoad
@@deletedMembersLoad
@@changedMembersLoad
@@planesLoad
/*TRANSFORM FACT FLIGHT*/
@@validateDurationFlights(Transform)
@@validatePilotInfoFlights

TRUNCATE TABLE LEFTJOINEDTAMEMBER;