# Use the official MySQL 5.7 server image as the base
FROM mysql/mysql-server:5.7

# Copy the initialization SQL script into the special directory
# Files in /docker-entrypoint-initdb.d/ run automatically on first container startup
COPY init.sql /docker-entrypoint-initdb.d/

# Expose port 3306 so MySQL can accept connections
EXPOSE 3306

# Set the root password for MySQL (used during initial setup)
ENV MYSQL_ROOT_PASSWORD=admin123
