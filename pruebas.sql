EXEC sp_RegistrarAjustes
    @idMP = 1, 
    @cantidad = -600, 
    @observacion = 'Prueba de trigger stock mínimo';
GO

select * from MateriaPrima