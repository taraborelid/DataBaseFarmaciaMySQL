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

CREATE TABLE IF NOT EXISTS localidad(
	localidad_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR (100) NOT NULL
    );
    
CREATE TABLE IF NOT EXISTS provincia(
	provincia_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR (100) NOT NULL
    );

CREATE TABLE IF NOT EXISTS medicamento(
	medicamento_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (100) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR (100) NOT NULL -- receta o venta libre
);

CREATE TABLE IF NOT EXISTS laboratorio(
	laboratorio_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100),
    telefono VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    nacionalidad_id INT NOT NULL,  
    provincia_id INT NOT NULL,  
    localidad_id INT NOT NULL,  
    FOREIGN KEY (nacionalidad_id) REFERENCES nacionalidad(nacionalidad_id),
    FOREIGN KEY (provincia_id) REFERENCES provincia(provincia_id),
    FOREIGN KEY (localidad_id) REFERENCES localidad(localidad_id)
);

CREATE TABLE IF NOT EXISTS medicamento_laboratorio( 
-- en esta tabla se indica dentro de cada id de la primary key, los medicamentos disponibles en cada laboratorio
	medicamento_laboratorio_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    precio_unitario DECIMAL(10,2) NOT NULL,
    cantidad_disponible INT NOT NULL,
    fecha_vencimiento DATETIME,
    medicamento_id INT NOT NULL,
    laboratorio_id INT NOT NULL,
    foreign key (medicamento_id) REFERENCES medicamento(medicamento_id),
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
    localidad_id INT NOT NULL,  
    medicamento_laboratorio_id INT NOT NULL,
    foreign key (nacionalidad_id) REFERENCES nacionalidad(nacionalidad_id),
    foreign key (provincia_id) REFERENCES provincia(provincia_id),
    foreign key (localidad_id) REFERENCES localidad(localidad_id),
    foreign key (medicamento_laboratorio_id) REFERENCES medicamento_laboratorio(medicamento_laboratorio_id) -- medicamentos que el proveedor tendra disponibles
);

CREATE TABLE IF NOT EXISTS compra(
	compra_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fecha_compra DATETIME NOT NULL,
    total DECIMAL(10,2),
    proveedor_id INT NOT NULL,
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
    plan_obra_social_id INT,
    plan_prepaga_id INT,
    nacionalidad_id INT NOT NULL,  
    provincia_id INT NOT NULL,  
    localidad_id INT NOT NULL,
    genero_id INT NOT NULL,
    foreign key (plan_obra_social_id) REFERENCES  plan_obra_social( plan_obra_social_id),
    foreign key (plan_prepaga_id) REFERENCES plan_prepaga(plan_prepaga_id),
    foreign key (nacionalidad_id) REFERENCES nacionalidad(nacionalidad_id),
    foreign key (provincia_id) REFERENCES provincia(provincia_id),
    foreign key (localidad_id) REFERENCES localidad(localidad_id),
    foreign key (genero_id) REFERENCES genero(genero_id)
);

CREATE TABLE IF NOT EXISTS medico(
	medico_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    matricula VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS receta(
	receta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fecha_receta DATETIME NOT NULL,
    instrucciones TEXT,
    cliente_id INT NOT NULL,
    medico_id INT NOT NULL, 
	foreign key (cliente_id) REFERENCES cliente(cliente_id),
    foreign key (medico_id) REFERENCES medico(medico_id)
);

CREATE TABLE IF NOT EXISTS detalle_receta(
	-- aqui vemos en detalle del medicamentos con su respectivo laboratorio ordenado enla receta
	detalle_receta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
    cantidad INT NOT NULL,
    medicamento_laboratorio_id INT NOT NULL, 
    receta_id INT NOT NULL,
    foreign key (medicamento_laboratorio_id) REFERENCES medicamento_laboratorio(medicamento_laboratorio_id),
    foreign key (receta_id) REFERENCES receta(receta_id)
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
    cargo VARCHAR(100) NOT NULL, 
    localidad_id INT NOT NULL,
    provincia_id INT NOT NULL,
    foreign key (localidad_id) REFERENCES localidad(localidad_id),
    foreign key (provincia_id) REFERENCES provincia(provincia_id)
);

CREATE TABLE IF NOT EXISTS venta(
	venta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fecha_venta DATETIME NOT NULL,
    total DECIMAL (10,2) NOT NULL,
    tipo_venta VARCHAR(100),
    cliente_id INT NOT NULL,
    receta_id INT NULL,
    personal_id INT NOT NULL,
    foreign key (cliente_id) REFERENCES cliente(cliente_id),
    foreign key (receta_id) REFERENCES receta(receta_id),
    foreign key (personal_id) REFERENCES personal(personal_id)
    
);

CREATE TABLE IF NOT EXISTS detalle_venta(
	detalle_venta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    venta_id INT NOT NULL,
    medicamento_laboratorio_id INT NOT NULL,
    foreign key (venta_id) REFERENCES venta(venta_id),
    foreign key (medicamento_laboratorio_id) REFERENCES medicamento_laboratorio(medicamento_laboratorio_id)
    
);

CREATE TABLE IF NOT EXISTS stock_farmacia(  
	stock_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,  
    medicamento_laboratorio_id INT NOT NULL,  
    cantidad INT NOT NULL,  
    FOREIGN KEY (medicamento_laboratorio_id) REFERENCES medicamento_laboratorio(medicamento_laboratorio_id)  
);  








    


	



