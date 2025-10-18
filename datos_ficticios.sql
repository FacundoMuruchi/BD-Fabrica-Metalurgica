USE induestant;
GO

-- PROVEEDOR
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

-- CATEGORIA (empieza en 300)
INSERT INTO Categoria (tipo, descripcion) VALUES
('Aceros', 'Materiales de acero para estructuras.'),
('Aluminio', 'Aleaciones livianas.'),
('Cobre', 'Usado para conexiones eléctricas.'),
('Tornillería', 'Tornillos, tuercas y arandelas.'),
('Pinturas', 'Recubrimientos y esmaltes industriales.'),
('Lubricantes', 'Aceites y grasas para maquinaria.'),
('Fundición', 'Metales fundidos para piezas.'),
('Planchas', 'Planchas metálicas.'),
('Tubos', 'Tuberías metálicas.'),
('Soldaduras', 'Varillas para soldadura MIG/TIG.');

-- UNIDAD DE MEDIDA (empieza en 300)
INSERT INTO UnidadMedida (unidad) VALUES
('kg'), ('m'), ('m2'), ('litros'), ('unidades'),
('toneladas'), ('cm'), ('ml'), ('piezas'), ('barras');

-- MATERIA PRIMA
INSERT INTO MateriaPrima (idCategoria, nombre, idUnidadMedida, stockActual, stockMin, stockMax) VALUES
(300, 'Acero SAE 1020', 300, 1000, 500, 3000),
(301, 'Aluminio 6061', 300, 500, 200, 1500),
(302, 'Cobre electrolítico', 300, 200, 100, 800),
(303, 'Tornillo M8', 304, 4000, 1000, 10000),
(304, 'Pintura Epoxi Azul', 303, 100, 50, 500),
(305, 'Grasa Industrial', 300, 50, 30, 300),
(306, 'Hierro Fundido', 300, 800, 200, 2500),
(307, 'Plancha de Acero 3mm', 302, 300, 200, 1200),
(308, 'Tubo de Acero 2”', 301, 900, 300, 2500),
(309, 'Varilla MIG', 309, 150, 50, 700);

-- INGRESO (empieza en 100)
INSERT INTO Ingreso (idProveedor, idMP) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- DIRECCION (empieza en 300)
INSERT INTO Direccion (calle, altura, cp, ciudad, provincia) VALUES
('Av. San Martín',4500,'1417','CABA','Buenos Aires'),
('Ruta 8',35000,'1618','Tigre','Buenos Aires'),
('Av. Calchaquí',1200,'1878','Quilmes','Buenos Aires'),
('Moreno',2300,'1708','Morón','Buenos Aires'),
('Camino Belgrano',5600,'1874','Avellaneda','Buenos Aires'),
('Parque Industrial Pilar',100,'1629','Pilar','Buenos Aires'),
('Parque Industrial Ezeiza',200,'1804','Ezeiza','Buenos Aires'),
('Av. Mitre',800,'1871','Dock Sud','Buenos Aires'),
('9 de Julio',2500,'1824','Lanús Oeste','Buenos Aires'),
('Oliden',1900,'1832','Lomas de Zamora','Buenos Aires');

-- DEPOSITO (empieza en 300)
INSERT INTO Deposito (nombre, idDireccion) VALUES
('Depósito Central',300),
('Depósito Norte',301),
('Depósito Sur',302),
('Depósito Oeste',303),
('Depósito Este',304),
('Depósito Pilar',305),
('Depósito Ezeiza',306),
('Depósito Dock Sud',307),
('Depósito Lanús',308),
('Depósito Lomas',309);

-- UBICACION (empieza en 300)
INSERT INTO Ubicacion (idDeposito, pasillo, columna, nivel) VALUES
(300,1,'A',1),
(300,2,'B',2),
(301,1,'A',1),
(302,2,'C',1),
(303,3,'D',1),
(304,1,'E',1),
(305,2,'F',2),
(306,3,'G',1),
(307,1,'H',1),
(308,2,'I',1);

-- STOCK (empieza en 100)
INSERT INTO Stock (idUbicacion, idMP, cantidad) VALUES
(300,1,1000),
(301,2,500),
(302,3,200),
(303,4,4000),
(304,5,100),
(305,6,50),
(306,7,800),
(307,8,300),
(308,9,900),
(309,10,150);

-- ETAPA (empieza en 300)
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

