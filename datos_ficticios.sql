USE induestant;
GO

-- ### Categoria ###
PRINT 'Insertando datos en Categoria...';
INSERT INTO Categoria (tipo, descripcion) VALUES
('Perfiles de Acero', 'Perfiles estructurales de acero al carbono para racks y estanterías.'),
('Tornillería', 'Tornillos, tuercas y arandelas de distintas medidas.'),
('Chapas', 'Chapas de acero laminado en frío y en caliente.'),
('Pinturas', 'Pinturas epoxi y sintéticas para acabado y protección.'),
('Herrajes', 'Bisagras, ruedas, cerraduras y otros componentes.'),
('Soldadura', 'Electrodos, alambres y consumibles para procesos de soldadura.'),
('Abrasivos', 'Discos de corte, desbaste y lijas.'),
('Embalaje', 'Film stretch, cartón corrugado y cintas para empaque.'),
('Químicos', 'Lubricantes, desengrasantes y otros químicos de taller.'),
('Componentes Plásticos', 'Regatones, protectores y otros componentes plásticos.');
GO

-- ### Deposito ###
PRINT 'Insertando datos en Deposito...';
INSERT INTO Deposito (nombre, direccion) VALUES
('Depósito Central', 'Pedro Suárez 1108, Luis Guillón'),
('Centro Logístico Quilmes', 'Ruta 2 KM 40, Quilmes'),
('Almacén La Plata', 'Calle 122 y 50, La Plata'),
('Galpón Industrial Pilar', 'Parque Industrial Pilar, Pilar'),
('Sucursal Zona Norte - Tigre', 'Acceso Tigre KM 20, Tigre'),
('Depósito de Acopio Campana', 'Ruta 9 KM 70, Campana'),
('Planta de Despacho Bahía Blanca', 'Puerto de Ing. White, Bahía Blanca'),
('Centro de Distribución MDP', 'Parque Industrial Gral. Savio, Mar del Plata'),
('Almacén Regional Junín', 'Ruta 7 KM 260, Junín'),
('Sucursal Oeste - Morón', 'Acceso Oeste KM 25, Morón');
GO

-- ### Etapa ###
PRINT 'Insertando datos en Etapa...';
INSERT INTO Etapa (nombre) VALUES
('Diseño y Planificación'),
('Recepción de Material'),
('Corte'),
('Plegado'),
('Soldadura'),
('Pulido y Desbaste'),
('Pintura'),
('Ensamblaje'),
('Control de Calidad'),
('Embalaje y Despacho');
GO

-- ### Proveedor ###
PRINT 'Insertando datos en Proveedor...';
INSERT INTO Proveedor (razonSocial, cuit, telefono, email) VALUES
('Acindar S.A.', '30123456789', '011-4444-5555', 'ventas@acindar.com.ar'),
('Ternium Argentina', '30234567890', '011-4444-6666', 'contacto@ternium.com'),
('Bulonera Industrial SRL', '30345678901', '011-4201-1111', 'pedidos@buloneraindustrial.com'),
('Ferretería El Tornillo Feliz', '30456789012', '011-4205-2222', 'tornillofeliz@gmail.com'),
('Pinturas Industriales S.A.', '30567890123', '011-4222-3333', 'info@pinturasindustriales.net'),
('Chapas Galvanizadas del Sur', '30678901234', '0221-450-4050', 'chapasdelsur@yahoo.com'),
('Abrasivos Nacionales', '30789012345', '0341-433-3344', 'abrasivosnac@hotmail.com'),
('Herrajes Metalúrgicos', '30890123456', '011-4244-5566', 'herrajesmet@live.com'),
('Logística Rápida S.A.', '30901234567', '011-5000-5000', 'operaciones@lograpida.com.ar'),
('Plásticos Inyectados Cuyo', '33123456789', '0264-420-2020', 'plasticoscuyo@outlook.com');
GO

-- ### Cliente ###
PRINT 'Insertando datos en Cliente...';
INSERT INTO Cliente (razonSocial, cuit, telefono, email) VALUES
('Supermercados COTO', '33987654321', '011-4586-7777', 'compras@coto.com.ar'),
('Logística Andreani', '33876543210', '011-4740-4000', 'proveedores@andreani.com'),
('MercadoLibre S.R.L.', '33765432109', '011-4609-0000', 'compras.depo@mercadolibre.com'),
('Ferretería Central', '33654321098', '011-4300-3000', 'ferreteriacentral@gmail.com'),
('Estanterías Modernas', '33543210987', '0351-466-6677', 'estanteriasmodernas@hotmail.com'),
('Depósitos Seguros S.A.', '33432109876', '011-4900-9000', 'info@deposeguros.com.ar'),
('Construcciones Metálicas Patagónicas', '33321098765', '0299-440-4040', 'compras@cmpatagonia.com'),
('Taller Mecánico El Rápido', '20234567890', '011-4687-1234', 'elrapidotaller@yahoo.com'),
('Góndolas Express', '33210987654', '011-4202-2020', 'gondolasexpress@live.com'),
('Muebles de Oficina S.A.', '33109876543', '011-4777-8888', 'mueblesoficina@outlook.com');
GO

