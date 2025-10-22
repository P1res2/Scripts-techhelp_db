USE techhelp_db

-- Inserindo 1º tecnico de exemplo
INSERT INTO dbo.tecnicos (nome, email, telefone, senha, ativo, created_at)
VALUES
(N'Gabriel Araujo', 'gabriel@email.com', '11976547965', 'senha123', 1, GETDATE());

-- Pegar o ID que acabou de ser criado
DECLARE @id_tecnico INT = SCOPE_IDENTITY();

-- Inserir relacionamento
INSERT INTO dbo.tecnico_especialidades(id_tecnico, id_especialidade, created_at)
VALUES 
(@id_tecnico, 1, GETDATE()),
(@id_tecnico, 2, GETDATE()),
(@id_tecnico, 5, GETDATE());



-- Inserindo 2° tecnico de exemplo
INSERT INTO dbo.tecnicos (nome, email, telefone, senha, ativo, created_at)
VALUES
(N'Douglas Mota', 'joao.oliveira@email.com', '11988880001', 'senha123', 1, GETDATE());

-- Pegar o ID que acabou de ser criado
SET @id_tecnico = SCOPE_IDENTITY();

-- Inserir relacionamento
INSERT INTO dbo.tecnico_especialidades(id_tecnico, id_especialidade, created_at)
VALUES 
(@id_tecnico, 3, GETDATE()),
(@id_tecnico, 4, GETDATE());