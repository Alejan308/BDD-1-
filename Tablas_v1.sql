CREATE DATABASE FreeSpaces 
GO
USE FreeSpaces;
GO

--# CREACION DE TABLAS

drop database FreeSpaces
CREATE TABLE Usuario (
    LU INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Mail VARCHAR(100) UNIQUE NOT NULL,
    Privilegio VARCHAR(20) NOT NULL,

);

CREATE TABLE Sede (
    IDsede INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200),
    Edificios INT
);

CREATE TABLE Ubicacion (
    IDubicacion INT IDENTITY(1,1) PRIMARY KEY,
    Edificio VARCHAR(100),
    Piso VARCHAR(10)
);

CREATE TABLE TipoEspacio (
    IDtipoEspacio INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Elementos VARCHAR(400),
    CantLugar INT,
);

CREATE TABLE Espacios (
    IDespacio INT IDENTITY(1,1) PRIMARY KEY,
    IDsede INT,
    Estado VARCHAR(20) DEFAULT 'Disponible' CHECK (Estado IN ('Ocupado', 'Disponible')),
    IDtipoEspacio INT,
    IDubicacion INT,
    CONSTRAINT Espacios_Sede FOREIGN KEY (IDsede) REFERENCES Sede(IDsede),
    CONSTRAINT Espacios_TipoEspacio FOREIGN KEY (IDtipoEspacio) REFERENCES TipoEspacio(IDtipoEspacio),
    CONSTRAINT Espacios_Ubicacion FOREIGN KEY (IDubicacion) REFERENCES Ubicacion(IDubicacion)
);

CREATE TABLE Registro (
    IDregistro INT IDENTITY(1,1) PRIMARY KEY, 
    IDespacio INT,
    IDusuario INT,
    HoraEntrada DATETIME,
    HoraSalida DATETIME,
    CONSTRAINT Registro_Espacio FOREIGN KEY (IDespacio) REFERENCES Espacios(IDespacio),
    CONSTRAINT Registro_Usuario FOREIGN KEY (IDusuario) REFERENCES Usuario(LU)
);



--# INSERTES

-- USUARIOS
INSERT INTO Usuario (Nombre, Apellido, Mail, Privilegio) VALUES
('Ana', 'Gomez', 'ana.gomez@uade.edu.ar', 'Admin'),
('Luis', 'Perez', 'luis.perez@uade.edu.ar', 'Usuario'),
('Mar�a', 'Lopez', 'maria.lopez@uade.edu.ar', 'Usuario'),
('Juan', 'Torres', 'juan.torres@uade.edu.ar', 'Admin'),
('Sof�a', 'Mendez', 'sofia.mendez@uade.edu.ar', 'Usuario'),
('Carlos', 'Rivas', 'carlos.rivas@uade.edu.ar', 'Usuario'),
('Luc�a', 'Navarro', 'lucia.navarro@uade.edu.ar', 'Usuario'),
('Miguel', 'Ruiz', 'miguel.ruiz@uade.edu.ar', 'Usuario'),
('Elena', 'Fernandez', 'elena.fernandez@uade.edu.ar', 'Admin'),
('Jorge', 'Santos', 'jorge.santos@uade.edu.ar', 'Usuario');

-- SEDES (solo 4 tipos, repetidas para 10 registros)
INSERT INTO Sede (Nombre, Direccion, Edificios) VALUES
('Monserrat', 'Lima 775', 3),
('Belgrano', 'Av. Cabildo 1456', 2),
('Pinamar', 'Av. Bunge 1200', 1),
('Recoleta', 'Av. Santa Fe 940', 2),
('Monserrat', 'Chile 1023', 3),
('Belgrano', 'Av. Juramento 600', 2),
('Recoleta', 'Callao 333', 1),
('Monserrat', 'Independencia 450', 2),
('Pinamar', 'De las Artes 900', 1),
('Recoleta', 'Av. Pueyrred�n 120', 2);

-- UBICACIONES (usando tus edificios)
INSERT INTO Ubicacion (Edificio, Piso) VALUES
('Lima 1', '2'),
('Lima 2', '3'),
('Lima 3', '3'),
('Labs', '1'),
('Chile 1', '3'),
('Chile 2', '1'),
('Chile 3', '2'),
('Independencia 1', '5'),
('Independencia 2', '9'),
('Comedor', 'PB');

-- TIPOESPACIO
INSERT INTO TipoEspacio (Nombre, Elementos, CantLugar) VALUES
('Laboratorio Inform�tica', 'PCs, proyectores, pizarras', 25),
('Aula', 'Sillas, mesas, pizarr�n', 40),
('Sala de Reuniones', 'Mesa grande, pantalla, sillas', 10),
('Auditorio', 'Escenario, butacas, sonido', 200),
('Biblioteca', 'Mesas, estantes, PCs', 50),
('Oficina', 'Escritorios, sillas, armarios', 5),
('Taller', 'Herramientas, bancos de trabajo', 15),
('Comedor', 'Mesas, sillas, microondas', 30),
('Dep�sito', 'Estantes, cajas, armarios', 8),
('Sala de Estudio', 'Mesas, sillas, enchufes', 20);

-- ESPACIOS
INSERT INTO Espacios (IDsede, Estado, IDtipoEspacio, IDubicacion) VALUES
(1, 'Disponible', 1, 1),
(2, 'Ocupado', 2, 2),
(3, 'Disponible', 3, 3),
(4, 'Ocupado', 4, 4),
(5, 'Disponible', 5, 5),
(6, 'Disponible', 6, 6),
(7, 'Ocupado', 7, 7),
(8, 'Disponible', 8, 8),
(9, 'Ocupado', 9, 9),
(10, 'Disponible', 10, 10);

-- REGISTRO
INSERT INTO Registro (IDespacio, IDusuario, HoraEntrada, HoraSalida) VALUES
(1, 1, '2025-11-03 08:00:00', '2025-11-03 10:00:00'),
(2, 2, '2025-11-03 09:15:00', '2025-11-03 11:15:00'),
(3, 3, '2025-11-03 10:00:00', '2025-11-03 12:30:00'),
(4, 4, '2025-11-03 11:00:00', '2025-11-03 13:00:00'),
(5, 5, '2025-11-03 12:00:00', '2025-11-03 13:30:00'),
(6, 6, '2025-11-03 13:00:00', '2025-11-03 14:45:00'),
(7, 7, '2025-11-03 14:00:00', '2025-11-03 15:15:00'),
(8, 8, '2025-11-03 15:00:00', '2025-11-03 16:00:00'),
(9, 9, '2025-11-03 16:00:00', '2025-11-03 17:30:00'),
(10, 10, '2025-11-03 17:00:00', '2025-11-03 18:00:00');
