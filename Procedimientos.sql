/*Procedimiento almacenado Usuario*/
--Procedimiento 1: sp_Ingresar_Usuario
--Objetivo: Ingresar nuevos Usuarios
CREATE PROCEDURE sp_Ingresar_Usuario
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Mail VARCHAR(100),
    @Privilegio VARCHAR(20)
AS
BEGIN
    INSERT INTO Usuario VALUES (@Nombre, @Apellido, @Mail, @Privilegio)
    PRINT 'Ingreso del nuevo usuario realizado con éxito.'
END
GO

EXEC sp_Ingresar_Usuario 'Ignacio Fernando', 'Gonzalez Gomez', 'igngonzalez@uade.edu.ar', 'Estudiante';
GO

--Procedimiento 2: sp_Baja_Usuario
--Objetivo: Capacidad de dar de baja a un Usuario con el Legajo o el mail.
CREATE PROCEDURE sp_Baja_Usuario
    @LU INT,
    @Mail VARCHAR(100)
AS
BEGIN
    DELETE FROM Usuario WHERE LU = @LU OR mail = @Mail
    PRINT 'El usuario ha sido Eliminado correctamente'
END
GO

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
--Procedimiento 1: sp_Insertar_Sede
--Objetivo: Incertar una nueva sede en caso de expanción de la universidad
CREATE PROCEDURE sp_Insertar_Sede
    @Nombre VARCHAR(100),
    @Direccion VARCHAR(200),
    @Edificios INT
AS
BEGIN
    INSERT INTO Sede(nombre,Direccion,edificios) 
    VALUES (@Nombre, @Direccion, @Edificios);
    PRINT 'Se agrego exitosamente una nueva sede.';
    SELECT nombre, direccion, edificios
        FROM Sede WHERE nombre = @Nombre AND direccion = @Direccion
END;
GO

EXEC sp_Insertar_Sede 'San Juan', 'Av. Libertador Gral. San Martín 915', 3;
GO

--Procedimiento 2: sp_Eliminar_Sede
--Objetivo: Permite eliminar una sede que ya no es de utilidad utilizando el nombre y la ubicación.
CREATE PROCEDURE sp_Eliminar_Sede
    @Nombre VARCHAR(100),
    @Direccion VARCHAR(200)
AS
BEGIN
    DELETE FROM Sede WHERE nombre = @Nombre AND direccion = @Direccion
    PRINT 'Eliminación realizada correctamente'
END;
GO

EXEC sp_Eliminar_Sede 'San Juan', 'Av. Libertador Gral. San Martín 915';
