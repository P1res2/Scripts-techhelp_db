USE techhelp_db

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

-- Inserir dados iniciais
INSERT INTO especialidades (nome, descricao) VALUES 
('Hardware', 'Manutenção e reparo de componentes físicos de computadores'),
('Software', 'Instalação, configuração e troubleshooting de software'),
('Redes', 'Configuração e solução de problemas de redes'),
('Segurança', 'Implementação e manutenção de sistemas de segurança'),
('Sistemas Operacionais', 'Instalação e configuração de sistemas operacionais');
