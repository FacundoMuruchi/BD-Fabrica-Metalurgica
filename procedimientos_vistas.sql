use induestant;
GO
-- =============================================
-- PROCEDIMIENTO 1: Registrar Ingreso de Materia Prima
-- =============================================
CREATE OR ALTER PROCEDURE sp_RegistrarIngreso
    @idProveedor INT,
    @idMP INT,
    @cantidad DECIMAL(10,2),
    @observacion VARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que el proveedor existe
        IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE idProveedor = @idProveedor)
        BEGIN
            RAISERROR('El proveedor especificado no existe.', 16, 1);
            RETURN;
        END
        
        -- Validar que la materia prima existe
        IF NOT EXISTS (SELECT 1 FROM MateriaPrima WHERE idMP = @idMP)
        BEGIN
            RAISERROR('La materia prima especificada no existe.', 16, 1);
            RETURN;
        END
        
        -- Validar cantidad positiva
        IF @cantidad <= 0
        BEGIN
            RAISERROR('La cantidad debe ser mayor a cero.', 16, 1);
            RETURN;
        END
        
        -- Crear el registro de Ingreso
        DECLARE @idIngresoNuevo INT;
        INSERT INTO Ingreso (idProveedor, idMP)
        VALUES (@idProveedor, @idMP);
        
        SET @idIngresoNuevo = SCOPE_IDENTITY();
        
        -- Obtener el idTipoMovimiento para "INGRESO"
        DECLARE @idTipoIngreso INT;
        SELECT @idTipoIngreso = idTipoMovimiento 
        FROM TipoMovimiento 
        WHERE tipo = 'Ingreso de Materia Prima';
        
        -- Si no existe el tipo, crearlo
        IF @idTipoIngreso IS NULL
        BEGIN
            INSERT INTO TipoMovimiento (tipo) VALUES ('Ingreso de Materia Prima');
            SET @idTipoIngreso = SCOPE_IDENTITY();
        END
        
        -- Registrar el movimiento
        INSERT INTO Movimiento (idIngreso, idTipoMovimiento, cantidad, observacion)
        VALUES (@idIngresoNuevo, @idTipoIngreso, @cantidad, @observacion);
        
        -- Actualizar stock actual de la materia prima
        UPDATE MateriaPrima
        SET stockActual = stockActual + @cantidad
        WHERE idMP = @idMP;
        
        COMMIT TRANSACTION;
        
        PRINT CONCAT('Ingreso registrado exitosamente! ID Ingreso: ', @idIngresoNuevo);
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END;
GO

-- =============================================
-- PROCEDIMIENTO 2: Registrar Venta de Producto
-- =============================================
CREATE OR ALTER PROCEDURE sp_RegistrarVenta
    @idProducto INT,
    @idCliente INT,
    @cantidadProductos INT,
    @observacion VARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que el producto existe
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE idProducto = @idProducto)
        BEGIN
            RAISERROR('El producto especificado no existe.', 16, 1);
            RETURN;
        END
        
        -- Validar que el cliente existe
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE idCliente = @idCliente)
        BEGIN
            RAISERROR('El cliente especificado no existe.', 16, 1);
            RETURN;
        END
        
        -- Validar cantidad positiva
        IF @cantidadProductos <= 0
        BEGIN
            RAISERROR('La cantidad debe ser mayor a cero.', 16, 1);
            RETURN;
        END
        
        -- Verificar que hay suficiente materia prima para producir
        DECLARE @mpInsuficiente VARCHAR(100);
        
        SELECT TOP 1 @mpInsuficiente = mp.nombre
        FROM ProductoMP pmp
        INNER JOIN MateriaPrima mp ON pmp.idMP = mp.idMP
        WHERE pmp.idProducto = @idProducto
          AND mp.stockActual < (pmp.cantNecesaria * @cantidadProductos);
        
        IF @mpInsuficiente IS NOT NULL
        BEGIN
            DECLARE @msgError VARCHAR(200) = 'Stock insuficiente de materia prima: ' + @mpInsuficiente;
            RAISERROR(@msgError, 16, 1);
            RETURN;
        END
        
        -- Obtener precio unitario del producto
        DECLARE @precioUnitario DECIMAL(10,2);
        SELECT @precioUnitario = pUnitario FROM Producto WHERE idProducto = @idProducto;
        
        -- Calcular precio total
        DECLARE @precioTotal DECIMAL(10,2) = @precioUnitario * @cantidadProductos;
        
        -- Crear el registro de Venta
        DECLARE @idVentaNueva INT;
        INSERT INTO Venta (idProducto, idCliente, pTotal)
        VALUES (@idProducto, @idCliente, @precioTotal);
        
        SET @idVentaNueva = SCOPE_IDENTITY();
        
        -- Obtener el idTipoMovimiento para "SALIDA"
        DECLARE @idTipoSalida INT;
        SELECT @idTipoSalida = idTipoMovimiento 
        FROM TipoMovimiento 
        WHERE tipo = 'Venta de Producto';
        
        -- Si no existe el tipo, crearlo
        IF @idTipoSalida IS NULL
        BEGIN
            INSERT INTO TipoMovimiento (tipo) VALUES ('Venta de Producto');
            SET @idTipoSalida = SCOPE_IDENTITY();
        END
        
        -- Registrar el movimiento de venta del producto
        INSERT INTO Movimiento (idVenta, idTipoMovimiento, cantidad, observacion)
        VALUES (@idVentaNueva, @idTipoSalida, @cantidadProductos, @observacion);
        
        -- Descontar las materias primas necesarias
        UPDATE mp
        SET mp.stockActual = mp.stockActual - (pmp.cantNecesaria * @cantidadProductos)
        FROM MateriaPrima mp
        INNER JOIN ProductoMP pmp ON mp.idMP = pmp.idMP
        WHERE pmp.idProducto = @idProducto;
        
        COMMIT TRANSACTION;
        
        PRINT CONCAT('Venta registrada exitosamente. ID Venta: ', @idVentaNueva);
        PRINT CONCAT('Precio Total: $', @precioTotal);
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END;
GO

