USE centrodedia3idade
go
DECLARE usuarios_Cursor CURSOR FOR  
	SELECT id_usuario, direccion  
	FROM centrodedia3idade.HR.USUARIOS
OPEN usuarios_Cursor;  
FETCH NEXT FROM usuarios_Cursor;  
WHILE @@FETCH_STATUS = 0  
   BEGIN  
	   FETCH NEXT FROM usuarios_Cursor  
   END;  
CLOSE usuarios_Cursor;  
DEALLOCATE usuarios_Cursor;
GO