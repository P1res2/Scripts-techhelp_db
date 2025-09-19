USE techhelp_db

IF NOT EXISTS (
    SELECT 1 FROM sys.tables
    WHERE name = 'logs_acesso'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.logs_acesso (
        id_log INT IDENTITY(1,1) PRIMARY KEY,
        usuario VARCHAR(100) NULL,
        acao VARCHAR(200) NULL,
        data_hora DATETIME DEFAULT GETDATE(),
        ip VARCHAR(45) NULL,
        user_agent NVARCHAR(MAX) NULL
    );

    CREATE INDEX idx_usuario ON dbo.logs_acesso (usuario);
    CREATE INDEX idx_data_hora ON dbo.logs_acesso (data_hora);
END
ELSE
BEGIN
    PRINT 'A tabela logs_acesso já existe!';
END;
