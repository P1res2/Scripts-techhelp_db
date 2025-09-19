USE techhelp_db

INSERT INTO tecnicos (nome, email, telefone, senha) VALUES 
    ('Administrador', 'admin@techhelp.com', '(11) 99999-9999', '$2a$10$rOyVcHifyBf6BHFOBbNWO.BKZ9qWavXYoJh4IvOxwZSPpZx0kYQ6a');

INSERT INTO tecnico_especialidades (id_tecnico, id_especialidade)
SELECT 1, id_especialidade FROM especialidades;