-- ### MateriaPrima ###
PRINT 'Insertando datos en MateriaPrima...';
INSERT INTO MateriaPrima (idCategoria, nombre, unidadMedida, stockActual, stockMin, stockMax) VALUES
(300, 'Perfil de Acero 40x40 2mm', 'Metros', 1250.50, 200, 2000),
(301, 'Tornillo Hexagonal 1/4"', 'Unidades', 8500, 1000, 20000),
(302, 'Chapa de Acero 1.2mm', 'Metros Cuadrados', 300, 50, 500),
(303, 'Pintura Epoxi Gris (Lata 20L)', 'Unidades', 50, 10, 80),
(304, 'Rueda Giratoria con Freno 100mm', 'Unidades', 250, 40, 400),
(305, 'Electrodo 6013 2.5mm (Caja 5kg)', 'Unidades', 80, 20, 150),
(306, 'Disco de Corte 4.5 pulgadas', 'Unidades', 450, 100, 1000),
(307, 'Film Stretch (Rollo)', 'Unidades', 60, 15, 100),
(308, 'Grasa de Litio (Pote 1kg)', 'Unidades', 30, 5, 50),
(309, 'Regatón Plástico 40x40', 'Unidades', 5000, 500, 10000);
GO

-- ### Producto ###
PRINT 'Insertando datos en Producto...';
INSERT INTO Producto (idEtapa, nombre, descripcion, pUnitario, tFabricacion) VALUES
(309, 'Rack de Carga Ligera R200', 'Rack de 2m alto x 1.5m ancho x 0.6m prof.', 15000.00, 3),
(309, 'Estantería Metálica E150', 'Estantería de 5 estantes, 1.5m alto', 8500.00, 2),
(309, 'Góndola Central G300', 'Góndola para supermercado, 1.8m alto', 22000.00, 5),
(309, 'Mesa de Trabajo Taller T-01', 'Mesa reforzada con chapa superior', 18000.00, 4),
(309, 'Armario Metálico A-02', 'Armario de dos puertas con cerradura', 25000.00, 6),
(309, 'Accesorio Gancho S', 'Gancho tipo S para panel perforado', 150.00, 1),
(309, 'Soporte para TV Metálico', 'Soporte fijo para TV de hasta 55"', 2500.00, 1),
(309, 'Carro de Herramientas C-50', 'Carro con 3 bandejas y ruedas', 19500.00, 5),
(309, 'Banco de Trabajo Plegable B-10', 'Banco de trabajo para taller, plegable', 12000.00, 3),
(309, 'Panel Perforado P-05', 'Panel de 1x1m para colgar herramientas', 4500.00, 2);
GO

-- ### ProveedorMP ###
PRINT 'Insertando datos en ProveedorMP...';
INSERT INTO ProveedorMP (idProveedor, idMP) VALUES
(1, 1), (1, 3), -- Acindar provee Perfiles y Chapas
(2, 1), (2, 3), -- Ternium provee Perfiles y Chapas
(3, 2), (3, 7), -- Bulonera provee Tornillos y Abrasivos
(4, 2), -- Ferretería provee Tornillos
(5, 4), -- Pinturas Ind. provee Pintura
(6, 3), -- Chapas del Sur provee Chapas
(7, 7), -- Abrasivos Nac. provee Discos
(8, 5), -- Herrajes Met. provee Ruedas
(10, 10), -- Plásticos Cuyo provee Regatones
(9, 8),   -- Logística Rápida provee Film Stretch
(5, 9),   -- Pinturas Industriales provee Grasa de Litio
(1, 6),   -- Acindar también provee Electrodos
(3, 10),  -- Bulonera Industrial también provee Regatones
(8, 5);   -- Herrajes Metalúrgicos también provee Ruedas
GO

