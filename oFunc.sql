CREATE FUNCTION show() RETURNS SETOF tbl_ AS
$$
SELECT * FROM tbl_;
$$ LANGUAGE sql;


---
CREATE TABLE datos(
	nom_emp text,
	sal_emp integer,
	las_dat timestamp,
	las_use text
	);
	
CREATE OR REPLACE FUNCTION  emp() TRIGGER AS 
$emp$
		BEGIN
				IF NEW.nom_emp IS NULL THEN
						RAISE EXCEPTION 'No se inserto nombre';
				END IF;
				IF NEW.sal_emp IS NULL THEN
						RAISE EXCEPTION '% Debe tener sal', NEW.nom_emp;
				END IF; 
				RETURN NEW;
		END;
$emp$
LANGUAGE plpgsql;

CREATE TRIGGER emp BEFORE INSERT OR UPDATE ON datos
		FOR EACH ROW EXECUTE PROCEDURE emp();
------------

--Falta editar
