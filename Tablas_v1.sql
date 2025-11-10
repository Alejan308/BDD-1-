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
    Privilegio VARCHAR(20) NOT NULL CHECK (Privilegio IN ('Admin', 'Estudiante', 'Docente')),

);

CREATE TABLE Sede (
    IDsede INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200),
    Edificios INT CHECK (Edificios > 0),
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
    CantLugar CHECK (CantLugar > 0),
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
    HoraEntrada DATETIME NOT NULL,
    HoraSalida DATETIME,
    CONSTRAINT Registro_Espacio FOREIGN KEY (IDespacio) REFERENCES Espacios(IDespacio),
    CONSTRAINT Registro_Usuario FOREIGN KEY (IDusuario) REFERENCES Usuario(LU)
);
