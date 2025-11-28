-- -----------------------------------------------------
-- Esquema: Creación de tablas del DER
-- -----------------------------------------------------
-- Opcional: Crear el esquema (base de datos) si no existe
CREATE SCHEMA IF NOT EXISTS `AR_PROD_HUB_EXT` DEFAULT CHARACTER SET utf8mb4 ;
USE `AR_PROD_HUB_EXT`;

-- Desactivar temporalmente las comprobaciones de claves foráneas
-- para asegurar la correcta creación en orden
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- Tabla `MAE_SENSIBILIDAD`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MAE_SENSIBILIDAD` (
  `sensibilidad_id` VARCHAR(50) NOT NULL,
  `descripcion_corta` VARCHAR(100) NULL,
  `nivel_riesgo` INT NULL,
  PRIMARY KEY (`sensibilidad_id`)
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla `DIM_EMPLEADO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DIM_EMPLEADO` (
  `empleado_id` INT NOT NULL,
  `nombre` VARCHAR(100) NULL,
  `apellido` VARCHAR(100) NULL,
  `email_laboral` VARCHAR(100) NULL,
  `puesto` VARCHAR(100) NULL,
  `gerencia` VARCHAR(100) NULL,
  `activo_fl` TINYINT(1) NULL,
  PRIMARY KEY (`empleado_id`)
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla `CAT_METODO_ANON`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CAT_METODO_ANON` (
  `metodo_anon_id` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `funcion_sql_ejemplo` VARCHAR(255) NULL,
  PRIMARY KEY (`metodo_anon_id`)
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla `MAE_CONCEPTO_SENSIBLE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MAE_CONCEPTO_SENSIBLE` (
  `concepto_id` VARCHAR(100) NOT NULL,
  `nombre_concepto` VARCHAR(255) NULL,
  `sensibilidad_id` VARCHAR(50) NOT NULL,
  `propietario_id` INT NOT NULL,
  `metodo_anon_id` VARCHAR(100) NOT NULL,
  `normativa_aplicable` VARCHAR(255) NULL,
  PRIMARY KEY (`concepto_id`),
  CONSTRAINT `fk_concepto_sensibilidad`
    FOREIGN KEY (`sensibilidad_id`)
    REFERENCES `MAE_SENSIBILIDAD` (`sensibilidad_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_concepto_empleado`
    FOREIGN KEY (`propietario_id`)
    REFERENCES `DIM_EMPLEADO` (`empleado_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_concepto_metodo_anon`
    FOREIGN KEY (`metodo_anon_id`)
    REFERENCES `CAT_METODO_ANON` (`metodo_anon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla `MAE_CATALOGO_DATOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MAE_CATALOGO_DATOS` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre_campo` VARCHAR(100) NULL,
  `tabla_origen` VARCHAR(100) NULL,
  `concepto_id` VARCHAR(100) NOT NULL,
  `lote_carga` TIMESTAMP NULL,
  `lote_actualizacion` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_catalogo_concepto`
    FOREIGN KEY (`concepto_id`)
    REFERENCES `MAE_CONCEPTO_SENSIBLE` (`concepto_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- Reactivar las comprobaciones de claves foráneas
SET FOREIGN_KEY_CHECKS = 1;

-- Fin del script