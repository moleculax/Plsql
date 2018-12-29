--www.moleculax.com.ve - www.emiliogomez.com.ve

CREATE OR REPLACE FUNCTION OP_trig() RETURNS TRIGGER AS
$$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		---
		RETURN NEW;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO view_per VALUES(OLD.codigo,OLD.nombre);
		RETURN NEW;
	ELSIF (TG_OP = 'DELETE') THEN
		CREATE VIEW vista_personal AS SELECT * FROM personal
		RETURN OLD;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER OPERA_tr AFTER INSERT OR UPDATE OR DELETE ON personal  FOR EACH ROW
EXECUTE PROCEDURE OP_trig();
------

--Inicio
CREATE OR REPLACE FUNCTION excluData() RETURNS TRIGGER AS
$$
BEGIN
COPY (SELECT * FROM prac.data) TO '/home/moleculax/Escritorio/plsql/data.csv' WITH csv;
RETURN TRUE;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER respData BEFORE INSERT OR UPDATE ON prac.data FOR EACH ROW EXECUTE PROCEDURE excludata();

--Fin


