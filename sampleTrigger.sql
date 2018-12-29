---crea respaldo DB csv

CREATE OR REPLACE FUNCTION salvar()
RETURNS boolean AS
$BODY$
BEGIN
COPY (SELECT * FROM tbl_ ) TO '/ruta/fileTable.csv' WITH CSV;
--Por cada tabla se tiene que crear un COPY.
RETURN true;
END;
$BODY$
  LANGUAGE plpgsql;
 
------------------------------

CREATE OR REPLACE FUNCTION TG_creaView()
RETURNS TRIGGER AS
$$
DECLARE
BEGIN
-- Borra la  vista si existe.
DROP VIEW IF EXISTS view_; 
--Crea una vista con los valores de la tabla seleccionada.
CREATE VIEW view_ AS SELECT * FROM tbl_;
RETURN NULL;
END;
$$
LANGUAGE plpgsql;

--Trigger que se ejecuta luego de insertar valores en la
--tabla indicada en la función
CREATE TRIGGER INSERT_View AFTER INSERT ON tbl_ FOR EACH ROW
EXECUTE PROCEDURE TG_createView();





--Trigger que se ejecuta cuando se elimina un dato de  tabla.
CREATE OR REPLACE FUCTION TG_DELETEView()
RETURNS TRIGGER AS
$$
BEGIN
INSERT INTO view_  VALUES(OLD.campo1,OLD.campo2,...);
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER DELETE_View AFTER DELETE tbl_  FOR EACH ROW
EXECUTE PROCEDURE TG_DELETEView();


--Trigger que se ejecuta cuando se cuando inserta new data
CREATE OR REPLACE FUNCTION TG_insert() RETURNS TRIGGER AS $$
BEGIN
INSERT INTO tabla_ VALUES(NEW.valor1,NEW.valir2,...);
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER INSERT_newdata AFTER INSERT ON tbl_tabla FOR EACH ROW
EXECUTE PROCEDURE TG_insert();



CREATE OR REPLACE FUNCTION show() RETURNS tbl_alumnos AS $$
BEGIN
SELECT cedula FROM tbl_alumnos;
END;
$$LANGUAGE plpgsql;

------
-- Ejercicio basico para eliminar datos de tabla.
CREATE OR REPLACE FUNCTION DEL_v(valor integer) RETURNS void AS
$$
DELETE FROM TBL_ WHERE valor=$1;
$$
LANGUAGE sql;
----

-- Ejercicio basico para insertar valor
CREATE OR REPLACE FUCTION INS_v(VALOR1 integer,VALOR2 varchar) RETURNS void AS
$$
INSERT INTO TBL_ VALUES($1,$2);
$$
LANGUAGE sql;

-----


CREATE OR REPLACE FUNCTION VAR_p(v1 integer, v2 varchar) RETURNS varchar AS
$$
DECLARE 
id integer;
valor varchar;
BEGIN
UPDATE personal SET nombre=$2 WHERE codigo=$1; 
SELECT nombre FROM personal  INTO valor  WHERE codigo=$1; 
RETURN valor;
END;
$$LANGUAGE plpgsql;


-----
CREATE OR REPLACE FUNCTION gettbl() RETURNS SETOF nombreTabla AS
$BODY$
DECLARE
r nombreTabla%rowtype;
BEGIN
FOR r IN SELECT * FROM tbl_
WHERE nombreCampo1 > 0
LOOP
RETURN NEXT r; -- Retorna los valores row del SELECT
END LOOP;
RETURN;
END
$BODY$
LANGUAGE plpgsql;

SELECT * FROM gettbl();
----------------

CREATE FUNCTION listarTBL() RETURNS SETOF tbl_ AS
$$
SELECT * FROM tbl_;
$$ LANGUAGE sql;

-----------------

CREATE OR REPLACE FUNCTION FUN_nom() RETURNS TRIGGER AS 
$$
BEGIN

IF (...) THEN
ELSIF (...) THEN
ELSE (...) THEN
END IF;
RETURN NULL;
END;
$$LANGUAGE plpgsql;

