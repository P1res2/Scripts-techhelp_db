USE techhelp_db

-- Apaga os dados em ordem
DELETE FROM dbo.chamados;
DELETE FROM dbo.tecnicos;
DELETE FROM dbo.clientes;

-- Reinicia os IDs das tabelas
DBCC CHECKIDENT ('dbo.chamados', RESEED, 0);
DBCC CHECKIDENT ('dbo.tecnicos', RESEED, 0);
DBCC CHECKIDENT ('dbo.clientes', RESEED, 0);
