/* In fact, this code will be usefull once in a very long period of time.
  Nobody will deny the fact that new regions within a country are introduced 
  once a century maybe or even more rarely. Unless, the country is progressive 
  in a way it creates regions on a dayli basis.*/

/*Insert regions from source*/
INSERT INTO D_REGION
  (NAME)
  SELECT NAME FROM CHANGEDTAREGION WHERE OPERATION='NEW';