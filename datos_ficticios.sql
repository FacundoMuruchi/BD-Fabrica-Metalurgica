USE induestant;
GO

-- =====================
-- 1. PROVEEDORES
-- =====================
INSERT INTO Proveedor (razonSocial, cuit, telefono, email) VALUES
('Aceros Buenos Aires S.A.', '30711234567', '011-4567-8901', 'contacto@acerosba.com'),
('Metalúrgica Sur SRL', '30722345678', '011-4321-5678', 'ventas@metalsur.com'),
('Industrias Pampa S.A.', '30733456789', '011-4789-6543', 'info@pampa.com'),
('Hierros del Plata', '30744567890', '011-4890-1234', 'proveedor@hierrosplata.com'),
('Tornillos Argentinos SRL', '30755678901', '011-4123-9876', 'ventas@tornillosarg.com'),
('Fundición La Roca', '30766789012', '011-4780-1345', 'contacto@laroca.com'),
('Metales del Sur', '30777890123', '011-4981-2222', 'info@metalesdelsur.com'),
('Siderurgia Andina', '30788901234', '011-4765-3333', 'ventas@andina.com'),
('Acindar Proveedores', '30799012345', '011-4322-4444', 'acindar@proveedores.com'),
('Cobrex SRL', '30710123456', '011-4333-5555', 'contacto@cobrex.com');

-- =====================
-- 2. CATEGORÍAS
-- =====================
INSERT INTO Categoria (tipo, descripcion) VALUES
('Aceros', 'Materiales de acero para estructuras y piezas metálicas.'),
('Aluminio', 'Aleaciones ligeras para componentes.'),
('Cobre', 'Usado para conexiones eléctricas.'),
('Tornillería', 'Tornillos, tuercas y arandelas.'),
('Pinturas', 'Pinturas y recubrimientos protectores.'),
('Lubricantes', 'Aceites y grasas industriales.'),
('Fundición', 'Metales fundidos para piezas pesadas.'),
('Planchas', 'Planchas metálicas para corte y doblado.'),
('Tubos', 'Tuberías y perfiles huecos.'),
('Soldaduras', 'Varillas y alambres para soldadura.');

-- =====================
-- 3. MATERIAS PRIMAS
-- =====================
INSERT INTO MateriaPrima (idCategoria, nombre, unidadMedida, stockActual, stockMin, stockMax) VALUES
(300, 'Acero SAE 1020', 'kg', 1000, 500, 3000),
(301, 'Aluminio 6061', 'kg', 500, 200, 1500),
(302, 'Cobre electrolítico', 'kg', 200, 100, 800),
(303, 'Tornillo M8', 'unidades', 4000, 1000, 10000),
(304, 'Pintura Epoxi Azul', 'litros', 100, 50, 500),
(305, 'Grasa Industrial', 'kg', 50, 30, 300),
(306, 'Hierro Fundido', 'kg', 800, 200, 2500),
(307, 'Plancha de Acero 3mm', 'm2', 300, 200, 1200),
(308, 'Tubo de Acero 2”', 'm', 900, 300, 2500),
(309, 'Varilla de Soldadura MIG', 'kg', 150, 50, 700);

-- =====================
-- 4. INGRESOS
-- =====================
INSERT INTO Ingreso (idProveedor, idMP, cantidad) VALUES
(1, 1, 1000), 
(2, 2, 500), 
(3, 3, 200), 
(4, 4, 4000), 
(5, 5, 100),
(6, 6, 50), 
(7, 7, 800), 
(8, 8, 300), 
(9, 9, 900), 
(10, 10, 150);

-- =====================
-- 5. DEPÓSITOS
-- =====================
INSERT INTO Deposito (nombre, direccion) VALUES
('Depósito Central', 'Av. San Martín 4500, CABA'),
('Depósito Norte', 'Ruta 8 km 35, Tigre'),
('Depósito Sur', 'Av. Calchaquí 1200, Quilmes'),
('Depósito Oeste', 'Moreno 2300, Morón'),
('Depósito Este', 'Camino General Belgrano 5600, Avellaneda'),
('Depósito Industrial 1', 'Parque Industrial Pilar'),
('Depósito Industrial 2', 'Parque Industrial Ezeiza'),
('Depósito Logístico', 'Dock Sud, Av. Mitre 800'),
('Depósito Metalúrgico', 'Lanús Oeste, 9 de Julio 2500'),
('Depósito Auxiliar', 'Lomas de Zamora, Oliden 1900');

