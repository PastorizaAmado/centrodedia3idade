USE centrodedia3idade
GO
DROP TABLE IF EXISTS CuentaCorriente
GO
CREATE TABLE dbo.CuentaCorriente
(
    ID INT NOT NULL,
    Cantidad DECIMAL(19, 2) NOT NULL,
    Descripcion NVARCHAR(100) NOT NULL,
    Fechatransaccion DATE NOT NULL
);
GO
DROP TABLE IF EXISTS CuentaAhorro
GO
CREATE TABLE dbo.CuentaAhorro
(
    ID INT NOT NULL,
    Cantidad DECIMAL(19, 2) NOT NULL,
    Descripcion NVARCHAR(100) NOT NULL,
    Fechatransaccion DATE NOT NULL
);
GO

--INSERTO DATOS EN CUENTA CORRIENTE --

INSERT INTO dbo.CuentaCorriente
(
    ID,
    Cantidad,
    Descripcion,
    Fechatransaccion
)
VALUES
(1, 25.00, 'Ahorrando en mi cuenta corriente', GETDATE());
GO
----- INSERTO EN MI CUENTA DE AHORRO----
INSERT INTO dbo.CuentaAhorro
(
    ID,
    Cantidad,
    Descripcion,
    Fechatransaccion
)
VALUES
(1, 100.00, 'Ahorrando en mi cuenta  de ahorro, Gracias Papa', GETDATE());
GO

-- UNION ALL ME SALE EL RESULTADO COMO SI ESTUVIERA EN UNA ÚNICA TABLA

SELECT SUM(Cantidad) AS [Total], 
       'Ahorro' AS [TipoDeCuenta]
FROM dbo.CuentaAhorro
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Corriente' AS [TipoDeCuenta]
FROM dbo.CuentaCorriente;
GO

-- TRANSACCIÓN IMPLICITA ---
SELECT *
FROM dbo.CuentaAhorro
GO
------
SELECT *
FROM dbo.CuentaCorriente
GO

-- EJECUTAR LOS 2 UPDATES JUNTOS
UPDATE dbo.CuentaAhorro
SET  Cantidad=Cantidad-100,Descripcion='Sacando dinero de mi cuenta de ahorro.',
    Fechatransaccion = GETDATE()
WHERE ID = 1

-- ESTE UPDATE VA A FALLAR --
UPDATE dbo.CuentaCorriente
SET  Cantidad=Cantidad+100,Descripcion='Sacando dinero de mi cuenta corriente para un nuevo servicio, 
								Perdona Papa! Lo remplazaré en cuanto encuentre un trabajo',
    Fechatransaccion = GETDATE()
WHERE ID = 1

-- Comprobamos--
SELECT SUM(Cantidad) AS [Total], 
       'Ahorro' AS [TipoDeCuenta]
FROM dbo.CuentaAhorro
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Corriente' AS [TipoDeCuenta]
FROM dbo.CuentaCorriente;
GO

-- TRANSACCIÓN EXPLICITA --
SET XACT_ABORT ON;-- CONTROLAR EXCEPCIONES
BEGIN TRANSACTION; -- EMPIEZA TRANSACCIÓN

--Hacemos lo mismo que antes---
UPDATE dbo.CuentaAhorro
SET  Cantidad=Cantidad-100,Descripcion='Sacando dinero de mi cuenta de ahorro.',
    Fechatransaccion = GETDATE()
WHERE ID = 1

-- ESTE UPDATE VA A FALLAR --
UPDATE dbo.CuentaCorriente
SET  Cantidad=Cantidad+100,Descripcion='Sacando dinero de mi cuenta corriente para un nuevo servicio, 
								Perdona Papa! Lo remplazaré en cuanto encuentre un trabajo',
    Fechatransaccion = GETDATE()
WHERE ID = 1
COMMIT TRAN

--Comprobamos --
SELECT SUM(Cantidad) AS [Total], 
       'Ahorro' AS [TipoDeCuenta]
FROM dbo.CuentaAhorro
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Corriente' AS [TipoDeCuenta]
FROM dbo.CuentaCorriente;
GO

-- USANDO TRY - CATCH - THROW -- 
-- Comenzamos desde el principio -- 
DROP TABLE IF EXISTS CuentaCorriente
GO
CREATE TABLE dbo.CuentaCorriente
(
    ID INT NOT NULL,
    Cantidad DECIMAL(19, 2) NOT NULL,
    Descripcion NVARCHAR(100) NOT NULL,
    Fechatransaccion DATE NOT NULL
);
GO
DROP TABLE IF EXISTS CuentaAhorro
GO
CREATE TABLE dbo.CuentaAhorro
(
    ID INT NOT NULL,
    Cantidad DECIMAL(19, 2) NOT NULL,
    Descripcion NVARCHAR(100) NOT NULL,
    Fechatransaccion DATE NOT NULL
);
GO

--INSERTO DATOS EN CUENTA CORRIENTE --

INSERT INTO dbo.CuentaCorriente
(
    ID,
    Cantidad,
    Descripcion,
    Fechatransaccion
)
VALUES
(1, 25.00, 'Ahorrando en mi cuenta corriente', GETDATE());
GO
----- INSERTO EN MI CUENTA DE AHORRO----
INSERT INTO dbo.CuentaAhorro
(
    ID,
    Cantidad,
    Descripcion,
    Fechatransaccion
)
VALUES
(1, 100.00, 'Ahorrando en mi cuenta  de ahorro, Gracias Papa', GETDATE());
GO
-- UNION ALL ME SALE EL RESULTADO COMO SI ESTUVIERA EN UNA ÚNICA TABLA

SELECT SUM(Cantidad) AS [Total], 
       'Ahorro' AS [TipoDeCuenta]
FROM dbo.CuentaAhorro
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Corriente' AS [TipoDeCuenta]
FROM dbo.CuentaCorriente;
GO
---------
BEGIN TRY  
BEGIN TRANSACTION; -- EMPIEZA TRANSACCIÓN
-- MISMAS INSERCIONES
INSERT INTO dbo.CuentaAhorro
(
    ID,
    Cantidad,
    Descripcion,
    Fechatransaccion
)
VALUES
(2, -100.00, 'Ahorrando en mi cuenta  de ahorro', GETDATE());

INSERT INTO dbo.CuentaCorriente
(
    ID,
    Cantidad,
    Descripcion,
    Fechatransaccion
)
VALUES
(2, 100.00, 'Sacando dinero de mi cuenta corriente para un nuevo servicio, Perdona Papa! Lo remplazaré en cuanto encuentre un trabajo', GETDATE());

COMMIT TRANSACTION; 
END TRY  
BEGIN CATCH  
    PRINT 'Truncated value:';  
    THROW;  
END CATCH;  
 GO 

 --Comprobamos --
 SELECT SUM(Cantidad) AS [Total], 
       'Ahorro' AS [TipoDeCuenta]
FROM dbo.CuentaAhorro
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Corriente' AS [TipoDeCuenta]
FROM dbo.CuentaCorriente;
GO