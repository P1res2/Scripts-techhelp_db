USE techhelp_db

-- Inserindo 3 clientes de exemplo: 2 pessoa física e 1 jurídica
INSERT INTO dbo.clientes (nome_razao, cpf_cnpj, tipo, email, telefone)
VALUES
(N'João Oliveira', '123.456.789-00', 'Fisica', 'joao.oliveira@email.com', '11988880001'),
(N'Gabriel Araujo', '321.654.789-99', 'Fisica', 'gabriel@email.com', '11976547965'),
(N'Empresa XPTO Ltda', '12.345.678/0001-99', 'Juridica', 'contato@xpto.com.br', '11333330001');
