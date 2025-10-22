USE techhelp_db

IF NOT EXISTS (
    SELECT 1 FROM sys.tables 
    WHERE name = 'atendimentos' 
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.atendimentos (
        id_atendimento INT IDENTITY(1,1) PRIMARY KEY,
        id_chamado INT NOT NULL,
        data_inicio DATETIME2 NOT NULL,
        data_fim DATETIME2 NULL,
        descricao NVARCHAR(MAX),
        solucao NVARCHAR(MAX),
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2 DEFAULT GETDATE()
    );

    CREATE INDEX idx_chamado ON dbo.atendimentos (id_chamado);
    CREATE INDEX idx_data_inicio ON dbo.atendimentos (data_inicio);

    ALTER TABLE dbo.atendimentos
    ADD CONSTRAINT fk_atendimentos_chamados
        FOREIGN KEY (id_chamado) REFERENCES dbo.chamados(id_chamado) ON DELETE CASCADE;
END;
ELSE
BEGIN
    PRINT 'A tabela atendimentos j� existe!';
END