-- =====================
-- 6. STOCK
-- =====================
INSERT INTO Stock (idDeposito, idMP, cantidad, ubicacion) VALUES
(300, 1, 1000, 'Sector A1'),
(301, 2, 500, 'Sector B2'),
(302, 3, 200, 'Sector C1'),
(303, 4, 4000, 'Sector D4'),
(304, 5, 100, 'Sector E1'),
(305, 6, 50, 'Sector F3'),
(306, 7, 800, 'Sector G2'),
(307, 8, 300, 'Sector H1'),
(308, 9, 900, 'Sector I2'),
(309, 10, 150, 'Sector J3');

-- =====================
-- 7. ETAPAS
-- =====================
INSERT INTO Etapa (nombre) VALUES
('Corte de Materiales'),
('Soldadura'),
('Pintura'),
('Montaje'),
('Pulido'),
('Control de Calidad'),
('Embalaje'),
('Almacenamiento'),
('Distribución'),
('Reparación');

-- =====================
-- 8. PRODUCTOS
-- =====================
INSERT INTO Producto (idEtapa, nombre, descripcion, pUnitario, tFabricacion) VALUES
(300, 'Estructura Base', 'Estructura metálica principal.', 12000, 5),
(301, 'Chasis Liviano', 'Chasis para maquinaria.', 15000, 6),
(302, 'Puerta Industrial', 'Puerta reforzada de acero.', 8000, 4),
(303, 'Baranda Metálica', 'Baranda de seguridad galvanizada.', 4000, 3),
(304, 'Tanque Presurizado', 'Tanque cilíndrico de acero inoxidable.', 25000, 8),
(305, 'Pieza Fundida', 'Componente moldeado por fundición.', 10000, 7),
(306, 'Gabinete Eléctrico', 'Caja metálica con recubrimiento epoxi.', 7000, 5),
(307, 'Rejilla Antideslizante', 'Rejilla de acero galvanizado.', 5000, 3),
(308, 'Soporte Tubular', 'Estructura de soporte de tubos.', 6000, 4),
(309, 'Panel de Protección', 'Panel laminado de seguridad.', 4500, 3);

-- =====================
-- 9. CLIENTES
-- =====================
INSERT INTO Cliente (razonSocial, cuit, telefono, email) VALUES
('Construcciones del Plata', '30711111111', '011-4655-1234', 'compras@cdplata.com'),
('Metalúrgica Andina', '30722222222', '011-4789-2233', 'ventas@andina.com'),
('Industrias Norte', '30733333333', '011-4567-3344', 'info@indnorte.com'),
('Automatizaciones SRL', '30744444444', '011-4890-4455', 'ventas@automat.com'),
('Obras Civiles SA', '30755555555', '011-4321-5566', 'compras@obrasciviles.com'),
('Transportes Argentinos', '30766666666', '011-4981-6677', 'contacto@transarg.com'),
('AceroTech', '30777777777', '011-4765-7788', 'ventas@acerotech.com'),
('MegaConstrucciones', '30788888888', '011-4333-8899', 'compras@megacons.com'),
('MetalHouse', '30799999999', '011-4123-9900', 'info@metalhouse.com'),
('Industrias del Sur', '30710101010', '011-4555-1010', 'ventas@indsur.com');

-- =====================
-- 10. VENTAS
-- =====================
INSERT INTO Venta (idProducto, idCliente, cantidad, pTotal) VALUES
(1, 1, 2, 24000), (2, 2, 1, 15000), (3, 3, 3, 24000), (4, 4, 5, 20000), (5, 5, 1, 25000),
(6, 6, 2, 20000), (7, 7, 4, 28000), (8, 8, 2, 10000), (9, 9, 3, 18000), (10, 10, 1, 4500);

-- =====================
-- 11. PRODUCTO-MATERIA PRIMA
-- =====================
INSERT INTO ProductoMP (idMP, idProducto, cantNecesaria) VALUES
(1, 1, 200), (2, 2, 150), (3, 3, 100), (4, 4, 500), (5, 5, 20),
(6, 6, 10), (7, 7, 250), (8, 8, 150), (9, 9, 200), (10, 10, 50);

-- =====================
-- 12. MOVIMIENTOS
-- =====================
INSERT INTO Movimiento (idIngreso, tipoMovimiento) VALUES
(100, 'Ingreso de materiales'),
(101, 'Ingreso de materiales'),
(104, 'Ingreso de materiales'),
(108, 'Ingreso de materiales');

INSERT INTO Movimiento (idVenta, tipoMovimiento) VALUES
(102, 'Venta'),
(103, 'Venta'),
(105, 'Venta'),
(106, 'Venta'),
(107, 'Venta'),
(109, 'Venta');