/* ============================================================
   CONSULTAS SIMPLES
   ============================================================ */

/* 1) Listar ingresos mostrando idIngreso, idProveedor, idMP y cantidad */
SELECT idIngreso, idProveedor, idMP
FROM Ingreso;

/* 2) Mostrar información principal de todas las materias primas */
SELECT idMP, idCategoria, nombre, idUnidadMedida,
       stockActual, stockMin, stockMax
FROM MateriaPrima;



/* ============================================================
   CONSULTAS AVANZADAS
   ============================================================ */

/* 3) Combinar Materia Prima con Categoria para mostrar a qué categoría pertenece */
SELECT 
    mp.nombre AS materia_prima,
    c.tipo AS categoria
FROM MateriaPrima mp
JOIN Categoria c ON mp.idCategoria = c.idCategoria;


/* 4) Encontrar los clientes que han comprado el producto más caro */
SELECT DISTINCT
    c.razonSocial
FROM Cliente c
JOIN Venta v ON c.idCliente = v.idCliente
WHERE v.idProducto = (
        SELECT TOP 1 idProducto
        FROM Producto
        ORDER BY pUnitario DESC
);


/* 5) (Básica) Calcular cuánto ha gastado cada cliente en total y cuántas compras realizó */
SELECT 
    c.razonSocial,
    COUNT(v.idVenta) AS numero_de_compras,
    SUM(v.pTotal) AS gasto_total
FROM Cliente c
JOIN Venta v ON c.idCliente = v.idCliente
GROUP BY c.razonSocial
ORDER BY gasto_total DESC;


/* 6) (Básica) Stock total de cada materia prima sumando ubicaciones */
SELECT 
    mp.nombre,
    SUM(s.cantidad) AS stock_total_general
FROM MateriaPrima mp
JOIN Stock s ON mp.idMP = s.idMP
GROUP BY mp.nombre
ORDER BY stock_total_general ASC;



/* ============================================================
   CONSULTAS AVANZADAS (SEGUNDA PARTE)
   ============================================================ */

/* 7) Compras del cliente con ID = 3 que superen los $15000 */
SELECT razonSocial, cuit, producto, descripcion, precio_total, precio_por_unidad
FROM Cliente c
JOIN (
        SELECT 
            p.nombre AS producto,
            p.descripcion,
            v.pTotal AS precio_total,
            p.pUnitario AS precio_por_unidad,
            v.idCliente
        FROM Producto p
        JOIN Venta v ON v.idProducto = p.idProducto
     ) aux ON c.idCliente = aux.idCliente
WHERE aux.precio_total > 15000 
  AND c.idCliente = 3;


/* 8) Encontrar la ubicación con más de 3000 tornillos */
SELECT 
    mp.nombre,
    mp.idUnidadMedida,
    mp.stockActual,
    s.idUbicacion,
    d.nombre AS deposito,
    dir.calle + ' ' + CAST(dir.altura AS VARCHAR) AS direccion
FROM MateriaPrima mp
JOIN Stock s ON s.idMP = mp.idMP
JOIN Ubicacion u ON u.idUbicacion = s.idUbicacion
JOIN Deposito d ON d.idDeposito = u.idDeposito
JOIN Direccion dir ON dir.idDireccion = d.idDireccion
WHERE mp.idMP = 9
  AND mp.stockActual > 3000;


/* 9) Identificar el proveedor de la materia prima más utilizada en productos */
SELECT DISTINCT
    p.razonSocial,
    p.cuit
FROM Proveedor p
JOIN Ingreso i ON i.idProveedor = p.idProveedor
JOIN MateriaPrima mp ON mp.idMP = i.idMP
JOIN ProductoMP pm ON pm.idMP = mp.idMP
WHERE mp.idMP = (
        SELECT TOP 1 idMP
        FROM ProductoMP
        GROUP BY idMP
        ORDER BY COUNT(idProducto) DESC   -- más usada
);


/* 10) (Avanzada) Listar productos que no han tenido ninguna venta */
SELECT 
    p.nombre,
    p.pUnitario,
    p.descripcion
FROM Producto p
LEFT JOIN Venta v ON p.idProducto = v.idProducto
WHERE v.idVenta IS NULL;


/* 11) (Avanzada) Productos que utilizan las 3 materias primas con menos stock */
WITH MateriasPrimasCriticas AS (
    SELECT TOP 3 
        idMP,
        nombre,
        stockActual
    FROM MateriaPrima
    ORDER BY stockActual ASC
)
SELECT DISTINCT
    p.nombre,
    p.descripcion
FROM Producto p
JOIN ProductoMP pmp ON p.idProducto = pmp.idProducto
WHERE pmp.idMP IN (SELECT idMP FROM MateriasPrimasCriticas);
