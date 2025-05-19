DROP DATABASE IF EXISTS `dbmwp`;
CREATE DATABASE `dbmwp`;
USE `dbmwp`;


-- CREATE TABLES

-- Creación de la tabla 'clients'
CREATE TABLE `Clients` (
    `IdClient`  INT, -- Clave primaria
    `nom`       VARCHAR(64) NOT NULL,
    `DNI`       CHAR(9) NOT NULL,
    `telefon`   VARCHAR(20) NOT NULL,
    `email`     VARCHAR(64) NOT NULL
);

-- Creación de la tabla 'cita'
CREATE TABLE `Cita` (
    `IdCita`    INT, -- Clave primaria
    `IdClient`  INT NOT NULL, -- Clave foránea hacia 'clients'
    `data`      DATE NOT NULL,
    `servei`    VARCHAR(64) NOT NULL,
    `IdVehicle` INT -- Clave foránea hacia 'Vehicles'
   
);

-- Creación de la tabla 'Vehicles'
CREATE TABLE `Vehicles` (
    `IdVehicle` INT, -- Clave primaria
    `IdClient`  INT, -- Clave foránea opcional hacia 'clients'
    `matricula` VARCHAR(20) NOT NULL,
    `model`     VARCHAR(64) NOT NULL,
    `any`       INT NOT NULL
    
);


-- PRIMARY KEYS
ALTER TABLE `Clients`
    MODIFY `IdClient` INT AUTO_INCREMENT,
    ADD CONSTRAINT PK_IdClient PRIMARY KEY (`IdClient`);

ALTER TABLE `Cita`
    MODIFY `IdCita` INT AUTO_INCREMENT,
    ADD CONSTRAINT PK_IdCita PRIMARY KEY (`IdCita`);

ALTER TABLE `Vehicles`
    MODIFY `IdVehicle` INT AUTO_INCREMENT,
    ADD CONSTRAINT PK_IdVehicle PRIMARY KEY (`IdVehicle`);


-- FOREIGN KEYS
ALTER TABLE `Cita`
    ADD CONSTRAINT FK_Cita_Cliente FOREIGN KEY (`IdClient`) 
        REFERENCES Clients(`IdClient`),
    ADD CONSTRAINT FK_Cita_Vehicle FOREIGN KEY (`IdVehicle`) 
        REFERENCES Vehicles(`IdVehicle`);

ALTER TABLE `Vehicles`
    ADD CONSTRAINT FK_Vehicle_Client FOREIGN KEY (`IdClient`) 
        REFERENCES Clients(`IdClient`);


-- UNIQUE
ALTER TABLE `Clients`
    ADD CONSTRAINT UQ_Client_DNI UNIQUE (`DNI`),
    ADD CONSTRAINT UQ_Client_Email UNIQUE (`email`);

ALTER TABLE `Vehicles`
    ADD CONSTRAINT UQ_Vehicle_Matricula UNIQUE (`matricula`);
