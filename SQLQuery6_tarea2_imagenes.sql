USE centrodedia3idade
GO
DROP TABLE IF EXISTS imagenes
GO
CREATE TABLE imagenes (
   nombreimagen NVARCHAR(40) PRIMARY KEY NOT NULL
   , nombrearchivoimagen NVARCHAR (100)
   , datosimagen VARBINARY (max)
   )
GO
Use master
Go
EXEC sp_configure 'show advanced options', 1; 
GO 
RECONFIGURE; 
GO 
--RECONFIGURE WITH OVERRIDE; 
--GO
EXEC sp_configure 'Ole Automation Procedures', 1; 
GO 
RECONFIGURE; 
GO

--ALTER SERVER ROLE [bulkadmin] ADD MEMBER [Enter here the Login Name that will execute the Import] 
--GO  

ALTER SERVER ROLE [bulkadmin] ADD MEMBER [WINDOWS11BBDD\Dpastoriza]
GO

USE centrodedia3idade
GO

-- Image Import Stored Procedure
-- IMPORTAR IMAGENES
CREATE OR ALTER PROCEDURE dbo.usp_ImportImage (
     @nombreim NVARCHAR (100)
   , @rutaimagen NVARCHAR (1000)
   , @nombre NVARCHAR (1000)
   )
AS
BEGIN
   DECLARE @Path2OutFile NVARCHAR (2000);
   DECLARE @tsql NVARCHAR (2000);
   SET NOCOUNT ON
   SET @Path2OutFile = CONCAT (
         @rutaimagen
         ,'\'
         , @nombre
         );
   SET @tsql = 'insert into imagenes (nombreimagen, nombrearchivoimagen, datosimagen) ' +
               ' SELECT ' + '''' + @nombreim + '''' + ',' + '''' + @nombre + '''' + ', * ' + 
               'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as img'
   EXEC (@tsql)
   SET NOCOUNT OFF
END
GO

--Image Export Stored Procedure
-- EXPORT IMAGENES

CREATE OR ALTER PROCEDURE dbo.usp_ExportarImagen (
     @nombreim NVARCHAR (100)
   , @rutaimagen NVARCHAR (1000)
   , @nombre NVARCHAR (1000)
   )
AS
BEGIN
   DECLARE @ImagenData VARBINARY (max);
   DECLARE @Path2OutFile NVARCHAR (2000);
   DECLARE @Obj INT
 
   SET NOCOUNT ON
 
   SELECT @ImagenData = (
         SELECT convert (VARBINARY (max), datosimagen, 1)
         FROM imagenes
         WHERE nombreimagen = @nombreim
         );
 
   SET @Path2OutFile = CONCAT (
         @rutaimagen
         ,'\'
         , @nombre
         );
    BEGIN TRY
     EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
     EXEC sp_OASetProperty @Obj ,'Type',1;
     EXEC sp_OAMethod @Obj,'Open';
     EXEC sp_OAMethod @Obj,'Write', NULL, @ImagenData;
     EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
     EXEC sp_OAMethod @Obj,'Close';
     EXEC sp_OADestroy @Obj;
    END TRY
    
 BEGIN CATCH
  EXEC sp_OADestroy @Obj;
 END CATCH
 
   SET NOCOUNT OFF
END
GO


SELECT * FROM imagenes
GO

-- PROBANDO
-- CARPETA C:\IMAGENES\ENTRADA

exec dbo.usp_ImportImage 'Practica','C:\IMAGENES\ENTRADA','practica.jpg' 
GO

--Comprobamos---
SELECT * FROM imagenes
GO

-- EXPORTAR FICHERO USANDO LA EJECUCIÓN SIGUIENTE
exec dbo.usp_ExportarImagen  'Practica','C:\IMAGENES\SALIDA','practica.jpg' 
GO

EXEC sp_configure 'xp_cmdshell', 1; 
GO 
RECONFIGURE; 
GO

xp_cmdshell "dir C:\IMAGENES\SALIDA"
go