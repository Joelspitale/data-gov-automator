-- Modelo de Datos Simplificado para Venta de Planes de Pago en Telecomunicaciones
-- Generado para ser importado directamente en MySQL Workbench.

-- -----------------------------------------------------
-- Esquema: AR_PROD_HUB_DIM
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `AR_PROD_HUB_DIM` DEFAULT CHARACTER SET utf8mb4 ;
USE `AR_PROD_HUB_DIM`;

-- Desactivar temporalmente las comprobaciones de claves foráneas
-- para asegurar la correcta creación en orden
SET FOREIGN_KEY_CHECKS = 0;

-- Tabla: PLANES
-- Contiene la definición de los servicios y precios ofertados.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PLANES` (
  `plan_id` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria del plan.',
  `nombre_plan` VARCHAR(100) NOT NULL COMMENT 'Nombre comercial del plan (e.g., Fibra 300MB + TV Básica).',
  `precio_mensual` DECIMAL(10, 2) NOT NULL COMMENT 'Costo mensual base del plan.',
  `descripcion` TEXT NULL COMMENT 'Detalle de los beneficios y caracteristicas del plan.',
  `tipo_servicio` ENUM('Internet', 'Móvil', 'TV', 'Bundle') NOT NULL COMMENT 'Categoría principal del servicio.',
  PRIMARY KEY (`plan_id`))
ENGINE = InnoDB
COMMENT = 'Define los planes y servicios que la compañia ofrece a sus clientes.';


-- -----------------------------------------------------
-- Tabla: CLIENTES
-- Contiene la información personal y sensible de los suscriptores.
-- Las columnas sensibles se indican con un comentario.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLIENTES` (
  `cliente_id` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria del cliente.',
  `nombre` VARCHAR(100) NOT NULL,
  `apellido` VARCHAR(100) NOT NULL,
  `fecha_nacimiento` DATE NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE COMMENT 'DATO SENSIBLE: Correo electrónico del cliente.',
  `telefono` VARCHAR(20) NOT NULL UNIQUE,
  `direccion_calle` VARCHAR(255) NOT NULL,
  `ciudad` VARCHAR(100) NOT NULL,
  `documento_identidad` VARCHAR(50) NOT NULL UNIQUE COMMENT 'DATO SENSIBLE: Documento de identidad (DNI, CUIT, Pasaporte).',
  `fecha_registro` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cliente_id`))
ENGINE = InnoDB
COMMENT = 'Información de los clientes, incluyendo datos personales y sensibles.';


-- -----------------------------------------------------
-- Tabla: SUSCRIPCIONES
-- Representa la venta o contrato de un plan específico a un cliente.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SUSCRIPCIONES` (
  `suscripcion_id` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria de la suscripción.',
  `cliente_id` INT NOT NULL COMMENT 'Clave foránea al cliente que compra el plan.',
  `plan_id` INT NOT NULL COMMENT 'Clave foránea al plan adquirido.',
  `fecha_inicio` DATE NOT NULL COMMENT 'Fecha de activación del servicio.',
  `fecha_fin_estimada` DATE NULL COMMENT 'Fecha de finalización si es un contrato temporal.',
  `estado_suscripcion` ENUM('Activa', 'Suspendida', 'Cancelada', 'Pendiente') NOT NULL DEFAULT 'Activa',
  `costo_final` DECIMAL(10, 2) NOT NULL COMMENT 'Costo con posibles descuentos aplicados.',
  PRIMARY KEY (`suscripcion_id`),
  INDEX `fk_suscripciones_clientes_idx` (`cliente_id` ASC) VISIBLE,
  INDEX `fk_suscripciones_planes_idx` (`plan_id` ASC) VISIBLE,
  CONSTRAINT `fk_suscripciones_clientes`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `CLIENTES` (`cliente_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_suscripciones_planes`
    FOREIGN KEY (`plan_id`)
    REFERENCES `PLANES` (`plan_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Registro de la venta de un plan específico a un cliente.';


-- -----------------------------------------------------
-- Tabla: PAGOS
-- Registra los pagos realizados por las suscripciones.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PAGOS` (
  `pago_id` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria del pago.',
  `suscripcion_id` INT NOT NULL COMMENT 'Clave foránea a la suscripción asociada.',
  `monto_pagado` DECIMAL(10, 2) NOT NULL,
  `fecha_pago` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `metodo_pago` ENUM('Tarjeta Crédito/Débito', 'Transferencia', 'Efectivo') NOT NULL,
  `detalles_transaccion` VARCHAR(255) NULL COMMENT 'Referencia o ID de la transacción.',
  `ultimos_4_tarjeta` VARCHAR(4) NULL COMMENT 'DATO SENSIBLE: Últimos 4 dígitos de la tarjeta (para referencia).',
  PRIMARY KEY (`pago_id`),
  INDEX `fk_pagos_suscripciones1_idx` (`suscripcion_id` ASC) VISIBLE,
  CONSTRAINT `fk_pagos_suscripciones1`
    FOREIGN KEY (`suscripcion_id`)
    REFERENCES `SUSCRIPCIONES` (`suscripcion_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Registro de todos los pagos de los clientes.';
