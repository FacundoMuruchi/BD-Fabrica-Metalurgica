use induestant;
GO
-- =============================================
-- PROCEDIMIENTO 1: Registrar Ingreso de Materia Prima
-- =============================================
CREATE OR ALTER PROCEDURE sp_RegistrarIngreso
    @idProveedor INT,
    @idMP INT,
    @cantidad DECIMAL(10,2),
    @idUbicacion INT,  -- Ubicación donde se almacenará el material
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
        
        -- Validar que la ubicación existe
        IF NOT EXISTS (SELECT 1 FROM Ubicacion WHERE idUbicacion = @idUbicacion)
        BEGIN
            RAISERROR('La ubicación especificada no existe.', 16, 1);
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
        
        -- Gestión de ubicación física
        -- Verificar si ya existe stock en esa ubicación para esa materia prima
        IF EXISTS (SELECT 1 FROM Stock WHERE idUbicacion = @idUbicacion AND idMP = @idMP)
        BEGIN
            -- Actualizar cantidad en ubicación existente
            UPDATE Stock
            SET cantidad = cantidad + @cantidad
            WHERE idUbicacion = @idUbicacion AND idMP = @idMP;
            
            PRINT 'Stock agregado a ubicación existente';
        END
        ELSE
        BEGIN
            -- Crear nuevo registro de stock en esa ubicación
            INSERT INTO Stock (idUbicacion, idMP, cantidad)
            VALUES (@idUbicacion, @idMP, @cantidad);
            
            PRINT 'Nueva ubicación de stock creada';
        END
        
        -- Actualizar stock total de la materia prima
        UPDATE MateriaPrima
        SET stockActual = stockActual + @cantidad
        WHERE idMP = @idMP;
        
        COMMIT TRANSACTION;
        
        -- Obtener información de la ubicación para el mensaje
        DECLARE @nombreDeposito VARCHAR(100);
        DECLARE @pasillo INT, @columna CHAR(1), @nivel INT;
        
        SELECT 
            @nombreDeposito = d.nombre,
            @pasillo = u.pasillo,
            @columna = u.columna,
            @nivel = u.nivel
        FROM Ubicacion u
        JOIN Deposito d ON u.idDeposito = d.idDeposito
        WHERE u.idUbicacion = @idUbicacion;
        
        PRINT '==============================================';
        PRINT 'Ingreso registrado exitosamente';
        PRINT 'ID Ingreso: ' + CAST(@idIngresoNuevo AS VARCHAR(10));
        PRINT 'Cantidad: ' + CAST(@cantidad AS VARCHAR(20));
        PRINT 'Ubicación: ' + @nombreDeposito + ' - Pasillo ' + CAST(@pasillo AS VARCHAR) + 
              ', Columna ' + @columna + ', Nivel ' + CAST(@nivel AS VARCHAR);
        PRINT '==============================================';
        
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
    @idUbicacion INT,
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
        
        -- Verificar que hay suficiente materia prima EN LA UBICACIÓN ESPECIFICADA
        DECLARE @mpInsuficiente VARCHAR(100);
        
        SELECT TOP 1 @mpInsuficiente = mp.nombre
        FROM ProductoMP pmp
        JOIN MateriaPrima mp ON pmp.idMP = mp.idMP
        LEFT JOIN Stock s ON pmp.idMP = s.idMP AND s.idUbicacion = @idUbicacion
        WHERE pmp.idProducto = @idProducto
          AND (s.cantidad IS NULL OR s.cantidad < (pmp.cantNecesaria * @cantidadProductos)); -- Comprobar stock en ubicación
        
        IF @mpInsuficiente IS NOT NULL
        BEGIN
            DECLARE @msgError VARCHAR(200) = 'Stock insuficiente de materia prima: ' + @mpInsuficiente + ' en la ubicación ' + CAST(@idUbicacion AS VARCHAR);
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
        
        -- Descontar del stock en la ubicación
        UPDATE s
        SET s.cantidad = s.cantidad - (pmp.cantNecesaria * @cantidadProductos)
        FROM Stock s
        JOIN ProductoMP pmp ON s.idMP = pmp.idMP
        WHERE pmp.idProducto = @idProducto
          AND s.idUbicacion = @idUbicacion;
        
        -- Descontar del stock total
        UPDATE mp
        SET mp.stockActual = mp.stockActual - (pmp.cantNecesaria * @cantidadProductos)
        FROM MateriaPrima mp
        JOIN ProductoMP pmp ON mp.idMP = pmp.idMP
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
CREATE OR ALTER PROCEDURE sp_RegistrarAjustes
    @idMP INT = NULL,
    @idProducto INT = NULL,
    @cantidad DECIMAL(10,2),
    @idUbicacion INT = NULL,  -- Ubicación donde se hace el ajuste
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
            
            -- Validar que no se genera stock negativo en MateriaPrima
            DECLARE @stockActualMP DECIMAL(10,2);
            SELECT @stockActualMP = stockActual FROM MateriaPrima WHERE idMP = @idMP;
            
            IF (@stockActualMP + @cantidad) < 0
            BEGIN
                RAISERROR('El ajuste generaría stock negativo en el total.', 16, 1);
                RETURN;
            END
            
            -- *** NUEVA LÓGICA: Gestión de ubicaciones ***
            IF @idUbicacion IS NOT NULL
            BEGIN
                -- Validar que la ubicación existe
                IF NOT EXISTS (SELECT 1 FROM Ubicacion WHERE idUbicacion = @idUbicacion)
                BEGIN
                    RAISERROR('La ubicación especificada no existe.', 16, 1);
                    RETURN;
                END
                
                -- Verificar si ya existe un registro de stock en esa ubicación
                IF EXISTS (SELECT 1 FROM Stock WHERE idUbicacion = @idUbicacion AND idMP = @idMP)
                BEGIN
                    -- Validar que no se genera stock negativo en la ubicación
                    DECLARE @stockUbicacion DECIMAL(10,2);
                    SELECT @stockUbicacion = cantidad 
                    FROM Stock 
                    WHERE idUbicacion = @idUbicacion AND idMP = @idMP;
                    
                    IF (@stockUbicacion + @cantidad) < 0
                    BEGIN
                        RAISERROR('El ajuste generaría stock negativo en la ubicación especificada.', 16, 1);
                        RETURN;
                    END
                    
                    -- Actualizar cantidad en la ubicación existente
                    UPDATE Stock
                    SET cantidad = cantidad + @cantidad
                    WHERE idUbicacion = @idUbicacion AND idMP = @idMP;
                    
                    PRINT 'Stock actualizado en ubicación existente';
                END
                ELSE
                BEGIN
                    -- Solo permitir crear nueva ubicación si es ajuste positivo
                    IF @cantidad < 0
                    BEGIN
                        RAISERROR('No existe stock en la ubicación especificada para descontar.', 16, 1);
                        RETURN;
                    END
                    
                    -- Crear nuevo registro de stock en esa ubicación
                    INSERT INTO Stock (idUbicacion, idMP, cantidad)
                    VALUES (@idUbicacion, @idMP, @cantidad);
                    
                    PRINT 'Nueva ubicación de stock creada';
                END
            END
            ELSE
            BEGIN
                -- Si no se especifica ubicación, buscar automáticamente una ubicación con stock
                IF @cantidad < 0  -- Solo para ajustes negativos
                BEGIN
                    -- Intentar descontar de la ubicación con más stock
                    SELECT TOP 1 @idUbicacion = idUbicacion
                    FROM Stock
                    WHERE idMP = @idMP AND cantidad >= ABS(@cantidad)
                    ORDER BY cantidad DESC;
                    
                    IF @idUbicacion IS NULL
                    BEGIN
                        RAISERROR('No hay ubicación con stock suficiente. Debe especificar @idUbicacion.', 16, 1);
                        RETURN;
                    END
                    
                    -- Actualizar stock en la ubicación encontrada
                    UPDATE Stock
                    SET cantidad = cantidad + @cantidad  -- @cantidad es negativo
                    WHERE idUbicacion = @idUbicacion AND idMP = @idMP;
                    
                    PRINT 'Stock descontado automáticamente de ubicación con mayor disponibilidad';
                END
                ELSE
                BEGIN
                    RAISERROR('Para ajustes positivos debe especificar la ubicación (@idUbicacion).', 16, 1);
                    RETURN;
                END
            END
            
            -- Actualizar stock total de materia prima
            UPDATE MateriaPrima
            SET stockActual = stockActual + @cantidad
            WHERE idMP = @idMP;
            
            PRINT 'Stock total de materia prima actualizado';
        END
        
        -- Si es ajuste de producto (solo auditoría, sin ubicaciones)
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
        INSERT INTO Movimiento (idMP, idProducto, idTipoMovimiento, cantidad, observacion, fecha)
        VALUES (@idMP, @idProducto, @idTipoAjuste, ABS(@cantidad), @observacion, GETDATE());
        
        COMMIT TRANSACTION;
        
        DECLARE @tipoItem VARCHAR(50) = CASE WHEN @idMP IS NOT NULL THEN 'Materia Prima' ELSE 'Producto' END;
        PRINT '==============================================';
        PRINT 'Ajuste registrado exitosamente para ' + @tipoItem;
        PRINT 'Tipo: ' + @tipoAjuste + ', Cantidad: ' + CAST(@cantidad AS VARCHAR(20));
        IF @idUbicacion IS NOT NULL
            PRINT 'Ubicación: ' + CAST(@idUbicacion AS VARCHAR(10));
        PRINT '==============================================';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END;
GO