CREATE DATABASE VideoClub
GO
USE VideoClub

 
 CREATE TABLE actor(
	id_actor int IDENTITY(1,1) NOT NULL,
	nombre VARCHAR(45) NOT NULL,
	apellido VARCHAR(45) NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,
	CONSTRAINT PK_actor PRIMARY KEY (id_actor)
)
CREATE TABLE pais(
	id_pais int IDENTITY(1,1)NOT NULL,
	pais VARCHAR (50)NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,
	CONSTRAINT PK_pais PRIMARY KEY(id_pais)
)
CREATE TABLE idioma(
	id_idioma TINYINT IDENTITY(1,1)NOT NULL,
	nombre VARCHAR(20)NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,

	CONSTRAINT PK_id_idioma PRIMARY KEY(id_idioma)
	
)
CREATE TABLE categoria(
	id_categoria TINYINT IDENTITY(1,1)NOT NULL,
	nombre VARCHAR(25)NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,
	
	CONSTRAINT PK_id_categoria PRIMARY KEY(id_categoria),
)


CREATE TABLE ciudad(
	id_ciudad int IDENTITY (1,1)NOT NULL,
	ciudad VARCHAR(50)NOT NULL,
	id_pais INT NOT NULL, --No hace falta colocar restricciones eso lo haremos en su propia tabla
	ultima_actualizacion DATETIME NOT NULL,
	
	CONSTRAINT PK_ciudad PRIMARY KEY(id_ciudad),
	CONSTRAINT FK_ciudad_pais FOREIGN KEY(id_pais)--Recordemos que es tablaActual_tablareferenciada
		REFERENCES pais(id_pais)--apunto a la tabla
)
CREATE TABLE direccion(
	id_direccion INT IDENTITY(1,1)NOT NULL,
	direccion VARCHAR(50)NOT NULL,
	direccion2 VARCHAR(50)NULL, --Osea con esto considero que puedo tener este atributo como null
	distrito VARCHAR(20)NOT NULL,
	id_ciudad INT NOT NULL,
	codigo_postal VARCHAR(10)NULL,
	telefono VARCHAR(20)NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,

	CONSTRAINT PK_id_direccion PRIMARY KEY(id_direccion),	
	CONSTRAINT FK_direccion_ciudad FOREIGN KEY(id_ciudad)
		REFERENCES ciudad(id_ciudad)
)
CREATE TABLE tienda(
	id_tienda TINYINT IDENTITY(1,1)NOT NULL,
	id_personal_gerente TINYINT NULL,
	id_direccion INT NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,


	CONSTRAINT PK_id_tienda PRIMARY KEY(id_tienda),
	CONSTRAINT FK_direccion FOREIGN KEY(id_direccion)
		REFERENCES direccion(id_direccion),
	--CONSTRAINT FK_tienda_personal FOREIGN KEY(id_personal_gerente)
		--REFERENCES personal(id_personal),
)



