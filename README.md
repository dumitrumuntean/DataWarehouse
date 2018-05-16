# DataWarehouse

### Extract

1. extractChangedTables.sql
  contains the ddl for creating tables which are to be used in extract operation;

2. extractOperation.sql
  contains the ddl for extract operation.
  extract operation is performed on all tables from all the sources

##### Transform operation is performed only on member tables

### Transform
    
1. transformMEMBER.sql
 contains the ddl for creating tables which are to be used in tranform operaion
 contains the ddl for transform operation itself

### Load

1. newMemebersLoad.sql
2. deletedMembersLoad.sql
3. changedMemebersLoad.sql

