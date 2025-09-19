USE techhelp_db

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'tecnicos' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE tecnicos (
        id_tecnico INT IDENTITY(1,1) PRIMARY KEY, 
        nome VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        telefone VARCHAR(20) NOT NULL,
        senha VARCHAR(255) NOT NULL,
        ativo BIT DEFAULT 1, 
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE()
    );

    CREATE INDEX idx_email ON tecnicos (email);
    CREATE INDEX idx_ativo ON tecnicos (ativo);

END
ELSE
BEGIN
    PRINT 'A tabela tecnicos já existe!';
END
