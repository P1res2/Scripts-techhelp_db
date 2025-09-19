USE techhelp_db

-- Inserindo 2 t�cnicos de exemplo
INSERT INTO dbo.tecnicos (nome, email, telefone, senha)
VALUES 
(N'Carlos Silva', 'carlos.silva@empresa.com', '11999990001', 'senha123'),
(N'Ana Paula', 'ana.paula@empresa.com', '11999990002', 'senha456');

-- Inserindo 2 clientes de exemplo: 1 pessoa f�sica e 1 jur�dica
INSERT INTO dbo.clientes (nome_razao, cpf_cnpj, tipo, email, telefone)
VALUES
(N'Jo�o Oliveira', '123.456.789-00', 'F�sica', 'joao.oliveira@email.com', '11988880001'),
(N'Empresa XPTO Ltda', '12.345.678/0001-99', 'Jur�dica', 'contato@xpto.com.br', '11333330001');


-- Inserindo 1 chamado
INSERT INTO dbo.chamados (
    id_cliente,
    id_tecnico,
    titulo,
    descricao,
    tipo_atendimento,
    categoria
)
VALUES (
    1,
    NULL,
    N'Falha ao acessar sistema interno',
    N'O sistema trava ao tentar acessar relat�rios.',
    N'Remoto',
    N'Software'
);
