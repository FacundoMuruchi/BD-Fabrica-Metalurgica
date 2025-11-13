use induestant;
GO

-- PRUEBA AJUSTE
EXEC sp_RegistrarAjustes
    @idMP = 1, 
    @cantidad = 1000, 
    @idUbicacion = 303,
    @observacion = 'probando ajuste';
GO

-- PRUEBA INGRESO
EXEC sp_RegistrarIngreso
    @idProveedor = 1,
    @idMP = 1,
    @cantidad = 300,
    @idUbicacion = 303,
    @observacion = 'probando ingreso';
GO

--PRUEBA VENTA
EXEC sp_RegistrarVenta
    @idProducto = 1,
    @idCliente = 10,
    @cantidadProductos = 3,
    @idUbicacion = 300,
    @observacion = 'probando venta';

select * from Ubicacion;

select * from vw_StockGeneral;

select * from vw_StockPorUbicacion;

select * from vw_MovimientosDetallados;

select * from vw_RecetaProducto;

select * from Cliente;