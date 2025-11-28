-- -----------------------------------------------------
-- INSERTS PARA TABLAS LOOKUP Y DIMENSIONALES
-- -----------------------------------------------------
USE `AR_PROD_HUB_EXT`;

-- 1. MAE_SENSIBILIDAD (Niveles de Riesgo y Clasificación)
INSERT INTO `MAE_SENSIBILIDAD` (sensibilidad_id, descripcion_corta, nivel_riesgo) VALUES
('PUBLICA', 'Público', 1),
('PII_BAJA', 'Información Personal (Baja)', 2),
('PII_ALTA', 'Información Personal (Alta)', 4),
('PCI', 'Datos de Tarjeta de Pago', 5),
('SECRETO', 'Información Estratégica', 5);

-- 2. CAT_METODO_ANON (Métodos de Anonimización/Enmascaramiento)
INSERT INTO `CAT_METODO_ANON` (metodo_anon_id, descripcion, funcion_sql_ejemplo) VALUES
('NINGUNO', 'No se requiere enmascaramiento.', 'N/A'),
('HASH_MD5', 'Aplicar hash criptográfico para validación de unicidad.', 'MD5(campo)'),
('MASCARA_ULTIMOS_4', 'Mostrar solo los últimos 4 caracteres.', 'CONCAT(REPEAT("*", LENGTH(campo) - 4), RIGHT(campo, 4))'),
('MASCARA_DOMINIO', 'Enmascarar nombre de usuario en email, dejando el dominio.', 'CONCAT("****@", SUBSTRING_INDEX(email, "@", -1))'),
('MASCARA_TOTAL', 'Enmascaramiento completo (útil para campos PCI-DSS).', 'REPEAT("X", LENGTH(campo))');

-- 3. DIM_EMPLEADO (Propietarios/Responsables de los Conceptos Sensibles)
INSERT INTO `DIM_EMPLEADO` (empleado_id, nombre, apellido, email_laboral, puesto, gerencia, activo_fl) VALUES
(101, 'Javier', 'Perez', 'javier.perez@telco.com.ar', 'Gerente de Seguridad', 'Legal', TRUE),
(102, 'Maria', 'Gomez', 'maria.gomez@telco.com.ar', 'Analista Comercial Senior', 'Comercial', TRUE),
(103, 'Carlos', 'Lopez', 'carlos.lopez@telco.com.ar', 'Jefe de Finanzas', 'Finanzas', TRUE),
(104, 'Ana', 'Rodriguez', 'ana.rodriguez@telco.com.ar', 'Analista de Producto', 'Producto', TRUE);

-- -----------------------------------------------------
-- INSERTS PARA TABLAS MAESTRAS TRANSACCIONALES
-- -----------------------------------------------------

-- 4. MAE_CONCEPTO_SENSIBLE (Definición Canónica de Datos Sensibles)
-- Nota: Los `propietario_id` (102, 101, 103) deben existir en DIM_EMPLEADO
INSERT INTO `MAE_CONCEPTO_SENSIBLE` (concepto_id, nombre_concepto, sensibilidad_id, propietario_id, metodo_anon_id, normativa_aplicable) VALUES
('ID_NOMBRE', 'Nombre y Apellido del Suscriptor', 'PII_BAJA', 102, 'NINGUNO', 'Ley 25.326'),
('ID_EMAIL', 'Correo Electrónico de Contacto', 'PII_ALTA', 102, 'MASCARA_DOMINIO', 'Ley 25.326'),
('ID_TELEFONO', 'Número de Teléfono de Contacto', 'PII_BAJA', 102, 'MASCARA_ULTIMOS_4', 'Ley 25.326'),
('ID_FISCAL', 'Documento de Identidad / CUIL / CUIT', 'PII_ALTA', 101, 'HASH_MD5', 'Ley 25.326'),
('ID_TARJETA', 'Últimos 4 Dígitos de Tarjeta de Crédito', 'PCI', 103, 'MASCARA_TOTAL', 'PCI-DSS');

-- 5. MAE_CATALOGO_DATOS (Mapeo de Campos Físicos a Conceptos Canónicos)
-- Nota: Los `concepto_id` deben existir en MAE_CONCEPTO_SENSIBLE
-- `id` es AUTO_INCREMENT, por lo que no se inserta.
-- `lote_carga` y `lote_actualizacion` tomarán valores NULL o el valor por defecto de la base de datos (generalmente CURRENT_TIMESTAMP)
INSERT INTO `MAE_CATALOGO_DATOS` 
(nombre_campo, tabla_origen, concepto_id) VALUES
-- Mapeo de campos de la Tabla CLIENTES
('nombre', 'CLIENTES', 'ID_NOMBRE'),
('apellido', 'CLIENTES', 'ID_NOMBRE'),
('email', 'CLIENTES', 'ID_EMAIL'),
('telefono', 'CLIENTES', 'ID_TELEFONO'),
('documento_identidad', 'CLIENTES', 'ID_FISCAL'),

-- Mapeo de campos de la Tabla CONTACTOS
('correo', 'CONTACTOS', 'ID_EMAIL'),
('dni', 'CONTACTOS', 'ID_FISCAL'),

-- Mapeo de campos de la Tabla PAGOS
('ultimos_4_tarjeta', 'PAGOS', 'ID_TARJETA');

-- Fin del script de inserción