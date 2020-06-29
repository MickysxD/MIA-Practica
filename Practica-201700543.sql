/*************************************************************************
							PRACTICA MIA
					MIGUEL ANGEL SOLIS YANTUCHE
							 201700543
*************************************************************************/

/*************************************************************************
						DESCRIPCION DEL PROBLEMA
El Comité Olímpico Internacional se prepara para los juegos olímpicos
de Tokio, debido a esto han decidido utilizar una base de datos que les
permita llevar el control total de su organización, desde miembros,
televisoras, atletas, etc.

El Comité Olímpico propuso un diseño para dicha base de datos, y pide que 
resuelva a través de las instrucciones DDL y DML los planteamientos
descritos.
*************************************************************************/


CREATE DATABASE COI;



/*************************************************************************
1. Generar el script que crea cada una de las tablas que conforman la 
base de datos propuesta por el Comité Olímpico.
*************************************************************************/

CREATE TABLE PROFESION(
    cod_prof INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);
SELECT * FROM PROFESION;

CREATE TABLE PAIS(
    cod_pais INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);
SELECT * FROM PAIS;

CREATE TABLE PUESTO(
    cod_puesto INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);
SELECT * FROM PUESTO;

CREATE TABLE DEPARTAMENTO(
    cod_depto INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);
SELECT * FROM DEPARTAMENTO;

CREATE TABLE MIEMBRO(
    cod_miembro INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    edad INTEGER NOT NULL,
    telefono INTEGER NULL,
    residencia VARCHAR(100) NULL,
    PAIS_cod_pais INTEGER NOT NULL REFERENCES PAIS(cod_pais) ON DELETE CASCADE,
    PROFESION_cod_prof INTEGER NOT NULL REFERENCES PROFESION(cod_prof) ON DELETE CASCADE
);
SELECT * FROM MIEMBRO;

CREATE TABLE PUESTO_MIEMBRO(
    MIEMBRO_cod_miembro INTEGER NOT NULL REFERENCES MIEMBRO(cod_miembro) ON DELETE CASCADE,
    PUESTO_cod_puesto INTEGER NOT NULL REFERENCES PUESTO(cod_puesto) ON DELETE CASCADE,
    DEPARTAMENTO_cod_depto INTEGER NOT NULL REFERENCES DEPARTAMENTO(cod_depto) ON DELETE CASCADE,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
	PRIMARY KEY (MIEMBRO_cod_miembro, PUESTO_cod_puesto, DEPARTAMENTO_cod_depto)
);
SELECT * FROM PUESTO_MIEMBRO;

CREATE TABLE TIPO_MEDALLA(
    cod_tipo INTEGER NOT NULL PRIMARY KEY,
    medalla VARCHAR(20) NOT NULL UNIQUE
);
SELECT * FROM TIPO_MEDALLA;

CREATE TABLE MEDALLERO(
    PAIS_cod_pais INTEGER NOT NULL REFERENCES PAIS(cod_pais) ON DELETE CASCADE,
    TIPO_MEDALLA_cod_tipo INTEGER NOT NULL REFERENCES TIPO_MEDALLA(cod_tipo) ON DELETE CASCADE,
    cantidad_medallas INTEGER NOT NULL,
	PRIMARY KEY (PAIS_cod_pais, TIPO_MEDALLA_cod_tipo)
);
SELECT * FROM MEDALLERO;

CREATE TABLE DISCIPLINA(
    cod_disciplina INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150) NULL
);
SELECT * FROM DISCIPLINA;

CREATE TABLE ATLETA(
    cod_atleta INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INTEGER NOT NULL,
    Participaciones VARCHAR(100),
    DISCIPLINA_cod_disciplina INTEGER NOT NULL REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE,
    PAIS_cod_pais INTEGER NOT NULL REFERENCES PAIS(cod_pais) ON DELETE CASCADE
);
SELECT * FROM PROFESION;

CREATE TABLE CATEGORIA(
    cod_categoria INTEGER NOT NULL PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL
);
SELECT * FROM CATEGORIA;

CREATE TABLE TIPO_PARTICIPACION(
    cod_participacion INTEGER NOT NULL PRIMARY KEY,
    tipo_participacion VARCHAR(100) NOT NULL
);
SELECT * FROM TIPO_PARTICIPACION;