CREATE TABLE personal(
	id_personal TINYINT IDENTITY(1,1)NOT NULL,
	nombre VARCHAR(45)NOT NULL,
	apellido VARCHAR(45)NOT NULL,
	id_direccion INT NOT NULL,
	foto VARBINARY(MAX)NULL,
	correo VARCHAR(50)NOT NULL,
	id_tienda TINYINT NOT NULL,
	activo BIT NOT NULL,
	usuario VARCHAR (16) NOT NULL,
	contrasena VARCHAR(40)NULL,
	ultima_actualizacion DATETIME NOT NULL,

	CONSTRAINT FK_direccion_personal FOREIGN KEY(id_direccion)
		REFERENCES direccion(id_direccion),
	CONSTRAINT FK_personal_tienda FOREIGN KEY(id_tienda)
		REFERENCES tienda(id_tienda),
	CONSTRAINT PK_id_personal PRIMARY KEY(id_personal),

	--Ahora si creo la FK en tienda de personal(había una referencia circular anteriormente
)
GO
ALTER TABLE tienda
	ADD CONSTRAINT FK_tienda_personal FOREIGN KEY(id_personal_gerente)
		REFERENCES personal(id_personal);
GO
CREATE TABLE cliente(
	id_cliente INT IDENTITY(1,1)NOT NULL,
	id_tienda TINYINT,
	nombre VARCHAR(45)NOT NULL,
	apellido VARCHAR(45)NOT NULL,
	correo VARCHAR(50)NOT NULL,
	id_direccion INT,--Como son foraneas no hace falta declarar el not null
	activo BIT NOT NULL,-- Ya estaba predefinido como 1 
	fecha_creacion DATETIME NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,

	CONSTRAINT FK_id_tienda FOREIGN KEY (id_tienda)
		REFERENCES tienda(id_tienda),
	CONSTRAINT FK_cliente_direccion FOREIGN KEY(id_direccion)
		REFERENCES direccion(id_direccion),
	CONSTRAINT PK_id_cliente PRIMARY KEY(id_cliente),
)

CREATE TABLE pelicula (
	id_pelicula INT IDENTITY(1,1)NOT NULL,
	titulo VARCHAR(128)NOT NULL,
	descripcion VARCHAR(8000)NULL,
	anio_estreno SMALLINT NULL,
	id_idioma TINYINT NOT NULL,
	id_idioma_original TINYINT NULL,
	duracion_alquiler TINYINT NOT NULL,
	tarifa_alquiler DECIMAL(4,2)NOT NULL,
	duracion INT NULL,
	costo_reemplazo DECIMAL(5,2)NOT NULL,
	clasificacion VARCHAR(10)NOT NULL,
	caracteristicas_especiales VARCHAR(255) NULL,
	ultima_actualizacion DATETIME NOT NULL,

	CONSTRAINT PK_id_pelicula PRIMARY KEY(id_pelicula),
	CONSTRAINT FK_pelicula_idioma FOREIGN KEY(id_idioma)
		REFERENCES idioma(id_idioma),
	CONSTRAINT FK_pelicula_idioma_original FOREIGN KEY(id_idioma_original)
		REFERENCES idioma(id_idioma),
	

)
CREATE TABLE pelicula_actor(
	id_actor INT NOT NULL, --No seteo el identity aca. No hace falta pq ya viene preseteado de la clase padre
	id_pelicula INT NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,

	CONSTRAINT FK_pelicula_actor_actor FOREIGN KEY(id_actor)
		REFERENCES actor(id_actor),
	CONSTRAINT FK_pelicula_actor_pelicula FOREIGN KEY(id_pelicula)
		REFERENCES pelicula(id_pelicula),
	CONSTRAINT PK_id_actor PRIMARY KEY(id_actor,id_pelicula)--Aca formamos la clave compuesta

)
CREATE TABLE pelicula_categoria(
	id_pelicula INT NOT NULL,
	id_categoria TINYINT NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,

	CONSTRAINT FK_pelicula_categoria_categoria FOREIGN KEY(id_categoria)
		REFERENCES categoria(id_categoria),
	CONSTRAINT FK_pelicula_categoria_pelicula FOREIGN KEY(id_pelicula)
		REFERENCES pelicula(id_pelicula),
	CONSTRAINT PK_id_pelicula_cat PRIMARY KEY(id_pelicula,id_categoria),
)

CREATE TABLE inventario(
	id_inventario INT IDENTITY(1,1)NOT NULL,
	id_tienda TINYINT NOT NULL,
	id_pelicula INT NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,
	
	CONSTRAINT FK_inventario_pelicula FOREIGN KEY(id_pelicula)
		REFERENCES pelicula(id_pelicula),
	CONSTRAINT FK_inventario_tienda FOREIGN KEY(id_tienda)
		REFERENCES tienda(id_tienda),
	CONSTRAINT PK_id_inventario PRIMARY KEY(id_inventario)
)

CREATE TABLE alquiler(
	id_alquiler INT IDENTITY(1,1)NOT NULL,
	fecha_alquiler DATETIME NOT NULL,
	id_inventario INT NOT NULL,
	id_cliente INT NOT NULL,
	fecha_devolucion DATETIME NULL,
	id_personal TINYINT NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,
	
	CONSTRAINT PK_alquiler PRIMARY KEY(id_alquiler),
	CONSTRAINT FK_alquiler_inventario FOREIGN KEY(id_inventario)
		REFERENCES inventario(id_inventario),
	CONSTRAINT FK_alquiler_cliente FOREIGN KEY(id_cliente)
		REFERENCES cliente(id_cliente),
	CONSTRAINT FK_alquiler_personal FOREIGN KEY(id_personal)
		REFERENCES personal(id_personal),
)
CREATE TABLE pago(
	id_pago INT IDENTITY(1,1)NOT NULL,
	id_cliente INT NOT NULL,
	id_personal TINYINT NOT NULL,
	id_alquiler INT NULL,
	monto DECIMAL(5,2) NOT NULL,
	fecha_pago DATETIME NOT NULL,
	ultima_actualizacion DATETIME NOT NULL,

	CONSTRAINT PK_pago PRIMARY KEY(id_pago),
	CONSTRAINT FK_pago_cliente FOREIGN KEY (id_cliente)
		REFERENCES cliente(id_cliente),
	CONSTRAINT FK_pago_personal FOREIGN KEY (id_personal)
		REFERENCES personal(id_personal),
	CONSTRAINT FK_pago_alquiler FOREIGN KEY(id_alquiler)
		REFERENCES alquiler(id_alquiler)
)


--------------------Excepciones que hay que tener en cuenta--------------------
--Para la implementación en SQL Server se pueden utilizar los mismos tipos de datos, salvo algunas
--excepciones:
--• En la tabla personal, para el atributo foto en lugar de BLOB se deberá utilizar
--VARBINARY(MAX), y para el atributo activo en lugar de BOOLEAN se deberá utilizar BIT.
--• En la tabla cliente, para el atributo activo en lugar de BOOLEAN se deberá utilizar BIT.