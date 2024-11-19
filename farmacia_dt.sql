DROP DATABASE IF EXISTS farmacia_dt;
-- PROYECTO FARMACIA DENIS TARABORELI 
-- CREACION DE LA BASE DE DATOS

CREATE DATABASE farmacia_dt;

-- NOS PARAMOS EN LA NUEVA BASE

USE farmacia_dt;

-- CREACION DE TABLAS

CREATE TABLE IF NOT EXISTS genero(
	genero_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    genero ENUM('Masculino', 'Femenino')
);

CREATE TABLE IF NOT EXISTS nacionalidad(
	nacionalidad_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR (100) NOT NULL
    );

CREATE TABLE IF NOT EXISTS partido(
	partido_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR (100) NOT NULL
    );
    
CREATE TABLE IF NOT EXISTS provincia(
	provincia_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR (100) NOT NULL
    );

CREATE TABLE IF NOT EXISTS farmaco(
	farmaco_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (100) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR (100) NOT NULL -- receta o venta libre
);

CREATE TABLE IF NOT EXISTS ciudad(
	ciudad_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS laboratorio(
	laboratorio_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100),
    telefono VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    nacionalidad_id INT NOT NULL,  
    provincia_id INT,  
    ciudad_id INT,
    FOREIGN KEY (nacionalidad_id) REFERENCES nacionalidad(nacionalidad_id),
    FOREIGN KEY (provincia_id) REFERENCES provincia(provincia_id),
    FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id)
);

CREATE TABLE IF NOT EXISTS medicamento_laboratorio( 
-- en esta tabla se indica dentro de cada id de la primary key, los medicamentos disponibles en cada laboratorio
	medicamento_laboratorio_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    presentacion VARCHAR(50) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    cantidad_disponible INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    fecha_vencimiento DATETIME,
    farmaco_id INT NOT NULL,
    laboratorio_id INT NOT NULL,
    eliminado BOOLEAN DEFAULT FALSE,
    foreign key (farmaco_id) REFERENCES farmaco(farmaco_id),
    foreign key (laboratorio_id) REFERENCES laboratorio(laboratorio_id)
);

CREATE TABLE IF NOT EXISTS proveedor(
	proveedor_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(30) NOT NULL,
    email VARCHAR(100),
    CUIT VARCHAR(30) NOT NULL,
    nacionalidad_id INT NOT NULL,  
    provincia_id INT NOT NULL,  
    ciudad_id INT NOT NULL,  
    foreign key (nacionalidad_id) REFERENCES nacionalidad(nacionalidad_id),
    foreign key (provincia_id) REFERENCES provincia(provincia_id),
    FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id)
    
);

CREATE TABLE IF NOT EXISTS proveedor_medicamento(
	-- tabla intermedia de los medicamentos que cada proveedor tiene disponible
    proveedor_medicamento_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    proveedor_id INT NOT NULL,
    medicamento_laboratorio_id INT NOT NULL,
    foreign key (proveedor_id) REFERENCES proveedor(proveedor_id),
    foreign key (medicamento_laboratorio_id) REFERENCES medicamento_laboratorio(medicamento_laboratorio_id)
    
);

CREATE TABLE IF NOT EXISTS stock_farmacia(  
	stock_farmacia_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    presentacion VARCHAR(100) NOT NULL,
    precio_unitario INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL, 
    tipo VARCHAR(20) NOT NULL,
    fecha_de_vencimiento DATETIME,
    medicamento_laboratorio_id INT NOT NULL,
    FOREIGN KEY (medicamento_laboratorio_id) REFERENCES medicamento_laboratorio(medicamento_laboratorio_id)  
);  

CREATE TABLE IF NOT EXISTS compra(
	compra_id INT PRIMARY KEY,
    numero_comprobante VARCHAR(50) ,
    fecha_compra DATETIME,
    total DECIMAL(10, 2),
    proveedor_id INT,
    foreign key (proveedor_id) REFERENCES proveedor(proveedor_id) 
);

CREATE TABLE IF NOT EXISTS detalle_compra(
detalle_compra_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
cantidad INT NOT NULL,
precio_unitario DECIMAL(10,2) NOT NULL,
precio_total DECIMAL(10,2) NOT NULL,
compra_id INT NOT NULL,
medicamento_laboratorio_id INT NOT NULL, -- medicamentos especificos comprados al proveedor
foreign key (compra_id) REFERENCES compra (compra_id),
foreign key (medicamento_laboratorio_id) REFERENCES medicamento_laboratorio(medicamento_laboratorio_id)
);

