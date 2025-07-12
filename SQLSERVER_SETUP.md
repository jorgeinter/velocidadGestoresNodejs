# SQL Server Configuration Guide

This guide helps you configure SQL Server connection for the velocity testing application.

## Connection Issues

If you're getting "Login failed for user 'sa'" errors, try these solutions:

### Option 1: Use Windows Authentication (Recommended for local development)

1. Set `SQLSERVER_USE_WINDOWS_AUTH=true` in your `.env` file
2. Make sure SQL Server allows Windows Authentication
3. Your Windows user should have access to SQL Server

### Option 2: Configure SQL Server Authentication

1. Enable SQL Server Authentication:

   - Open SQL Server Management Studio (SSMS)
   - Right-click on the server → Properties
   - Go to Security tab
   - Select "SQL Server and Windows Authentication mode"
   - Restart SQL Server service

2. Enable SA account (if using sa user):

   - In SSMS, expand Security → Logins
   - Right-click on 'sa' → Properties
   - Set a strong password
   - Uncheck "Password must be changed at next login"
   - On Status tab, set Login to "Enabled"

3. Update your `.env` file:
   ```
   SQLSERVER_USE_WINDOWS_AUTH=false
   SQLSERVER_USER=sa
   SQLSERVER_PASSWORD=your_strong_password
   ```

### Option 3: Create a new SQL Server user

1. In SSMS, create a new login:

   - Right-click Security → Logins → New Login
   - Choose "SQL Server authentication"
   - Set username and password
   - Grant necessary permissions

2. Update your `.env` file with the new credentials

## Common SQL Server Instance Names

- Default instance: `localhost` or `localhost,1433`
- Named instance: `localhost\\SQLEXPRESS` (most common for local dev)
- Remote server: `server_name\\instance_name` or `server_ip,port`

## Database Setup

Make sure to create the database and table:

```sql
CREATE DATABASE dbproductos;
USE dbproductos;

CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    category NVARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Create stored procedure for batch inserts
CREATE PROCEDURE insert_product
    @name NVARCHAR(255),
    @category NVARCHAR(255),
    @price DECIMAL(10,2),
    @stock INT
AS
BEGIN
    INSERT INTO products (name, category, price, stock)
    VALUES (@name, @category, @price, @stock);
END;
```

## Environment Variables Reference

```env
# SQL Server Configuration
SQLSERVER_SERVER=localhost\\SQLEXPRESS    # Your SQL Server instance
SQLSERVER_USER=sa                         # Username (if using SQL auth)
SQLSERVER_PASSWORD=your_password          # Password (if using SQL auth)
SQLSERVER_DATABASE=dbproductos            # Database name
SQLSERVER_USE_WINDOWS_AUTH=true           # Use Windows Auth (true/false)
SQLSERVER_ENCRYPT=false                   # Encrypt connection (true/false)
SQLSERVER_TRUST_CERT=true                 # Trust server certificate (true/false)
```

## Testing Connection

Visit `http://localhost:3000` and click "Test SQL Server Connection" to verify your configuration.

## Troubleshooting

1. **Connection timeout**: Check if SQL Server is running and accessible
2. **Login failed**: Verify authentication method and credentials
3. **Server not found**: Check server name and port
4. **Database not found**: Make sure the database exists and user has access

The application now includes automatic fallback from SQL Server Authentication to Windows Authentication if the first method fails.
