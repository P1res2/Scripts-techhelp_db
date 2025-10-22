IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'techhelp_db')
BEGIN
    CREATE DATABASE techhelp_db;
    PRINT 'Banco techhelp_db criado com sucesso!';
END
ELSE
BEGIN
    PRINT 'Banco techhelp_db já existe!';
END;