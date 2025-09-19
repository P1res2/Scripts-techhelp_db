USE techhelp_db

IF NOT EXISTS (
    SELECT 1 FROM sys.tables
    WHERE name = 'contratos'
    AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE contratos (
        id_contrato INT IDENTITY(1,1) PRIMARY KEY, 
        id_cliente INT NOT NULL,
        tipo_cobranca VARCHAR(20) CHECK (tipo_cobranca IN ('Chamado', 'Hora Técnica', 'Mensal')) NOT NULL, 
        data_inicio DATE NOT NULL,
        data_fim DATE NULL,
        valor DECIMAL(10,2) NULL,
        descricao VARCHAR(MAX) NULL, 
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_contrato_cliente FOREIGN KEY (id_cliente) 
            REFERENCES clientes(id_cliente) ON DELETE CASCADE
    );

    CREATE INDEX idx_cliente ON contratos (id_cliente);
    CREATE INDEX idx_data_inicio ON contratos (data_inicio);
END
ELSE
BEGIN
    PRINT 'A tabela contratos já existe!';
END
