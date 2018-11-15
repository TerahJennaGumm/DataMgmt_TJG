CREATE ROLE [rol_excproc]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [rol_excproc] ADD MEMBER [ReplicationAdmin];

