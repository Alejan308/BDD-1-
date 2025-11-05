USE FreeSpaces;
GO


-- Crea funcion que devuelve la cantidad de espacios segun el tipo 
CREATE FUNCTION CantidadEspaciosPorTipo (@NombreTipo VARCHAR(100))
RETURNS INT 
BEGIN 
    DECLARE @cantidad INT; --Crea una variable donde se va a guardar el resultado del conteo


    SELECT @cantidad = COUNT(*)
    FROM Espacios e
    INNER JOIN TipoEspacio T On E.IDtipoEspacio =t.IDtipoEspacio
    WHERE T.Nombre = @NombreTipo;

    RETURN @cantidad;

END;
GO
