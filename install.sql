/*This file is to be runned first time when installing 
the whole case in the computer.*/

/*
  NOTE!
  Class.csv and fly.csv should be placed
  on disk D:\ before running this script
*/

--DDL for tables of the source system
@@DDLForOperationalSystems

--Poplating source with data
@@RegionsClubsMembers

--Populating flights with data
@@flights

--Creating and populating tables from external planes source
@@externalPanes

--Creating and populating table from external class source
@@externalClass

--Creates and populates table D_DATE dimension
--it with dates from 1-JAN-1966 till 31-DEC-2030
@@dateGenerator

--Creates and populates table D_TIME dimension
/*
  SOURCE :
    https://stackoverflow.com/questions/17549523/populate-time-dim
  DATE: 25 April 2018
*/
@@timeGenerator

--DDL of the Dimensional Model
-- find the diagram attached to appendicies.
@@dimensionModel

-- DDL for creating tables used in extract operation
@@extractChangedTables

-- DDL for creating tables used in transform operation
@@transformTables