CREATE TABLE EVENTO(
    cod_evento INTEGER NOT NULL PRIMARY KEY,
    fecha DATE NOT NULL,
    ubicacion VARCHAR(50) NOT NULL,
    hora DATE NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE,
    TIPO_PARTICIPACION_cod_participacion INTEGER NOT NULL REFERENCES TIPO_PARTICIPACION(cod_participacion) ON DELETE CASCADE,
    CATEGORIA_cod_categoria INTEGER NOT NULL REFERENCES CATEGORIA(cod_categoria) ON DELETE CASCADE
);
SELECT * FROM EVENTO;

CREATE TABLE EVENTO_ATLETA(
    ATLETA_cod_atleta INTEGER NOT NULL REFERENCES ATLETA(cod_atleta) ON DELETE CASCADE,
    EVENTO_cod_evento INTEGER NOT NULL REFERENCES EVENTO(cod_evento) ON DELETE CASCADE,
	PRIMARY KEY (ATLETA_cod_atleta, EVENTO_cod_evento)
);
SELECT * FROM EVENTO_ATLETA;

CREATE TABLE TELEVISORA(
    cod_televisora INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);
SELECT * FROM TELEVISORA;

CREATE TABLE COSTO_EVENTO(
    EVENTO_cod_evento INTEGER NOT NULL REFERENCES EVENTO(cod_evento) ON DELETE CASCADE,
    TELEVISORA_cod_televisora INTEGER NOT NULL REFERENCES TELEVISORA(cod_televisora) ON DELETE CASCADE,
    tarifa INTEGER NOT NULL,
	PRIMARY KEY (EVENTO_cod_evento, TELEVISORA_cod_televisora)
);
SELECT * FROM COSTO_EVENTO;



/*************************************************************************
2. En la tabla “Evento” se decidió que la fecha y hora se trabajaría en 
una sola columna.
	-Eliminar las columnas fecha y hora.
	-Crear una columna llamada “fecha_hora” con el tipo de dato que
	 corresponda según el DBMS.
*************************************************************************/
SELECT * FROM EVENTO;

ALTER TABLE EVENTO DROP fecha;
ALTER TABLE EVENTO DROP hora;

ALTER TABLE EVENTO ADD fecha_hora TIMESTAMP NOT NULL;



/*************************************************************************
3. Todos los eventos de las olimpiadas deben ser programados del 24 de 
julio de 2020 a partir de las 9:00:00 hasta el 09 de agosto de 2020 hasta
las 20:00:00.
*************************************************************************/
ALTER TABLE EVENTO ADD CHECK(fecha_hora BETWEEN '2020-07-24 09:00:00' AND '2020-08-09 20:00:00')



/*************************************************************************
4. Se decidió que las ubicación de los eventos se registrarán previamente
en una tabla y que en la tabla “Evento” sólo se almacenara la llave
foránea según el código del registro de la ubicación, para esto debe 
realizar lo siguiente:
	a. Crear la tabla llamada “Sede” que tendrá los campos:
		i. Código: será tipo entero y será la llave primaria.
		ii. Sede: será tipo varchar(50) y será obligatoria.
	b. Cambiar el tipo de dato de la columna Ubicación de la tabla Evento
	   por un tipo entero.
	c. Crear una llave foránea en la columna Ubicación de la tabla Evento
	   y referenciarla a la columna código de la tabla Sede, la que fue
	   creada en el paso anterior.
*************************************************************************/
SELECT * FROM SEDE;

CREATE TABLE SEDE(
codigo INTEGER NOT NULL PRIMARY KEY,
sede VARCHAR(50) NOT NULL
);

SELECT * FROM EVENTO;
ALTER TABLE EVENTO ALTER COLUMN ubicacion TYPE INTEGER USING ubicacion::INTEGER;
ALTER TABLE EVENTO ALTER COLUMN ubicacion SET NOT NULL;

ALTER TABLE EVENTO ADD FOREIGN KEY (ubicacion) REFERENCES SEDE(codigo);