-- PRODUCTO
INSERT INTO Producto (idEtapa, nombre, descripcion, pUnitario, tFabricacion) VALUES
(300,'Estructura Base','Estructura metálica principal.',12000,5),
(301,'Chasis Liviano','Chasis para maquinaria.',15000,6),
(302,'Puerta Industrial','Puerta reforzada de acero.',8000,4),
(303,'Baranda Metálica','Baranda galvanizada.',4000,3),
(304,'Tanque Presurizado','Tanque de acero inoxidable.',25000,8),
(305,'Pieza Fundida','Componente moldeado.',10000,7),
(306,'Gabinete Eléctrico','Caja metálica pintada.',7000,5),
(307,'Rejilla Antideslizante','Rejilla galvanizada.',5000,3),
(308,'Soporte Tubular','Estructura de soporte.',6000,4),
(309,'Panel de Protección','Panel laminado.',4500,3);

-- CLIENTE
INSERT INTO Cliente (razonSocial, cuit, telefono, email) VALUES
('Construcciones del Plata','30711111111','011-4655-1234','compras@cdplata.com'),
('Metalúrgica Andina','30722222222','011-4789-2233','ventas@andina.com'),
('Industrias Norte','30733333333','011-4567-3344','info@indnorte.com'),
('Automatizaciones SRL','30744444444','011-4890-4455','ventas@automat.com'),
('Obras Civiles SA','30755555555','011-4321-5566','compras@obrasciviles.com'),
('Transportes Argentinos','30766666666','011-4981-6677','contacto@transarg.com'),
('AceroTech','30777777777','011-4765-7788','ventas@acerotech.com'),
('MegaConstrucciones','30788888888','011-4333-8899','compras@megacons.com'),
('MetalHouse','30799999999','011-4123-9900','info@metalhouse.com'),
('Industrias del Sur','30710101010','011-4555-1010','ventas@indsur.com');

-- VENTA (empieza en 100)
INSERT INTO Venta (idProducto, idCliente, pTotal) VALUES
(1,1,24000),
(2,2,15000),
(3,3,24000),
(4,4,20000),
(5,5,25000),
(6,6,20000),
(7,7,28000),
(8,8,10000),
(9,9,18000),
(10,10,4500);

-- PRODUCTO-MATERIA PRIMA (empieza en 100)
INSERT INTO ProductoMP (idMP, idProducto, cantNecesaria) VALUES
(1,1,200),
(2,2,150),
(3,3,100),
(4,4,500),
(5,5,20),
(6,6,10),
(7,7,250),
(8,8,150),
(9,9,200),
(10,10,50);

-- TIPO MOVIMIENTO (empieza en 300)
INSERT INTO TipoMovimiento (tipo) VALUES
('Ingreso de Materia Prima'),
('Venta de Producto'),
('Ajuste Positivo'),
('Ajuste Negativo'),
('Transferencia Interna'),
('Devolución de Cliente'),
('Devolución a Proveedor'),
('Consumo Interno'),
('Producción'),
('Inventario Inicial');

-- MOVIMIENTO (empieza en 500)
INSERT INTO Movimiento (idVenta, idIngreso, idMP, idProducto, idTipoMovimiento, cantidad, observacion, fecha) VALUES
(NULL,100,NULL,NULL,300,1000,'Ingreso de acero SAE 1020',DATEADD(DAY,-20,GETDATE())),
(NULL,101,NULL,NULL,300,500,'Ingreso de aluminio 6061',DATEADD(DAY,-19,GETDATE())),
(100,NULL,NULL,NULL,301,2,'Venta de estructura base',DATEADD(DAY,-10,GETDATE())),
(102,NULL,NULL,NULL,301,3,'Venta de puerta industrial',DATEADD(DAY,-8,GETDATE())),
(NULL,NULL,4,NULL,303,100,'Ajuste negativo: pérdida de tornillos',DATEADD(DAY,-5,GETDATE())),
(NULL,NULL,5,NULL,302,50,'Ajuste positivo: sobrante de pintura',DATEADD(DAY,-4,GETDATE())),
(NULL,NULL,1,NULL,304,200,'Transferencia interna de acero',DATEADD(DAY,-3,GETDATE())),
(NULL,NULL,NULL,2,308,1,'Producción interna de chasis',DATEADD(DAY,-2,GETDATE())),
(NULL,NULL,NULL,5,305,1,'Devolución de cliente',DATEADD(DAY,-1,GETDATE())),
(NULL,109,NULL,NULL,300,150,'Ingreso de varillas MIG',GETDATE());
