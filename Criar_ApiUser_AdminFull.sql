-- =========================
-- Usu�rio Admin
-- =========================
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'AdminFull')
BEGIN
    CREATE LOGIN AdminFull WITH PASSWORD = 'admin123';
    ALTER SERVER ROLE sysadmin ADD MEMBER AdminFull;
    PRINT 'Usu�rio AdminFull criado e adicionado ao sysadmin';
END
ELSE
BEGIN
    PRINT 'Usu�rio AdminFull j� existe';
END

-- =========================
-- Usu�rio B�sico para API
-- =========================
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ApiUser')
BEGIN
    CREATE LOGIN ApiUser WITH PASSWORD = '123456';
    PRINT 'Usu�rio ApiUser criado';
END
ELSE
BEGIN
    PRINT 'Usu�rio ApiUser j� existe';
END

-- =========================
-- Banco espec�fico
-- =========================
USE techhelp_db; -- coloque o nome do seu banco aqui
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ApiUser')
BEGIN
    CREATE USER ApiUser FOR LOGIN ApiUser;
    -- Permiss�es b�sicas
    ALTER ROLE db_datareader ADD MEMBER ApiUser;  -- ler dados
    ALTER ROLE db_datawriter ADD MEMBER ApiUser;  -- escrever dados
    PRINT 'Permiss�es b�sicas concedidas ao ApiUser';
END
ELSE
BEGIN
    PRINT 'Usu�rio ApiUser j� existe no banco';
END
