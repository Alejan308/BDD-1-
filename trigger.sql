USE FreeSpaces;
GO

-- Crear tabla para guardar los registros de nuevos tipos de espacio 
CREATE TABLE Auditoria_TipoEspacio( --Guarda los datos de los tipos de espacio que se vayan agregando.
    ID INT IDENTITY (1,1) PRIMARY KEY,
    IDtipoEspacio INT,
    Nombre VARCHAR(100),
    Fecha DATETIME DEFAULT GETDATE()
);
GO

--trigger para registrar cuando se agrega un nuevo tipo de espacio

CREATE TRIGGER tr_TipoEspacio_Auditoria --Crea un trigger llamado tr_TipoEspacio_Auditoria
ON TipoEspacio --Indica sobre qué tabla actúa el trigger
AFTER INSERT
AS
BEGIN 
    INSERT INTO Auditoria_TipoEspacio(IDtipoEspacio,Nombre)
    select IDtipoEspacio,Nombre
    FROM inserted;
end;
GO
