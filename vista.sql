    CREATE VIEW V_Detalle_Todos_Espacios AS
    /* Vista Para mostrar todos los Espacios que tiene en la distintas sedes, usando joins para traer datos y crear una tabla
        entendible y no solo traer los ID*/

        SELECT 
            e.IDespacio,
            e.Estado,
            s.Nombre AS Sede,
            s.Direccion AS SdeDireccion,
            u.Edificio,
            u.Piso,
            t.Nombre AS TipoEspacio,
            t.Elementos,
            t.CantLugar AS Capacidad
        FROM 
            Espacios e
        JOIN 
            Sede s ON e.IDsede = s.IDsede
        JOIN 
            Ubicacion u ON e.IDubicacion = u.IDubicacion
        JOIN 
            TipoEspacio t ON e.IDtipoEspacio = t.IDtipoEspacio;
GO

    SELECT * FROM V_Detalle_Todos_Espacios;
GO

    CREATE VIEW V_Popularidad_Espacios AS
    /* Vista para mostrar los espacios con mayor frecuencia de uso */
        SELECT 
        e.IDespacio,
        t.Nombre AS TipoDeEspacio,
        u.Edificio,
        u.Piso,
        s.Nombre AS Sede,
        e.Estado AS EstadoActual,
        COUNT(r.IDregistro) AS VecesUtilizado
    FROM 
        Espacios e
    JOIN 
        TipoEspacio t ON e.IDtipoEspacio = t.IDtipoEspacio
    JOIN 
        Ubicacion u ON e.IDubicacion = u.IDubicacion
    JOIN 
        Sede s ON e.IDsede = s.IDsede
    LEFT JOIN --Se usa el left porque tambien tiene que devolver los espacios que se usaron 0 veces de la tabla izquierda Espacios
        Registro r ON e.IDespacio = r.IDespacio
    GROUP BY
        e.IDespacio, t.Nombre, u.Edificio, u.Piso, s.Nombre, e.Estado;
GO
    SELECT * FROM V_Popularidad_Espacios;
GO


GO

-- crea una visita para ver los espacios junto con su tipo 
CREATE VIEW Vista_Espacios_Tipo
AS
SELECT
     E.IDespacio,
     E.Nombre AS NombreEspacio,
     T.Nombre AS TipoEspacio,
     E.Capacidad 
FROM Espacios e
INNER JOIN TipoEspacio T ON E.IDtipoEspacio = T.IDtipoEspacio;
GO
