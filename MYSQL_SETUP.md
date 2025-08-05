# MySQL Database Configuration Guide

This guide helps you configure MySQL Database connection for the velocity testing application.

## Prerequisites

1. **MySQL Server Installation**:

   - MySQL Server 8.0 or higher (recommended)
   - MySQL Server 5.7 (minimum supported)
   - MySQL Workbench (optional GUI tool)

2. **Download MySQL**: https://dev.mysql.com/downloads/mysql/

## Installation Steps

### Option 1: MySQL Installer (Windows)

1. **Download MySQL Installer**:

   - Download MySQL Installer for Windows
   - Choose "Custom" installation
   - Select: MySQL Server, MySQL Workbench, MySQL Shell

2. **Configuration**:

   - Set root password: `mysql123` (for development)
   - Default port: `3306`
   - Authentication method: Use Strong Password Encryption

3. **Windows Service**: MySQL will run as a Windows service (`MySQL80`)

### Option 2: MySQL in Docker

```bash
# Pull MySQL image
docker pull mysql:8.0

# Run MySQL container
docker run -d \
  --name mysql-server \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=mysql123 \
  -e MYSQL_DATABASE=dbproductos \
  mysql:8.0
```

### Option 3: XAMPP (Easy setup)

1. Download XAMPP from https://www.apachefriends.org/
2. Install and start MySQL service
3. Default credentials: root (no password)

## Database Setup

### 1. Connect to MySQL

Using MySQL Command Line or MySQL Workbench:

```bash
mysql -u root -p
# Enter password: mysql123
```

### 2. Create Database and User

```sql
-- Create database
CREATE DATABASE dbproductos;

-- Create user with proper privileges
CREATE USER 'dbproducto'@'localhost' IDENTIFIED BY 'dbproducto';
CREATE USER 'dbproducto'@'%' IDENTIFIED BY 'dbproducto';

-- Grant privileges
GRANT ALL PRIVILEGES ON dbproductos.* TO 'dbproducto'@'localhost';
GRANT ALL PRIVILEGES ON dbproductos.* TO 'dbproducto'@'%';

-- Apply privileges
FLUSH PRIVILEGES;

-- Use the database
USE dbproductos;
```

### 3. Create Table and Sample Data

```sql
-- Create products table
CREATE TABLE producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO producto (nombre, categoria, precio, stock) VALUES
('Laptop', 'Electrónica', 1200.00, 10),
('Smartphone', 'Electrónica', 800.00, 25),
('Tablet', 'Electrónica', 500.00, 15),
('Cámara', 'Fotografía', 600.00, 5),
('Auriculares', 'Accesorios', 150.00, 30);

-- Create stored procedure for inserting products
DELIMITER //
CREATE PROCEDURE SP_insertar_producto(
    IN p_nombre VARCHAR(100),
    IN p_categoria VARCHAR(100),
    IN p_precio DECIMAL(10,2),
    IN p_stock INT
)
BEGIN
    INSERT INTO producto (nombre, categoria, precio, stock)
    VALUES (p_nombre, p_categoria, p_precio, p_stock);
END //
DELIMITER ;

-- Test the stored procedure
CALL SP_insertar_producto('Producto E', 'Categoria A', 50.00, 500);
```

## Connection Configuration

### Environment Variables

Update your `.env` file:

```env
# MySQL Configuration
MYSQL_HOST=localhost                # Database host
MYSQL_USER=dbproducto              # Database user
MYSQL_PASSWORD=dbproducto          # User password
MYSQL_DATABASE=dbproductos         # Database name
MYSQL_PORT=3306                    # Database port
```

### Alternative Root User Configuration

If you prefer to use root user:

```env
# MySQL Configuration (using root)
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=123456789
MYSQL_DATABASE=dbproductos
MYSQL_PORT=3306
```

## Testing Connection

1. **Using MySQL Command Line**:

   ```bash
   mysql -u dbproducto -p -h localhost dbproductos
   # Enter password: dbproducto
   ```

2. **Using the Application**:
   - Visit `http://localhost:3000`
   - Click "Test MySQL Connection"

## Troubleshooting

### Common Issues

1. **Access denied for user 'dbproducto'@'localhost'**

   ```sql
   -- Check user exists
   SELECT User, Host FROM mysql.user WHERE User = 'dbproducto';

   -- Recreate user if needed
   DROP USER 'dbproducto'@'localhost';
   CREATE USER 'dbproducto'@'localhost' IDENTIFIED BY 'dbproducto';
   GRANT ALL PRIVILEGES ON dbproductos.* TO 'dbproducto'@'localhost';
   FLUSH PRIVILEGES;
   ```

2. **Can't connect to MySQL server on 'localhost'**

   - Check if MySQL service is running
   - Verify port 3306 is not blocked
   - Check firewall settings

3. **Database 'dbproductos' doesn't exist**

   ```sql
   -- Create database
   CREATE DATABASE dbproductos;
   ```

4. **Too many connections**
   - Check max_connections setting
   - Restart MySQL service if needed

### Service Management

**Windows Services**:

- MySQL80 (or MySQL57 for older versions)

**Start/Stop Commands**:

```cmd
# Start MySQL service
net start MySQL80

# Stop MySQL service
net stop MySQL80

# Restart MySQL service
net stop MySQL80 && net start MySQL80
```

**Check MySQL Status**:

```bash
# Check if MySQL is running
mysqladmin -u root -p status

# Show processlist
mysqladmin -u root -p processlist
```

## Performance Tips

1. **Connection Pooling**: Application uses connection pooling
2. **Indexing**: Add indexes for frequently queried columns
3. **Query Optimization**: Use EXPLAIN to analyze query performance
4. **Configuration**: Adjust `my.ini` or `my.cnf` for better performance

## Security Considerations

1. **Change default passwords** in production
2. **Disable root remote access** if not needed
3. **Use SSL connections** for production
4. **Regular security updates**

## MySQL Tools

1. **MySQL Workbench**: Official GUI tool
2. **phpMyAdmin**: Web-based administration
3. **MySQL Shell**: Advanced command-line tool
4. **HeidiSQL**: Windows MySQL client

## Configuration Files

- **Windows**: `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`
- **Linux**: `/etc/mysql/my.cnf`
- **macOS**: `/usr/local/etc/my.cnf`

## Additional Resources

- [MySQL Documentation](https://dev.mysql.com/doc/)
- [MySQL Workbench](https://www.mysql.com/products/workbench/)
- [MySQL Tutorial](https://www.mysqltutorial.org/)
- [MySQL Performance Tuning](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)