-- =============================================
-- PROCEDIMIENTO 3: Registrar Ajuste de Stock
-- =============================================
CREATE OR ALTER PROCEDURE sp_RegistrarAjuste
    @idMP INT = NULL,
    @idProducto INT = NULL,
    @cantidad DECIMAL(10,2),
    @observacion VARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que se especificó materia prima O producto (pero no ambos)
        IF (@idMP IS NULL AND @idProducto IS NULL)
        BEGIN
            RAISERROR('Debe especificar idMP o idProducto.', 16, 1);
            RETURN;
        END
        
        IF (@idMP IS NOT NULL AND @idProducto IS NOT NULL)
        BEGIN
            RAISERROR('No puede especificar idMP e idProducto al mismo tiempo.', 16, 1);
            RETURN;
        END
        
        -- Validar cantidad diferente de cero
        IF @cantidad = 0
        BEGIN
            RAISERROR('La cantidad no puede ser cero.', 16, 1);
            RETURN;
        END
        
        -- Determinar el tipo de ajuste
        DECLARE @tipoAjuste VARCHAR(50);
        IF @cantidad > 0
            SET @tipoAjuste = 'Ajuste Positivo';
        ELSE
            SET @tipoAjuste = 'Ajuste Negativo';
        
        -- Si es ajuste de materia prima
        IF @idMP IS NOT NULL
        BEGIN
            -- Validar que la materia prima existe
            IF NOT EXISTS (SELECT 1 FROM MateriaPrima WHERE idMP = @idMP)
            BEGIN
                RAISERROR('La materia prima especificada no existe.', 16, 1);
                RETURN;
            END
            
            -- Validar que no se genera stock negativo
            DECLARE @stockActualMP DECIMAL(10,2);
            SELECT @stockActualMP = stockActual FROM MateriaPrima WHERE idMP = @idMP;
            
            IF (@stockActualMP + @cantidad) < 0
            BEGIN
                RAISERROR('El ajuste generaría stock negativo.', 16, 1);
                RETURN;
            END
            
            -- Actualizar stock de materia prima
            UPDATE MateriaPrima
            SET stockActual = stockActual + @cantidad
            WHERE idMP = @idMP;
        END
        
        -- Si es ajuste de producto solo registra el movimiento para auditoría
        IF @idProducto IS NOT NULL
        BEGIN
            -- Validar que el producto existe
            IF NOT EXISTS (SELECT 1 FROM Producto WHERE idProducto = @idProducto)
            BEGIN
                RAISERROR('El producto especificado no existe.', 16, 1);
                RETURN;
            END
        END
        
        -- Obtener o crear el idTipoMovimiento para el ajuste
        DECLARE @idTipoAjuste INT;
        SELECT @idTipoAjuste = idTipoMovimiento 
        FROM TipoMovimiento 
        WHERE tipo = @tipoAjuste;
        
        IF @idTipoAjuste IS NULL
        BEGIN
            INSERT INTO TipoMovimiento (tipo) VALUES (@tipoAjuste);
            SET @idTipoAjuste = SCOPE_IDENTITY();
        END
        
        -- Registrar el movimiento de ajuste
        INSERT INTO Movimiento (idMP, idProducto, idTipoMovimiento, cantidad, observacion)
        VALUES (@idMP, @idProducto, @idTipoAjuste, ABS(@cantidad), @observacion);
        
        COMMIT TRANSACTION;
        
        DECLARE @tipoItem VARCHAR(50) = CASE WHEN @idMP IS NOT NULL THEN 'Materia Prima' ELSE 'Producto' END;
        PRINT 'Ajuste registrado exitosamente para ' + @tipoItem;
        PRINT CONCAT('Tipo: ', @tipoAjuste, ', Cantidad: ', @cantidad);
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END;