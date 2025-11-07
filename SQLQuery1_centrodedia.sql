DROP DATABASE IF EXISTS centrodedia3idade;
GO
CREATE DATABASE centrodedia3idade;
GO
USE centrodedia3idade;
GO
-------------------------
-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2025-10-19 15:13:43 CEST
--   sitio:      SQL Server 2012
--   tipo:      SQL Server 2012

CREATE TABLE ACTIVIDADES 
    (
     id_actividad NUMERIC (28) NOT NULL , 
     nombre VARCHAR (50) , 
     descripcion TEXT , 
     horario TIME , 
     SERVICIOS_id_servicio NUMERIC (28) NOT NULL 
    )
GO

ALTER TABLE ACTIVIDADES ADD CONSTRAINT ACTIVIDADES_PK PRIMARY KEY CLUSTERED (id_actividad)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE ASISTENCIA 
    (
     id_asistencia NUMERIC (28) NOT NULL , 
     fecha DATE , 
     USUARIOS_id_usuario NUMERIC (28) NOT NULL , 
     ACTIVIDADES_id_actividad NUMERIC (28) NOT NULL 
    )
GO

ALTER TABLE ASISTENCIA ADD CONSTRAINT ASISTENCIA_PK PRIMARY KEY CLUSTERED (id_asistencia)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE EMPLEADOS 
    (
     id_empleado NUMERIC (28) NOT NULL , 
     nombre VARCHAR (50) , 
     apellido VARCHAR (50) , 
     cargo VARCHAR (50) , 
     especialidad VARCHAR (50) , 
     telefono VARCHAR (15) , 
     SERVICIOS_id_servicio NUMERIC (28) NOT NULL 
    )
GO

ALTER TABLE EMPLEADOS ADD CONSTRAINT EMPLEADOS_PK PRIMARY KEY CLUSTERED (id_empleado)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE FAMILIAR 
    (
     id_familiar NUMERIC (28) NOT NULL , 
     nombre VARCHAR (50) , 
     apellido VARCHAR (50) , 
     parentesco VARCHAR (20) , 
     telefono VARCHAR (15) , 
     USUARIOS_id_usuario NUMERIC (28) NOT NULL 
    )
GO

ALTER TABLE FAMILIAR ADD CONSTRAINT FAMILIAR_PK PRIMARY KEY CLUSTERED (id_familiar)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE PAGO 
    (
     id_pago NUMERIC (28) NOT NULL , 
     fecha DATE , 
     cantidad DECIMAL (10,2) , 
     mediopago VARCHAR (20) , 
     USUARIOS_id_usuario NUMERIC (28) NOT NULL 
    )
GO

ALTER TABLE PAGO ADD CONSTRAINT PAGO_PK PRIMARY KEY CLUSTERED (id_pago)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE RESERVA_SERVICIO 
    (
     id_reserva NUMERIC (28) NOT NULL , 
     fechareserva DATE , 
     estado VARCHAR (20) , 
     USUARIOS_id_usuario NUMERIC (28) NOT NULL , 
     SERVICIOS_id_servicio NUMERIC (28) NOT NULL 
    )
GO

ALTER TABLE RESERVA_SERVICIO ADD CONSTRAINT RESERVA_SERVICIO_PK PRIMARY KEY CLUSTERED (id_reserva)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE SERVICIOS 
    (
     id_servicio NUMERIC (28) NOT NULL , 
     nombre VARCHAR (50) , 
     descripcion TEXT , 
     precio DECIMAL (10,2) , 
     tipo VARCHAR (30) 
    )
GO

ALTER TABLE SERVICIOS ADD CONSTRAINT SERVICIOS_PK PRIMARY KEY CLUSTERED (id_servicio)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE TRANSPORTE 
    (
     id_transporte NUMERIC (28) NOT NULL , 
     chofer VARCHAR (50) , 
     ruta VARCHAR (100) , 
     capacidad NUMERIC (28) 
    )
GO

