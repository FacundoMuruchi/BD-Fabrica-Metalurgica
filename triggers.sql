USE induestant;
GO

-- =============================================
-- TRIGGER: Alertas de Stock por Pantalla
-- =============================================
-- Se dispara automáticamente cuando se actualiza
-- el stockActual de una materia prima
-- Muestra mensajes de alerta si:
-- - Stock actual < Stock mínimo (BAJO)
-- - Stock actual > Stock máximo (ALTO)
-- =============================================

CREATE OR ALTER TRIGGER trgAlertaStockPantalla
ON MateriaPrima
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @alertas VARCHAR(MAX) = '';
    
    -- Solo procesar si se modificó el stockActual
    IF UPDATE(stockActual)
    BEGIN
        -- Construir mensajes de STOCK BAJO
        SELECT @alertas = @alertas + 
            '! ALERTA STOCK BAJO: ' + nombre + 
            ' - Stock actual: ' + CAST(stockActual AS VARCHAR(20)) + 
            ' | Stock mínimo: ' + CAST(stockMin AS VARCHAR(20)) + CHAR(13) + CHAR(10)
        FROM inserted
        WHERE stockActual < stockMin
          AND stockMin IS NOT NULL;
        
        -- Construir mensajes de STOCK ALTO
        SELECT @alertas = @alertas + 
            '! ALERTA STOCK ALTO: ' + nombre + 
            ' - Stock actual: ' + CAST(stockActual AS VARCHAR(20)) + 
            ' | Stock máximo: ' + CAST(stockMax AS VARCHAR(20)) + CHAR(13) + CHAR(10)
        FROM inserted
        WHERE stockActual > stockMax
          AND stockMax IS NOT NULL;
        
        -- Mostrar alertas o mensaje de confirmación
        IF LEN(@alertas) > 0
            PRINT @alertas;
        ELSE
            PRINT 'Stock actualizado correctamente. Niveles dentro de los límites establecidos.';
    END;
END;
GO