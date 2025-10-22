IF NOT EXISTS (
    SELECT 1 FROM sys.tables 
    WHERE name = 'avaliacoes' 
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.avaliacoes (
        id_avaliacao INT IDENTITY(1,1) PRIMARY KEY,
        id_chamado INT NOT NULL UNIQUE,
        nota INT CHECK (nota BETWEEN 1 AND 5),
        comentario NVARCHAR(MAX),
        data_avaliacao DATETIME2 DEFAULT GETDATE()
    );

    CREATE INDEX idx_chamado ON dbo.avaliacoes (id_chamado);
    CREATE INDEX idx_data_avaliacao ON dbo.avaliacoes (data_avaliacao);

    ALTER TABLE dbo.avaliacoes
    ADD CONSTRAINT fk_avaliacoes_chamados
        FOREIGN KEY (id_chamado) REFERENCES dbo.chamados(id_chamado) ON DELETE CASCADE;
END
ELSE
BEGIN
    PRINT 'A tabela avaliacoes j� existe!';
END;
