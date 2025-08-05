# PostgreSQL Database Configuration Guide

This guide helps you configure PostgreSQL Database connection for the velocity testing application.

## Prerequisites

1. **PostgreSQL Server Installation**:

   - PostgreSQL 14 or higher (recommended)
   - PostgreSQL 12 or higher (minimum supported)
   - pgAdmin 4 (optional GUI tool)

2. **Download PostgreSQL**: https://www.postgresql.org/download/

## Installation Steps

### Option 1: PostgreSQL Installer (Windows)

1. **Download PostgreSQL Installer**:

   - Download PostgreSQL installer for Windows
   - Run installer as Administrator
   - Set password for postgres user: `123456`
   - Default port: `5432`
   - Default locale: Use system locale

2. **Additional Tools** (optional):
   - pgAdmin 4 (GUI administration tool)
   - Command Line Tools
   - Stack Builder (for additional modules)

### Option 2: PostgreSQL in Docker

```bash
# Pull PostgreSQL image
docker pull postgres:14

# Run PostgreSQL container
docker run -d \
  --name postgres-server \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=123456 \
  -e POSTGRES_DB=dbproductos \
  postgres:14
```

### Option 3: PostgreSQL via Package Manager

**Windows (using Chocolatey)**:

```powershell
choco install postgresql
```

**macOS (using Homebrew)**:

```bash
brew install postgresql
```

## Database Setup

### 1. Connect to PostgreSQL

Using psql command line or pgAdmin:

```bash
# Connect as postgres user
psql -U postgres -h localhost -p 5432
# Enter password: 123456
```

### 2. Create Database and User

```sql
-- Create database
CREATE DATABASE dbproductos;

-- Create user
CREATE USER dbproducto WITH PASSWORD 'dbproducto';

-- Grant privileges to user
GRANT ALL PRIVILEGES ON DATABASE dbproductos TO dbproducto;

-- Connect to the database
\c dbproductos;

-- Grant schema privileges
GRANT ALL ON SCHEMA public TO dbproducto;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO dbproducto;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO dbproducto;
```

### 3. Create Table and Sample Data

```sql
-- Connect to dbproductos database
\c dbproductos;

-- Create products table
CREATE TABLE producto (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO producto (nombre, categoria, precio, stock) VALUES
('Laptop', 'Electrónica', 1200.00, 10),
('Smartphone', 'Electrónica', 800.00, 25),
('Tablet', 'Electrónica', 500.00, 15),
('Cámara', 'Fotografía', 600.00, 5),
('Auriculares', 'Accesorios', 150.00, 30);

-- Create stored procedure (function in PostgreSQL)
CREATE OR REPLACE FUNCTION SP_insertar_producto(
    p_nombre VARCHAR(100),
    p_categoria VARCHAR(100),
    p_precio DECIMAL(10,2),
    p_stock INTEGER
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO producto (nombre, categoria, precio, stock)
    VALUES (p_nombre, p_categoria, p_precio, p_stock);
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT SP_insertar_producto('Producto E', 'Categoria A', 50.00, 500);
```

## Connection Configuration

### Environment Variables

Update your `.env` file:

```env
# PostgreSQL Configuration
POSTGRES_HOST=localhost            # Database host
POSTGRES_USER=dbproducto          # Database user
POSTGRES_PASSWORD=dbproducto      # User password
POSTGRES_DATABASE=dbproductos     # Database name
POSTGRES_PORT=5432                # Database port
```

### Alternative Postgres User Configuration

If you prefer to use postgres superuser:

```env
# PostgreSQL Configuration (using postgres)
POSTGRES_HOST=localhost
POSTGRES_USER=postgres
POSTGRES_PASSWORD=123456789
POSTGRES_DATABASE=dbproductos
POSTGRES_PORT=5432
```

## Testing Connection

1. **Using psql Command Line**:

   ```bash
   psql -U dbproducto -h localhost -d dbproductos -p 5432
   # Enter password: dbproducto
   ```

2. **Using the Application**:
   - Visit `http://localhost:3000`
   - Click "Test PostgreSQL Connection"

## Troubleshooting

### Common Issues

1. **FATAL: password authentication failed for user 'dbproducto'**

   ```sql
   -- Connect as postgres user first
   psql -U postgres

   -- Check if user exists
   SELECT usename FROM pg_user WHERE usename = 'dbproducto';

   -- Reset password if needed
   ALTER USER dbproducto WITH PASSWORD 'dbproducto';
   ```

2. **could not connect to server: Connection refused**

   - Check if PostgreSQL service is running
   - Verify port 5432 is not blocked
   - Check `postgresql.conf` for listen_addresses

3. **FATAL: database "dbproductos" does not exist**

   ```sql
   -- Create database
   CREATE DATABASE dbproductos;
   ```

4. **permission denied for schema public**
   ```sql
   -- Grant schema permissions
   GRANT ALL ON SCHEMA public TO dbproducto;
   GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO dbproducto;
   GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO dbproducto;
   ```

### Service Management

**Windows Services**:

- postgresql-x64-14 (or similar based on version)

**Start/Stop Commands**:

```cmd
# Start PostgreSQL service
net start postgresql-x64-14

# Stop PostgreSQL service
net stop postgresql-x64-14

# Restart PostgreSQL service
net stop postgresql-x64-14 && net start postgresql-x64-14
```

**Check PostgreSQL Status**:

```bash
# Check if PostgreSQL is running
pg_ctl status -D "C:\Program Files\PostgreSQL\14\data"

# Show active connections
psql -U postgres -c "SELECT * FROM pg_stat_activity;"
```

## Configuration Files

**Important PostgreSQL configuration files**:

- `postgresql.conf`: Main configuration file
- `pg_hba.conf`: Host-based authentication
- `pg_ident.conf`: User name mapping

**Default locations**:

- **Windows**: `C:\Program Files\PostgreSQL\14\data\`
- **Linux**: `/etc/postgresql/14/main/`
- **macOS**: `/usr/local/var/postgres/`

### Common Configuration Changes

1. **Allow connections from localhost**:

   ```conf
   # postgresql.conf
   listen_addresses = 'localhost'
   port = 5432
   ```

2. **Authentication method**:
   ```conf
   # pg_hba.conf
   host    all             all             127.0.0.1/32            md5
   host    all             all             ::1/128                 md5
   ```

## Performance Tips

1. **Connection Pooling**: Application uses connection pooling
2. **Indexing**: Add indexes for frequently queried columns
3. **Query Optimization**: Use EXPLAIN ANALYZE to analyze queries
4. **Configuration Tuning**: Adjust `shared_buffers`, `work_mem`, etc.

## Security Considerations

1. **Change default passwords** in production
2. **Configure pg_hba.conf** properly
3. **Use SSL connections** for production
4. **Regular security updates**

## PostgreSQL Tools

1. **pgAdmin 4**: Official GUI administration tool
2. **psql**: Command-line interface
3. **DBeaver**: Universal database tool
4. **DataGrip**: JetBrains database IDE

## Useful Commands

```sql
-- List all databases
\l

-- Connect to database
\c dbproductos

-- List all tables
\dt

-- Describe table structure
\d producto

-- Show current user
SELECT current_user;

-- Show all users
\du

-- Exit psql
\q
```

## Backup and Restore

```bash
# Backup database
pg_dump -U dbproducto -h localhost -d dbproductos > backup.sql

# Restore database
psql -U dbproducto -h localhost -d dbproductos < backup.sql
```

## Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [pgAdmin 4](https://www.pgadmin.org/)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)
- [PostgreSQL Performance Tips](https://wiki.postgresql.org/wiki/Performance_Optimization)
