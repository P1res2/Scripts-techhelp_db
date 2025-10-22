-- =========================
-- Usuário Admin
-- =========================
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'AdminFull')
BEGIN
    CREATE LOGIN AdminFull WITH PASSWORD = 'admin123';
    ALTER SERVER ROLE sysadmin ADD MEMBER AdminFull;
    PRINT 'Usuário AdminFull criado e adicionado ao sysadmin';
END
ELSE
BEGIN
    PRINT 'Usuário AdminFull já existe';
END

-- =========================
-- Usuário Básico para API
-- =========================
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ApiUser')
BEGIN
    CREATE LOGIN ApiUser WITH PASSWORD = '123456';
    PRINT 'Usuário ApiUser criado';
END
ELSE
BEGIN
    PRINT 'Usuário ApiUser já existe';
END

-- =========================
-- Banco específico
-- =========================
USE techhelp_db; -- coloque o nome do seu banco aqui
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ApiUser')
BEGIN
    CREATE USER ApiUser FOR LOGIN ApiUser;
    -- Permissões básicas
    ALTER ROLE db_datareader ADD MEMBER ApiUser;  -- ler dados
    ALTER ROLE db_datawriter ADD MEMBER ApiUser;  -- escrever dados
    PRINT 'Permissões básicas concedidas ao ApiUser';
END
ELSE
BEGIN
    PRINT 'Usuário ApiUser já existe no banco';
END
