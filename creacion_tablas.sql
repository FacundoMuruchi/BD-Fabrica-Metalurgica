CREATE DATABASE induestant;

GO;

USE induestant;

GO;

CREATE TABLE Proveedor(
idProveedor INT IDENTITY PRIMARY KEY,
razonSocial VARCHAR(100) NOT NULL,
cuit VARCHAR(11) NOT NULL,
telefono VARCHAR(50),
email VARCHAR(100),
CONSTRAINT uniqueProveedorCuit UNIQUE (cuit),
CONSTRAINT checkProveedorCuitLen CHECK (LEN(cuit) = 11),
CONSTRAINT checkProveedorEmail CHECK (email LIKE '%@%.%')
);

CREATE TABLE Categoria(
idCategoria INT IDENTITY(300,1) PRIMARY KEY,
tipo VARCHAR(100) NOT NULL,
descripcion VARCHAR(500)
);

CREATE TABLE MateriaPrima(
idMP INT IDENTITY PRIMARY KEY,
idCategoria INT NOT NULL,
nombre VARCHAR(100) NOT NULL,
unidadMedida VARCHAR(50) NOT NULL,
stockActual DECIMAL(10,2) NOT NULL,
stockMin DECIMAL(10,2),
stockMax DECIMAL(10,2),
CONSTRAINT fkIdCateogria FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria),
CONSTRAINT cantStockActual CHECK (stockActual >= 0),
CONSTRAINT cantStockMin CHECK (stockMin >= 0),
CONSTRAINT cantStockMax CHECK (stockMax >= 0)
);

CREATE TABLE ProveedorMP(
idProveedorMP INT IDENTITY(100,1) PRIMARY KEY,
idProveedor INT NOT NULL,
idMP INT NOT NULL,
CONSTRAINT fkProveedorIdProveedor FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor),
CONSTRAINT fkProveedorIdMP FOREIGN KEY (idMP) REFERENCES MateriaPrima(idMP)
);

CREATE TABLE Deposito(
idDeposito INT IDENTITY(300,1) PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
direccion VARCHAR(100) NOT NULL
);

CREATE TABLE Stock(
idStock INT IDENTITY(100,1) PRIMARY KEY,
idDeposito INT NOT NULL,
idMP INT NOT NULL,
cantidad DECIMAL(10,2) NOT NULL,
ubicacion VARCHAR(100),
CONSTRAINT fkStockIdDeposito FOREIGN KEY (idDeposito) REFERENCES Deposito(idDeposito),
CONSTRAINT fkStockIdMP FOREIGN KEY (idMP) REFERENCES MateriaPrima(idMP)
);

CREATE TABLE Etapa(
idEtapa INT IDENTITY(300,1) PRIMARY KEY,
nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Producto(
idProducto INT IDENTITY PRIMARY KEY,
idEtapa INT NOT NULL,
nombre VARCHAR(100) NOT NULL,
descripcion VARCHAR(500),
pUnitario DECIMAL(10,2) NOT NULL,
tFabricacion INT NOT NULL,
CONSTRAINT fkProductoIdEtapa FOREIGN KEY (idEtapa) REFERENCES Etapa(idEtapa)
);

CREATE TABLE Cliente(
idCliente INT IDENTITY PRIMARY KEY,
razonSocial VARCHAR(100) NOT NULL,
cuit VARCHAR(11) NOT NULL,
telefono VARCHAR(50),
email VARCHAR(100),
CONSTRAINT uniqueClienteCuit UNIQUE (cuit),
CONSTRAINT checkClienteCuitLen CHECK (LEN(cuit) = 11),
CONSTRAINT checkClienteEmail CHECK (email LIKE '%@%.%')
);

CREATE TABLE Venta(
idVenta INT IDENTITY(100,1) PRIMARY KEY,
idProducto INT NOT NULL,
idCliente INT NOT NULL,
cantidad INT NOT NULL,
pTotal DECIMAL(10,2) NOT NULL,
fecha DATETIME NOT NULL DEFAULT GETDATE(),
CONSTRAINT fkVentaIdProducto FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
CONSTRAINT fkVentaIdCliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
CONSTRAINT checkVentaCantidad CHECK (cantidad > 0),
CONSTRAINT checkVentaPTotal CHECK (pTotal >= 0)
);

CREATE TABLE ProductoMP(
idProductoMP INT IDENTITY(100,1) PRIMARY KEY,
idMP INT NOT NULL,
idProducto INT NOT NULL,
cantNecesaria DECIMAL(10,2) NOT NULL,
CONSTRAINT fkProductoMPIdMP FOREIGN KEY (idMP) REFERENCES MateriaPrima(idMP),
CONSTRAINT fkProductoMPIdProducto FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

CREATE TABLE Movimiento(
idMovimiento INT IDENTITY(500,1) PRIMARY KEY,
idProveedor INT,
idVenta INT,
idProducto INT,
idMP INT,
tipoMovimiento VARCHAR(100) NOT NULL,
cantidad DECIMAL(10,2) NOT NULL,
fecha DATETIME NOT NULL DEFAULT GETDATE(),
CONSTRAINT fkMovimientoIdProveedor FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor),
CONSTRAINT fkMovimientoIdVenta FOREIGN KEY (idVenta) REFERENCES Venta(idVenta),
CONSTRAINT fkMovimientoIdProducto FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
CONSTRAINT fkMovimientoIdMP FOREIGN KEY (idMP) REFERENCES MateriaPrima(idMP)
);