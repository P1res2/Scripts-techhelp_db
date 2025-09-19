USE techhelp_db

IF NOT EXISTS (
    SELECT 1 FROM sys.tables 
    WHERE name = 'relatorios' 
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.relatorios (
        id_relatorio INT IDENTITY(1,1) PRIMARY KEY,
        mes_referencia VARCHAR(7) NOT NULL, -- Exemplo: '2025-09'
        id_cliente INT NULL,
        id_tecnico INT NULL,
        tipo_problema VARCHAR(100),
        quantidade_chamados INT DEFAULT 0,
        tempo_medio_resolucao TIME,
        created_at DATETIME DEFAULT GETDATE()
    );

    -- Índices
    CREATE INDEX idx_mes_referencia ON dbo.relatorios (mes_referencia);
    CREATE INDEX idx_cliente ON dbo.relatorios (id_cliente);
    CREATE INDEX idx_tecnico ON dbo.relatorios (id_tecnico);

    -- Chaves estrangeiras
    ALTER TABLE dbo.relatorios
    ADD CONSTRAINT fk_relatorios_clientes
        FOREIGN KEY (id_cliente) REFERENCES dbo.clientes(id_cliente) ON DELETE SET NULL;

    ALTER TABLE dbo.relatorios
    ADD CONSTRAINT fk_relatorios_tecnicos
        FOREIGN KEY (id_tecnico) REFERENCES dbo.tecnicos(id_tecnico) ON DELETE SET NULL;
END
ELSE
BEGIN
    PRINT 'A tabela relatorios já existe!';
END;
