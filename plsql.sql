--www.moleculax.com.ve - www.emiliogomez.com.ve

CREATE OR REPLACE FUNCTION getLibros() RETURNS SETOF libros AS
$BODY$
DECLARE
r libros%rowtype;
BEGIN
FOR r IN
SELECT * FROM libros
LOOP

RETURN NEXT r; -- Retorna los valores del SELECT
END LOOP;
RETURN;
END
$BODY$
LANGUAGE plpgsql;


--Creamos una funcion que retorne un trigger 
--Este trigger inserta en la tabla auditoria los valores que se 
--eliminen en la tabla personal
CREATE OR REPLACE  FUNCTION insertar_trigger()
RETURNS TRIGGER AS $insertar$
DECLARE BEGIN
INSERT INTO auditoria VALUES(OLD.codigo,OLD.nombre);
RETURN NULL;
END;
$insertar$
LANGUAGE plpgsql;
--se puede combinar AFTER DELETE OR UPDATE ON 
CREATE TRIGGER insertar_auditoria  AFTER DELETE 
ON personal FOR EACH ROW
EXECUTE PROCEDURE insertar_trigger();

--Fin trigger

---------------
CREATE OR REPLACE FUNCTION simple_loop(n integer)
RETURNS integer AS $$
DECLARE
g integer := 10;
BEGIN
LOOP
g := g * n;
IF (g >= 100) THEN
EXIT;
END IF;
END LOOP;
RETURN g;
END;
$$ LANGUAGE plpgsql;

----------------