/*************************************************************************
5. Se revisó la información de los miembros que se tienen actualmente y 
antes de que se ingresen a la base de datos el Comité desea que a los
miembros que no tengan número telefónico se le ingrese el número por
Default 0 al momento de ser cargados a la base de datos.
*************************************************************************/
/*ALTER TABLE MIEMBRO ALTER COLUMN telefono TYPE INTEGER;*/
ALTER TABLE MIEMBRO ALTER COLUMN telefono SET DEFAULT 0;


/*************************************************************************
6. Generar el script necesario para hacer la inserción de datos a las
tablas requeridas.
*************************************************************************/
SELECT * FROM PAIS;
INSERT INTO PAIS
VALUES (1, 'Guatemala');
INSERT INTO PAIS
VALUES (2, 'Francia');
INSERT INTO PAIS
VALUES (3, 'Argentina');
INSERT INTO PAIS
VALUES (4, 'Alemania');
INSERT INTO PAIS
VALUES (5, 'Italia');
INSERT INTO PAIS
VALUES (6, 'Brasil');
INSERT INTO PAIS
VALUES (7, 'Estados Unidos');
SELECT * FROM PAIS;


SELECT * FROM PROFESION;
INSERT INTO PROFESION
VALUES (1, 'Medico');
INSERT INTO PROFESION
VALUES (2, 'Arquitecto');
INSERT INTO PROFESION
VALUES (3, 'Ingeniero');
INSERT INTO PROFESION
VALUES (4, 'Secretaria');
INSERT INTO PROFESION
VALUES (5, 'Auditor');
SELECT * FROM PROFESION;


SELECT * FROM MIEMBRO;
INSERT INTO MIEMBRO (cod_miembro, nombre, apellido, edad, residencia, PAIS_cod_pais, PROFESION_cod_prof)
VALUES (1, 'Scott', 'Mitchell', 32, '1092 Highland Drive Manitowoc, Wl 54220', 7, 3);
INSERT INTO MIEMBRO
VALUES (2, 'Fanette', 'Poulin', 25, 25075853, '49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY', 2, 4);
INSERT INTO MIEMBRO (cod_miembro, nombre, apellido, edad, residencia, PAIS_cod_pais, PROFESION_cod_prof)
VALUES (3, 'Laura', 'Cunha Silva', 55, 'Rua Onze, 86 Uberaba-MG', 6, 5);
INSERT INTO MIEMBRO
VALUES (4, 'Juan José', 'López', 38, 36985247, '26 calle 4-10 zona 11', 1, 2);
INSERT INTO MIEMBRO
VALUES (5, 'Arcangela', 'Panicucci', 39, 391664921, 'Via Santa Teresa, 114 90010-Geraci Siculo PA', 5, 1);
INSERT INTO MIEMBRO (cod_miembro, nombre, apellido, edad, residencia, PAIS_cod_pais, PROFESION_cod_prof)
VALUES (6, 'Jeuel', 'Villalpando', 31, 'Acuña de Figeroa 6106 80101 Playa Pascual', 3, 5);
SELECT * FROM MIEMBRO;


SELECT * FROM DISCIPLINA;
INSERT INTO DISCIPLINA
VALUES (1, 'Atletismo', 'Saltos de longitud y triples, de altura y con pErtiga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco');
INSERT INTO DISCIPLINA (cod_disciplina, nombre)
VALUES (2, 'Bádminton');
INSERT INTO DISCIPLINA (cod_disciplina, nombre)
VALUES (3, 'Ciclismo');
INSERT INTO DISCIPLINA
VALUES (4, 'Judo', 'Es un arte marcial que se origino en Japon alrededor de 1880');
INSERT INTO DISCIPLINA (cod_disciplina, nombre)
VALUES (5, 'Lucha');
INSERT INTO DISCIPLINA (cod_disciplina, nombre)
VALUES (6, 'Tenis de Mesa');
INSERT INTO DISCIPLINA (cod_disciplina, nombre)
VALUES (7, 'Boxeo');
INSERT INTO DISCIPLINA
VALUES (8, 'Natación', 'Esta presente como deporte en los Juegos desde la primera edicion de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas');
INSERT INTO DISCIPLINA (cod_disciplina, nombre)
VALUES (9, 'Esgrima');
INSERT INTO DISCIPLINA (cod_disciplina, nombre)
VALUES (10, 'Vela');
SELECT * FROM DISCIPLINA;


