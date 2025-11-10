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




--------------------------------------------------------------------------------------------
-- 2. Número Total de Espacios por Tipo

SELECT
    TE.Nombre AS TipoEspacio,
    COUNT(E.IDespacio) AS TotalEspacios
FROM
    Espacios E
JOIN
    TipoEspacio TE ON E.IDtipoEspacio = TE.IDtipoEspacio
GROUP BY
    TE.Nombre
ORDER BY
    TotalEspacios DESC;

--------------------------------------------------------------------------------------------
-- 3. Usuarios que Han Registrado Entrada Hoy

SELECT
    U.Nombre,
    U.Apellido
FROM
    Usuario U
WHERE
    EXISTS (
        SELECT 1
        FROM Registro R
        WHERE
            R.IDusuario = U.LU
            -- Utilizamos CAST para convertir el DATETIME a DATE en ambas partes
            -- para que la comparación solo se haga a nivel de día.
            AND CAST(R.HoraEntrada AS DATE) = CAST(GETDATE() AS DATE)
    );

GO

--------------------------------------------------------------------------------------------
-- 4. Detalle de Registros de Usuario por LU de usuario

SELECT
    R.HoraEntrada,
    R.HoraSalida,
    TE.Nombre AS TipoEspacio
FROM
    Registro R
JOIN
    Espacios E ON R.IDespacio = E.IDespacio
JOIN
    TipoEspacio TE ON E.IDtipoEspacio = TE.IDtipoEspacio
WHERE
    R.IDusuario = 2;

GO

--------------------------------------------------------------------------------------------
-- 5. Promedio de Tiempo de Ocupación por Sede

SELECT
    S.IDsede,
    S.Nombre AS NombreSede,
    -- Calcula el promedio SOLO para las filas que tienen registro, si no hay, devuelve NULL
    AVG(DATEDIFF(MINUTE, R.HoraEntrada, R.HoraSalida)) AS PromedioMinutosOcupacion
FROM
    Sede S -- Tabla izquierda: queremos TODAS las sedes
LEFT JOIN
    Espacios E ON S.IDsede = E.IDsede
LEFT JOIN
    Registro R ON E.IDespacio = R.IDespacio
WHERE
    R.HoraSalida IS NOT NULL OR R.HoraSalida IS NULL -- Esta condición se puede omitir, pero si se deja, el AVG se encargará de los NULLs.
GROUP BY
    S.IDsede,
    S.Nombre 
ORDER BY
    PromedioMinutosOcupacion DESC,

    S.IDsede;

--------------------------------------------------------------------------------------------
-- 6. Ocupación actual: quién está usando qué, ahora mismo

SELECT
    E.IDespacio,
    S.Nombre      AS Sede,
    T.Nombre      AS TipoEspacio,
    U.Nombre + ' ' + U.Apellido AS Usuario,
    R.HoraEntrada AS Desde
FROM 
    Registro R
JOIN 
    Espacios E      ON E.IDespacio = R.IDespacio
JOIN 
    Usuario U       ON U.LU = R.IDusuario
JOIN 
    Sede S          ON S.IDsede = E.IDsede
JOIN 
    TipoEspacio T   ON T.IDtipoEspacio = E.IDtipoEspacio
WHERE 
    R.HoraSalida IS NULL
ORDER BY 
    R.HoraEntrada DESC;
GO







