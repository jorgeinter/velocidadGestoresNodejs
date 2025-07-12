create database if not exists dbproductos; -- Crear la base de datos si no existe
-- Seleccionar la base de datos
use dbproductos;
-- Crear la tabla de productos
create table producto (
    id int auto_increment primary key,
    nombre varchar(50) not null,
    categoria varchar(50) not null,
    precio decimal(10,2) not null,
    stock int not null
);

-- Insertar algunos productos de ejemplo
insert into producto (nombre, categoria, precio, stock) values
('Laptop', 'Electrónica', 1200.00, 10),
('Smartphone', 'Electrónica', 800.00, 25),
('Tablet', 'Electrónica', 500.00, 15),
('Cámara', 'Fotografía', 600.00, 5),
('Auriculares', 'Accesorios', 150.00, 30);

 -- Crear un procedimiento almacenado para insertar productos
DELIMITER $$
create procedure SP_insertar_producto(
    IN p_nombre VARCHAR(50),
    IN p_categoria VARCHAR(50),
    IN p_precio DECIMAL(10,2),
    IN p_stock INT
)
BEGIN
    INSERT INTO producto (nombre, categoria, precio, stock)
    VALUES (p_nombre, p_categoria, p_precio, p_stock);
END$$
DELIMITER ;

-- Prueba del procedimiento almacenado
CALL SP_insertar_producto('Smartwatch', 'Electrónica', 200.00, 20);


