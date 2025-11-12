EXEC sp_RegistrarAjustes
    @idMP = 3, 
    @cantidad = 600, 
    @idUbicacion = 302,
    @observacion = 'llegar a 100%';
GO

EXEC sp_RegistrarIngreso
    @idProveedor = 1,
    @idMP = 4,
    @cantidad = 40,
    @idUbicacion = 302;
GO

select * from Ubicacion;

select * from vw_StockGeneral;

select * from vw_StockPorUbicacion;

select * from vw_MovimientosDetallados;

select * from Movimiento;

SELECT * FROM MateriaPrima;

select * from Stock;