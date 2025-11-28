USE `AR_PROD_HUB_DIM`;

-- -----------------------------------------------------
-- 1. Inserción de PLANES
-- -----------------------------------------------------
INSERT INTO PLANES (nombre_plan, precio_mensual, descripcion, tipo_servicio) VALUES
('Fibra Hogar 300 Plus', 12500.00, 'Conexión simétrica de 300MB, ideal para teletrabajo y streaming 4K.', 'Internet'),
('Móvil Ilimitado 5G', 8900.00, 'Datos y llamadas ilimitadas en red 5G. Incluye roaming en países limítrofes.', 'Móvil'),
('Paquete Premium Fútbol', 4500.00, 'Todos los partidos del fútbol argentino y ligas internacionales en HD.', 'TV'),
('Triple Pack Ahorro', 21000.00, 'Internet 100MB + Móvil Básico + Pack TV Esencial. Descuento por bundling.', 'Bundle'),
('Internet Rural Satelital', 15500.00, 'Conexión vía satélite para zonas de baja cobertura terrestre.', 'Internet');

-- -----------------------------------------------------
-- 2. Inserción de CLIENTES (Datos Sensibles Simulados)
-- Usamos datos típicos de Argentina: DNI/CUIT simulados, direcciones en CABA, Rosario y Córdoba.
-- -----------------------------------------------------
INSERT INTO CLIENTES (nombre, apellido, fecha_nacimiento, email, telefono, direccion_calle, ciudad, documento_identidad) VALUES
('Martín', 'Gómez', '1985-05-20', 'martin.gomez@ejemplo.com.ar', '11-4567-8901', 'Av. Corrientes 1234, Piso 5', 'CABA', '29123456'),
('Sofía', 'Pérez', '1992-11-10', 'sofia.perez@ejemplo.com.ar', '341-5555-1234', 'Bv. Oroño 456', 'Rosario', '36789012'),
('Juan', 'López', '1978-02-28', 'juan.lopez@ejemplo.com.ar', '351-8888-9999', 'Vélez Sársfield 78', 'Córdoba', '25012345'),
('Valeria', 'Rodríguez', '1995-07-04', 'valeria.r@ejemplo.com.ar', '221-3333-4444', 'Calle 50 #1500', 'La Plata', '38901234'),
('Carlos', 'Fernández', '1965-01-15', 'carlos.fdez@ejemplo.com.ar', '261-7777-1111', 'San Martín 900', 'Mendoza', '18567890');


-- -----------------------------------------------------
-- 3. Inserción de SUSCRIPCIONES
-- Vincula Clientes con Planes.
-- -----------------------------------------------------
INSERT INTO SUSCRIPCIONES (cliente_id, plan_id, fecha_inicio, estado_suscripcion, costo_final) VALUES
-- Martín Gómez (cliente 1) compra el Triple Pack (plan 4)
(1, 4, '2024-01-15', 'Activa', 20500.00),
-- Sofía Pérez (cliente 2) compra el Móvil Ilimitado (plan 2)
(2, 2, '2025-08-01', 'Activa', 8900.00),
-- Juan López (cliente 3) compra Fibra Hogar (plan 1), su suscripción está pendiente de instalación
(3, 1, '2025-10-20', 'Pendiente', 12500.00),
-- Valeria Rodríguez (cliente 4) compra Internet Rural (plan 5)
(4, 5, '2025-05-10', 'Activa', 15500.00),
-- Carlos Fernández (cliente 5) compra Paquete Fútbol (plan 3)
(5, 3, '2024-12-01', 'Activa', 4500.00);


-- -----------------------------------------------------
-- 4. Inserción de PAGOS
-- Registra los pagos de las suscripciones.
-- -----------------------------------------------------
INSERT INTO PAGOS (suscripcion_id, monto_pagado, fecha_pago, metodo_pago, ultimos_4_tarjeta) VALUES
-- Pagos de Martín Gómez (suscripcion 1)
(1, 20500.00, '2025-10-01 10:30:00', 'Tarjeta Crédito/Débito', '4321'),
(1, 20500.00, '2025-09-01 11:00:00', 'Tarjeta Crédito/Débito', '4321'),

-- Pagos de Sofía Pérez (suscripcion 2)
(2, 8900.00, '2025-09-28 14:00:00', 'Transferencia', NULL),
(2, 8900.00, '2025-08-30 09:15:00', 'Transferencia', NULL),

-- Pagos de Carlos Fernández (suscripcion 5)
(5, 4500.00, '2025-10-25 18:00:00', 'Efectivo', NULL);
