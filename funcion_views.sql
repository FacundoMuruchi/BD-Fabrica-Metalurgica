use induestant;
GO

-- =============================================
-- FUNCION: OBTENER PORCENTAJE DE STOCK POR MP
-- =============================================
CREATE OR ALTER FUNCTION fn_PorcentajeOcupacion (@idMP INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @actual DECIMAL(10,2), @max DECIMAL(10,2);

    SELECT @actual = stockActual, @max = stockMax
    FROM MateriaPrima
    WHERE idMP = @idMP;

    IF @max IS NULL OR @max = 0 RETURN NULL;
    RETURN ROUND((@actual / @max) * 100, 2);
END;
GO

-- =============================================
-- VISTAS
-- =============================================

-- =============================================
-- VISTA1: MUESTRA MOVIMIENTOS CON DETALLE
-- =============================================
CREATE OR ALTER VIEW vw_MovimientosDetallados AS
SELECT 
    m.idMovimiento,
    m.fecha,
    tm.tipo AS tipoMovimiento,
    m.cantidad,
    m.observacion,

    prov.razonSocial AS proveedor,
    -- Nombre de materia prima desde Movimiento o desde Ingreso
    COALESCE(mp.nombre, mp_i.nombre) AS materiaPrima,
    
    c.razonSocial AS cliente,
    -- Nombre de producto desde Movimiento o desde Venta
    COALESCE(p.nombre, p_v.nombre) AS nombreProducto

FROM Movimiento m
JOIN TipoMovimiento tm ON m.idTipoMovimiento = tm.idTipoMovimiento
LEFT JOIN Ingreso i ON i.idIngreso = m.idIngreso
LEFT JOIN Venta v ON v.idVenta = m.idVenta

-- Tablas de producto/materia prima directamente referenciadas por Movimiento
LEFT JOIN MateriaPrima mp ON mp.idMP = m.idMP
LEFT JOIN Producto p ON p.idProducto = m.idProducto

-- Tablas de producto/materia prima referenciadas a través de Ingreso/Venta
LEFT JOIN MateriaPrima mp_i ON mp_i.idMP = i.idMP
LEFT JOIN Producto p_v ON p_v.idProducto = v.idProducto

-- Entidades comerciales
LEFT JOIN Proveedor prov ON prov.idProveedor = i.idProveedor
LEFT JOIN Cliente c ON c.idCliente = v.idCliente;
GO

-- =============================================
-- VISTA2: MUESTRA STOCK GENERAL
-- =============================================
CREATE OR ALTER VIEW vw_StockGeneral AS
SELECT 
    idMP,
    nombre,
    CONCAT(stockActual, ' ', um.unidad) AS stockActual,
    CONCAT(stockMin, ' ', um.unidad) AS stockMinimo,
    CONCAT(stockMax, ' ', um.unidad) AS stockMaximo,
    CONCAT(dbo.fn_PorcentajeOcupacion(mp.idMP) , '%')AS porcentajeOcupacion
FROM MateriaPrima mp
JOIN UnidadMedida um on um.idUnidadMedida = mp.idUnidadMedida
GO

-- =============================================
-- VISTA3: MUESTRA STOCK POR UBICACION
-- =============================================
CREATE OR ALTER VIEW vw_StockPorUbicacion AS
SELECT 
    s.idStock,
    mp.idMP,
    mp.nombre AS materiaPrima,
    d.nombre AS deposito,
    u.pasillo,
    u.columna,
    u.nivel,
    CONCAT(s.cantidad, ' ', um.unidad) AS stockUbicacion,
    CONCAT('P', u.pasillo, '-C', u.columna, '-N', u.nivel) AS codigoUbicacion,
    u.idUbicacion
FROM Stock s
JOIN MateriaPrima mp ON s.idMP = mp.idMP
JOIN Ubicacion u ON s.idUbicacion = u.idUbicacion
JOIN Deposito d ON u.idDeposito = d.idDeposito
JOIN UnidadMedida um on um.idUnidadMedida = mp.idUnidadMedida;
GO

-- =============================================
-- VISTA4: MUESTRA CANTIDAD NECESARIA
-- =============================================
CREATE OR ALTER VIEW vw_RecetaProducto AS
SELECT
    p.idProducto,
    p.nombre AS producto,
    p.descripcion,
    mp.idMP,
    CONCAT(pmp.cantNecesaria, ' ', um.unidad, ' de ', mp.nombre) AS cantidadNecesariaDeMP,
    p.tFabricacion AS horasFabricacion,
    p.pUnitario
FROM ProductoMP pmp
JOIN Producto p on p.idProducto = pmp.idProducto
JOIN MateriaPrima mp on mp.idMP = pmp.idMP
JOIN UnidadMedida um on um.idUnidadMedida = mp.idUnidadMedida;
GO