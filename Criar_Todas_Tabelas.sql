USE techhelp_db

-- Criando tabela clientes
IF NOT EXISTS (
    SELECT 1 FROM sys.tables
    WHERE name = 'clientes'
    AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE clientes (
        id_cliente INT IDENTITY(1,1) PRIMARY KEY,
        nome_razao VARCHAR(100) NOT NULL,
        cpf_cnpj VARCHAR(20) NOT NULL UNIQUE,
        tipo VARCHAR(10) CHECK (tipo IN ('Física', 'Jurídica')) NOT NULL,
        email VARCHAR(100) NOT NULL,
        telefone VARCHAR(20) NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE()
    );

    CREATE INDEX idx_cpf_cnpj ON clientes (cpf_cnpj);
    CREATE INDEX idx_email ON clientes (email);
END
ELSE
BEGIN
    PRINT 'A tabela clientes já existe!';
END


-- Criando tabela tecnicos
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


-- Criando tabela chamados
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

        prioridade NVARCHAR(10) DEFAULT 'Média' CHECK (prioridade IN ('Baixa', 'Média', 'Alta', 'Crítica')),
        status NVARCHAR(20) DEFAULT 'Aberto' CHECK (status IN ('Aberto', 'Em Andamento', 'Aguardando Cliente', 'Resolvido', 'Fechado')),
        tipo_atendimento NVARCHAR(20) NOT NULL CHECK (tipo_atendimento IN ('Remoto', 'Presencial')),
        categoria NVARCHAR(20) NOT NULL CHECK (categoria IN ('Hardware', 'Software', 'Redes', 'Segurança', 'Outros')),

        data_abertura DATETIME DEFAULT GETDATE(),
        data_fechamento DATETIME NULL,
        tempo_resolucao TIME NULL,
        sla_maximo TIME NULL,

        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE()
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
    PRINT 'A tabela chamados já existe!';
END


-- Criando tabela especialidades
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'especialidades' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE especialidades (
        id_especialidade INT IDENTITY(1,1) PRIMARY KEY,
        nome VARCHAR(50) NOT NULL UNIQUE,
        descricao VARCHAR(MAX),
        created_at DATETIME DEFAULT GETDATE()
    );
END
ELSE
BEGIN
    PRINT 'A tabela especialidades já existe!';
END


-- Inserir dados iniciais em especialidades
IF NOT EXISTS (SELECT 1 FROM especialidades WHERE nome = 'Hardware')
BEGIN
    INSERT INTO especialidades (nome, descricao)
    VALUES ('Hardware', 'Manutenção e reparo de componentes físicos de computadores');
END
ELSE
BEGIN
    PRINT('O item Hardware já existe!');
END

IF NOT EXISTS (SELECT 1 FROM especialidades WHERE nome = 'Software')
BEGIN
    INSERT INTO especialidades (nome, descricao)
    VALUES ('Software', 'Instalação, configuração e troubleshooting de software');
END
ELSE
BEGIN
    PRINT('O item Software já existe!');
END

IF NOT EXISTS (SELECT 1 FROM especialidades WHERE nome = 'Redes')
BEGIN
    INSERT INTO especialidades (nome, descricao)
    VALUES ('Redes', 'Configuração e solução de problemas de redes');
END
ELSE
BEGIN
    PRINT('O item Redes já existe!');
END

IF NOT EXISTS (SELECT 1 FROM especialidades WHERE nome = 'Segurança')
BEGIN
    INSERT INTO especialidades (nome, descricao)
    VALUES ('Segurança', 'Implementação e manutenção de sistemas de segurança');
END
ELSE
BEGIN
    PRINT('O item Segurança já existe!');
END

IF NOT EXISTS (SELECT 1 FROM especialidades WHERE nome = 'Sistemas Operacionais')
BEGIN
    INSERT INTO especialidades (nome, descricao)
    VALUES ('Sistemas Operacionais', 'Instalação e configuração de sistemas operacionais');
END
ELSE
BEGIN
    PRINT('O item Sistemas Operacionais já existe!');
END


-- Criando tabela atendimentos
IF NOT EXISTS (
    SELECT 1 FROM sys.tables 
    WHERE name = 'atendimentos' 
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.atendimentos (
        id_atendimento INT IDENTITY(1,1) PRIMARY KEY,
        id_chamado INT NOT NULL,
        data_inicio DATETIME NOT NULL,
        data_fim DATETIME NULL,
        descricao NVARCHAR(MAX),
        solucao NVARCHAR(MAX),
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE()
    );

    CREATE INDEX idx_chamado ON dbo.atendimentos (id_chamado);
    CREATE INDEX idx_data_inicio ON dbo.atendimentos (data_inicio);

    ALTER TABLE dbo.atendimentos
    ADD CONSTRAINT fk_atendimentos_chamados
        FOREIGN KEY (id_chamado) REFERENCES dbo.chamados(id_chamado) ON DELETE CASCADE;
END;
ELSE
BEGIN
    PRINT 'A tabela atendimentos já existe!';
END


-- Criando tabela de relação de tecnicos e especialidades
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'tecnico_especialidades' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE tecnico_especialidades (
        id_tecnico INT NOT NULL,
        id_especialidade INT NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT PK_tecnico_especialidades PRIMARY KEY (id_tecnico, id_especialidade),
        CONSTRAINT FK_tecnico FOREIGN KEY (id_tecnico) 
            REFERENCES tecnicos(id_tecnico) ON DELETE CASCADE,
        CONSTRAINT FK_especialidade FOREIGN KEY (id_especialidade) 
            REFERENCES especialidades(id_especialidade) ON DELETE CASCADE
    );
END
ELSE
BEGIN
    PRINT 'A tabela tecnico_especialidades já existe!';
END


-- Criando tabela contratos
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


-- Criando tabela avaliações
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
        data_avaliacao DATETIME DEFAULT GETDATE()
    );

    CREATE INDEX idx_chamado ON dbo.avaliacoes (id_chamado);
    CREATE INDEX idx_data_avaliacao ON dbo.avaliacoes (data_avaliacao);

    ALTER TABLE dbo.avaliacoes
    ADD CONSTRAINT fk_avaliacoes_chamados
        FOREIGN KEY (id_chamado) REFERENCES dbo.chamados(id_chamado) ON DELETE CASCADE;
END
ELSE
BEGIN
    PRINT 'A tabela avaliacoes já existe!';
END;


-- Criando tabela relatorios
IF NOT EXISTS (
    SELECT 1 FROM sys.tables 
    WHERE name = 'relatorios' 
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.relatorios (
        id_relatorio INT IDENTITY(1,1) PRIMARY KEY,
        mes_referencia VARCHAR(7) NOT NULL,
        id_cliente INT NULL,
        id_tecnico INT NULL,
        tipo_problema VARCHAR(100),
        quantidade_chamados INT DEFAULT 0,
        tempo_medio_resolucao TIME,
        created_at DATETIME DEFAULT GETDATE()
    );

    CREATE INDEX idx_mes_referencia ON dbo.relatorios (mes_referencia);
    CREATE INDEX idx_cliente ON dbo.relatorios (id_cliente);
    CREATE INDEX idx_tecnico ON dbo.relatorios (id_tecnico);

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


-- Criando tabela logs_acesso
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
