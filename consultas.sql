--1. Muestra cuantos espacios hay de cada tipo  (por ejemplo, cuántas aulas, cuántas salas, etc.), ordenados de mayor a menor cantidad.

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
/*-- 2. Número Total de Espacios por Tipo NO VA

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
  TotalEspacios DESC;*/

--------------------------------------------------------------------------------------------
-- 2. Usuarios que Han Registrado Entrada Hoy

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
-- 3. Detalle de Registros de Usuario por LU de usuario

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
-- 4. Promedio de Tiempo de Ocupación por Sede

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
-- 5. Ocupación actual: quién está usando qué, ahora mismo

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

--------------------------------------------------------------------------------------------

-- 6. Cual es el tipo de espacio, el estado y el piso en el que se encuentra que tienen proyector y se encuentran en edificios Lima
SELECT te.Nombre, e.Estado, u.Piso
FROM TipoEspacio te inner join Espacios e on te.IDtipoEspacio=e.IDtipoEspacio inner join Ubicacion u on u.IDubicacion= e.IDubicacion
where te.Elementos LIKE '%proyectores%' and u.Edificio LIKE '%Lima%'


--------------------------------------------------------------------------------------------

-- 7. Esta consulta nos permite encontrar un espacio grande y libre para una reunion de ultima hora en una sede especifica

SELECT
    S.Nombre AS Sede,
    E.IDespacio,
    TE.Nombre AS TipoEspacio,
    TE.CantLugar AS Capacidad,
    E.Estado
FROM
    Espacios E
JOIN
    Sede S ON E.IDsede = S.IDsede
JOIN
    TipoEspacio TE ON E.IDtipoEspacio = TE.IDtipoEspacio
WHERE
    S.Nombre = 'Monserrat' --  FILTRO 1: Selecciona una sede específica
    AND E.Estado = 'Disponible' --  FILTRO 2: Solo espacios que están libres AHORA
    AND TE.CantLugar >= 50 -- FILTRO 3: Solo espacios de alta capacidad
ORDER BY
    TE.CantLugar DESC;

----------------------------------------------------------------------------------------

--8. Duracion promedio de uso por tipo de espacio (ide cuánto tiempo, en promedio, la gente usa cada tipo de espacio)

SELECT
    TE.Nombre AS TipoEspacio,
    -- Calcula el promedio SOLO para los usos finalizados
    CAST(AVG(DATEDIFF(MINUTE, R.HoraEntrada, R.HoraSalida)) AS DECIMAL(10, 2)) AS PromedioMinutos
FROM
    Registro R
JOIN
    Espacios E ON R.IDespacio = E.IDespacio
JOIN
    TipoEspacio TE ON E.IDtipoEspacio = TE.IDtipoEspacio
WHERE
    R.HoraSalida IS NOT NULL -- Excluye los usos que aún están activos
GROUP BY
    TE.Nombre
ORDER BY
    PromedioMinutos DESC;

-----------------------------------------------------------------------------------------

--9. 



