CREATE SCHEMA [Archive]
    AUTHORIZATION [dbo];




GO
GRANT UPDATE
    ON SCHEMA::[Archive] TO [rol_archive];


GO
GRANT SELECT
    ON SCHEMA::[Archive] TO [rol_archive];


GO
GRANT INSERT
    ON SCHEMA::[Archive] TO [rol_archive];