----
CREATE TRIGGER EJEC_nom BEFORE INSERT ON nom_tabla FOR EACH ROW 
EXECUTE PROCEDURE FUN_nom();


------------

CREATE OR REPLACE FUNCTION NOM_fun() RETURNS TRIGGER AS 
$$
BEGIN
	DELETE FROM tbl_ WHERE OLD.camp=camp;
	INSERT INTO tbl_2 VALUES(NEW.*);
	RETURN NULL;
END;
$$LANGUAGE plpgsql;
----
CREATE TRIGGER EJEC_NOM_fun BEFORE UPDATE ON tbl_  FOR EACH ROW
EXECUTE PROCEDURE NOM_fun();

-----

--En lineas generales para TRIGGER

CREATE OR REPLACE FUNCTION trigger_function_name()
RETURNS trigger AS $SAMPLE_CODE$
BEGIN
/* your code goes here*/
RETURN NEW;
END;
$SAMPLE_CODE$ LANGUAGE plpgsql;

---
CREATE TRIGGER trigger_name {BEFORE | AFTER | INSTEAD OF} {event
[OR ...]}
ON table_name
[FOR [EACH] {ROW | STATEMENT}]
EXECUTE PROCEDURE trigger_function_name();

-----
--TRIGGER para crear respaldo csv de tabla en ruta determinada
---despues de insertar datos.
CREATE OR REPLACE FUNCTION RES_pers() RETURNS TRIGGER AS 
$$
BEGIN
COPY (SELECT * FROM personal ) TO '/ruta/fileTabla.csv' WITH CSV;
END;
$$LANGUAGE plpgsql;
CREATE TRIGGER RESP_pers AFTER INSERT OR UPDATE ON nomtablaFOR FOR EACH ROW
EXECUTE PROCEDURE RES_pers();

--------

CREATE OR REPLACE FUNCTION audit_func_all() RETURNS trigger AS 
$BODY$
BEGIN
--this IF block confirms the operation type to be INSERT.
IF (TG_OP = 'INSERT') THEN
INSERT INTO warehouse_audit
(wlog_id, insertion_time, operation_detail)
VALUES
(new.warehouse_id, current_timestamp,'INSERT
operation performed. Row with id '||NEW.warehouse_id||
'inserted');
RETURN NEW;
--this IF block confirms the operation type to be UPDATE.
ELSIF (TG_OP = 'UPDATE') THEN
INSERT INTO warehouse_audit
(wlog_id, insertion_time, operation_detail)
VALUES
(NEW.warehouse_id, current_timestamp,'UPDATE operation
performed. Row with id '||NEW.warehouse_id||' updates
values '||OLD||' with '|| NEW.* ||'.');
RETURN NEW;
--this IF block confirms the operation type to be DELETE
ELSIF (TG_OP = 'DELETE') THEN
INSERT INTO warehouse_audit
(wlog_id, insertion_time, operation_detail)
VALUES (OLD.warehouse_id, current_timestamp,'DELETE
operation performed. Row with id '||OLD.warehouse_id||
'deleted ');
RETURN OLD;
END IF;
RETURN NULL;
END;
$BODY$ 
LANGUAGE plpgsql;

CREATE TRIGGER audit_all_ops_trigger
AFTER INSERT OR UPDATE OR DELETE ON warehouse_tbl
FOR EACH ROW
EXECUTE PROCEDURE audit_func_all();

----
 ---FUNCION QUE REALIZA EL SELECT.
CREATE OR REPLACE FUNCTION searchpc(integer) RETURNS SETOF tbl_pc AS
$BODY$
DECLARE
r tbl_pc%rowtype;
BEGIN
FOR r IN SELECT user_id,idpc,scpu,stec,smo,scorn,sreg,ubicacion,observacion,fecha FROM tbl_pc
WHERE user_id=$1
LOOP
RETURN NEXT r; -- Retorna los valores row del SELECT CUANDO SE HACE LLAMADO DESDE PHP.
END LOOP;
RETURN;
END
$BODY$
LANGUAGE plpgsql;