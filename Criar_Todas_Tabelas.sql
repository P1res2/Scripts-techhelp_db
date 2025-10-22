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
        tipo VARCHAR(10) CHECK (tipo IN ('Fisica', 'Juridica')) NOT NULL,
        email VARCHAR(100) NOT NULL,
        telefone VARCHAR(20) NOT NULL,
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2 DEFAULT GETDATE()
    );

    CREATE INDEX idx_cpf_cnpj ON clientes (cpf_cnpj);
    CREATE INDEX idx_email ON clientes (email);
END
ELSE
BEGIN
    PRINT 'A tabela clientes j� existe!';
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
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2 DEFAULT GETDATE()
    );

    CREATE INDEX idx_email ON tecnicos (email);
    CREATE INDEX idx_ativo ON tecnicos (ativo);

END
ELSE
BEGIN
    PRINT 'A tabela tecnicos j� existe!';
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

        prioridade NVARCHAR(10) DEFAULT 'Media' CHECK (prioridade IN ('Baixa', 'Media', 'Alta', 'Critica')),
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


-- Criando tabela especialidades
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'especialidades' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE especialidades (
        id_especialidade INT IDENTITY(1,1) PRIMARY KEY,
        nome VARCHAR(50) NOT NULL UNIQUE,
        descricao VARCHAR(MAX),
        created_at DATETIME2 DEFAULT GETDATE()
    );
END
ELSE
BEGIN
    PRINT 'A tabela especialidades j� existe!';
END


-- Inserir dados iniciais em especialidades
IF NOT EXISTS (SELECT 1 FROM especialidades WHERE nome = 'Hardware')
BEGIN
    INSERT INTO especialidades (nome, descricao)
    VALUES ('Hardware', 'Manuten��o e reparo de componentes f�sicos de computadores');
END
ELSE
BEGIN
    PRINT('O item Hardware j� existe!');
END

IF NOT EXISTS (SELECT 1 FROM especialidades WHERE nome = 'Software')
BEGIN
    INSERT INTO especialidades (nome, descricao)
    VALUES ('Software', 'Instala��o, configura��o e troubleshooting de software');
END
ELSE
BEGIN
    PRINT('O item Software j� existe!');
END

IF NOT EXISTS (SELECT 1 FROM especialidades WHERE nome = 'Redes')
BEGIN
    INSERT INTO especialidades (nome, descricao)
    VALUES ('Redes', 'Configura��o e solu��o de problemas de redes');
END
ELSE
BEGIN
    PRINT('O item Redes j� existe!');
END

IF NOT EXISTS (SELECT 1 FROM especialidades WHERE nome = 'Seguran�a')
BEGIN
    INSERT INTO especialidades (nome, descricao)
    VALUES ('Seguran�a', 'Implementa��o e manuten��o de sistemas de seguran�a');
END
ELSE
BEGIN
    PRINT('O item Seguran�a j� existe!');
END

IF NOT EXISTS (SELECT 1 FROM especialidades WHERE nome = 'Sistemas Operacionais')
BEGIN
    INSERT INTO especialidades (nome, descricao)
    VALUES ('Sistemas Operacionais', 'Instala��o e configura��o de sistemas operacionais');
END
ELSE
BEGIN
    PRINT('O item Sistemas Operacionais j� existe!');
END

-- Criando tabela de rela��o de tecnicos e especialidades
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'tecnico_especialidades' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE tecnico_especialidades (
        id_tecnico INT NOT NULL,
        id_especialidade INT NOT NULL,
        created_at DATETIME2 DEFAULT GETDATE(),
        CONSTRAINT PK_tecnico_especialidades PRIMARY KEY (id_tecnico, id_especialidade),
        CONSTRAINT FK_tecnico FOREIGN KEY (id_tecnico) 
            REFERENCES tecnicos(id_tecnico) ON DELETE CASCADE,
        CONSTRAINT FK_especialidade FOREIGN KEY (id_especialidade) 
            REFERENCES especialidades(id_especialidade) ON DELETE CASCADE
    );
END
ELSE
BEGIN
    PRINT 'A tabela tecnico_especialidades j� existe!';
END
