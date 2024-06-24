use master
go
if exists(Select * from sys.databases  Where name='BD_ProyectoADS2')
Begin
	Drop Database BD_ProyectoADS2
End
go


create database BD_ProyectoADS2
go

use BD_ProyectoADS2
go

-- tabla Usuario
CREATE TABLE Usuario(
    cod_usu int identity PRIMARY KEY,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    Carrera VARCHAR(255),
	tipo_usu VARCHAR(255),
	telefono VARCHAR(30),
	contrasea VARCHAR(255),
)
go

--  tabla Aula
CREATE TABLE Aula(	
    cod_aula INT PRIMARY KEY,
    tipo_aula VARCHAR(255),
    hora_inicio time,
	hora_fin time,
	estado VARCHAR(20)
)
go

-- Reserva
CREATE TABLE Reserva(
    usuario INT,
    cod_aula INT,
    inicio_reserva DATETIME,
	fin_reserva DATETIME,
    FOREIGN KEY (usuario) REFERENCES Usuario(cod_usu),
    FOREIGN KEY (cod_aula) REFERENCES Aula(cod_aula),
)
go

--Trigger
CREATE TRIGGER trg_ActualizarEstadoAula
ON Reserva
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar el estado a "reservado" si el aula tiene reservas
    UPDATE Aula
    SET estado = 'reservado'
    WHERE cod_aula IN (SELECT cod_aula FROM Reserva);

    -- Actualizar el estado a "libre" si el aula no tiene reservas
    UPDATE Aula
    SET estado = 'libre'
    WHERE cod_aula NOT IN (SELECT cod_aula FROM Reserva);
END;
GO

--Procedures

CREATE PROCEDURE RegistrarReserva
    @usuario INT,
    @cod_aula INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @inicio_reserva DATETIME;
    DECLARE @fin_reserva DATETIME;
    DECLARE @fecha_actual DATE;
    
    -- Obtener la fecha actual sin la hora
    SET @fecha_actual = CONVERT(DATE, GETDATE());

    -- Obtener la hora de inicio y fin del aula
    SELECT @inicio_reserva = CAST(@fecha_actual AS DATETIME) + CAST(hora_inicio AS DATETIME),
           @fin_reserva = CAST(@fecha_actual AS DATETIME) + CAST(hora_fin AS DATETIME)
    FROM Aula
    WHERE cod_aula = @cod_aula;

    -- Insertar la reserva en la tabla
    INSERT INTO Reserva (usuario, cod_aula, inicio_reserva, fin_reserva)
    VALUES (@usuario, @cod_aula, @inicio_reserva, @fin_reserva);
END;
GO

--Eliminar Reserva
CREATE OR ALTER PROCEDURE EliminarReserva(
    @_usuario INT,
    @_aula INT
)
AS
BEGIN
    DELETE FROM Reserva 
    WHERE usuario = @_usuario AND cod_aula = @_aula;
END 
go

--Historial de reservas
CREATE PROCEDURE HistorialReservas
AS
BEGIN
    SELECT 
        A.cod_aula,
        A.tipo_aula,
        R.inicio_reserva,
        R.fin_reserva,
        A.estado
    FROM 
        Reserva R
    INNER JOIN 
        Aula A ON R.cod_aula = A.cod_aula
END
GO

--EXEC HistorialReservas;


--"Buscar Usuario" buscando su Codigo
CREATE or ALTER PROCEDURE BuscarUsuario
    @Cod_Usu INT
AS
BEGIN
    SELECT cod_usu, nombre, apellido, tipo_usu, Carrera, telefono
    FROM Usuario
    WHERE cod_usu = @Cod_Usu;
END
GO

--exec BuscarUsuario @Cod_Usu = 2

--"Buscar Aula" Mediante su Codigo
CREATE or ALTER PROCEDURE BuscarAula
	@Cod_Aula INT
AS
BEGIN
    SELECT cod_aula, tipo_aula, hora_inicio, hora_fin, estado
    FROM Aula
    WHERE cod_aula = @Cod_Aula;
END
GO
	
--exec BuscarAula @Cod_Aula = 109

-- Insertar valores en la tabla Usuario
INSERT INTO Usuario(nombre, apellido, Carrera, tipo_usu, telefono, contrasea) VALUES
('Juan', 'Perez', 'Ingeniería Informática', 'Coordinador', '953243520', 'Juaerz953'),
('María', 'Gonzalez', 'Medicina', 'Coordinador', '986754321', 'Maralez986'),
('Luis', 'Martinez', 'Derecho', 'Coordinador', '974123456', 'Luinnez974'),
('Ana', 'Lopez', 'Arquitectura', 'Coordinador', '965432198', 'Anaopez965'),
('Pedro', 'Rodriguez', 'Ingeniería Civil', 'Coordinador', '932145678', 'Perigue932'),
('Laura', 'Fernandez', 'Psicología', 'Coordinador', '913457689', 'Lauez913'),
('Carlos', 'Garcia', 'Administración', 'Coordinador', '921346578', 'Carcia921'),
('Sofia', 'Sanchez', 'Biología', 'Coordinador', '987654312', 'Sofchez987'),
('David', 'Ramirez', 'Química', 'Coordinador', '954312678', 'Davirez954'),
('Elena', 'Hernandez', 'Física', 'Coordinador', '942135679', 'Eleandez942'),

