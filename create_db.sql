SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `Rol`;
DROP TABLE IF EXISTS `Usuario`;
DROP TABLE IF EXISTS `access_key`;
DROP TABLE IF EXISTS `usuario_rol`;
DROP TABLE IF EXISTS `Cuenta`;
DROP TABLE IF EXISTS `Equipo`;
DROP TABLE IF EXISTS `tecnicos`;
DROP TABLE IF EXISTS `conocimientos`;
DROP TABLE IF EXISTS `modulo`;
DROP TABLE IF EXISTS `rol_modulo`;
SET FOREIGN_KEY_CHECKS = 1;
CREATE TABLE `Rol` (
    `id` CHAR NOT NULL,
    `descripcion` VARCHAR(200) NOT NULL,
    `activo` BOOLEAN DEFAULT (1),
    `createdAt` DATETIME DEFAULT (CURRENT_DATE),
    `updatedAt` DATETIME DEFAULT (CURRENT_DATE),
    PRIMARY KEY (`id`)
);
CREATE TABLE `Usuario` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(500) NOT NULL,
    `correo` VARCHAR(500) NOT NULL,
    `activo` BOOLEAN DEFAULT (1),
    `createdAt` DATETIME DEFAULT (CURRENT_DATE),
    `updatedAt` DATETIME DEFAULT (CURRENT_DATE),
    PRIMARY KEY (`id`)
);
CREATE TABLE `access_key` (
    `usuario_id` BIGINT NOT NULL,
    `password` TEXT NOT NULL,
    `createdAt` DATETIME DEFAULT (CURRENT_DATE),
    `updatedAt` DATETIME DEFAULT (CURRENT_DATE),
    PRIMARY KEY (`usuario_id`)
);
CREATE TABLE `usuario_rol` (
    `usuario_id` BIGINT NOT NULL,
    `rol_id` CHAR NOT NULL,
    `activo` BOOLEAN DEFAULT (1),
    `createdAt` DATETIME DEFAULT (CURRENT_DATE),
    `updatedAt` DATETIME DEFAULT (CURRENT_DATE)
);
CREATE TABLE `Cuenta` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(500) NOT NULL,
    `cliente` BIGINT NOT NULL,
    `responsable` BIGINT NOT NULL,
    `activo` BOOLEAN DEFAULT (1),
    `createdAt` DATETIME DEFAULT (CURRENT_DATE),
    `updatedAt` DATETIME DEFAULT (CURRENT_DATE),
    PRIMARY KEY (`id`)
);
CREATE TABLE `Equipo` (
    `usuario_id` BIGINT NOT NULL,
    `cuenta_id` BIGINT NOT NULL,
    `activo` BOOLEAN DEFAULT (1),
    `createdAt` DATETIME DEFAULT (CURRENT_DATE),
    `updatedAt` DATETIME DEFAULT (CURRENT_DATE),
    PRIMARY KEY (`usuario_id`, `cuenta_id`)
);
CREATE TABLE `tecnicos` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(100) NOT NULL,
    `activo` BOOLEAN DEFAULT (1),
    `createdAt` DATETIME DEFAULT (CURRENT_DATE),
    `updatedAt` DATETIME DEFAULT (CURRENT_DATE),
    PRIMARY KEY (`id`)
);
CREATE TABLE `conocimientos` (
    `usuario_id` BIGINT NOT NULL,
    `tech_id` BIGINT NOT NULL,
    `createdAt` DATETIME DEFAULT (CURRENT_DATE),
    `updatedAt` DATETIME DEFAULT (CURRENT_DATE)
);
CREATE TABLE `modulo` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `nombre` varchar(200) NOT NULL,
    `createdAt` DATETIME DEFAULT (CURRENT_DATE),
    `updatedAt` DATETIME DEFAULT (CURRENT_DATE),
    PRIMARY KEY (`id`)
);
CREATE TABLE `rol_modulo` (
    `rol_id` CHAR NOT NULL,
    `modulo_id` BIGINT NOT NULL,
    `createdAt` DATETIME DEFAULT (CURRENT_DATE),
    `updatedAt` DATETIME DEFAULT (CURRENT_DATE)
);
ALTER TABLE `access_key`
ADD FOREIGN KEY (`usuario_id`) REFERENCES `Usuario`(`id`);
ALTER TABLE `usuario_rol`
ADD FOREIGN KEY (`rol_id`) REFERENCES `Rol`(`id`);
ALTER TABLE `usuario_rol`
ADD FOREIGN KEY (`usuario_id`) REFERENCES `Usuario`(`id`);
ALTER TABLE `Cuenta`
ADD FOREIGN KEY (`nombre`) REFERENCES `Usuario`(`id`);
ALTER TABLE `Cuenta`
ADD FOREIGN KEY (`cliente`) REFERENCES `Usuario`(`id`);
ALTER TABLE `Equipo`
ADD FOREIGN KEY (`usuario_id`) REFERENCES `Usuario`(`id`);
ALTER TABLE `Equipo`
ADD FOREIGN KEY (`cuenta_id`) REFERENCES `Cuenta`(`id`);
ALTER TABLE `conocimientos`
ADD FOREIGN KEY (`tech_id`) REFERENCES `tecnicos`(`id`);
ALTER TABLE `conocimientos`
ADD FOREIGN KEY (`usuario_id`) REFERENCES `Usuario`(`id`);
ALTER TABLE `rol_modulo`
ADD FOREIGN KEY (`rol_id`) REFERENCES `Rol`(`id`);
ALTER TABLE `rol_modulo`
ADD FOREIGN KEY (`modulo_id`) REFERENCES `modulo`(`id`);
CREATE VIEW Responsable AS
SELECT u.*
FROM Usuario u
    LEFT JOIN usuario_rol ur on u.id = ur.usuario_id
    LEFT JOIN Rol r on ur.rol_id = r.id
where r.descripcion = "Responsable";
CREATE VIEW Cliente AS
SELECT u.*
FROM Usuario u
    LEFT JOIN usuario_rol ur on u.id = ur.usuario_id
    LEFT JOIN Rol r on ur.rol_id = r.id
where r.descripcion = "Cliente";

CREATE VIEW Libres AS
SELECT u.*
FROM Usuario u
LEFT JOIN Equipo e
ON u.id = e.usuario_id
WHERE e.usuario_id IS NULL
OR e.activo = FALSE;

INSERT INTO modulo(nombre)
VALUES("Dashboard"),
("Cuenta"),
("Usuario"),
("Perfil"),
("Sign In");