-- ### Stock ###
PRINT 'Insertando datos en Stock...';
INSERT INTO Stock (idDeposito, idMP, cantidad, ubicacion) VALUES
(307, 1, 1250.50, 'Rack Largo L1-L5'),
(304, 2, 8500, 'Estantería T5, Caja 1-20'),
(305, 3, 300, 'Zona Exterior Techada'),
(303, 4, 50, 'Armario de Químicos Q1'),
(304, 5, 250, 'Estantería H2, Caja 1-5'),
(302, 6, 80, 'Sector Soldadura, Armario S2'),
(302, 7, 450, 'Sector Corte, Estantería C1'),
(308, 8, 60, 'Sector Despacho'),
(306, 9, 30, 'Pañol de Mantenimiento'),
(304, 10, 5000, 'Estantería P1, Caja 1-10'),
(303, 1, 3000.00, 'Sector A, Rack 12'),                
(304, 2, 25000.00, 'Estantería T-08, Caja 40-50'),    
(300, 4, 20.00, 'Armario de Pinturas P2'),           
(301, 8, 150.00, 'Sector Embalaje E1'),          
(300, 3, 500.00, 'Patio Trasero, Lote 3');    

GO

-- ### ProductoMP ###
PRINT 'Insertando datos en ProductoMP...';
INSERT INTO ProductoMP (idProducto, idMP, cantNecesaria) VALUES
(1, 1, 12.50), -- Rack R200 necesita 12.5m de Perfil de Acero
(1, 2, 16.00), -- Rack R200 necesita 16 Tornillos
(1, 10, 8.00), -- Rack R200 necesita 8 Regatones
(2, 3, 3.75),  -- Estantería E150 necesita 3.75m2 de Chapa
(2, 2, 24.00), -- Estantería E150 necesita 24 Tornillos
(4, 1, 6.00),  -- Mesa de Trabajo necesita 6m de Perfil de Acero
(4, 3, 2.00),  -- Mesa de Trabajo necesita 2m2 de Chapa
(4, 6, 0.50),  -- Mesa de Trabajo necesita media caja de Electrodos
(5, 3, 6.00),  -- Armario Metálico necesita 6m2 de Chapa
(5, 5, 2.00),  -- Armario Metálico necesita 2 Bisagras
(3, 1, 25.00),  -- Góndola Central necesita 25m de Perfil de Acero
(3, 2, 40.00),  -- Góndola Central necesita 40 Tornillos
(6, 1, 0.50),   -- Accesorio Gancho S necesita 0.5m de Perfil de Acero (alambre)
(8, 5, 4.00),   -- Carro de Herramientas necesita 4 Ruedas
(8, 3, 2.50);   -- Carro de Herramientas necesita 2.5m2 de Chapa
GO

-- ### Venta ###
PRINT 'Insertando datos en Venta...';
INSERT INTO Venta (idProducto, idCliente, cantidad, pTotal) VALUES
(1, 1, 10, 150000.00),
(2, 2, 20, 170000.00),
(1, 3, 5, 75000.00),
(4, 8, 2, 36000.00),
(5, 6, 4, 100000.00),
(8, 8, 3, 58500.00),
(3, 1, 8, 176000.00),
(10, 4, 15, 67500.00),
(7, 5, 30, 75000.00),
(1, 2, 12, 180000.00),
(3, 1, 5, 110000.00), 
(5, 6, 10, 250000.00),
(1, 7, 15, 225000.00),
(9, 10, 20, 240000.00),
(4, 2, 8, 144000.00); 
GO

-- ### Movimiento ###
PRINT 'Insertando datos en Movimiento...';
INSERT INTO Movimiento (tipoMovimiento, cantidad, idProveedor, idMP) VALUES
('Ingreso por compra', 1000, 1, 1),
('Ingreso por compra', 5000, 3, 2),
('Ingreso por compra', 200, 2, 3),
('Ingreso por compra', 30, 5, 4),
('Ingreso por compra', 800.00, 2, 1),     
('Ingreso por compra', 10000.00, 4, 2);  


INSERT INTO Movimiento (tipoMovimiento, cantidad, idVenta, idProducto) VALUES
('Salida por venta', -10, 100, 1),
('Salida por venta', -20, 101, 2),
('Salida por venta', -5, 102, 1),
('Salida por venta', -2, 103, 4),
('Salida por venta', -5, 110, 3),  
('Salida por venta', -10, 111, 5), 
('Salida por venta', -15, 112, 1), 
('Salida por venta', -20, 113, 9),  
('Salida por venta', -8, 114, 4);  

INSERT INTO Movimiento (tipoMovimiento, cantidad, idMP) VALUES
('Salida para producción', -125, 1), -- (10 racks * 12.5m cada uno)
('Salida para producción', -160, 2), -- (10 racks * 16 tornillos cada uno)
('Ajuste de inventario', 5.5, 1), -- Se encontró un sobrante de Perfil de Acero
('Ajuste por rotura', -10, 5), -- Se rompieron 10 ruedas
('Salida para producción', -250.00, 1), -- Se usan 250m de Perfil de Acero para fabricar Góndolas
('Salida para producción', -400.00, 2), -- Se usan 400 tornillos para las mismas Góndolas
('Ajuste de inventario', -10.00, 10);   -- Se pierden 10 regatones durante el conteo