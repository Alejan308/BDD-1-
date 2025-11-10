--# INSERTES


-- USUARIOS
INSERT INTO Usuario (Nombre, Apellido, Mail, Privilegio) VALUES
('Ana', 'Gomez', 'ana.gomez@uade.edu.ar', 'Docente'),
('Luis', 'Perez', 'luis.perez@uade.edu.ar', 'Admin'),
('Mar�a', 'Lopez', 'maria.lopez@uade.edu.ar', 'Estudiante'),
('Juan', 'Torres', 'juan.torres@uade.edu.ar', 'Docente'),
('Sof�a', 'Mendez', 'sofia.mendez@uade.edu.ar', 'Estudiante'),
('Carlos', 'Rivas', 'carlos.rivas@uade.edu.ar', 'Estudiante'),
('Luc�a', 'Navarro', 'lucia.navarro@uade.edu.ar', 'Estudiante'),
('Miguel', 'Ruiz', 'miguel.ruiz@uade.edu.ar', 'Estudiante'),
('Elena', 'Fernandez', 'elena.fernandez@uade.edu.ar', 'Docente'),
('Jorge', 'Santos', 'jorge.santos@uade.edu.ar', 'Estudiante');

-- SEDES 
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


-- UBICACIONES 
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
('Aula grande', 'Sillas, mesas, pizarr�n', 60),
('Sala de Reuniones', 'Mesa grande, pantalla, sillas', 10),
('Auditorio', 'Escenario, butacas, sonido', 200),
('Biblioteca', 'Mesas, estantes, PCs', 50),
('Aula chica', 'Escritorios, sillas, armarios', 5),
('Aula mediana', 'Herramientas, bancos de trabajo', 15),
('Comedor', 'Mesas, sillas, microondas', 30),
('Aula ruidosa', 'Estantes, cajas, armarios', 20),
('Aula silenciosa', 'Mesas, sillas, enchufes', 20),
('Mesa patio', 'Mesas, sillas, enchufes', 20),
('Mesa pasillo', 'Mesas, sillas, enchufes', 20),
('Mesa de Estudio', 'Mesas, sillas, enchufes', 20),
('Xperience', 'Mesas, sillas, enchufes', 80);

-- ESPACIOS
INSERT INTO Espacios (IDsede, Estado, IDtipoEspacio, IDubicacion) VALUES
(1, 'Disponible', 1, 1),
(2, 'Disponible', 2, 2),
(3, 'Disponible', 3, 3),
(4, 'Disponible', 4, 4),
(5, 'Disponible', 5, 5),
(6, 'Disponible', 6, 6),
(7, 'Disponible', 7, 7),
(8, 'Disponible', 8, 8),
(9, 'Disponible', 9, 9),
(10, 'Disponible', 10, 10);

-- REGISTRO
INSERT INTO Registro (IDespacio, IDusuario, HoraEntrada, HoraSalida) VALUES
(3,5,'2025-11-11 17:00:00',NULL),
(1, 1, '2025-11-10 08:00:00', '2025-11-10 10:00:00'),
(2, 2, '2025-11-03 09:15:00', '2025-11-03 11:15:00'),
(3, 3, '2025-11-03 10:00:00', '2025-11-03 12:30:00'),
(4, 4, '2025-11-03 11:00:00', '2025-11-03 13:00:00'),
(5, 5, '2025-11-10 12:00:00', '2025-11-10 13:30:00'),
(6, 6, '2025-11-03 13:00:00', '2025-11-03 14:45:00'),
(7, 7, '2025-11-03 14:00:00', '2025-11-03 15:15:00'),
(8, 8, '2025-11-03 15:00:00', '2025-11-03 16:00:00'),
(9, 9, '2025-11-03 16:00:00', '2025-11-03 17:30:00'),
(10, 10, '2025-11-03 17:00:00', '2025-11-03 18:00:00');