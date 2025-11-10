USE FreeSpaces;
GO

-- Funcion que calcula la duracion de una estadia
CREATE OR ALTER FUNCTION dbo.fn_CalcularDuracionEstadia (
    @HoraEntrada DATETIME,
    @HoraSalida DATETIME
)
RETURNS VARCHAR(100) -- Devuelve un texto
AS
BEGIN
    DECLARE @TotalMinutos INT;
    DECLARE @Horas INT;
    DECLARE @Minutos INT;
    DECLARE @Resultado VARCHAR(100);

    IF @HoraSalida IS NULL
        SET @TotalMinutos = DATEDIFF(MINUTE, @HoraEntrada, GETDATE());
    ELSE
        SET @TotalMinutos = DATEDIFF(MINUTE, @HoraEntrada, @HoraSalida);

    SET @Horas = @TotalMinutos / 60;
    SET @Minutos = @TotalMinutos % 60;

    -- pasamos del int a string con cast para imprimir el resultado
    SET @Resultado = CAST(@Horas AS VARCHAR) + ' horas, ' + CAST(@Minutos AS VARCHAR) + ' minutos';

    RETURN @Resultado;
END;
GO


SELECT 
    r.IDregistro,
    r.IDusuario,
    r.HoraEntrada,
    r.HoraSalida,
    -- ¡Aquí usamos la función!
    dbo.fn_CalcularDuracionEstadia(r.HoraEntrada, r.HoraSalida) AS Duracion
FROM 
    Registro r
WHERE
    IDusuario = 3; 
GO

SELECT * FROM dbo.fn_CalcularDuracionEstadia('2025-11-11 20:00:00',NULL);
------------------------------------------------------------------------------------------------------------------------


-- Lista los espacios disponibles de una sede, incluyendo tipo y ubicación
CREATE OR ALTER FUNCTION dbo.fn_EspaciosDisponiblesPorSede
(
    @IDsede INT                         
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        e.IDespacio,                      
        e.IDsede,                        
        t.Nombre    AS TipoEspacio,    
        u.Edificio,                    
        u.Piso                          
    FROM dbo.Espacios e
    JOIN dbo.TipoEspacio t ON t.IDtipoEspacio = e.IDtipoEspacio
    JOIN dbo.Ubicacion  u ON u.IDubicacion   = e.IDubicacion
    WHERE e.IDsede = @IDsede
      AND e.Estado = 'Disponible'        
);
GO

-- Para probarlo

SELECT * FROM dbo.fn_EspaciosDisponiblesPorSede(1);



-- Función que calcula si un espacio esta 'Ocupado' o 'Disponible'
CREATE OR ALTER FUNCTION dbo.fn_CalcularEstadoEspacio (@IDespacio INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @LugaresOcupados INT;
    DECLARE @CapacidadTotal INT;
    DECLARE @NuevoEstado VARCHAR(20);

    -- 1. Contar cuántos "lugares" están ocupados actualmente (registros activos)
    SELECT 
        @LugaresOcupados = COUNT(*)
    FROM 
        Registro R
    WHERE 
        R.IDespacio = @IDespacio
        AND R.HoraSalida IS NULL; -- Solo registros con hora de entrada, pero sin hora de salida

    -- 2. Obtener la capacidad total del espacio
    SELECT 
        @CapacidadTotal = TE.CantLugar
    FROM 
        Espacios E
    JOIN 
        TipoEspacio TE ON E.IDtipoEspacio = TE.IDtipoEspacio
    WHERE 
        E.IDespacio = @IDespacio;

    -- 3. Determinar el nuevo estado
    IF @LugaresOcupados >= ISNULL(@CapacidadTotal, 1) -- Si la capacidad es NULL o 0, asumimos 1 para evitar división por cero.
        SET @NuevoEstado = 'Ocupado';
    ELSE
        SET @NuevoEstado = 'Disponible';

    RETURN @NuevoEstado;
END;
GO

SELECT * FROM dbo.fn_CalcularEstadoEspacio(1);
