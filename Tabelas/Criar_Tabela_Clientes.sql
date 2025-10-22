USE techhelp_db

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'clientes' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE clientes (
        id_cliente INT IDENTITY(1,1) PRIMARY KEY,
        nome_razao VARCHAR(100) NOT NULL,
        cpf_cnpj VARCHAR(20) NOT NULL UNIQUE,
        tipo VARCHAR(10) CHECK (tipo IN ('F�sica', 'Jur�dica')) NOT NULL,
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