ALTER TABLE TRANSPORTE ADD CONSTRAINT TRANSPORTE_PK PRIMARY KEY CLUSTERED (id_transporte)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE USUARIO_TRANSPORTE 
    (
     USUARIOS_id_usuario NUMERIC (28) NOT NULL , 
     TRANSPORTE_id_transporte NUMERIC (28) NOT NULL , 
     dia DATE , 
     hora DATETIME 
    )
GO

ALTER TABLE USUARIO_TRANSPORTE ADD CONSTRAINT Relation_12_PK PRIMARY KEY CLUSTERED (USUARIOS_id_usuario, TRANSPORTE_id_transporte)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE USUARIOS 
    (
     id_usuario NUMERIC (28) NOT NULL , 
     nombre VARCHAR (50) , 
     apellido VARCHAR (50) , 
     fechanacimiento DATE , 
     direccion VARCHAR (100) , 
     telefono VARCHAR (15) , 
     genero VARCHAR (10) , 
     contactoemergencia VARCHAR (50) 
    )
GO

ALTER TABLE USUARIOS ADD CONSTRAINT USUARIOS_PK PRIMARY KEY CLUSTERED (id_usuario)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

ALTER TABLE ACTIVIDADES 
    ADD CONSTRAINT ACTIVIDADES_SERVICIOS_FK FOREIGN KEY 
    ( 
     SERVICIOS_id_servicio
    ) 
    REFERENCES SERVICIOS 
    ( 
     id_servicio 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE ASISTENCIA 
    ADD CONSTRAINT ASISTENCIA_ACTIVIDADES_FK FOREIGN KEY 
    ( 
     ACTIVIDADES_id_actividad
    ) 
    REFERENCES ACTIVIDADES 
    ( 
     id_actividad 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE ASISTENCIA 
    ADD CONSTRAINT ASISTENCIA_USUARIOS_FK FOREIGN KEY 
    ( 
     USUARIOS_id_usuario
    ) 
    REFERENCES USUARIOS 
    ( 
     id_usuario 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE EMPLEADOS 
    ADD CONSTRAINT EMPLEADOS_SERVICIOS_FK FOREIGN KEY 
    ( 
     SERVICIOS_id_servicio
    ) 
    REFERENCES SERVICIOS 
    ( 
     id_servicio 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE FAMILIAR 
    ADD CONSTRAINT FAMILIAR_USUARIOS_FK FOREIGN KEY 
    ( 
     USUARIOS_id_usuario
    ) 
    REFERENCES USUARIOS 
    ( 
     id_usuario 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_USUARIOS_FK FOREIGN KEY 
    ( 
     USUARIOS_id_usuario
    ) 
    REFERENCES USUARIOS 
    ( 
     id_usuario 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE RESERVA_SERVICIO 
    ADD CONSTRAINT RESERVA_SERVICIO_SERVICIOS_FK FOREIGN KEY 
    ( 
     SERVICIOS_id_servicio
    ) 
    REFERENCES SERVICIOS 
    ( 
     id_servicio 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE RESERVA_SERVICIO 
    ADD CONSTRAINT RESERVA_SERVICIO_USUARIOS_FK FOREIGN KEY 
    ( 
     USUARIOS_id_usuario
    ) 
    REFERENCES USUARIOS 
    ( 
     id_usuario 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE USUARIO_TRANSPORTE 
    ADD CONSTRAINT USUARIO_TRANSPORTE_TRANSPORTE_FK FOREIGN KEY 
    ( 
     TRANSPORTE_id_transporte
    ) 
    REFERENCES TRANSPORTE 
    ( 
     id_transporte 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE USUARIO_TRANSPORTE 
    ADD CONSTRAINT USUARIO_TRANSPORTE_USUARIOS_FK FOREIGN KEY 
    ( 
     USUARIOS_id_usuario
    ) 
    REFERENCES USUARIOS 
    ( 
     id_usuario 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            10
-- CREATE INDEX                             0
-- ALTER TABLE                             20
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE DATABASE                          0
-- CREATE DEFAULT                           0
-- CREATE INDEX ON VIEW                     0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE ROLE                              0
-- CREATE RULE                              0
-- CREATE SCHEMA                            0
-- CREATE SEQUENCE                          0
-- CREATE PARTITION FUNCTION                0
-- CREATE PARTITION SCHEME                  0
-- 
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
