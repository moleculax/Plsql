--www.moleculax.com.ve - www.emiliogomez.com.ve

CREATE OR REPLACE FUNCTION ViewTa() RETURNS TRIGGER AS
$vista$
BEGIN
	IF NEW.user_id IS NULL THEN
		RAISE EXCEPTION 'ERROR NULL';
		END IF;
	IF NEW.idpc IS NULL THEN
		RAISE EXCEPTION 'ERROR NULL';
		END IF;
	IF NEW.user_id IS NOT NULL THEN
		CREATE OR REPLACE VIEW vistaPC AS SELECT * FROM tbl_pc;
		END IF;
RETURN NEW;
END;
$vista$
LANGUAGE plpgsql;

CREATE TRIGGER ForVista BEFORE INSERT OR UPDATE  ON tbl_pc
	FOR EACH ROW EXECUTE PROCEDURE ViewTa();

-----

CREATE OR REPLACE FUNCTION DEL_tblPC(integer) RETURNS void AS
$$
DELETE FROM tbl_pc WHERE user_id=$1;
$$
LANGUAGE sql;

----

CREATE OR REPLACE FUNCTION searchpc(integer) RETURNS SETOF tbl_pc AS
$BODY$
DECLARE
r tbl_pc%rowtype;
BEGIN
FOR r IN SELECT user_id,idpc,scpu,stec,smo,scorn,sreg,ubicacion,observacion,fecha FROM tbl_pc
WHERE user_id=$1
LOOP
RETURN NEXT r; -- Retorna los valores row del SELECT
END LOOP;
RETURN;
END
$BODY$
LANGUAGE plpgsql;
---
SELECT * FROM searchpc(valor entero);
---

CREATE FUNCTION listarPC(integer) RETURNS SETOF tbl_pc AS
$$
SELECT * FROM tbl_pc WHERE user_id=$1;
$$ LANGUAGE sql;

---
SELECT * FROM listaPC(valor entero);
---


