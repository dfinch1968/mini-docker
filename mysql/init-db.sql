-- This runs only on first initialization when /var/lib/mysql is empty.

-- Create database
CREATE DATABASE IF NOT EXISTS speed
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Create user "darren" without password initially.
-- You will set a password manually later.
CREATE USER IF NOT EXISTS 'darren'@'%' IDENTIFIED BY '';

-- Grant full access to database "speed" from LAN
GRANT ALL PRIVILEGES ON speed.* TO 'darren'@'%';

FLUSH PRIVILEGES;