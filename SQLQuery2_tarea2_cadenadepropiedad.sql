------ 1 CADENA DE PROPIEDAD -----
USE centrodedia3idade;
GO
--Creación de SCHEMA---
DROP SCHEMA IF EXISTS HR
GO
CREATE SCHEMA HR;
GO 
--Creación de tabla---
DROP TABLE IF EXISTS HR.USUARIOS
GO
CREATE TABLE HR.USUARIOS
(
     id_usuario CHAR(2) NOT NULL , 
     nombre VARCHAR (50) , 
     apellido VARCHAR (50) , 
     fechanacimiento DATE , 
     direccion VARCHAR (100) , 
     telefono VARCHAR (15) , 
     genero VARCHAR (10) , 
     contactoemergencia VARCHAR (50)
);
GO 
---Creamos fichero usuarios.txt----
--Comprobamos----
SELECT * FROM HR.USUARIOS;
GO
--Creamos vista---
DROP VIEW IF EXISTS HR.VistaUsuarios
GO
CREATE VIEW HR.VistaUsuarios
AS
SELECT 
   id_usuario, nombre, apellido, fechanacimiento
FROM HR.USUARIOS;
GO
---Creamos rol---
DROP ROLE IF EXISTS Rolusuariocentro;
GO
CREATE ROLE Rolusuariocentro;
GO 
--Asignamos permisos---
GRANT SELECT ON HR.VistaUsuarios TO Rolusuariocentro;
GO 
---Creamos usuario y lo asignamos al rol---
DROP USER IF EXISTS ManoloLamas
GO
CREATE USER ManoloLamas WITHOUT LOGIN;
GO 

ALTER ROLE Rolusuariocentro
ADD MEMBER ManoloLamas;
GO 

--Usamos la vista---
-- Impersonamos--
EXECUTE AS USER = 'ManoloLamas';
GO 

SELECT * FROM HR.VistaUsuarios;
GO

PRINT USER;
GO
 
REVERT;
GO

---Con usuario ManoloLamas demostrando que NO tiene permisos sobre la tabla---
EXECUTE AS USER = 'ManoloLamas';
GO

SELECT * FROM HR.USUARIOS;
GO

REVERT;
GO

-- Creamos procedimiento almacenado---

CREATE OR ALTER PROC HR.InsertarUsuario
    -- Parámetros de entrada
    @id_usuario CHAR(2),
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @fechanacimiento DATE,
    @direccion VARCHAR(100),
    @telefono VARCHAR(15),
    @genero VARCHAR(10),
    @contactoemergencia VARCHAR(50)
AS
BEGIN
    -- Insertar en la tabla Usuario
    INSERT INTO HR.USUARIOS(
        id_usuario,
        nombre,
        apellido,
        fechanacimiento,
        direccion,
        telefono,
        genero,
        contactoemergencia
    )
    VALUES (
        @id_usuario,
        @nombre,
        @apellido,
        @fechanacimiento,
        @direccion,
        @telefono,
        @genero,
        @contactoemergencia
    );
END;
GO
--Creamos un nuevo ROL --- 
DROP ROLE IF EXISTS  Rolusuariocentro2
GO
CREATE ROLE Rolusuariocentro2;
GO 
-- asignamos permisos
GRANT EXECUTE ON SCHEMA::[HR] TO Rolusuariocentro2;
GO 
-- Creamos otro usuario para demostración---
DROP USER IF EXISTS PepeGarcia;
GO
CREATE USER PepeGarcia WITHOUT LOGIN;
GO
-- Añadiomos el usuario al rol--
ALTER ROLE Rolusuariocentro2
ADD MEMBER PepeGarcia;
GO

---Probamos la ejecucción demostrando que NO tenemos permisos"
EXECUTE AS USER = 'PepeGarcia';
GO 
PRINT USER;
GO

INSERT INTO HR.USUARIOS(
    id_usuario,
    nombre,
    apellido,
    fechanacimiento,
    direccion,
    telefono,
    genero,
    contactoemergencia
)
VALUES (
    'A99',                             
    'Lucia',
    'Fernandez',  
    '1995-07-23',
    'Av. Siempre Viva 123, Lima',
    '987654321',   
    'Femenino',  
    'Carlos Fernandez' 
);
GO
---Demostramos como si podremos insertar usando el SP---
EXECUTE AS USER = 'PepeGarcia';
GO 

EXEC HR.InsertarUsuario
    @id_usuario = 'A99',
    @nombre = 'Lucia',
    @apellido = 'Fernandez',
    @fechanacimiento = '1995-07-23',
    @direccion = 'Av. Siempre Viva 123, Lima',
    @telefono = '987654321',
    @genero = 'Femenino',
    @contactoemergencia = 'Carlos Fernandez';
GO

PRINT user
GO

--Demostramos que el objeto usuarios es diferente a HR.usuarios
SELECT * FROM USUARIOS
GO

--Tampoco tiene permisos directanmente sobre la tabla
SELECT * FROM HR.USUARIOS;
GO 

--Demostramos la insercción anterior
REVERT;
GO

SELECT * FROM HR.USUARIOS;
GO 
