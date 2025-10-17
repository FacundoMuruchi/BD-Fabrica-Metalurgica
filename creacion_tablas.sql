CREATE DATABASE induestant;

GO

USE induestant;

GO

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
CONSTRAINT checkCantStockActual CHECK (stockActual >= 0),
CONSTRAINT checkCantStockMin CHECK (stockMin >= 0),
CONSTRAINT checkCantStockMax CHECK (stockMax >= 0)
);

CREATE TABLE Ingreso(
idIngreso INT IDENTITY(100,1) PRIMARY KEY,
idProveedor INT NOT NULL,
idMP INT NOT NULL,
CONSTRAINT fkProveedorIdProveedor FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor),
CONSTRAINT fkProveedorIdMP FOREIGN KEY (idMP) REFERENCES MateriaPrima(idMP)
);

CREATE TABLE Direccion(
idDireccion INT IDENTITY(300,1) PRIMARY KEY,
calle VARCHAR(100) NOT NULL,
altura INT NOT NULL,
cp VARCHAR(50) NOT NULL,
ciudad VARCHAR(100) NOT NULL,
provincia VARCHAR(100) NOT NULL,
);

CREATE TABLE Deposito(
idDeposito INT IDENTITY(300,1) PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
idDireccion INT NOT NULL,
CONSTRAINT fkDepositoIdDireccion FOREIGN KEY (idDireccion) REFERENCES Direccion(idDireccion)
);

CREATE TABLE Ubicacion(
idUbicacion INT IDENTITY(300,1) PRIMARY KEY,
idDeposito INT NOT NULL,
pasillo INT NOT NULL,
columna CHAR(1) NOT NULL,
nivel INT NOT NULL,
CONSTRAINT fkUbicacionIdDeposito FOREIGN KEY (idDeposito) REFERENCES Deposito(idDeposito),
CONSTRAINT checkUbicacionColumna CHECK (columna LIKE '[A-Z]')
);

CREATE TABLE Stock(
idStock INT IDENTITY(100,1) PRIMARY KEY,
idUbicacion INT NOT NULL,
idMP INT NOT NULL,
cantidad DECIMAL(10,2) NOT NULL,
CONSTRAINT fkStockIdUbicacion FOREIGN KEY (idUbicacion) REFERENCES Ubicacion(idUbicacion),
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
pTotal DECIMAL(10,2) NOT NULL,
CONSTRAINT fkVentaIdProducto FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
CONSTRAINT fkVentaIdCliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
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

CREATE TABLE TipoMovimiento(
idTipoMovimiento INT IDENTITY(300,1) PRIMARY KEY,
tipo VARCHAR(50) NOT NULL
);

CREATE TABLE Movimiento(
idMovimiento INT IDENTITY(500,1) PRIMARY KEY,
idVenta INT,
idIngreso INT,
idTipoMovimiento INT NOT NULL,
cantidad DECIMAL(10,2) NOT NULL,
fecha DATETIME NOT NULL DEFAULT GETDATE(),
CONSTRAINT fkMovimientoIdVenta FOREIGN KEY (idVenta) REFERENCES Venta(idVenta),
CONSTRAINT fkMovimientoIdIngreso FOREIGN KEY (idIngreso) REFERENCES Ingreso(idIngreso),
CONSTRAINT fkMovimientoIdTipoMovimiento FOREIGN KEY (idTipoMovimiento) REFERENCES TipoMovimiento(idTipoMovimiento),
CONSTRAINT checkMovimientoCantidad CHECK (cantidad > 0)
);