SELECT * FROM TIPO_MEDALLA;
INSERT INTO TIPO_MEDALLA
VALUES (1, 'Oro');
INSERT INTO TIPO_MEDALLA
VALUES (2, 'Plata');
INSERT INTO TIPO_MEDALLA
VALUES (3, 'Bronce');
INSERT INTO TIPO_MEDALLA
VALUES (4, 'Platino');
SELECT * FROM TIPO_MEDALLA;


SELECT * FROM CATEGORIA;
INSERT INTO CATEGORIA
VALUES (1, 'Clasificatorio');
INSERT INTO CATEGORIA
VALUES (2, 'Eliminatorio');
INSERT INTO CATEGORIA
VALUES (3, 'Final');
SELECT * FROM CATEGORIA;


SELECT * FROM TIPO_PARTICIPACION;
INSERT INTO TIPO_PARTICIPACION
VALUES (1, 'Individual');
INSERT INTO TIPO_PARTICIPACION
VALUES (2, 'Parejas');
INSERT INTO TIPO_PARTICIPACION
VALUES (3, 'Equipos');
SELECT * FROM TIPO_PARTICIPACION;


SELECT * FROM MEDALLERO;
INSERT INTO MEDALLERO
VALUES (5, 1, 3);
INSERT INTO MEDALLERO
VALUES (2, 1, 5);
INSERT INTO MEDALLERO
VALUES (6, 3, 4);
INSERT INTO MEDALLERO
VALUES (4, 4, 3);
INSERT INTO MEDALLERO
VALUES (7, 3, 10);
INSERT INTO MEDALLERO
VALUES (3, 2, 8);
INSERT INTO MEDALLERO
VALUES (1, 1, 2);
INSERT INTO MEDALLERO
VALUES (1, 4, 5);
INSERT INTO MEDALLERO
VALUES (5, 2, 7);
SELECT * FROM MEDALLERO;


SELECT * FROM SEDE;
INSERT INTO SEDE
VALUES (1, 'Gimnasio Metropolitano de Tokio');
INSERT INTO SEDE
VALUES (2, 'Jardin del Palacio Imperial de Tokio');
INSERT INTO SEDE
VALUES (3, 'Gimnasio Nacional Yoyogi');
INSERT INTO SEDE
VALUES (4, 'Nippon Budokan');
INSERT INTO SEDE
VALUES (5, 'Estadio Olimpico');
SELECT * FROM SEDE;


SELECT * FROM EVENTO;
INSERT INTO EVENTO (cod_evento, fecha_hora, ubicacion, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria)
VALUES (1, '2020-07-24 11:00:00', 3, 2, 2, 1);
INSERT INTO EVENTO (cod_evento, fecha_hora, ubicacion, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria)
VALUES (2, '2020-07-26 10:30:00', 1, 6, 1, 3);
INSERT INTO EVENTO (cod_evento, fecha_hora, ubicacion, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria)
VALUES (3, '2020-07-30 18:45:00', 5, 7, 1, 2);
INSERT INTO EVENTO (cod_evento, fecha_hora, ubicacion, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria)
VALUES (4, '2020-08-01 12:15:00', 2, 1, 1, 1);
INSERT INTO EVENTO (cod_evento, fecha_hora, ubicacion, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria)
VALUES (5, '2020-08-08 19:35:00', 4, 10, 3, 1);
SELECT * FROM EVENTO;


/*************************************************************************
7. Después de que se implementó el script el cuál creó todas las tablas de las
bases de datos, el Comité Olímpico Internacional tomó la decisión de
eliminar la restricción “UNIQUE” de las siguientes tablas:

Tabla			Columna
País			Nombre
Tipo_medalla	Nombre
Departamento 	Nombre
*************************************************************************/
ALTER TABLE PAIS DROP CONSTRAINT pais_nombre_key;
ALTER TABLE TIPO_MEDALLA DROP CONSTRAINT tipo_medalla_medalla_key;
ALTER TABLE DEPARTAMENTO DROP CONSTRAINT departamento_nombre_key;


