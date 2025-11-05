/*Procedimiento almacenado Usuario*/

--------------------------------------------------------------------------------------------------------------------------------
/*Procedimiento almacenado Registo*/

CREATE PROCEDURE sp_Registro_IniciarOcupacion
        @IDusuario INT,
        @IDespacio INT
    AS
    BEGIN
        -- Aca se guarda el estado de Espacio
        DECLARE @EstadoActual VARCHAR(20);

        -- Aca se consigue el estado actual del Espacio
        SELECT @EstadoActual = Estado 
        FROM Espacios 
        WHERE IDespacio = @IDespacio;

        -- Se ve si esta disponible
        IF @EstadoActual = 'Disponible'
        BEGIN
            UPDATE Espacios
            SET Estado = 'Ocupado'
            WHERE IDespacio = @IDespacio;
            
            INSERT INTO Registro (IDespacio, IDusuario, HoraEntrada, HoraSalida)
            VALUES (@IDespacio, @IDusuario, GETDATE(), NULL);
            
            PRINT 'Ocupación registrada con éxito.';
        END
        ELSE
        BEGIN
            PRINT 'Error: El espacio ya se encuentra ocupado.';
        END
    END;
GO

CREATE PROCEDURE sp_Registro_FinalizarOcupacion
        @IDespacio INT
    AS
    BEGIN
        DECLARE @EstadoActual VARCHAR(20);

        SELECT @EstadoActual = Estado 
        FROM Espacios 
        WHERE IDespacio = @IDespacio;

        IF @EstadoActual = 'Ocupado'
        BEGIN
            UPDATE Espacios
            SET Estado = 'Disponible'
            WHERE IDespacio = @IDespacio;

            UPDATE Registro
            SET HoraSalida = GETDATE()
            WHERE IDespacio = @IDespacio AND HoraSalida IS NULL;
            
            PRINT 'Espacio liberado.';
        END
        ELSE
        BEGIN
            PRINT 'Error: El espacio ya se encontraba disponible.';
        END
    END;
GO

CREATE PROCEDURE sp_Registro_GetPorUsuario
        @IDusuario INT
    AS
    BEGIN
        SELECT 
            r.IDregistro,
            r.HoraEntrada,
            r.HoraSalida,
            t.Nombre AS TipoDeEspacio,
            s.Nombre AS Sede
        FROM 
            Registro r
        JOIN 
            Espacios e ON r.IDespacio = e.IDespacio
        JOIN 
            TipoEspacio t ON e.IDtipoEspacio = t.IDtipoEspacio
        JOIN
            Sede s ON e.IDsede = s.IDsede
        WHERE 
            r.IDusuario = @IDusuario
        ORDER BY
            r.HoraEntrada DESC; -- Descendiente para mostrar los más nuevos primero
    END;
GO

CREATE PROCEDURE sp_Registro_Delete
        @IDregistro INT
    AS
    BEGIN
        DELETE FROM Registro
        WHERE IDregistro = @IDregistro;
        
        PRINT 'Registro eliminado.';
    END;
GO
--------------------------------------------------------------------------------------------------------------------------------
/*Procedimiento almacenado Espacio*/

/*Procedimiento almacenado TipoEspacio*/
GO
--Procedimiento 1: sp_Listar_TipoEspacio
--Objetivo: Listar todos los tipos de espacio con sus elementos y cantidad de lugares.

CREATE PROCEDURE sp_Listar_TipoEspacio --→ Crea un procedimiento almacenado con el nombre sp_Listar_TipoEspacio
AS
BEGIN
    SELECT --→ Consulta (SELECT) que pide esos 4 campos de la tabla TipoEspacio. Devuelve todas las filas de la tabla.
        IDtipoEspacio,
        Nombre,
        Elementos,
        CantLugar
    FROM TipoEspacio
    ORDER BY Nombre;
END;
GO

--Procedimiento 2: sp_Insertar_TipoEspacio
--Objetivo: Insertar un nuevo tipo de espacio con sus características.
CREATE PROCEDURE sp_Insertar_TipoEspacio --→ Crea el procedimiento sp_Insertar_TipoEspacio
    @Nombre VARCHAR(100), --→ Estos son los parámetros que recibe el procedimiento.
    @Elementos VARCHAR(400),
    @CantLugar INT
AS
BEGIN
    INSERT INTO TipoEspacio (Nombre, Elementos) --→ Inserta un nuevo registro en la tabla TipoEspacio
    VALUES (@Nombre, @Elementos);

    PRINT 'Se agrego un nuevo tipo de espacio correctamente.';
END;
GO

/*Procedimiento almacenado Ubicacion*/

/*Procedimiento almacenado Sede*/
