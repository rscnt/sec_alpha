-- db:mysql -D sec_alpha -u _r 
-- raul_ascencio@lavabit.com
-- DROP DATABASE sec_alpha;
CREATE DATABASE IF NOT EXISTS sec_alpha;

USE sec_alpha;

/**
 * Especialidad
 */
CREATE TABLE IF NOT EXISTS Especialidad (
  codigo TINYINT AUTO_INCREMENT UNIQUE NOT NULL,
  nombre VARCHAR(100) UNIQUE NOT NULL,
  total_alumnos TINYINT NOT NULL,
  voto_alumnos TINYINT NOT NULL DEFAULT 0,
  fecha_registro DATE,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE Especialidad
ADD CONSTRAINT especialidad_codigo_pk
PRIMARY KEY (codigo);


/**
 * /Especialidad
 */



CREATE TABLE IF NOT EXISTS Alumno (
  codigo VARCHAR(8) UNIQUE NOT NULL,
  NIE varchar(11) UNIQUE NOT NULL,
  nombre varchar(150) NOT NULL,
  especialidad tinyint NOT NULL,
  fecha_registro date,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- one more column

ALTER TABLE Alumno
ADD voto BIT NOT NULL DEFAULT 0;

-- PK
ALTER TABLE Alumno
ADD CONSTRAINT alumno_codigo_pk
PRIMARY KEY (codigo, NIE);

-- FK

ALTER TABLE Alumno
ADD CONSTRAINT alumno_especialidad_fk
FOREIGN KEY (especialidad) REFERENCES Especialidad(codigo) ON DELETE CASCADE ON UPDATE CASCADE;




CREATE TABLE `Presidente` (
  `alumno` varchar(8) NOT NULL,
  `imagen_src` varchar(250) NOT NULL,
  `puntaje` int(11) NOT NULL DEFAULT '0',
  especialidad tinyint NOT NULL,
  PRIMARY KEY (`alumno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE Presidente
ADD CONSTRAINT presidente_codigo_fk
FOREIGN KEY (alumno) REFERENCES Alumno (codigo) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Presidente
ADD CONSTRAINT presidente_especialidad_fk
FOREIGN KEY (especialidad) REFERENCES Especialidad(codigo) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS Votantes (
    alumno VARCHAR(8) UNIQUE NOT NULL,
    especialidad TINYINT NOT NULL,
    imagen_src TEXT NOT NULL,
    voto_realizado BOOLEAN  DEFAULT 0 NOT NULL
);

ALTER TABLE Votantes 
ADD CONSTRAINT votantes_alumnos_fk 
FOREIGN KEY (alumno) REFERENCES Alumno (codigo) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Votantes 
ADD CONSTRAINT votantes_especialidad_fk 
FOREIGN KEY (especialidad) REFERENCES Especialidad (codigo) ON DELETE RESTRICT ON UPDATE CASCADE;

DROP TRIGGER IF EXISTS agregarCandidatoVotantes;
DELIMITER $$
CREATE TRIGGER agregarCandidatoVotantes BEFORE INSERT ON Votantes FOR EACH ROW BEGIN
SET NEW.especialidad = ( SELECT especialidad FROM Alumno WHERE codigo = NEW.alumno );
END
$$

/**
 * /Alumno
 */

CREATE TABLE IF NOT EXISTS Candidato (
  alumno VARCHAR(8) UNIQUE NOT NULL,
  imagen_src VARCHAR(250),
  especialidad tinyint NOT NULL,
  fecha_registro DATE,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  puntaje smallint DEFAULT 0 NOT NULL
);

-- SELECT *

SELECT * FROM Candidato;

-- PK

ALTER TABLE Candidato
ADD CONSTRAINT candidato_codigo_pk
PRIMARY KEY (alumno);

-- FK

ALTER TABLE Candidato
ADD CONSTRAINT candidato_codigo_fk
FOREIGN KEY (alumno) REFERENCES Alumno (codigo) ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE Candidato
ADD CONSTRAINT candidato_especialidad_fk
FOREIGN KEY (especialidad) REFERENCES Especialidad (codigo) ON DELETE RESTRICT ON UPDATE RESTRICT;
 

/**
 * /Candidato
 */


CREATE TABLE IF NOT EXISTS Electo (
  alumno VARCHAR(8) UNIQUE UNIQUE NOT NULL,
  cargo VARCHAR(150),
  fecha_registro DATE,
  puntajeP INTEGER DEFAULT 0,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PK
ALTER TABLE Electo
ADD CONSTRAINT electo_pk
PRIMARY KEY (alumno);

-- FK

ALTER TABLE Electo 
ADD CONSTRAINT electo_codigo_fk
FOREIGN KEY (alumno) REFERENCES Candidato (alumno) ON DELETE RESTRICT ON UPDATE CASCADE;

/**
 * /Electo
 */


CREATE TABLE IF NOT EXISTS Pregunta (
  codigo SMALLINT AUTO_INCREMENT UNIQUE NOT NULL,
  descripcion varchar(255) NOT NULL,
  fecha_registro DATE,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PK

ALTER TABLE Pregunta
ADD CONSTRAINT pregunta_pk
PRIMARY KEY (codigo);

-- FK 

DROP TABLE Usuario;
SELECT * FROM Usuario;

INSERT INTO Usuario (nombre, pass, descripcion) VALUES ('nombre', 'foo45', 'lalalal');
CREATE TABLE IF NOT EXISTS Usuario (
  codigo TINYINT AUTO_INCREMENT UNIQUE NOT NULL,
  nombre VARCHAR(100) UNIQUE NOT NULL,
  pass TEXT NOT NULL,
  descripcion VARCHAR(150)
);

ALTER TABLE Usuario
ADD CONSTRAINT user_codigo_pk
PRIMARY KEY (codigo);


-- index 

CREATE INDEX index_candidato_codigo
on Candidato (codigo);

CREATE INDEX index_pregunta_codigo
on Pregunta (codigo);

TRUNCATE TABLE Candidato;
DROP TRIGGER tresCandidatos;
DELIMITER $$
CREATE TRIGGER tresCandidatos BEFORE INSERT ON Candidato FOR EACH ROW BEGIN
DECLARE done 					INT DEFAULT 0;
DECLARE maxCandidatos 			TINYINT;
DECLARE Nespecialidad 			TINYINT;
DECLARE nCandidatos 			TINYINT;
DECLARE CurrentCandidato 		VARCHAR(8);
DECLARE currentCandidatoEsp 	        TINYINT;
DECLARE nCandidatosEsp			TINYINT;
DECLARE countCandidato			TINYINT;
DECLARE cursorCandidato 		CURSOR FOR SELECT alumno FROM Candidato;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

SET maxCandidatos = 3;
SET nCandidatos = 0;
SET countCandidato = (SELECT COUNT(*) FROM Candidato);
IF  countCandidato > 0 THEN

  OPEN cursorCandidato;
  REPEAT	
  FETCH cursorCandidato INTO CurrentCandidato;
  SET currentCandidatoEsp = (SELECT especialidad FROM Alumno WHERE codigo = NEW.alumno);
  SET Nespecialidad = (SELECT especialidad FROM Alumno WHERE codigo = CurrentCandidato);
  IF (Nespecialidad = currentCandidatoEsp) THEN
	SET nCandidatos = nCandidatos + 1;	
  END IF; 
  SELECT alumno INTO CurrentCandidato FROM Candidato LIMIT 1;
  SET NEW.especialidad = ( SELECT especialidad FROM Alumno WHERE codigo = NEW.alumno ) ;
  UNTIL done END REPEAT;
  CLOSE cursorCandidato;

  IF (nCandidatos > 3) THEN
	SET NEW.alumno = null;
  END IF;
  END IF;
END
$$




INSERT INTO Candidato (alumno) VALUES ('20070063');

CREATE TABLE  debug (
  id varchar(100) default NULL,
  debug_output text,
  line_id int(11) NOT NULL auto_increment,
  PRIMARY KEY  (line_id)
);

-- PRESIDENTES

DROP TRIGGER IF EXISTS agregarCandidatoPresidente;
DELIMITER $$
CREATE TRIGGER agregarCandidatoPresidente BEFORE INSERT ON Presidente FOR EACH ROW BEGIN
SET NEW.especialidad = ( SELECT especialidad FROM Alumno WHERE codigo = NEW.alumno );
END
$$

-- /PRESIDENTES



-- PROCEDURE FOR COUNT ALUMNOS

DROP PROCEDURE numeroAlumnos;
-- SELECT e.codigo , COUNT(DISTINCT a.codigo) FROM Alumno a INNER JOIN
-- Especialidad e ON a.especialidad = e.codigo GROUP BY e.codigo;
-- WHERE e.codigo = @nEspecialidad;

CALL actualizarCAlm;

DROP PROCEDURE IF EXISTS actualizarCAlm;

DELIMITER //
CREATE PROCEDURE actualizarCAlm()
BEGIN

  DECLARE done          INT DEFAULT 0;
  DECLARE nAlumnos      INT DEFAULT 0;
  DECLARE cEspecialidad INT DEFAULT 0;

  DECLARE CURSORCAlm    CURSOR FOR SELECT e.codigo , COUNT(DISTINCT a.codigo) 
					     FROM Alumno a INNER JOIN Especialidad e 
						 ON a.especialidad = e.codigo GROUP BY e.codigo;

  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

  OPEN CURSORCAlm;
  REPEAT
	FETCH CURSORCAlm INTO cEspecialidad, nAlumnos;
	UPDATE Especialidad SET total_alumnos = nAlumnos
    WHERE Especialidad.codigo = cEspecialidad;
  UNTIL done END REPEAT;
  CLOSE CURSORCAlm;
END
//

-- PROCEDURE TIPO DE VOTACION
DROP PROCEDURE IF EXISTS EscogerVotacionN;
DELIMITER //
CREATE PROCEDURE EscogerVotacionN()
BEGIN
    UPDATE configuraciones SET valor = 0;
    UPDATE configuraciones SET valor = 1 WHERE nombre = 'votacionNormal';
END
//


DROP PROCEDURE IF EXISTS EscogerVotacionP;
DELIMITER //
CREATE PROCEDURE EscogerVotacionP()
BEGIN
    UPDATE configuraciones SET valor = 0;
    UPDATE configuraciones SET valor = 1 WHERE nombre = 'votacionPresidente';
END
//

DELIMITER //
CREATE PROCEDURE EscogerFaseVotacion()
BEGIN
    IF (SELECT valor FROM configuraciones WHERE nombre = 'faseConcejo') THEN
        UPDATE configuraciones SET valor = 0 WHERE nombre = 'faseConcejo';
    ELSE
        UPDATE configuraciones SET valor = 1 WHERE nombre = 'faseConcejo';
    END IF;
END
//

-- /PROCEDURE TIPO DE VOTACION

-- PROCEDURE UNLOCK PRESIDENTE

-- Un procedimiento que evalue si los votos han sido completos en cada Especialidad
-- Un disparador que se ejecute al actualizar la columno puntajeP de la tabla 
-- Electo.

-- SET Consejo

DELIMITER $$
CREATE PROCEDURE declararConsejo()
BEGIN
  DECLARE done          INT DEFAULT 0;

  DECLARE cursorCandidatos CURSOR FOR SELECT codigo 
							  FROM Candidato ORDER BY puntaje DESC LIMIT 12;

  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;


  OPEN cursorCandidatos;
  REPEAT
	FETCH cursorCandidatos INTO cCodigo;
	INSERT INTO Electo (alumno) VALUES (cCodigo);
  UNTIL done END REPEAT;
  CLOSE cursorCandidatos;
END
$$


-- set presidente
DELIMITER $$
CREATE PROCEDURE declararConsejo()
BEGIN

  DECLARE done				INT DEFAULT 0;
  DECLARE cCodigo			VARCHAR(8);
  DECLARE cursorCandidatos	CURSOR FOR SELECT alumno
							  FROM  Electo ORDER BY puntajeP DESC LIMIT 1;

  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;


  OPEN cursorCandidatos;
  REPEAT
	FETCH cursorCandidatos INTO cCodigo;
	UPDATE Electo SET cargo = 'Presidente' WHERE alumno = cCodigo;
  UNTIL done END REPEAT;
  CLOSE cursorCandidatos;
END
$$


CREATE TABLE IF NOT EXISTS configuraciones
(
    nombre VARCHAR(150) NOT NULL PRIMARY KEY,
    valor  boolean NOT NULL DEFAULT FALSE 
);

INSERT INTO configuraciones (nombre) VALUES ('votacionNormal');
INSERT INTO configuraciones (nombre) VALUES ('votacionPresidente');
INSERT INTO configuraciones (nombre) VALUES ('faseConcejo');


CREATE TABLE IF NOT EXISTS Categoria (
    codigo INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE Pregunta ADD categoria INTEGER;

 CREATE TABLE Puntaje (
    alumno VARCHAR(8), 
    categoria INTEGER, 
    puntaje INTEGER DEFAULT 0,  
    PRIMARY KEY(alumno, categoria)
);