CREATE TABLE IF NOT EXISTS prepaga(
prepaga_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
razon_social VARCHAR(100),
CUIT VARCHAR(30),
direccion VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS plan_prepaga(
	plan_prepaga_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    plan VARCHAR(100),
    prepaga_id INT NOT NULL,
    FOREIGN KEY (prepaga_id) REFERENCES prepaga(prepaga_id)
);

CREATE TABLE IF NOT EXISTS obra_social(
	obra_social_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	razon_social VARCHAR(100),
	CUIT VARCHAR(30),
	direccion VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS plan_obra_social(
	plan_obra_social_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    plan VARCHAR(100),
    obra_social_id INT NOT NULL,
    FOREIGN KEY (obra_social_id) REFERENCES obra_social(obra_social_id)
);

CREATE TABLE IF NOT EXISTS cliente(
	cliente_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(30) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE,
    dni VARCHAR(30) NOT NULL UNIQUE,
    fecha_nacimiento DATETIME NOT NULL,
    numero_afiliado VARCHAR (100) ,
    obra_social_id INT,
    prepaga_id INT,
    nacionalidad_id INT NOT NULL,  
    provincia_id INT NOT NULL, 
    ciudad_id INT NOT NULL, 
    partido_id INT NOT NULL,
    genero_id INT NOT NULL,
    foreign key (obra_social_id) REFERENCES  obra_social(obra_social_id),
    foreign key (prepaga_id) REFERENCES prepaga(prepaga_id),
    foreign key (nacionalidad_id) REFERENCES nacionalidad(nacionalidad_id),
    foreign key (provincia_id) REFERENCES provincia(provincia_id),
    foreign key (partido_id) REFERENCES partido(partido_id),
    FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id),
    foreign key (genero_id) REFERENCES genero(genero_id)
);

CREATE TABLE IF NOT EXISTS medico(
	medico_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    matricula VARCHAR(100) UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS personal(
	personal_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(30) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE,
    dni VARCHAR(30) NOT NULL UNIQUE,
    fecha_nacimiento DATETIME NOT NULL,
	partido_id INT NOT NULL,
    provincia_id INT NOT NULL,
    foreign key (partido_id) REFERENCES partido(partido_id),
    foreign key (provincia_id) REFERENCES provincia(provincia_id)
);


CREATE TABLE IF NOT EXISTS venta(
	venta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    comprobante VARCHAR(50) NOT NULL,
    precio_total DECIMAL(10, 2),
    fecha_venta DATETIME,
    cliente_id INT NOT NULL,
    personal_id INT NOT NULL,
    foreign key (cliente_id) REFERENCES cliente(cliente_id),
    foreign key (personal_id) REFERENCES personal(personal_id)
    
);

CREATE TABLE IF NOT EXISTS receta(
	receta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    numero_receta VARCHAR(50) NOT NULL,
    fecha_receta DATETIME,
    cliente_id INT NOT NULL,
    medico_id INT NOT NULL, 
	foreign key (cliente_id) REFERENCES cliente(cliente_id),
    foreign key (medico_id) REFERENCES medico(medico_id)
);

CREATE TABLE IF NOT EXISTS detalle_venta(
	detalle_venta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    cantidad INT NOT NULL,
    stock_farmacia_id INT NOT NULL,
    precio_unitario DECIMAL(10, 2),
    precio_final DECIMAL (10, 2),
    venta_id INT NOT NULL,
    receta_id INT,
    foreign key (venta_id) REFERENCES venta(venta_id),
    foreign key (stock_farmacia_id) REFERENCES stock_farmacia(stock_farmacia_id),
    foreign key (receta_id) REFERENCES receta(receta_id)
    
);



INSERT INTO farmaco (nombre, descripcion, tipo) VALUES  
('Paracetamol', 'Analgésico/antipirético', 'Venta Libre'),  
('Ibuprofeno', 'Antiinflamatorio no esteroideo (AINE)', 'Venta Libre'),  
('Aspirina (Ácido acetilsalicílico)', 'Analgésico/antipirético/antiinflamatorio', 'Venta Libre'),  
('Amoxicilina', 'Antibiótico', 'Receta'),  
('Ciprofloxacino', 'Antibiótico', 'Receta'),  
('Loratadina', 'Antihistamínico', 'Venta Libre'),  
('Metformina', 'Antidiabético', 'Receta'),  
('Simvastatina', 'Antilipémico', 'Receta'),  
('Salbutamol', 'Broncodilatador', 'Receta'),  
('Omeprazol', 'Inhibidor de la bomba de protones (IBP)', 'Venta Libre'),  
('Enalapril', 'Antihipertensivo', 'Receta'),  
('Clopidogrel', 'Antiplaquetario', 'Receta'),  
('Losartán', 'Antihipertensivo', 'Receta'),  
('Ranitidina', 'Antihistamínico H2', 'Venta Libre'),  
('Dextrometorfano', 'Antitusígeno', 'Venta Libre'),  
('Metoclopramida', 'Antiemético', 'Receta'),  
('Diazepam', 'Benzodiacepina (ansiolítico)', 'Receta'),  
('Sertralina', 'Antidepresivo (ISRS)', 'Receta'),  
('Gabapentina', 'Antiepiléptico/analgésico', 'Receta'),  
('Quetiapina', 'Antipsicótico', 'Receta'),  
('Amlodipino', 'Antihipertensivo', 'Receta'),  
('Fenitoína', 'Antiepiléptico', 'Receta'),  
('Furosemida', 'Diurético', 'Receta'),  
('Prednisona', 'Corticoide', 'Receta'),  
('Levotiroxina', 'Hormona tiroidea', 'Receta'),  
('Tamsulosina', 'Tratamiento benigna hiperplasia prostática', 'Receta'),  
('Mometasona', 'Corticoide intranasal', 'Receta'),  
('Tramadol', 'Analgésico opioide', 'Receta'),  
('Duloxetina', 'Antidepresivo/analgésico', 'Receta'),  
('Venlafaxina', 'Antidepresivo (ISRSN)', 'Receta'),  
('Cetirizina', 'Antihistamínico', 'Venta Libre'),  
('Naproxeno', 'Antiinflamatorio no esteroideo (AINE)', 'Receta'),  
('Clorfenamina', 'Antihistamínico', 'Venta Libre'),  
('Atenolol', 'Beta bloqueador', 'Receta'),  
('Bupropión', 'Antidepresivo', 'Receta'),  
('Codeína', 'Analgésico opioide', 'Receta'),  
('Fenilefrina', 'Descongestionante', 'Venta Libre'),  
('Citalopram', 'Antidepresivo (ISRS)', 'Receta'),  
('Rivaroxabán', 'Anticoagulante', 'Receta'),  
('Fluoxetina', 'Antidepresivo (ISRS)', 'Receta'),  
('Acarbosa', 'Antidiabético', 'Receta'),  
('Miconazol', 'Antifúngico', 'Venta Libre'),  
('Sildenafil', 'Tratamiento de disfunción eréctil', 'Receta'),  
('Propranolol', 'Beta bloqueador', 'Receta'),  
('Zolpidem', 'Hipnótico', 'Receta'),  
('Risosetron', 'Antiemético', 'Receta'),  
('Lisinopril', 'Antihipertensivo', 'Receta');  


INSERT INTO nacionalidad (nombre) VALUES  
('Argentina'),  
('Estados Unidos'),  
('Reino Unido'),  
('Alemania'),  
('Francia'),  
('España'),  
('Canadá'),  
('Italia'),  
('México'),  
('Brasil'),  
('Chile'),   
('Colombia'); 

INSERT INTO ciudad(nombre) VALUES
('Buenos Aires'),
('La plata'),
('Mendoza'),
('Salta'),
('Santa Fe'),
('Bahia Blanca');

INSERT INTO partido (nombre) VALUES  
('Ciudad Autónoma de Buenos Aires'),
('General San Martín'),
('Tres de Febrero'),
('San Isidro'),
('Vicente López'),
('Tigre'),
('San Fernando'),
('Hurlingham'),
('Ituzaingó'),
('Morón'),
('Merlo'),
('La Matanza'),
('Moreno'),
('Pilar'),
('Escobar'),
('Zárate'),
('Campana'),
('Avellaneda'),
('Lanús'),
('Quilmes'),
('Lomas de Zamora'),
('Almirante Brown'),
('Esteban Echeverría'),
('Ezeiza'),
('Florencio Varela'),
('Berazategui'),
('Presidente Perón'),
('San Vicente');


INSERT INTO provincia (nombre) VALUES  
('Buenos Aires'),  
('Santa Fe'),    
('Córdoba'),     
('Mendoza'),
('Salta');

INSERT INTO laboratorio (nombre, direccion, telefono, email, nacionalidad_id, provincia_id, ciudad_id) VALUES  
('Pfizer', '235 E 42nd St, New York, NY', '+1 800 879 3477', 'contact@pfizer.com', 2, NULL, NULL),  -- Amoxicilina, Clopidogrel, Sildenafil
('Bayer', 'Kaiser-Wilhelm-Allee 1, Leverkusen', '+49 214 30 1', 'info@bayer.com', 4, NULL, NULL),  -- Aspirina, Simvastatina, Amlodipino
('Roche', 'Grenzacherstrasse 124, Basel', '+41 61 688 1111', 'contact@roche.com', 4, NULL, NULL),  -- Omeprazol, Diazepam
('Novartis', 'Lichtstrasse 35, Basel', '+41 61 324 1111', 'info@novartis.com', 4, NULL, NULL),  -- Losartán, Gabapentina
('Sanofi', '54 Rue La Boétie, Paris', '+33 1 53 77 40 00', 'contact@sanofi.com', 5, NULL, NULL),  -- Venlafaxina, Citalopram
('GlaxoSmithKline', '980 Great West Rd, Brentford', '+44 20 8047 5000', 'gsk@gsk.com', 3, NULL, NULL),  -- Metformina, Enalapril
('AstraZeneca', '1 Francis Crick Ave, Cambridge', '+44 20 3749 5000', 'info@astrazeneca.com', 3, NULL, NULL),  -- Salbutamol, Prednisona
('Johnson & Johnson', 'One Johnson & Johnson Plaza, New Brunswick, NJ', '+1 800 526 3967', 'contact@jnj.com', 2, NULL, NULL),  -- Loratadina, Zolpidem
('AbbVie', '1 North Waukegan Rd, North Chicago, IL', '+1 800 255 5162', 'info@abbvie.com', 2, NULL, NULL),  -- Duloxetina, Fluoxetina
('Teva Pharmaceuticals', '124 Dunning Ave, Sydney', '+61 2 9384 4000', 'info@tevapharm.com', 3, NULL, NULL),  -- Losartán, Atenolol
('Merck', '2000 Galloping Hill Rd, Kenilworth, NJ', '+1 908 740 4000', 'contact@merck.com', 2, NULL, NULL),  -- Ranitidina, Naproxeno
('Eli Lilly', 'Lilly Corporate Center, Indianapolis, IN', '+1 317 276 2000', 'info@lilly.com', 2, NULL, NULL),  -- Duloxetina, Rivaroxabán
('Boehringer Ingelheim', 'Binger Strasse 173, Ingelheim', '+49 6132 770', 'contact@boehringer.com', 4, NULL, NULL),  -- Amlodipino, Tamsulosina
('Takeda Pharmaceuticals', '1-1, Nihonbashi-Honcho 2-chome, Chuo-ku, Tokyo', '+81 3 3278 2111', 'info@takeda.com', 9, NULL, NULL),  -- Tramadol, Acarbosa
('Gilead Sciences', '333 Lakeside Dr, Foster City, CA', '+1 650 574 3000', 'info@gilead.com', 2, NULL, NULL);  -- Codeína


-- Laboratorios argentinos (con provincia y localidad)
INSERT INTO laboratorio (nombre, direccion, telefono, email, nacionalidad_id, provincia_id, ciudad_id) VALUES  
('Laboratorio Bagó', 'Av. del Libertador 5200, Buenos Aires', '+54 11 4309 8500', 'info@bago.com.ar', 1, 1, 1),  -- Ibuprofeno, Salbutamol
('Laboratorios Richmond', 'Calle 45 N° 1234, La Plata', '+54 221 410 3000', 'contacto@richmond.com.ar', 1, 1, 2),  -- Amoxicilina, Simvastatina
('Laboratorios Elea', 'Av. Monroe 2772, Buenos Aires', '+54 11 4789 5000', 'info@elea.com.ar', 1, 1, 1),  -- Omeprazol, Enalapril
('Laboratorios Roemmers', 'Av. Pueyrredón 2446, Buenos Aires', '+54 11 4821 0100', 'contacto@roemmers.com.ar', 1, 1, 1),  -- Metoclopramida, Amlodipino
('Laboratorios Gador', 'Donato Alvarez 1380, Buenos Aires', '+54 11 4588 9999', 'info@gador.com.ar', 1, 1, 1),  -- Loratadina, Diazepam
('Laboratorio Denver Farma', 'Calle 7 N° 123, La Plata', '+54 221 456 7890', 'contacto@denverfarma.com.ar', 1, 1, 2),  -- Paracetamol, Gabapentina
('Laboratorio Bernabó', 'Av. Colón 3456, Córdoba', '+54 351 478 9023', 'info@bernabo.com.ar', 1, 3, 3),  -- Ibuprofeno, Cetirizina
('Laboratorio Montpellier', 'Calle San Martín 876, Mendoza', '+54 261 432 8765', 'info@montpellier.com.ar', 1, 4, 3),  -- Metformina, Furosemida
('Instituto Biológico Argentino', 'Av. 44 N° 2456, Buenos Aires', '+54 11 4441 1000', 'contacto@iba.com.ar', 1, 1, 1),  -- Prednisona, Metoclopramida
('Laboratorio Temis Lostalo', 'Av. Corrientes 4567, Buenos Aires', '+54 11 4873 1000', 'contacto@temislostalo.com.ar', 1, 1, 1),  -- Fluoxetina, Clorfenamina
('Laboratorio Beta', 'Calle Belgrano 1234, Santa Fe', '+54 342 456 7890', 'info@beta.com.ar', 1, 2, 5),  -- Tamsulosina, Tramadol
('Laboratorio Andrómaco', 'Calle Uruguay 4567, Buenos Aires', '+54 11 4389 1200', 'info@andromaco.com.ar', 1, 1, 1),  -- Ranitidina, Duloxetina
('Laboratorios Raffo', 'Av. Belgrano 2222, Buenos Aires', '+54 11 4389 1000', 'info@raffo.com.ar', 1, 1, 1),  -- Citalopram, Bupropión
('Laboratorio Pablo Cassará', 'Calle 12 N° 1234, Buenos Aires', '+54 11 4321 5678', 'contacto@cassara.com.ar', 1, 1, 1),  -- Zolpidem, Venlafaxina
('Laboratorios Savant', 'Av. Santa Fe 1234, Buenos Aires', '+54 11 4322 1234', 'info@savant.com.ar', 1, 1, 1),  -- Fenitoína, Atenolol
('Laboratorios HLB Pharma', 'Calle Juan B. Justo 1234, Buenos Aires', '+54 11 4567 7890', 'contacto@hlbpharma.com.ar', 1, 1, 1),  -- Acarbosa, Propranolol
('Laboratorio Biosidus', 'Av. Rivadavia 4567, Buenos Aires', '+54 11 4901 0000', 'info@biosidus.com.ar', 1, 1, 1),  -- Losartán, Clopidogrel
('Laboratorios Kemex', 'Calle 9 N° 456, Santa Fe', '+54 342 456 7890', 'contacto@kemex.com.ar', 1, 2, 5),  -- Simvastatina, Furosemida
('Laboratorios Craveri', 'Av. de Mayo 3456, Buenos Aires', '+54 11 4589 1200', 'info@craveri.com.ar', 1, 1, 1),  -- Propranolol, Levotiroxina
('Laboratorio LKM', 'Calle 11 N° 1234, Mendoza', '+54 261 431 1234', 'contacto@lkm.com.ar', 1, 4, 3),  -- Gabapentina, Salbutamol
('Laboratorio Baliarda', 'Av. Callao 1234, Buenos Aires', '+54 11 4812 3456', 'info@baliarda.com.ar', 1, 1, 1);  -- Clopidogrel, Diazepam

INSERT INTO medicamento_laboratorio (nombre, presentacion, precio_unitario, cantidad_disponible, tipo, fecha_vencimiento, farmaco_id, laboratorio_id) VALUES
('Tylenol', 'Tabletas 500mg', 3200, 1000, 'venta libre', '2025-07-31', 1, 26), -- Paracetamol - Denver Farma
('Advil', 'Cápsulas blandas 400mg', 4500, 850, 'venta libre', '2024-11-30', 2, 20), -- Ibuprofeno - Bagó
('Brufen', 'Cápsulas 600mg', 3800, 900, 'venta libre', '2024-08-15', 2, 27), -- Ibuprofeno - Bernabó
('Aspirina', 'Tabletas 500mg', 3350, 1200, 'venta libre', '2026-01-30', 3, 2), -- Aspirina - Bayer
('Amoxil 250', 'Suspensión 250mg/5ml', 18000, 600, 'receta', '2025-06-20', 4, 26), -- Amoxicilina - Richmond
('Amoxil 500', 'Cápsulas 500mg', 21000, 700, 'receta', '2025-12-10', 4, 1), -- Amoxicilina - Pfizer
('Cipro', 'Tabletas 500mg', 31000, 500, 'receta', '2026-09-15', 5, 1), -- Ciprofloxacino - Pfizer
('Claritin', 'Tabletas 10mg', 12000, 750, 'venta libre', '2025-05-30', 6, 8), -- Loratadina - Johnson & Johnson
('Loramax', 'Jarabe 5mg/5ml', 13500, 400, 'venta libre', '2025-10-25', 6, 25), -- Loratadina - Gador
('Glucophage 500', 'Tabletas 500mg', 9500, 600, 'receta', '2024-12-01', 7, 6), -- Metformina - GlaxoSmithKline
('Glucophage 850', 'Tabletas 850mg', 10500, 800, 'receta', '2025-03-15', 7, 28), -- Metformina - Montpellier
('Zocor 40', 'Tabletas 40mg', 17500, 450, 'receta', '2026-02-18', 8, 2), -- Simvastatina - Bayer
('Zocor 10', 'Tabletas 10mg', 16500, 300, 'receta', '2024-09-10', 8, 26), -- Simvastatina - Richmond
('Zocor 20', 'Tabletas 20mg', 15500, 500, 'receta', '2025-11-22', 8, 30), -- Simvastatina - Kemex
('Ventolin', 'Inhalador 100 mcg/dosis', 22000, 550, 'receta', '2026-03-05', 9, 7), -- Salbutamol - AstraZeneca
('Salbutamol Jarabe', 'Jarabe 2mg/5ml', 21000, 650, 'receta', '2025-10-05', 9, 20), -- Salbutamol - Bagó
('Salbutamol Inhalador', 'Inhalador 200 mcg/dosis', 23000, 500, 'receta', '2026-07-15', 9, 31), -- Salbutamol - LKM
('Losec', 'Cápsulas 20mg', 27000, 800, 'venta libre', '2026-05-20', 10, 3), -- Omeprazol - Roche
('Omeprazol', 'Tabletas 40mg', 2500, 700, 'venta libre', '2025-04-30', 10, 24), -- Omeprazol - Elea
('Vasotec 5', 'Tabletas 5mg', 15000, 800, 'receta', '2026-08-20', 11, 6), -- Enalapril - GlaxoSmithKline
('Vasotec 10', 'Tabletas 10mg', 16000, 650, 'receta', '2025-09-25', 11, 24), -- Enalapril - Elea
('Plavix 75', 'Tabletas 75mg', 35000, 900, 'receta', '2025-10-30', 12, 1), -- Clopidogrel - Pfizer
('Plavix 300', 'Tabletas 300mg', 34000, 850, 'receta', '2025-06-15', 12, 24), -- Clopidogrel - Elea
('Cozaar', 'Tabletas 50mg', 32000, 400, 'receta', '2026-04-10', 13, 4), -- Losartán - Novartis
('Lyrica', 'Cápsulas 75mg', 24000, 300, 'receta', '2025-12-20', 19, 4), -- Gabapentina - Novartis
('Sertraline', 'Tabletas 50mg', 15450, 450, 'receta', '2026-03-30', 18, 5), -- Sertralina - Sanofi
('Quetiapine', 'Tabletas 25mg', 35000, 600, 'receta', '2025-11-11', 20, 2), -- Quetiapina - Pfizer
('Amlodipine', 'Tabletas 5mg', 23000, 900, 'receta', '2026-06-10', 21, 4), -- Amlodipino - Novartis
('Phenobarbital', 'Tabletas 100mg', 15000, 550, 'receta', '2025-07-20', 22, 5), -- Fenitoína - Sanofi
('Furosemide', 'Tabletas 40mg', 17500, 750, 'receta', '2026-08-22', 23, 4), -- Furosemida - Boehringer Ingelheim
('Prednisone', 'Tabletas 5mg', 30000, 400, 'receta', '2025-10-28', 24, 2), -- Prednisona - Pfizer
('Levothyroxine', 'Tabletas 100mcg', 45000, 600, 'receta', '2026-07-15', 25, 4), -- Levotiroxina - Novartis
('Tamsulosin', 'Cápsulas 0.4mg', 20000, 500, 'receta', '2026-09-05', 26, 4), -- Tamsulosina - Boehringer Ingelheim
('Mometasone', 'Spray nasal 50mcg/dosis', 37000, 450, 'receta', '2025-12-31', 27, 4), -- Mometasona - Novartis
('Tramadol', 'Tabletas 50mg', 20000, 800, 'receta', '2026-01-20', 28, 5), -- Tramadol - Sanofi
('Duloxetine', 'Cápsulas 30mg', 29000, 700, 'receta', '2026-05-10', 29, 2), -- Duloxetina - Pfizer
('Venlafaxine', 'Tabletas 75mg', 40000, 650, 'receta', '2025-11-10', 30, 5), -- Venlafaxina - Sanofi
('Cetirizine', 'Tabletas 10mg', 32000, 400, 'venta libre', '2026-03-30', 31, 8), -- Cetirizina - Johnson & Johnson
('Naproxen', 'Tabletas 500mg', 41000, 500, 'venta libre', '2025-09-15', 32, 11), -- Naproxeno - Merck
('Chlorpheniramine', 'Jarabe 2mg/5ml', 39000, 300, 'venta libre', '2026-10-01', 33, 7), -- Clorfenamina - AstraZeneca
('Atenolol', 'Tabletas 50mg', 36000, 800, 'receta', '2026-04-10', 34, 4), -- Atenolol - Novartis
('Bupropion', 'Tabletas 150mg', 25000, 600, 'receta', '2026-05-22', 35, 2), -- Bupropión - Pfizer
('Codeine', 'Tabletas 30mg', 28000, 550, 'receta', '2026-02-01', 36, 5), -- Codeína - Sanofi
('Phenylephrine', 'Gotas nasales 0.25%', 27000, 450, 'venta libre', '2025-11-15', 37, 8), -- Fenilefrina - Johnson & Johnson
('Citalopram', 'Tabletas 20mg', 32000, 650, 'receta', '2025-10-30', 38, 5), -- Citalopram - Sanofi
('Rivaroxaban', 'Tabletas 20mg', 43000, 500, 'receta', '2026-01-20', 39, 2), -- Rivaroxabán - Pfizer
('Fluoxetine', 'Cápsulas 20mg', 14700, 750, 'receta', '2026-07-31', 40, 5), -- Fluoxetina - Sanofi
('Acarbose', 'Tabletas 50mg', 21000, 700, 'receta', '2026-03-05', 41, 2), -- Acarbosa - Pfizer
('Miconazole', 'Crema 2%', 4000, 600, 'venta libre', '2026-04-30', 42, 8), -- Miconazol - Johnson & Johnson
('Sildenafil', 'Tabletas 50mg', 55000, 300, 'receta', '2026-05-10', 43, 1), -- Sildenafil - Pfizer
('Propranolol', 'Tabletas 80mg', 42000, 800, 'receta', '2026-10-31', 44, 5), -- Propranolol - Sanofi
('Zolpidem', 'Tabletas 10mg', 25000, 650, 'receta', '2026-09-01', 45, 2), -- Zolpidem - Pfizer
('Risosetron', 'Inyectable 0.5mg/ml', 19000, 550, 'receta', '2025-12-31', 46, 2), -- Risosetron - Pfizer
('Lisinopril', 'Tabletas 10mg', 12350, 600, 'receta', '2025-05-01', 47, 6); -- Lisinopril - GlaxoSmithKline

INSERT INTO proveedor (nombre, direccion, telefono, email, CUIT, nacionalidad_id, provincia_id, ciudad_id) VALUES
  ('Farmacéutica del Sur', 'Av. San Martín 123, Bahía Blanca', '+54 291 456 7890', 'ventas@farmaciasdelsur.com.ar', '27-34567890-1', 1, 4, 6),
  ('Droguería Central', 'Av. Corrientes 4567, Buenos Aires', '+54 11 4321 5678', 'contacto@drogueriacentral.com.ar', '30-76543210-9', 1, 1, 1),
  ('Farmacia del Norte', 'Av. Colón 123, Salta', '+54 387 456 7890', 'info@farmacianorte.com.ar', '20-12345678-5', 1, 5, 4),
  ('Medicamentos Express', 'Av. Rivadavia 987, Mendoza', '+54 261 123 4567', 'pedidos@medicamentosexpress.com.ar', '33-87654321-6', 1, 4, 3),
  ('Farmacia Buenos Aires', 'Av. Santa Fe 1234, Buenos Aires', '+54 11 5555 6666', 'ventas@farmaciabuenosaires.com.ar', '27-98765432-1', 1, 1, 1),
  ('Droguería del Plata', 'Av. Belgrano 2345, La Plata', '+54 221 8765 4321', 'info@drogueriadelplata.com.ar', '30-23456789-0', 1, 1, 2);
-- Proveedor 1: 20 medicamentos
INSERT INTO proveedor_medicamento (proveedor_id, medicamento_laboratorio_id) VALUES 
(1, 1), (1, 2), (1, 3), (1, 5), (1, 6),
(1, 7), (1, 8), (1, 10), (1, 11), (1, 12),
(1, 14), (1, 16), (1, 20), (1, 22), (1, 24),
(1, 25), (1, 27), (1, 29), (1, 32), (1, 39),(1,52)
,(1,53);
-- Proveedor 2: 33 medicamentos
INSERT INTO proveedor_medicamento (proveedor_id, medicamento_laboratorio_id) VALUES 
(2, 4), (2, 9), (2, 13), (2, 15), (2, 17),
(2, 18), (2, 19), (2, 21), (2, 23), (2, 26),
(2, 28), (2, 30), (2, 31), (2, 33), (2, 35),
(2, 36), (2, 38), (2, 40), (2, 41), (2, 42),
(2, 43), (2, 44), (2, 46), (2, 47);

-- Proveedor 3: 19 medicamentos
INSERT INTO proveedor_medicamento (proveedor_id, medicamento_laboratorio_id) VALUES 
(3, 3), (3, 8), (3, 14), (3, 16), (3, 19),
(3, 20), (3, 21), (3, 24), (3, 25), (3, 26),
(3, 28), (3, 29), (3, 30), (3, 34), (3, 35),
(3, 39), (3, 42), (3, 46),(3,51);

-- Proveedor 4: 27 medicamentos
INSERT INTO proveedor_medicamento (proveedor_id, medicamento_laboratorio_id) VALUES 
(4, 1), (4, 2), (4, 5), (4, 6), (4, 7),
(4, 10), (4, 12), (4, 13), (4, 15), (4, 18),
(4, 22), (4, 25), (4, 27), (4, 32), (4, 33),
(4, 36), (4, 37), (4, 38), (4, 39), (4, 40),
(4, 41), (4, 42), (4, 43), (4, 44), (4, 45),
(4, 49);
-- Proveedor 5: 10 medicamentos
INSERT INTO proveedor_medicamento (proveedor_id, medicamento_laboratorio_id) VALUES 
(5, 9), (5, 14), (5, 15), (5, 19), (5, 24),
(5, 26), (5, 27), (5, 28), (5, 41),(5, 48),(5,50),(5,54);

INSERT INTO compra(compra_id, numero_comprobante, fecha_compra, total, proveedor_id) VALUES
(1,'FC-2024-001', '2024-08-14', 997000, 2),
(2,'FC-2024-004', '2024-09-21', 800000, 2),
(3,'FC-2024-003', '2024-07-30', 809000, 4),
(4,'FC-2024-002', '2024-06-15', 557000, 4),
(5,'FC-2024-005', '2024-10-02', 308400, 5),
(6,'FC-2024-006', '2024-10-10', 252500, 1),
(7,'FC-2024-007', '2024-09-05', 113400, 3),
(8,'FC-2024-008', '2024-09-29', 349000, 1);


-- compras al proveedor 2
INSERT INTO detalle_compra(cantidad, precio_unitario, precio_total, compra_id, medicamento_laboratorio_id) VALUES
(5,2500,12500,1,19),(10,22000,220000,1,15),(7,23000,161000,1,17),(30,3350,100500,1,4),
(4,23000,92000,1,28),(8,29000,232000,1,36),(5,27000,135000,1,44),(3,14700,44100,1,47);
INSERT INTO detalle_compra(cantidad, precio_unitario, precio_total, compra_id, medicamento_laboratorio_id) VALUES
(1,28000,28000,2,43),(4,15450,61800,2,26),(4,17500,70000,2,30);

-- compras al proveedor 4
INSERT INTO detalle_compra(cantidad, precio_unitario, precio_total, compra_id, medicamento_laboratorio_id) VALUES
(6,16500,99000,3,13),(8,35000,280000,3,22),(10,35000,350000,3,27),
(2,40000,80000,3,37);

INSERT INTO detalle_compra(cantidad, precio_unitario, precio_total, compra_id, medicamento_laboratorio_id) VALUES
(6,21000,126000,4,6),(4,31000,124000,4,7),
(1,3200,64000,4,1),(9,27000,243000,4,18);

-- compra al proveedor 5
INSERT INTO detalle_compra(cantidad, precio_unitario, precio_total, compra_id, medicamento_laboratorio_id) VALUES
(6,13500,81000,5,9),(2,36000,72000,5,41),
(3,23000,69000,5,28),(7,12350,86400,5,54);

-- compra al proveedor 1
INSERT INTO detalle_compra(cantidad, precio_unitario, precio_total, compra_id, medicamento_laboratorio_id) VALUES
(6,31000,186000,6,7),(2,17500,35000,6,12),
(3,10500,31500,6,11);
-- compra al proveedor 3
INSERT INTO detalle_compra(cantidad, precio_unitario, precio_total, compra_id, medicamento_laboratorio_id) VALUES
(6,3800,11400,7,3),(2,21000,42000,7,16),
(3,20000,60000,7,35);
-- compra al proveedor 1
INSERT INTO detalle_compra(cantidad, precio_unitario, precio_total, compra_id, medicamento_laboratorio_id) VALUES
(6,15000,90000,8,20),(2,32000,64000,8,24),
(3,21000,63000,8,6),(3,10500,31500,8,11),(5,25000,63000,8,52),(2,19000,38000,8,53);


INSERT INTO stock_farmacia (nombre, presentacion, precio_unitario, cantidad, tipo, fecha_de_vencimiento, medicamento_laboratorio_id)
VALUES 
  ('Tylenol', 'Tabletas 500mg', 3872, 100, 'venta libre', '2025-07-31', 1), -- Paracetamol - Denver Farma
  ('Advil', 'Cápsulas blandas 400mg', 5445, 85, 'venta libre', '2024-11-30', 2), -- Ibuprofeno - Bagó
  ('Brufen', 'Cápsulas 600mg', 4598, 18, 'venta libre', '2024-08-15', 3), -- Ibuprofeno - Bernabó
  ('Aspirina', 'Tabletas 500mg', 4053, 120, 'venta libre', '2026-01-30', 4), -- Aspirina - Bayer
  ('Amoxil', 'Suspensión 250mg/5ml', 21780, 60, 'receta', '2025-06-20', 5), -- Amoxicilina - Richmond
  ('Amoxil', 'Cápsulas 500mg', 25200, 70, 'receta', '2025-12-10', 6), -- Amoxicilina - Pfizer (precio ajustado)
  ('Cipro', 'Tabletas 500mg', 37200, 50, 'receta', '2026-09-15', 7), -- Ciprofloxacino - Pfizer (precio ajustado)
  ('Claritin', 'Tabletas 10mg', 14400, 75, 'venta libre', '2025-05-30', 8), -- Loratadina - Johnson & Johnson (precio ajustado)
  ('Loramax', 'Jarabe 5mg/5ml', 16200, 40, 'venta libre', '2025-10-25', 9), -- Loratadina - Gador (precio ajustado)
  ('Glucophage', 'Tabletas 500mg', 11400, 60, 'receta', '2024-12-01', 10), -- Metformina - GlaxoSmithKline (precio ajustado)
  ('Glucophage', 'Tabletas 850mg', 12600, 80, 'receta', '2025-03-15', 11), -- Metformina - Montpellier (precio ajustado)
  ('Zocor', 'Tabletas 40mg', 21000, 45, 'receta', '2026-02-18', 12), -- Simvastatina - Bayer (precio ajustado)
  ('Zocor', 'Tabletas 10mg', 19800, 30, 'receta', '2024-09-10', 13), -- Simvastatina - Richmond (precio ajustado)
  ('Zocor', 'Tabletas 20mg', 18600, 50, 'receta', '2025-11-22', 14), -- Simvastatina - Kemex (precio ajustado)
  ('Ventolin', 'Inhalador 100 mcg/dosis', 26400, 55, 'receta', '2026-03-05', 15), -- Salbutamol - AstraZeneca (precio ajustado)
  ('Salbutamol', 'Jarabe 2mg/5ml', 25200, 65, 'receta', '2025-10-05', 16), -- Salbutamol - Bagó (precio ajustado)
  ('Salbutamol', 'Inhalador 200 mcg/dosis', 27600, 50, 'receta', '2026-07-15', 17), -- Salbutamol - LKM (precio ajustado)
  ('Losec', 'Cápsulas 20mg', 32400, 80, 'venta libre', '2026-05-20', 18), -- Omeprazol - Roche (precio ajustado)
  ('Omeprazol', 'Tabletas 40mg', 3000, 70, 'venta libre', '2025-04-30', 19), -- Omeprazol - Elea (precio ajustado)
  ('Vasotec', 'Tabletas 5mg', 18000, 80, 'receta', '2026-08-20', 20), -- Enalapril - GlaxoSmithKline (precio ajustado)
  ('Vasotec', 'Tabletas 10mg', 19200, 65, 'receta', '2025-09-25', 21), -- Enalapril - Elea (precio ajustado)
  ('Plavix', 'Tabletas 75mg', 42000, 90, 'receta', '2025-10-30', 22), -- Clopidogrel - Pfizer (precio ajustado)
  ('Plavix', 'Tabletas 300mg', 40800, 85, 'receta', '2025-06-15', 23), -- Clopidogrel - Elea (precio ajustado)
  ('Cozaar', 'Tabletas 50mg', 38400, 40, 'receta', '2026-04-10', 24), -- Losartán - Novartis (precio ajustado)
  ('Lyrica', 'Cápsulas 75mg', 28800, 30, 'receta', '2025-12-20', 25), -- Gabapentina - Novartis (precio ajustado)
  ('Sertraline', 'Tabletas 50mg', 18540, 45, 'receta', '2026-03-30', 26), -- Sertralina - Sanofi (precio ajustado)
  ('Quetiapine', 'Tabletas 25mg', 42000, 60, 'receta', '2025-11-11', 27), -- Quetiapina - Pfizer (precio ajustado)
  ('Amlodipine', 'Tabletas 5mg', 27600, 90, 'receta', '2026-06-10', 28), -- Amlodipino - Novartis (precio ajustado)
  ('Phenobarbital', 'Tabletas 100mg', 18000, 55, 'receta', '2025-07-20', 29), -- Fenitoína - Sanofi (precio ajustado)
  ('Furosemide', 'Tabletas 40mg', 21000, 75, 'receta', '2026-08-22', 30), -- Furosemida - Boehringer Ingelheim (precio ajustado)
  ('Prednisone', 'Tabletas 5mg', 36000, 40, 'receta', '2025-10-28', 31), -- Prednisona - Pfizer (precio ajustado)
  ('Levothyroxine', 'Tabletas 100mcg', 54000, 60, 'receta', '2026-07-15', 32), -- Levotiroxina - Novartis (precio ajustado)
  ('Tamsulosin', 'Cápsulas 0.4mg', 24000, 50, 'receta', '2026-09-05', 33), -- Tamsulosina - Boehringer Ingelheim (precio ajustado)
  ('Mometasone', 'Spray nasal 50mcg/dosis', 44400, 45, 'receta', '2025-12-31', 34), -- Mometasona - Novartis (precio ajustado)
  ('Tramadol', 'Tabletas 50mg', 24000, 80, 'receta', '2026-01-20', 35), -- Tramadol - Sanofi (precio ajustado)
  ('Duloxetine', 'Cápsulas 30mg', 34800, 70, 'receta', '2026-05-10', 36), -- Duloxetina - Pfizer (precio ajustado)
  ('Venlafaxine', 'Tabletas 75mg', 48000, 65, 'receta', '2025-11-10', 37), -- Venlafaxina - Sanofi (precio ajustado)
  ('Cetirizine', 'Tabletas 10mg', 38400, 40, 'venta libre', '2026-03-30', 38), -- Cetirizina - Johnson & Johnson (precio ajustado)
  ('Naproxen', 'Tabletas 500mg', 49200, 50, 'venta libre', '2025-09-15', 39), -- Naproxeno - Merck (precio ajustado)
  ('Chlorpheniramine', 'Jarabe 2mg/5ml', 46800, 30, 'venta libre', '2026-10-01', 40), -- Clorfenamina - AstraZeneca (precio ajustado)
  ('Atenolol', 'Tabletas 50mg', 43200, 80, 'receta', '2026-04-10', 41), -- Atenolol - Novartis (precio ajustado)
  ('Bupropion', 'Tabletas 150mg', 30000, 60, 'receta', '2026-05-22', 42), -- Bupropión - Pfizer (precio ajustado)
  ('Codeine', 'Tabletas 30mg', 33600, 55, 'receta', '2026-02-01', 43), -- Codeína - Sanofi (precio ajustado)
  ('Phenylephrine', 'Gotas nasales 0.25%', 32400, 45, 'venta libre', '2025-11-15', 44), -- Fenilefrina - Johnson & Johnson (precio ajustado)
  ('Citalopram', 'Tabletas 20mg', 38400, 65, 'receta', '2025-10-30', 45), -- Citalopram - Sanofi (precio ajustado)
  ('Rivaroxaban', 'Tabletas 20mg', 51600, 50, 'receta', '2026-01-20', 46), -- Rivaroxabán - Pfizer (precio ajustado)
  ('Fluoxetine', 'Cápsulas 20mg', 17640, 75, 'receta', '2026-07-31', 47), -- Fluoxetina - Sanofi (precio ajustado)
  ('Acarbose', 'Tabletas 50mg', 25200, 70, 'receta', '2026-03-05', 48), -- Acarbosa - Pfizer (precio ajustado)
  ('Miconazole', 'Crema 2%', 4800, 60, 'venta libre', '2026-04-30', 49), -- Miconazol - Johnson & Johnson (precio ajustado)
  ('Sildenafil', 'Tabletas 50mg', 66000, 30, 'receta', '2026-05-10', 50), -- Sildenafil - Pfizer (precio ajustado)
  ('Propranolol', 'Tabletas 80mg', 50400, 80, 'receta', '2026-10-31', 51), -- Propranolol - Sanofi (precio ajustado)
  ('Zolpidem', 'Tabletas 10mg', 30000, 65, 'receta', '2026-09-01', 52), -- Zolpidem - Pfizer (precio ajustado)
  ('Risosetron', 'Inyectable 0.5mg/ml', 22800, 55, 'receta', '2025-12-31', 53), -- Risosetron - Pfizer (precio ajustado)
  ('Lisinopril', 'Tabletas 10mg', 14820, 60, 'receta', '2025-05-01', 54); -- Lisinopril - GlaxoSmithKline (precio ajustado)

INSERT INTO genero (genero) VALUES ('Masculino'), ('Femenino');

INSERT INTO prepaga (razon_social, CUIT, direccion) VALUES 
('Galeno Salud S.A.', '20-12345678-9', 'Av. Libertador 1234, Buenos Aires'),
('Omint S.A.', '30-23456789-0', 'Calle Tucumán 4567, Buenos Aires'),
('Swiss Medical S.A.', '20-34567890-1', 'Av. Corrientes 890, Buenos Aires'),
('Federación Patronal S.A.', '30-45678901-2', 'Calle Belgrano 135, La Plata');

INSERT INTO plan_prepaga (plan, prepaga_id) VALUES 
('Plan Familiar', 1),
('Plan Individual', 1),
('Plan Estándar', 2),
('Plan Premium', 2),
('Plan Completo', 3),
('Plan Básico', 3),
('Plan Senior', 4),
('Plan Especial', 4);

INSERT INTO obra_social (razon_social, CUIT, direccion) VALUES 
('Obra Social de los Trabajadores de la Sanidad', '20-11223344-5', 'Av. San Juan 5678, Buenos Aires'),
('Obra Social Unión Personal', '30-22334455-6', 'Calle Rivadavia 123, Buenos Aires'),
('Obra Social de la Industria de la Construcción', '20-33445566-7', 'Calle Salta 456, Córdoba'),
('Obra Social del Personal de la Administración Pública', '30-44556677-8', 'Av. de Mayo 789, Buenos Aires');

INSERT INTO plan_obra_social (plan, obra_social_id) VALUES 
('Plan Integral de Salud', 1),
('Plan Materno Infantil', 1),
('Plan de Emergencia', 2),
('Plan Básico', 2),
('Plan de Rehabilitación', 3),
('Plan Odontológico', 3),
('Plan Adultos Mayores', 4),
('Plan Prevención', 4);

INSERT INTO cliente (nombre, apellido, telefono, direccion, EMAIL, dni, fecha_nacimiento, numero_afiliado, obra_social_id, prepaga_id, nacionalidad_id, provincia_id, ciudad_id, partido_id, genero_id) VALUES  
('Luciano', 'Pérez', '011-5555-1011', 'Av. Santa Fe 1500, Buenos Aires', 'luciano.perez@example.com', '20-12345678', '1985-06-10', 'AF-101', 1, null, 1, 1, 1, 1, 1),  
('Valeria', 'Mendoza', '011-5555-2022', 'Calle Rincón 250, La Plata', 'valeria.mendoza@example.com', '20-6512389', '1990-05-15', 'AF-102', NULL, 4, 1, 1, 1, 2, 2),  
('Rafael', 'Sánchez', '011-5555-3033', 'Av. Independencia 1000, Barracas', 'rafael.sanchez@example.com', '20-34567890', '1988-03-20', 'AF-103', 2, NULL, 1, 1, 1, 3, 1),  
('Camila', 'García', '011-5555-4044', 'Calle San Luis 1200, Mataderos', 'camila.garcia@example.com', '20-45678901', '1992-01-10', 'AF-104', 3, NULL, 1, 1, 1, 4, 2),  
('Fernando', 'Belloni', '011-5555-5055', 'Calle Libertador 1200, Vicente López', 'fernando.belloni@example.com', '20-56736212', '1980-11-30', 'AF-105', NULL, 3, 1, 1, 1, 5, 1),  
('Isabella', 'López', '011-5555-6066', 'Av. Cabildo 2000, Recoleta', 'isabella.lopez@example.com', '20-67890123', '1995-10-18', 'AF-106', 2, NULL, 1, 1, 1, 6, 2),  
('Jorge', 'Ramírez', '011-5555-7077', 'Calle Suipacha 750, San Telmo', 'jorge.ramirez@example.com', '20-78901234', '1983-07-22', 'AF-107', NULL, 1, 1, 1, 1, 7, 1),  
('Milagros', 'Vera', '011-5555-8088', 'Av. Santa Fe 2500, Palermo', 'milagros.vera@example.com', '20-89012345', '1991-12-25', 'AF-108', 2, NULL, 1, 1, 1, 8, 2),  
('Diego', 'Alvarez', '011-5555-9099', 'Calle Corrientes 1500, Balvanera', 'diego.alvarez@example.com', '20-93522456', '1987-09-30', 'AF-109', NULL, 1, 1, 1, 1, 9, 1),  
('Jazmín', 'Ruiz', '011-5555-1001', 'Calle del Parque 500, Villa Crespo', 'jazz.ruiz@example.com', '20-0163567', '1997-04-15', 'AF-110', 4, NULL, 1, 1, 1, 10, 2),  
('Alejandro', 'Torres', '011-5555-1111', 'Av. San Martín 2000, San Martín', 'alejandro.torres@example.com', '20-64267868', '1982-08-20', 'AF-111', NULL, 4, 1, 1, 1, 11, 1),  
('Florencia', 'Giménez', '011-5555-1222', 'Calle 9 de Julio 400, Tres de Febrero', 'florencia.gimenez@example.com', '20-23456789', '1990-07-22', 'AF-112', 2, NULL, 1, 1, 1, 12, 2),  
('Santiago', 'Fernández', '011-5555-1333', 'Av. Libertador 1000, Vicente López', 'santiago.fernandez@example.com', '20-53567890', '1985-11-10', 'AF-113', NULL, 3, 1, 1, 1, 13, 1),  
('Ana', 'Díaz', '011-5555-1444', 'Calle Sarmiento 600, San Isidro', 'ana.diaz@example.com', '20-43568901', '1992-05-10', 'AF-114', 3, NULL, 1, 1, 1, 14, 2),  
('Marcelo', 'López', '011-5555-1555', 'Av. Blandengues 1200, Luján', 'marcelo.lopez@example.com', '20-56789012', '1980-10-15', 'AF-115', NULL, 2, 1, 1, 1, 15, 1),  
('Eva', 'Martínez', '011-5555-1666', 'Calle Moreno 1000, Moreno', 'eva.martinez@example.com', '20-66590123', '1995-06-20', 'AF-116', 2, NULL, 1, 1, 1, 16, 2),  
('Hernán', 'González', '011-5555-1777', 'Av. Mitre 1500, Ituzaingó', 'hernan.gonzalez@example.com', '20-78926523', '1982-09-20', 'AF-117', NULL, 1, 1, 1, 1, 17, 1),  
('Virginia', 'Rodríguez', '011-5555-1888', 'Calle Belgrano 1200, Morón', 'virginia.rodriguez@example.com', '20-89026545', '1988-04-10', 'AF-118', 4, NULL, 1, 1, 1, 18, 2),  
('Luis', 'Fernández', '011-5555-1999', 'Av. Rivadavia 2000, Merlo', 'luis.fernandez@example.com', '20-90123456', '1985-03-15', 'AF-119', NULL, 3, 1, 1, 1, 19, 1),  
('Gabriela', 'Suárez', '011-5555-2000', 'Calle España 1000, La Matanza', 'gabriela.suarez@example.com', '20-01215567', '1990-02-20', 'AF-120', 2, NULL, 1, 1, 1, 20, 2),  
('Daniel', 'Rivera', '011-5555-2111', 'Av. San Martín 2500, Pilar', 'daniel.rivera@example.com', '20-16513678', '1987-01-10', 'AF-121', NULL, 1, 1, 1, 1, 21, 1),  
('Rocío', 'Gómez', '011-5555-2222', 'Calle Sarmiento 800, Escobar', 'rocio.gomez@example.com', '20-2265789', '1994-12-15', 'AF-122', 1, NULL, 1, 1, 1, 22, 2);  

INSERT INTO medico (nombre, apellido, matricula) VALUES  
('Léon', 'Dupont', '19342-MN'),  
('Sofia', 'Kuznetsova', '21432-MN'),  
('Kai', 'Wang', '18976-MN'),  
('Luna', 'Moretti', '20193-MN'),  
('Cameron', 'MacDonald', '22104-MN'),  
('Leila', 'Hassan', '20865-MN'),  
('Mateo', 'Ramos', '19892-MN'),  
('Astrid', 'Larsson', '21567-MN'),  
('Rohan', 'Patel', '20432-MN'),  
('Eva', 'Muller', '19023-MN'),  
('Jian', 'Li', '20987-MN')
,('Liam', 'O''Connor', '22012-MN'),  
('Nina', 'Ivanova', '20654-MN'),  
('Finn', 'Jensen', '21298-MN'),  
('Rebecca', 'Taylor', '20793-MN');  

INSERT INTO personal (nombre, apellido, telefono, direccion, EMAIL, dni, fecha_nacimiento, partido_id, provincia_id) VALUES  
('Lorenzo', 'Rossi', '011-5555-1234', 'Calle 123, Buenos Aires', 'lorenzo.rossi@example.com', '20-12345678', '1980-01-01', 1, 1),  
('Sofía', 'González García', '011-5555-5678', 'Av. Rivadavia 1234, Buenos Aires', 'sofia.gonzalez@example.com', '30-90123456', '1990-06-15', 2, 1),  
('Gabriele', 'Esposito', '011-5555-9012', 'Calle Corrientes 456, Buenos Aires', 'gabriele.esposito@example.com', '20-11111111', '1985-03-20', 3, 1),  
('Lucía', 'Fernández López', '011-5555-1111', 'Av. Libertador 789, Buenos Aires', 'lucia.fernandez@example.com', '30-22222222', '1992-09-10', 4, 1),  
('Marcello', 'Romano', '011-5555-4444', 'Calle Uruguay 123, Buenos Aires', 'marcello.romano@example.com', '20-33333333', '1982-05-01', 5, 1);  

INSERT INTO venta(comprobante, fecha_venta, cliente_id, personal_id)  
VALUES  
('VT-001', '2024-04-10', 5, 3),  
('VT-005', '2024-02-24', 10, 1),  
('VT-011', '2024-08-12', 7, 2),  
('VT-020', '2024-09-07', 16, 1),  
('VT-003', '2024-05-13', 20, 4),  
('VT-002', '2024-06-02', 1, 2),  
('VT-018', '2024-07-18', 6, 5);  

INSERT INTO receta (numero_receta, fecha_receta, cliente_id, medico_id)  
VALUES  
('R-001', '2024-02-24', 1, 3),  
('R-002', '2024-02-24', 2, 4),  
('R-014', '2024-08-11', 4, 13),  
('R-015', '2024-08-12', 5, 11),  
('R-006', '2024-05-06', 6, 8),  
('R-010', '2024-06-02', 7, 9),  
('R-019', '2024-07-18', 8, 11),  
('R-021', '2024-07-18', 9, 9),  
('R-011', '2024-06-02', 10, 6),  
('R-007', '2024-05-13', 11, 1),  
('R-023', '2024-09-07', 12, 2),  
('R-024', '2024-09-07', 13, 4),  
('R-020', '2024-07-18', 14, 5),  
('R-004', '2024-07-18', 3, 7),  
('R-025', '2024-02-24', 1, 3),  
('R-026', '2024-02-24', 2, 4),  
('R-027', '2024-08-11', 4, 13);  

INSERT INTO detalle_venta ( cantidad,stock_farmacia_id ,precio_unitario, venta_id, receta_id) values 
(1,1,3872,1,null),(1,19,3000,1,null),(1,30,21000,2,1),(1,25,28800,2,2),(1,26,18540,2,3),
(1,35,24000,3,14),(2,2,5445,3,null),(2,11,12600,3,4),(2,43,33600,4,5),(1,51,50400,4,6),
(1,42,30000,4,7),(1,28,27600,5,8),(1,27,42000,6,9),(1,30,21000,6,10),(1,34,24000,6,11),
(3,18,32400,6,null),(1,15,26400,6,12),(1,7,20000,7,13);




select* from cliente;
select * from stock_farmacia;
select * from detalle_compra WHERE compra_id = 2;
select * from compra;
select * from detalle_compra;
select * from proveedor;
select * from proveedor_medicamento;
select * from farmaco;
select * from laboratorio;
select * from medicamento_laboratorio;


-- detalle_compra_proveedores permite visualizar todos los  detalles de la compra que se realicen a los proveedores.
-- Ademas, se mostrara el numero de comprobante asociado a cada compra, el nombre del medicamento y su presentacion desde la tabla medicamento_laboratorio
-- y los proveedores a los cuales se les ha efectuado la compra.
CREATE VIEW detalle_compra_proveedores AS
SELECT 
    c.compra_id AS "ID de compra",
    c.numero_comprobante AS "Comprobante",
    m.nombre AS "Medicamento",
    m.presentacion AS 'Presentacion',
    d.cantidad AS "Cantidad",
    d.precio_unitario AS "Precio Unitario",
    d.precio_total AS "Precio Total",
    p.nombre AS "Proveedor"
FROM 
    detalle_compra d
INNER JOIN compra c ON c.compra_id = d.compra_id
INNER JOIN medicamento_laboratorio m ON d.medicamento_laboratorio_id = m.medicamento_laboratorio_id
INNER JOIN proveedor p ON c.proveedor_id = p.proveedor_id 
ORDER BY c.numero_comprobante;

select * from detalle_compra_proveedores;

-- Esta vista permite visualizar todos los datos de la tabla medicamento_laboratorio, mostrando asi su nombre, presentacion, 
-- farmaco, laboratorio, precio unitario, cantidad disponible, si es venta libre o con receta, su fecha de vencimiento y el proveedor. 
-- Traemos el nombre del farmaco, del laboratorio y del proveedor asociado a cada medicamento mediante los id que tienen en comun con la tabla medicamentos_laboratorios
-- ordenandola por el id de la misma.
CREATE VIEW medicamentos_laboratorios AS
SELECT
	m.medicamento_laboratorio_id AS 'Medicamento ID',
	m.nombre as 'Nombre',
    m.presentacion as 'Presentacion',
    f.nombre as 'Farmaco',
    l.nombre as 'Laboratorio',
    m.precio_unitario as 'Precio Unitario',
    m.cantidad_disponible as 'Cantidad Disponible',
    m.tipo as 'Receta/Venta Libre',
    m.fecha_vencimiento as 'Fecha de Vencimiento',
    proveedor.nombre as "Proveedor"
FROM 
	medicamento_laboratorio m
LEFT JOIN farmaco f ON m.farmaco_id = f.farmaco_id
LEFT JOIN laboratorio l ON m.laboratorio_id = l.laboratorio_id
LEFT JOIN proveedor_medicamento p ON m.medicamento_laboratorio_id = p.medicamento_laboratorio_id
LEFT JOIN proveedor proveedor ON proveedor.proveedor_id = p.proveedor_id
ORDER BY m.medicamento_laboratorio_id ASC;

select * from  medicamentos_laboratorios;
Drop view medicamentos_laboratorios;


-- Vista venta_detallada permite visualizar los datos de las ventas realizadas a los clientes. Ordenada mediante venta_id de la tabla venta, podremos observar 
-- el comprobante,cantidad y precio_unitario de la tabla detalle_venta, nombre y apellido de la tabla cliente , medicamento y presentacion de la tabla stock_farmacia
-- nombre y apellido de la tabla personal.
CREATE VIEW venta_detallada AS
SELECT 
	d.venta_id as "ID venta",
    v.comprobante as "Comprobante",
    c.nombre as "Nombre del cliente",
    c.apellido as "Apellido del Cliente",
    s.nombre as "Medicamento",
    s.presentacion as "Presentacion",
    COALESCE(r.numero_receta, 'Venta Libre') AS "Número de Receta", 
    d.cantidad as "Cantidad",
    d.precio_unitario as "Precio Unitario",
    p.nombre as "Nombre del personal",
    p.apellido as "Apellido del personal"
FROM detalle_venta d
	LEFT JOIN venta v ON d.venta_id = v.venta_id
	LEFT JOIN receta r ON r.receta_id = d.receta_id
    LEFT JOIN stock_farmacia s ON s.stock_farmacia_id = d.stock_farmacia_id
	LEFT join personal p ON p.personal_id = v.personal_id
    LEFT JOIN cliente c ON v.cliente_id = c.cliente_id
ORDER BY d.venta_id ASC;

select * from  venta_detallada;
-- La vista clientes_detalles presenta la informacion completa de los clientes. Nombre, apellido, telofono, direccion, email, DNI, fecha de nacimiento y numero de afiliado 
-- de la tabla cliente que obra social o prepaga tienen, nacionalidad, provincia, ciudad, partido y genero de cada uno de las tablas.
CREATE VIEW clientes_detalles AS 
SELECT 
	c.nombre AS "Nombre",
    c.apellido as "Apellido",
    c.telefono as "Telefono",
    c.direccion as "Direccion",
    c.EMAIL as "Email",
    c.dni  as "DNI",
    c.fecha_nacimiento as "Fecha Nacimiento",
    COALESCE(o.razon_social, "SIN COBERTURA") as "Obra Social",
    COALESCE(p.razon_social, "SIN COBERTURA") as "Prepaga", 
    c.numero_afiliado as "Numero de Afiliado",
    n.nombre as "Nacionalidad",
    provincia.nombre as "Provincia",
    ciudad.nombre as "Ciudad",
    partido.nombre as "Partido",
    g.genero as "Genero"

FROM cliente c
	LEFT JOIN obra_social o ON c.obra_social_id = o.obra_social_id
    LEFT JOIN prepaga p ON p.prepaga_id = c.prepaga_id
    LEFT JOIN nacionalidad n ON c.nacionalidad_id = n.nacionalidad_id
    LEFT JOIN provincia provincia ON provincia.provincia_id = c.provincia_id
    LEFT JOIN ciudad ciudad ON ciudad.ciudad_id = c.ciudad_id
    LEFT JOIN partido partido ON partido.partido_id = c.partido_id
    LEFT JOIN genero g ON g.genero_id = c.genero_id
ORDER BY cliente_id DESC;

select * from clientes_detalles;

select * from medicamento_laboratorio;
select * from compra;
select * from detalle_compra;
CALL insertar_compra(9, "FC-2024-009", "2024-11-15", 3, '3, 4, 6, 6', 'Aspirina, Cipro, Codeine, Tylenol');

/*Procedimiento para ingresar las compras y los detalles por comprobante, compra id, fecha_compra, proveedor, la cantidad y los medicamentos*/
DROP PROCEDURE IF EXISTS insertar_compra;
DELIMITER //

CREATE PROCEDURE insertar_compra(
	IN i_compra_id INT,
	IN i_numero_comprobante VARCHAR(50),
    IN i_fecha_compra DATETIME,
    IN i_proveedor_id INT,
    IN i_cantidad VARCHAR(100), 
    IN i_nombres VARCHAR(1000)
)
BEGIN 
	DECLARE delimitador CHAR(1) DEFAULT ',';
    DECLARE error_message VARCHAR(100);
    DECLARE medicamento_id INT;
    DECLARE precio_unitario DECIMAL(10, 2);
    DECLARE precio_total DECIMAL(10, 2);
    DECLARE total_proveedor_id INT;
    DECLARE total_compra_id INT;
    DECLARE total_compras INT;
    

    /*Validar que los valores no sean nulos o negativos si corresponde*/
IF i_cantidad <= 0 THEN
	SET error_message = 'La cantidad de la compra de medicamentos debe ser mayor que cero';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
END IF;


IF i_compra_id <= 0 THEN
	SET error_message = 'El id de compra debe ser mayor que cero';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
END IF;
    
    /* Validar que los valores no sean nulos o negativos si corresponde */  
    IF i_proveedor_id <= 0 THEN  
        SET error_message = 'El id del proveedor debe ser mayor a 1';  
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;  
    END IF;  

    SELECT MAX(proveedor_id)  
    INTO total_proveedor_id  
    FROM proveedor;  

    IF i_proveedor_id >= total_proveedor_id THEN  
        SET error_message = CONCAT('El id del proveedor debe ser menor a ', total_proveedor_id);   
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;  
    END IF;  

    IF i_compra_id <= 0 THEN  
        SET error_message = 'El id de compra debe ser mayor que cero';  
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;  
    END IF;  

   SELECT MAX(compra_id)  
	INTO  total_compra_id
    FROM compra;  

    IF i_compra_id <= total_compra_id THEN  
        SET error_message = CONCAT('El id de la compra debe ser mayor a ', total_compra_id + '. Si usted desea actualizar datos de tabla compra utilice procedimiento insertar_compra.');   
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;  
    END IF;  
    
	INSERT INTO compra(compra_id, numero_comprobante, fecha_compra, total, proveedor_id)   
	VALUES(i_compra_id, i_numero_comprobante, i_fecha_compra, 0, i_proveedor_id);
    
    SET @compra_id = i_compra_id;
    
 -- Dividir la cadena de nombres y realizar inserciones en detalle_compra  
    WHILE CHAR_LENGTH(i_nombres) > 0 DO  
    
        SET @nombre = TRIM(SUBSTRING_INDEX(TRIM(i_nombres), delimitador, 1)); -- Obtener el primer nombre y eliminar espacios
		SET i_nombres = TRIM(SUBSTRING(i_nombres, CHAR_LENGTH(@nombre) + 2)); -- Remover el nombre de la cadena y eliminar espacios

		-- obtener la primera cantidad como INT
		SET @cantidad = CAST(SUBSTRING_INDEX(TRIM(i_cantidad), delimitador, 1) AS UNSIGNED);  
		-- remover la cantidad de la cadena
		SET i_cantidad = TRIM(SUBSTRING(i_cantidad, CHAR_LENGTH(CAST(@cantidad AS CHAR)) + 2));  
	  
		-- Mostrar el nombre que se busca  
		SELECT @nombre AS nombre_busqueda;  

		-- Obtener el medicamento y su precio unitario  
		select ml.medicamento_laboratorio_id, ml.precio_unitario
		into @medicamento_laboratorio_id, @precio_unitario
		from medicamento_laboratorio as ml
		where TRIM(ml.nombre) = @nombre;
        
        
        -- Verificar si el precio_unitario es NULL  
        IF @precio_unitario IS NULL THEN  
            SET error_message = CONCAT('No se encontró el medicamento: ', @nombre);  
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;  
        END IF;  

        -- Calcular el precio total  
        SET @precio_total = @cantidad * @precio_unitario;  

        -- Insertar en detalle_compra  
        INSERT INTO detalle_compra (cantidad, precio_unitario, precio_total, compra_id, medicamento_laboratorio_id)  
        VALUES (@cantidad, @precio_unitario, @precio_total, @compra_id, @medicamento_laboratorio_id);  
    END WHILE;  
	
    
    
    SET total_compras = calcular_total_compra(@compra_id);  

	UPDATE compra
    SET total = total_compras
    WHERE compra_id = @compra_id;


END //

DELIMITER ;    












/*Stored Procedure para insertar los detalles de manera mas automatizada de las compras a proveedores. 
Se puede utilizar select * from medicamento_laboratorio para consultar los nombres de los medicamentos, el nombre debe estar escritos igual que en la tabla medicamento_labotario.
*/

DROP FUNCTION IF EXISTS obtener_precio_unitario;

DELIMITER $$
CREATE FUNCTION obtener_precio_unitario(o_medicamento_id INT)
RETURNS DECIMAL(10, 2)

-- TIPOS DE FUNCIONES 
-- READS SQL DATA
-- NO SQL 
DETERMINISTIC 
-- NO DETERMINISTIC

BEGIN
    DECLARE precio_unitario DECIMAL(10, 2);
	SELECT ml.precio_unitario into precio_unitario
    FROM medicamento_laboratorio AS ml
    WHERE ml.medicamento_laboratorio_id = o_medicamento_id;
    
    RETURN precio_unitario; 
END $$
DELIMITER ;


DROP PROCEDURE if exists insertar_detalle_compra;
DELIMITER $$
CREATE PROCEDURE insertar_compra(
	IN i_cantidad INT, 
    IN i_compra_id INT,
    IN i_nombre VARCHAR(255)
    
) 
BEGIN
	DECLARE precio_unitario DECIMAL(10, 2);
    DECLARE precio_total DECIMAL(10, 2);
    DECLARE error_message VARCHAR(255);
    DECLARE total_compra_id DECIMAL(10, 2);
    DECLARE total_medicamento_ids DECIMAL(10, 2);
    DECLARE i_medicamento_laboratorio_id INT;
    DECLARE existe_compra INT;
/*Validar que los valores no sean nulos o negativos si corresponde*/
IF i_cantidad <= 0 THEN
	SET error_message = 'La cantidad de la compra de medicamentos debe ser mayor que cero';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
END IF;

IF i_compra_id <= 0 THEN
	SET error_message = 'El id de compra debe ser mayor que cero';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
END IF;

/*Seleccionamos el id que coincida con el nombre ingresado para luego obtener el precio*/
select ml.medicamento_laboratorio_id
into i_medicamento_laboratorio_id
from medicamento_laboratorio as ml
where i_nombre = ml.nombre;

/*Sino existe el nombre ingresado mostrara este error*/
IF i_medicamento_laboratorio_id IS NULL THEN  
	SET error_message = 'El nombre del medicamento ingresado no existe en la tabla medicamento_laboratorio.';  
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;  
END IF;  



/*Obtenemos el precio_unitario del medicamento desde la tabla medicamento_laboratorio_id a travez de la foreign key*/
SET precio_unitario = obtener_precio_unitario(i_medicamento_laboratorio_id);

/*Sino posee precio mostrara este error*/
IF precio_unitario IS NULL THEN 
	SET error_message = 'El medicamento con ID: ' + p_medicamento_laboratorio_id + 'no tiene un precio unitario definido';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
END IF;

-- Verificar si el compra_id ya existe  
SELECT COUNT(*)  
INTO existe_compra  
FROM compra  
WHERE compra_id = i_compra_id;  

-- Si no existe, entonces insertamos  
IF existe_compra = 0 THEN   
    INSERT INTO compra(compra_id, numero_comprobante, fecha_compra, total, proveedor_id)   
    VALUES(i_compra_id, NULL, NULL, 0, NULL); -- Asigna un valor a 'total' que sea válido  
END IF;  
/*Calculamos el precio total para agregarlo a la tabla y hacemos la insercion de los datos*/
SET precio_total = precio_unitario * i_cantidad;

	INSERT INTO detalle_compra(cantidad, precio_unitario, precio_total, compra_id, medicamento_laboratorio_id) VALUES(
		i_cantidad, precio_unitario, precio_total, i_compra_id, i_medicamento_laboratorio_id);
        
SELECT * from detalle_compra_historica1;
END $$
DELIMITER ;






DROP TABLE IF EXISTS detalle_compra_historica;

/*histórico de detalle compra*/
CREATE TABLE IF NOT EXISTS detalle_compra_historica (
    id INT PRIMARY KEY auto_increment,
    medicamento_laboratorio_id INT,
    precio_unitario DECIMAL(10, 2),
    precio_total DECIMAL(10, 2),
    compra_id INT,
    cantidad INT,
    fecha_hora datetime,
    usuario VARCHAR(200),
    operacion VARCHAR(200)
);

/*Vista para ver los medicamentos comprados ingresados a la tabla detalle_compra*/

CREATE VIEW detalle_compra_historica1 AS
SELECT
	ml.nombre AS "Medicamento",
    dch.precio_unitario AS "Precio Unitario",
	dch.precio_total AS "Precio Total",
	COALESCE(c.numero_comprobante, "SIN CARGAR") AS "Comprobante",
    dch.cantidad AS "Cantidad",
    dch.fecha_hora AS "Fecha de compra",
    dch.usuario AS "Usuario", 
    dch.operacion AS "Operacion"
FROM detalle_compra_historica dch
	LEFT JOIN medicamento_laboratorio ml ON dch.medicamento_laboratorio_id = ml.medicamento_laboratorio_id
    LEFT JOIN compra c ON c.compra_id = dch.compra_id
ORDER BY dch.fecha_hora DESC;



/*TRIGGER para mantener un registro constante del ingreso de los datos a detalle_compra*/
DROP TRIGGER IF EXISTS trigger_detalle_compra_alta;
DELIMITER $$
CREATE TRIGGER trigger_detalle_compra_alta
AFTER INSERT ON detalle_compra
FOR EACH ROW
BEGIN
	INSERT INTO detalle_compra_historica(medicamento_laboratorio_id, precio_unitario, precio_total, compra_id, cantidad, fecha_hora, usuario, operacion)
		VALUES (NEW.medicamento_laboratorio_id, NEW.precio_unitario, NEW.precio_total, NEW.compra_id, NEW.cantidad, now(), user(), 'ALTA');

END $$
DELIMITER ;

select * from compra;
SELECT * FROM detalle_compra;

/*consultamos la tabla medicamento para buscar los nombres de los medicamentos para ingresar*/
SELECT * FROM medicamento_laboratorio;

/*Insertamos compras*/
/*CANTIDAD, COMPRA_ID, NOMBRE DEL MEDICAMENTO*/
CALL insertar_detalle_compra(3, 5, 'Zolpidem');
CALL insertar_detalle_compra(4, 9, 'Brufen');
CALL insertar_detalle_compra(2, 9, 'Tramadol');
CALL insertar_detalle_compra(5, 9, 'Tamsulosin');
CALL insertar_detalle_compra(1, 10, 'Risosetron');
CALL insertar_detalle_compra(4, 11, 'Vasotec 5');
CALL insertar_detalle_compra(10, 11, 'Plavix 300');
CALL insertar_detalle_compra(3, 12, 'Codeine');
CALL insertar_detalle_compra(7, 12, 'Lyrica');
CALL insertar_detalle_compra(8, 13, 'Sertraline');

/*Llamamos a la view para ver la insercion a detalle_compra*/
SELECT * from detalle_compra_historica1;

/*Tambien podemos visualizar la insercion desde detalle_compra o en la vista detalle_compra_proveedores*/
SELECT * from detalle_compra;
select* from detalle_compra_proveedores;








/*Funcion para calcular el total de la compra en detalle_compra y luego llamarla en el stored procedure para introducir el total de la compra en base al id de la compra*/


DROP FUNCTION  IF EXISTS calcular_total_compra;

DELIMITER $$
CREATE FUNCTION calcular_total_compra (c_compra_id INT)
RETURNS DECIMAL(10, 2)

-- TIPOS DE FUNCIONES 
-- READS SQL DATA
-- NO SQL 
DETERMINISTIC 
-- NO DETERMINISTIC

BEGIN
    DECLARE total DECIMAL(10, 2);
	SELECT SUM(cantidad * precio_unitario) into total
    FROM detalle_compra
    WHERE compra_id = c_compra_id;
    
    RETURN IFNULL(total, 0); 
END $$
DELIMITER ;

select calcular_total_compra(4) as total_compra;

select * from compra;


/*Procedimiento para ingresar la compra*/
DROP PROCEDURE IF EXISTS insertar_compra;  
DELIMITER $$  

CREATE PROCEDURE insertar_compra(  
    IN c_compra_id INT,   
    IN c_numero_comprobante VARCHAR(255),  
    IN c_proveedor_id INT  
)   
BEGIN  
    DECLARE total_compras DECIMAL(10, 2);  
    DECLARE error_message VARCHAR(255);  
    DECLARE total_proveedor_id INT;  
    DECLARE existe_compra INT;  

    /* Validar que los valores no sean nulos o negativos si corresponde */  
    IF c_proveedor_id <= 0 THEN  
        SET error_message = 'El id del proveedor debe ser mayor a 1';  
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;  
    END IF;  

    SELECT MAX(proveedor_id)  
    INTO total_proveedor_id  
    FROM proveedor;  

    IF c_proveedor_id >= total_proveedor_id THEN  
        SET error_message = CONCAT('El id del proveedor debe ser menor a ', total_proveedor_id);   
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;  
    END IF;  

    IF c_compra_id <= 0 THEN  
        SET error_message = 'El id de compra debe ser mayor que cero';  
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;  
    END IF;  

    /* Verificar si el compra_id ya existe */  
    SELECT COUNT(*)  
    INTO existe_compra  
    FROM compra  
    WHERE compra_id = c_compra_id;  

    /* Calcular el total solo si ya existe */  
    IF existe_compra > 0 THEN  
        -- Obtener el total de la compra existente  
        SET total_compras = calcular_total_compra(c_compra_id);  

        -- Actualizar el registro existente  
        UPDATE compra  
        SET numero_comprobante = c_numero_comprobante,  
            fecha_compra = NOW(),  
            total = total_compras,  
            proveedor_id = c_proveedor_id  
        WHERE compra_id = c_compra_id;  
    ELSE  
        -- Si no existe, entonces insertamos  
        INSERT INTO compra(compra_id, numero_comprobante, fecha_compra, total, proveedor_id)   
        VALUES(c_compra_id, c_numero_comprobante, NOW(), 0, c_proveedor_id); -- El total se establece en 0 inicialmente  
    END IF;  
END $$  

DELIMITER ;  

CREATE TABLE compra_historica(compra_id INT, numero_comprobante VARCHAR(100), fecha datetime, total DECIMAL(10, 2), proveedor_id INT, estado VARCHAR(100)
);

/*TRIGGER para mantener un registro constante del ingreso de los datos a la tabla compra*/
DROP TRIGGER IF EXISTS trigger_compra_alta;
DELIMITER $$
CREATE TRIGGER trigger_compra_alta
AFTER INSERT ON compra
FOR EACH ROW
BEGIN
	INSERT INTO compra_historica(compra_id, numero_comprobante, fecha, total, proveedor_id, estado)
		VALUES (NEW.compra_id, NEW.numero_comprobante, now(), NEW.total, NEW.proveedor_id,'INGRESADA');

END $$
DELIMITER ;

/*TRIGGER para mantener un registro constante del ingreso de los datos a la tabla compra*/
DROP TRIGGER IF EXISTS trigger_compra_actualizacion;  

DELIMITER $$  

CREATE TRIGGER trigger_compra_actualizacion  
AFTER UPDATE ON compra  
FOR EACH ROW   
BEGIN  
    INSERT INTO compra_historica(compra_id, numero_comprobante, fecha, total, proveedor_id, estado)  
    VALUES (NEW.compra_id, NEW.numero_comprobante, NOW(), NEW.total, NEW.proveedor_id, 'ACTUALIZADO');  
END $$  

DELIMITER ;  


/*Llamamos al procedimiento*/
CALL insertar_compra(9, 'FC-2024-009', 3);
CALL insertar_compra(10, 'FC-2024-010', 4);
CALL insertar_compra(11, 'FC-2024-011', 1);
CALL insertar_compra(12, 'FC-2024-012', 5);
CALL insertar_compra(13, 'FC-2024-013', 3);
CALL insertar_compra(14, 'FC-2024-014', 4);
select * from compra;

select * from compra_historica;



select * from compra;





/*Stored Procedure para borrar medicamentos de la tabla medicamento_laboratorio por nombre del medicamento(mostrara un booleano true en caso de estar eliminado)*/

DROP PROCEDURE if exists borrar_medicamento_laboratorio;
DELIMITER $$
CREATE PROCEDURE borrar_medicamento_laboratorio(
	IN m_nombre_medicamento VARCHAR(100)
) 
BEGIN
	DECLARE i_medicamento_laboratorio_id INT;
    DECLARE error_message VARCHAR(255);
    
select ml.medicamento_laboratorio_id
into i_medicamento_laboratorio_id
from medicamento_laboratorio as ml
where m_nombre_medicamento = ml.nombre;

IF i_medicamento_laboratorio_id IS NULL THEN 

	SET error_message = 'El nombre del medicamento ingresado no existe en la base de datos o tiene un error tipográfico';  
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;  
	
ELSE 
	UPDATE medicamento_laboratorio  -- actualizamos la tabla para agregar el medicamento eliminado
    SET eliminado = TRUE
    WHERE medicamento_laboratorio_id = i_medicamento_laboratorio_id;
    
END IF;
END$$
DELIMITER ;



DROP TABLE IF EXISTS detalle_medicamentos_laboratorio;
/*histórico de cambios de medicamentos_laboratorio*/
CREATE TABLE IF NOT EXISTS detalle_medicamentos_laboratorio (
    medicamento_laboratorio_id INT,
    nombre VARCHAR(100),
    presentacion VARCHAR(100),
    farmaco_id INT,
    laboratorio_id INT,
    fecha_hora datetime,
    usuario VARCHAR(100),
    operacion VARCHAR(100)
);


/*Creamos vista para visualizar los medicamentos eliminados*/
CREATE VIEW detalle_medicamentos_eliminados1 AS 
SELECT
	ml.medicamento_laboratorio_id AS "ID del Medicamento",
    dme.nombre AS "Nombre",
    dme.presentacion AS "Presentacion",
    f.nombre AS "Farmaco",
    l.nombre AS "Laboratorio",
    dme.fecha_hora AS "Fecha",
    dme.usuario AS "Usuario",
    dme.operacion AS "Operacion"
FROM detalle_medicamentos_laboratorio dme
	LEFT JOIN laboratorio l ON l.laboratorio_id = dme.laboratorio_id
    LEFT JOIN medicamento_laboratorio ml ON ml.medicamento_laboratorio_id = dme.medicamento_laboratorio_id
    LEFT JOIN farmaco f ON f.farmaco_id = dme.farmaco_id
ORDER BY dme.fecha_hora DESC;


/*TRIGGER para mantener un registro constante del eliminacion de los datos a detalle_compra*/
DROP TRIGGER IF EXISTS trigger_detalle_medicamentos_eliminados;
DELIMITER $$
CREATE TRIGGER trigger_detalle_medicamentos_eliminados
AFTER UPDATE ON medicamento_laboratorio
FOR EACH ROW
BEGIN
	INSERT INTO detalle_medicamentos_laboratorio(medicamento_laboratorio_id, nombre, presentacion, farmaco_id, laboratorio_id, fecha_hora, usuario, operacion)
		VALUES (OLD.medicamento_laboratorio_id, OLD.nombre, OLD.presentacion, OLD.farmaco_id, OLD.laboratorio_id, now(), user(), 'BAJA');
END $$
DELIMITER ;

/*Hacemos una consulta para ver que medicamento queremos borrar*/
select * from medicamento_laboratorio;
/*borramos el medicamento con el stored procedure*/
CALL borrar_medicamento_laboratorio('Mometasone');
CALL borrar_medicamento_laboratorio('Rivaroxaban');
CALL borrar_medicamento_laboratorio('Propranolol');
/*LLamamos a la vista detalle_medicamentos_laboratorio de medicamentos eliminados agregados mediamente el trigger*/
select * from detalle_medicamentos_eliminados1;
/*Tambien podremos ver que esta eliminado en la tabla medicamento_laboratorio*/
select * from medicamento_laboratorio;
















/*funcion y procedimiento para actualizar y poner el valor total de las ventas a la nueva columna total en ventas*/

DROP FUNCTION  IF EXISTS calcular_total_venta;

DELIMITER $$
CREATE FUNCTION calcular_total_venta (v_venta_id INT)
RETURNS DECIMAL(10, 2)

-- TIPOS DE FUNCIONES 
-- READS SQL DATA
-- NO SQL 
DETERMINISTIC 
-- NO DETERMINISTIC

BEGIN
    DECLARE total DECIMAL(10, 2);
	SELECT SUM(cantidad * precio_unitario) into total
    FROM detalle_venta
    WHERE venta_id = v_venta_id;
    
    RETURN IFNULL(total, 0); 
END $$
DELIMITER ;


/*Procedimiento para actualizar las compras, agregamos la columna total en la tabla venta*/
DROP PROCEDURE IF EXISTS actualizar_total_venta;
DELIMITER $$  

CREATE PROCEDURE actualizar_total_venta()  
BEGIN  
    UPDATE venta 
    SET precio_total = calcular_total_venta(venta_id);
    
END $$  

DELIMITER ;  


CALL actualizar_total_venta();  

select * from venta;




    


	