/*************************************************************************
8. Después de un análisis más profundo se decidió que los Atletas pueden
participar en varias disciplinas y no sólo en una como está reflejado
actualmente en las tablas, por lo que se pide que realice lo siguiente.
	a. Script que elimine la llave foránea de “cod_disciplina” que se
	   encuentra en la tabla “Atleta”.
	b. Script que cree una tabla con el nombre “Disciplina_Atleta” que
	   contendrá los siguiente campos:
			i. Cod_atleta (llave foránea de la tabla Atleta)
			ii. Cod_disciplina (llave foránea de la tabla Disciplina)
	   La llave primaria será la unión de las llaves foráneas “cod_atleta”
	   y “cod_disciplina”.
*************************************************************************/
SELECT * FROM ATLETA;
ALTER TABLE ATLETA DROP COLUMN disciplina_cod_disciplina;

SELECT * FROM DISCIPLINA_ATLETA;
CREATE TABLE DISCIPLINA_ATLETA(
    cod_atleta INTEGER NOT NULL REFERENCES ATLETA(cod_atleta),
    cod_disciplina INTEGER NOT NULL REFERENCES DISCIPLINA(cod_disciplina),
	PRIMARY KEY (cod_atleta, cod_disciplina)
);


/*************************************************************************
9. En la tabla “Costo_Evento” se determinó que la columna “tarifa” no debe
ser entero sino un decimal con 2 cifras de precisión.
*************************************************************************/
SELECT * FROM COSTO_EVENTO;
ALTER TABLE COSTO_EVENTO ALTER COLUMN tarifa TYPE FLOAT(2);



/*************************************************************************
10. Generar el Script que borre de la tabla “Tipo_Medalla”, el registro
siguiente:

Cod_tipo	Medalla
	4		Platino
*************************************************************************/
SELECT * FROM TIPO_MEDALLA;
DELETE FROM TIPO_MEDALLA WHERE cod_tipo = 4 AND medalla='Platino';


/*************************************************************************
11. La fecha de las olimpiadas está cerca y los preparativos siguen, pero
de último momento se dieron problemas con las televisoras encargadas de
transmitir los eventos, ya que no hay tiempo de solucionar los problemas
que se dieron, se decidió no transmitir el evento a través de las
televisoras por lo que el Comité Olímpico pide generar el script que
elimine la tabla “TELEVISORAS” y “COSTO_EVENTO”.
*************************************************************************/
SELECT * FROM COSTO_EVENTO;
DROP TABLE COSTO_EVENTO;

SELECT * FROM TELEVISORA;
DROP TABLE TELEVISORA;


/*************************************************************************
12. El comité olímpico quiere replantear las disciplinas que van a
llevarse a cabo, por lo cual pide generar el script que elimine todos los
registros contenidos en la tabla “DISCIPLINA”.
*************************************************************************/
SELECT * FROM DISCIPLINA;
DELETE FROM DISCIPLINA;


/*************************************************************************
13. Los miembros que no tenían registrado su número de teléfono en sus
perfiles fueron notificados, por lo que se acercaron a las instalaciones de
Comité para actualizar sus datos.

Nombre				Teléfono
Laura Cunha Silva	55464601
Jeuel Villalpando	91514243
Scott Mitchell		920686670
*************************************************************************/
SELECT * FROM MIEMBRO;
UPDATE MIEMBRO SET telefono = 55464601
WHERE nombre = 'Laura' AND apellido = 'Cunha Silva';

UPDATE MIEMBRO SET telefono = 91514243
WHERE nombre = 'Jeuel' AND apellido = 'Villalpando';

UPDATE MIEMBRO SET telefono = 920686670
WHERE nombre = 'Scott' AND apellido = 'Mitchell';



/*************************************************************************
14. El Comité decidió que necesita la fotografía en la información de los
atletaspara su perfil, por lo que se debe agregar la columna “Fotografía”
a la tabla Atleta, debido a que es un cambio de última hora este campo
deberá ser opcional.
*************************************************************************/
SELECT * FROM ATLETA;
ALTER TABLE ATLETA ADD fotografia BYTEA NULL;



/*************************************************************************
15. Todos los atletas que se registren deben cumplir con ser menores a 25
años. De lo contrario no se debe poder registrar a un atleta en la base
de datos.
*************************************************************************/
ALTER TABLE ATLETA ADD CHECK (edad < 25);


