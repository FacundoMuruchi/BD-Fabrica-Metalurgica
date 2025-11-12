EXEC sp_RegistrarAjustes
    @idMP = 1, 
    @cantidad = 300, 
    @idUbicacion = 305,
    @observacion = 'Prueba de nuevo proc';
GO

select * from vw_StockGeneral;

select * from vw_StockPorUbicacion;

select * from vw_MovimientosDetallados;

select * from Movimiento;

SELECT * FROM MateriaPrima