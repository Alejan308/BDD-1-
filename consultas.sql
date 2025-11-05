USE FreeSpaces;
GO

SELECT --Le decimos al servidor qué columnas queremos mostrar.
t.IDtipoEspacio,
t.Nombre AS TipoEspacio,
COUNT(e.IDespacio) AS CantidadDeEspacios

FROM TipoEspacio t --Le dice de qué tabla sacar los datos principales.
LEFT JOIN Espacios e ON t.IDtipoEspacio = e.IDtipoEspacio
GROUP BY t.IDtipoEspacio, t.Nombre
ORDER BY CantidadDeEspacios DESC;

GO
