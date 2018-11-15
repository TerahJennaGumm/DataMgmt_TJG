ALTER ROLE [db_owner] ADD MEMBER [CONCUR\DataMgmt];


GO
ALTER ROLE [db_owner] ADD MEMBER [SAPService];


GO
ALTER ROLE [db_owner] ADD MEMBER [CONCUR\sqldb_prod_migrdb_dbo];


GO
ALTER ROLE [db_datareader] ADD MEMBER [ReplicationAdmin];


GO
ALTER ROLE [db_datareader] ADD MEMBER [dmgmt.infosteward];


GO
ALTER ROLE [db_datareader] ADD MEMBER [app.psiusr];


GO
ALTER ROLE [db_datareader] ADD MEMBER [QATeam];


GO
ALTER ROLE [db_datareader] ADD MEMBER [app.infosteward];


GO
ALTER ROLE [db_datareader] ADD MEMBER [CONCUR\sqldb_prod_migrdb_ro];


GO
ALTER ROLE [db_datareader] ADD MEMBER [CONCUR\sqldb_prod_migrdb_rw];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [CONCUR\sqldb_prod_migrdb_rw];

