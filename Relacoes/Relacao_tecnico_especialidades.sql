USE techhelp_db

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
