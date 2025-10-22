USE techhelp_db

IF NOT EXISTS (
    SELECT 1 FROM sys.tables 
    WHERE name = 'chamados' 
    AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.chamados (
        id_chamado INT IDENTITY(1,1) PRIMARY KEY,
        id_cliente INT NOT NULL,
        id_tecnico INT NULL,
        titulo NVARCHAR(200) NOT NULL,
        descricao NVARCHAR(MAX) NOT NULL,

        prioridade NVARCHAR(10) DEFAULT 'M�dia' CHECK (prioridade IN ('Baixa', 'M�dia', 'Alta', 'Cr�tica')),
        status NVARCHAR(20) DEFAULT 'Aberto' CHECK (status IN ('Aberto', 'Em Andamento', 'Aguardando Cliente', 'Resolvido', 'Fechado')),
        tipo_atendimento NVARCHAR(20) NOT NULL CHECK (tipo_atendimento IN ('Remoto', 'Presencial')),
        categoria NVARCHAR(20) NOT NULL CHECK (categoria IN ('Hardware', 'Software', 'Redes', 'Seguran�a', 'Outros')),

        data_abertura DATETIME2 DEFAULT GETDATE(),
        data_fechamento DATETIME2 NULL,
        tempo_resolucao TIME NULL,
        sla_maximo TIME NULL,

        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2 DEFAULT GETDATE()
    );

    CREATE INDEX idx_cliente ON dbo.chamados (id_cliente);
    CREATE INDEX idx_tecnico ON dbo.chamados (id_tecnico);
    CREATE INDEX idx_status ON dbo.chamados (status);
    CREATE INDEX idx_prioridade ON dbo.chamados (prioridade);
    CREATE INDEX idx_data_abertura ON dbo.chamados (data_abertura);

    ALTER TABLE dbo.chamados
    ADD CONSTRAINT fk_chamados_clientes
        FOREIGN KEY (id_cliente) REFERENCES dbo.clientes(id_cliente) ON DELETE CASCADE;

    ALTER TABLE dbo.chamados
    ADD CONSTRAINT fk_chamados_tecnicos
        FOREIGN KEY (id_tecnico) REFERENCES dbo.tecnicos(id_tecnico) ON DELETE SET NULL;
END;
ELSE
BEGIN
    PRINT 'A tabela chamados j� existe!';
END
