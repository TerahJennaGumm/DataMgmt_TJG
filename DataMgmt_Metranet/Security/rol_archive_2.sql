CREATE ROLE [rol_archive]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [rol_archive] ADD MEMBER [ReplicationAdmin];


GO
ALTER ROLE [rol_archive] ADD MEMBER [CONCUR\MN-RevCalc-Prod];

