USE centrodedia3idade
GO
DROP PROCEDURE IF EXISTS BACKUP_ALL_DB_PARENTRADA
GO

CREATE OR ALTER PROC BACKUP_ALL_DB_PARENTRADA
	@path VARCHAR(256) -- PARAMETRO DE ENTRADA PARA DAR RUTA
AS
-- Declarando variables
DECLARE @name VARCHAR(50), -- database name
-- @path VARCHAR(256), -- path for backup files
@fileName VARCHAR(256), -- filename for backup
@fileDate VARCHAR(20), -- used for file name
@backupCount INT

-- Creamos tabla temporal --
CREATE TABLE tablatemporal
	(intID INT IDENTITY (1, 1), 
	name VARCHAR(200))
-- INCLUIR LA FECHA EN EL NOMBRE DE FICHERO RESULTANTE
SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112)

INSERT INTO tablatemporal(name)
	SELECT name
	FROM master.dbo.sysdatabases
	WHERE name in ('centrodedia3idade')

SELECT TOP 1 @backupCount = intID 
FROM tablatemporal
ORDER BY intID DESC
--Comprobamos número de backups--
print @backupCount
-- COMPROBAR QUE HAY ALGUNA BD A LA CUAL REALIZARLE EL BACKUP - -
IF ((@backupCount IS NOT NULL) AND (@backupCount > 0))
BEGIN
	DECLARE @currentBackup INT
	SET @currentBackup = 1 -- ASIGNACIÓN DEL VALOR INICIAL
	WHILE (@currentBackup <= @backupCount) -- MIENTRAS QUE SE CUMPLA LA CONDICIÓN SE EJECUTA EL BUCLE
		BEGIN
			SELECT
				@name = name,
				@fileName = @path + name + '_' + @fileDate + '.BAK' -- Unique FileName
				--@fileName = @path + @name + '.BAK' -- Non-Unique Filename
				FROM tablatemporal
				WHERE intID = @currentBackup

			-- Utilidad: Solo Comprobacion Nombre Backup
			print @fileName
			
			-- SIN INIT NO SOBREESCRIBE EL FICHERO. MEJOR USAR WITH INIT
			-- does not overwrite the existing file
				BACKUP DATABASE @name TO DISK = @fileName
			-- overwrites the existing file (Note: remove @fileDate from the fileName so they are no longer unique
			--BACKUP DATABASE @name TO DISK = @fileName WITH INIT

				SET @currentBackup = @currentBackup + 1 -- CONTADOR
		END
END
-- Utilidad: Solo ComprobaciÓn Mirar panel de Resultados Autonumerico y Nombre BD
SELECT * FROM tablatemporal
-- Eliminamos tabla -- 
DROP TABLE tablatemporal
GO

-- Ejecutar Procedimiento
-- Input Parameter 'C:\Backup\'
EXEC BACKUP_ALL_DB_PARENTRADA 'C:\Backups\'
GO


--RESULTADO

--(1 row affected)
--1
--C:\Backups\centrodedia3idade_20251025.BAK
--Processed 584 pages for database 'centrodedia3idade', file 'centrodedia3idade' on file 1.
--Processed 1 pages for database 'centrodedia3idade', file 'centrodedia3idade_log' on file 1.
--BACKUP DATABASE successfully processed 585 pages in 0.037 seconds (123.350 MB/sec).

--(1 row affected)

--Completion time: 2025-10-25T13:47:31.4398302+02:00
