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

--Creación de tabla para guardar los registros de movimiento de Usuario
 CREATE TABLE tb_Registro_Usuario(
    ID_Registro_Usuario INT IDENTITY(1,1) PRIMARY KEY,
    LU int,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Mail VARCHAR(100),
    Estado_Usuario VARCHAR(10),
    Fecha DATETIME DEFAULT GETDATE()
);
GO

--Trigger tr_Resgistro_Usuario
--Objetivo: registrar cualquier alta y baja de Usuarios en una tabla específica 
CREATE TRIGGER tr_Registro_Usuario
ON Usuario
AFTER INSERT, DELETE
AS
BEGIN

    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO dbo.tb_Registro_Usuario (LU, Nombre, Apellido, Mail, Estado_Usuario)
            SELECT LU, Nombre, Apellido, Mail, 'Inserted' FROM inserted;
    END;

    IF EXISTS (SELECT 1 FROM deleated)
    BEGIN
        INSERT INTO dbo.tb_Registro_Usuario (LU, Nombre, Apellido, Mail, Estado_Usuario)
            SELECT LU, Nombre, Apellido, Mail, 'Deleted' FROM deleted;
    END;

END;
GO



-- Trigger que se dispara después de Insertar o Actualizar en la tabla Registro para actualizar estado del espacio
CREATE TRIGGER trg_Registro_ActualizarEstadoEspacio
ON Registro
AFTER INSERT, UPDATE
AS
BEGIN
    -- Declarar una tabla temporal para almacenar los IDespacio únicos afectados
    -- (La tabla 'inserted' o 'deleted' puede tener múltiples filas)
    DECLARE @EspaciosAfectados TABLE (IDespacio INT PRIMARY KEY);

    -- 1. Insertar en la tabla temporal los IDespacio afectados por la INSERCIÓN o ACTUALIZACIÓN
    INSERT INTO @EspaciosAfectados (IDespacio)
    SELECT IDespacio FROM inserted
    UNION
    SELECT IDespacio FROM deleted; -- En caso de UPDATE, también incluimos el ID viejo si cambió

    -- 2. Actualizar la tabla Espacios basándose en la lista de IDs afectados
    UPDATE E
    SET E.Estado = dbo.fn_CalcularEstadoEspacio(E.IDespacio)
    FROM 
        Espacios E
    JOIN 
        @EspaciosAfectados AF ON E.IDespacio = AF.IDespacio;

END
GO