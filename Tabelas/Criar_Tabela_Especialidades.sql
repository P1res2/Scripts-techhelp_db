USE techhelp_db

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

-- Inserir dados iniciais
INSERT INTO especialidades (nome, descricao) VALUES 
('Hardware', 'Manuten��o e reparo de componentes f�sicos de computadores'), -- id = 1
('Software', 'Instala��o, configura��o e troubleshooting de software'), -- id = 2
('Redes', 'Configura��o e solu��o de problemas de redes'), -- id = 3
('Seguran�a', 'Implementa��o e manuten��o de sistemas de seguran�a'), -- id = 4
('Sistemas Operacionais', 'Instala��o e configura��o de sistemas operacionais'); -- id = 5
