DROP DATABASE IF EXISTS dbmwp;
GO
CREATE DATABASE dbmwp;
GO
USE dbmwp;
GO

CREATE TABLE IF NOT EXISTS clients (
    `idClient` INT PRIMARY KEY AUTO_INCREMENT,
    `nom` VARCHAR(255) NOT NULL UNIQUE,
    `telèfon` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS vehicles (
    `idVehicle` INT PRIMARY KEY AUTO_INCREMENT,
    `matrícula` VARCHAR(255) NOT NULL UNIQUE,
    `model` VARCHAR(255) NOT NULL,
    `any` INT NOT NULL,
    `idClient` INT NOT NULL,
    FOREIGN KEY (`idClient`) REFERENCES clients(`idClient`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Cites (
    `idCita` INT PRIMARY KEY AUTO_INCREMENT,
    `data` DATE NOT NULL,
    `servei sol·licitat` TIME NOT NULL,
    `idClient` INT NOT NULL,
    `idVehicle` INT NOT NULL,
    FOREIGN KEY (`idClient`) REFERENCES clients(`idClient`) ON DELETE CASCADE,
    FOREIGN KEY (`idVehicle`) REFERENCES vehicles(`idVehicle`) ON DELETE CASCADE
);


-- Usuarios y permisos

CREATE USER 'mwp_user'@'localhost' IDENTIFIED BY 'secure_password';

GRANT INSERT ON MWP.clients TO 'mwp_user'@'localhost';
GRANT INSERT ON MWP.vehicles TO 'mwp_user'@'localhost';
GRANT INSERT ON MWP.Cites TO 'mwp_user'@'localhost';

FLUSH PRIVILEGES;