USE FreeSpaces;
GO

CREATE FUNCTION fn_CalcularDuracionEstadia (
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

-- Para probarlo

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


