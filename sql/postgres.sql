create database dbproductos; -- Crear la base de datos si no existe

-- Crear la tabla de productos
create table producto (
    id_producto serial primary key,
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
-- Crear un procedimiento almacenado para insertar productos
create or replace function SP_insertar_producto(
    p_nombre varchar(50),
    p_categoria varchar(50),
    p_precio decimal(10,2),
    p_stock int
)
    returns void as $$
begin
    insert into producto (nombre, categoria, precio, stock)
    values (p_nombre, p_categoria, p_precio, p_stock);
end;
$$ language plpgsql;

-- Prueba del procedimiento almacenado
select SP_insertar_producto('Smartwatch', 'Electrónica', 200.00, 20);