('Miguel', 'Vargas', 'Economía', 'Alumno', '971243568', 'Migagas971'),
('Lucia', 'Castro', 'Ingeniería Industrial', 'Alumno', '962345781', 'Lucastro962'),
('Fernando', 'Ortiz', 'Historia', 'Alumno', '981234675', 'Feroitz981'),
('Patricia', 'Mendoza', 'Filosofía', 'Alumno', '913476582', 'Patdoza913'),
('Gabriel', 'Nuñez', 'Sociología', 'Alumno', '992134678', 'Gabñez992'),
('Rosa', 'Silva', 'Enfermería', 'Alumno', '951236784', 'Rosilva951'),
('Jose', 'Torres', 'Matemáticas', 'Alumno', '963214587', 'Josrres963'),
('Daniela', 'Rojas', 'Literatura', 'Alumno', '972143568', 'Danrojas972'),
('Alberto', 'Jimenez', 'Antropología', 'Alumno', '923145678', 'Albenez923'),
('Francisco', 'Guerrero', 'Geografía', 'Alumno', '935214687', 'Fraguer935');
go


-- Insertar valores en la tabla Aula
INSERT INTO Aula(cod_aula, tipo_aula, hora_inicio, hora_fin) VALUES
(105, 'Laboratorio', '07:00:00.0000', '12:00:00.0000'),
(106, 'Teoria', '12:00:00.0000', '15:00:00.0000'),
(107, 'Laboratorio', '15:00:00.0000', '17:00:00.0000'),
(108, 'Teoria', '17:00:00.0000', '20:00:00.0000'),
(109, 'Laboratorio', '20:00:00.0000', '21:00:00.0000'),
(110, 'Teoria', '07:00:00.0000', '12:00:00.0000'),
(111, 'Laboratorio', '12:00:00.0000', '15:00:00.0000'),
(112, 'Teoria', '15:00:00.0000', '17:00:00.0000'),
(113, 'Laboratorio', '17:00:00.0000', '20:00:00.0000'),
(114, 'Teoria', '20:00:00.0000', '21:00:00.0000'),
(115, 'Laboratorio', '07:00:00.0000', '12:00:00.0000'),
(116, 'Teoria', '12:00:00.0000', '15:00:00.0000'),
(117, 'Laboratorio', '15:00:00.0000', '17:00:00.0000'),
(118, 'Teoria', '17:00:00.0000', '20:00:00.0000'),
(119, 'Laboratorio', '20:00:00.0000', '21:00:00.0000');
go

-- Insertar valores en la tabla Reserva
INSERT INTO Reserva(usuario, cod_aula, inicio_reserva, fin_reserva) VALUES
(1, 105, CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 07:00:00' AS DATETIME), CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 09:00:00' AS DATETIME)),
(2, 106, CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 09:00:00' AS DATETIME), CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 11:00:00' AS DATETIME)),
(3, 107, CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 11:00:00' AS DATETIME), CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 13:00:00' AS DATETIME)),
(4, 108, CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 13:00:00' AS DATETIME), CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 15:00:00' AS DATETIME)),
(5, 109, CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 15:00:00' AS DATETIME), CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 17:00:00' AS DATETIME)),
(6, 110, CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 17:00:00' AS DATETIME), CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 19:00:00' AS DATETIME)),
(7, 111, CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 19:00:00' AS DATETIME), CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 21:00:00' AS DATETIME)),
(8, 112, CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 07:00:00' AS DATETIME), CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 09:00:00' AS DATETIME)),
(9, 113, CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 09:00:00' AS DATETIME), CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 11:00:00' AS DATETIME));
go
--select * from reserva

CREATE OR ALTER PROCEDURE usp_ListarUsuarios
AS
BEGIN
    -- Selecciona todos los campos de la tabla Usuario
    SELECT cod_usu, nombre, apellido, carrera, tipo_usu, telefono
    FROM Usuario;
END;
GO

--exec usp_ListarUsuarios

CREATE OR ALTER PROCEDURE usp_ListarAula
AS
BEGIN
    -- Selecciona todos los campos de la tabla Usuario
    SELECT cod_aula, tipo_aula, hora_inicio, hora_fin, estado
    FROM Aula;
END;
GO

--exec usp_ListarAula