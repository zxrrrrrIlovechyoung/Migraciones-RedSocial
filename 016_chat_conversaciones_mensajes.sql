USE RedSocialDB;
GO

IF OBJECT_ID('dbo.Conversaciones', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Conversaciones (
        IdConversacion INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Conversaciones PRIMARY KEY,
        HashConversacion NVARCHAR(128) NOT NULL,
        IdUsuarioA INT NOT NULL,
        IdUsuarioB INT NOT NULL,
        FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_Conversaciones_FechaCreacion DEFAULT SYSUTCDATETIME(),
        FechaActualizacion DATETIME2 NOT NULL CONSTRAINT DF_Conversaciones_FechaActualizacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Conversaciones_UsuarioA FOREIGN KEY (IdUsuarioA) REFERENCES dbo.Usuarios(IdUsuario),
        CONSTRAINT FK_Conversaciones_UsuarioB FOREIGN KEY (IdUsuarioB) REFERENCES dbo.Usuarios(IdUsuario),
        CONSTRAINT CK_Conversaciones_Usuarios CHECK (IdUsuarioA <> IdUsuarioB)
    );

    CREATE UNIQUE INDEX UX_Conversaciones_Hash ON dbo.Conversaciones(HashConversacion);
    CREATE UNIQUE INDEX UX_Conversaciones_Usuarios ON dbo.Conversaciones(IdUsuarioA, IdUsuarioB);
END;
GO

IF OBJECT_ID('dbo.MensajesChat', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MensajesChat (
        IdMensaje INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MensajesChat PRIMARY KEY,
        IdConversacion INT NOT NULL,
        IdEmisor INT NOT NULL,
        Texto NVARCHAR(1000) NOT NULL,
        FechaEnvio DATETIME2 NOT NULL CONSTRAINT DF_MensajesChat_FechaEnvio DEFAULT SYSUTCDATETIME(),
        Leido BIT NOT NULL CONSTRAINT DF_MensajesChat_Leido DEFAULT 0,
        CONSTRAINT FK_MensajesChat_Conversacion FOREIGN KEY (IdConversacion) REFERENCES dbo.Conversaciones(IdConversacion) ON DELETE CASCADE,
        CONSTRAINT FK_MensajesChat_Emisor FOREIGN KEY (IdEmisor) REFERENCES dbo.Usuarios(IdUsuario)
    );

    CREATE INDEX IX_MensajesChat_Conversacion_Fecha ON dbo.MensajesChat(IdConversacion, FechaEnvio);
END;
GO
