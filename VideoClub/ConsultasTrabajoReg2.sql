--a. Listar los nombres de los clientes que han alquilado películas de todos los géneros disponibles.
USE VideoClub
SELECT c.nombre
FROM cliente AS C 
	WHERE NOT EXISTS(
		SELECT * 
		FROM categoria AS CAT
		--Tengo que usar logica de predicados
		--Comparo entonces contra categorias existentes - contra categorias existentes en los inventarios
		WHERE NOT EXISTS(
			SELECT * 
			FROM
			alquiler AS A INNER JOIN inventario AS I ON I.id_inventario = A.id_inventario
			INNER JOIN pelicula AS P ON P.id_pelicula = I.id_pelicula
			INNER JOIN pelicula_categoria AS PCAT ON P.id_pelicula = PCAT.id_pelicula
			--Ahora hago la condicion si el cliente alquilo sobre todas las peliculas y categorias existentes
			WHERE A.id_cliente = C.id_cliente AND PCAT.id_categoria = CAT.id_categoria
		)
	)


--b. Identificar las películas cuyo ingreso total por alquiler es superior al promedio de ingresos
--de las películas con su misma clasificación. Mostrar primero las de mayor recaudación.
SELECT pel.titulo,clasificacion--,SUM(P.monto)--pel.tarifa_alquiler, duracion_alquiler
--Como calcular ingreso total
FROM pelicula as pel INNER JOIN inventario AS I ON pel.id_pelicula = i.id_pelicula
INNER JOIN alquiler as al ON I.id_inventario = al.id_inventario INNER JOIN pago AS P ON
al.id_alquiler = P.id_alquiler
GROUP BY pel.titulo,pel.clasificacion--, SUM(P.monto)
HAVING SUM(P.monto)>(SELECT AVG(IngresoPelicula)
--Necesito un nivel mas en donde guardo->(SUM monto) segun la categoria
--Despues hago la consulta sobre eso
					 FROM
					 (SELECT SUM(P2.monto) AS IngresoPelicula
					 FROM  pelicula as pel2 INNER JOIN inventario AS I2 ON pel2.id_pelicula = I2.id_pelicula
					 INNER JOIN alquiler as al2 ON I2.id_inventario = al2.id_inventario INNER JOIN pago AS P2 ON
					 al2.id_alquiler = P2.id_alquiler
					 WHERE pel2.clasificacion = pel.clasificacion
					 GROUP BY pel2.id_pelicula)
						AS Ingresos
					 )--De esta misma lista que guarde la suma de todas las pelis por su respectiva clasificacion hago despues el promedio
ORDER BY SUM(P.monto)DESC;

--c. Generar un reporte de las películas de clasificación R que nunca fueron alquiladas,
--mostrando id, titulo, idioma y categoría. Ordenar por categoría y título.

SELECT *--p.id_pelicula,p.titulo,A.id_inventario--,p.idioma,p.c
FROM pelicula as p INNER JOIN inventario AS I ON p.id_pelicula = I.id_pelicula
LEFT JOIN alquiler AS A ON I.id_inventario = A.id_inventario--Considero quedarme con lo inventarios que no coinciden con ninguno. De esa forma me quedan los q nunca fueron alquilados
WHERE p.clasificacion = 'R' AND A.id_inventario IS NULL
--

--Pruebas chat gpt
SELECT COUNT(*) FROM pelicula WHERE clasificacion = 'R'
SELECT COUNT(DISTINCT p.id_pelicula)
FROM pelicula AS p 
INNER JOIN inventario AS I ON p.id_pelicula = I.id_pelicula
LEFT JOIN alquiler AS A ON I.id_inventario = A.id_inventario
WHERE p.clasificacion = 'R' AND A.id_inventario IS NULL

--d. Identificar los actores que han participado en películas de la categoría Action pero nunca en la categoría Horror.
--Ordenar por apellido y nombre. Mostrar una sola columna con apellido y nombre, separados por coma.

SELECT DISTINCT CONCAT(A.apellido,';',A.nombre)
FROM actor AS A INNER JOIN pelicula_actor AS PA ON A.id_actor = PA.id_actor
INNER JOIN pelicula AS P ON PA.id_pelicula = P.id_pelicula INNER JOIN pelicula_categoria
AS PCAT ON P.id_pelicula = PCAT.id_pelicula INNER JOIN categoria AS C ON PCAT.id_categoria = C.id_categoria
WHERE C.nombre = 'Action' AND A.id_actor NOT IN (SELECT A2.id_actor
												 FROM actor AS A2 INNER JOIN pelicula_actor AS PA2 ON A2.id_actor = PA2.id_actor
												 INNER JOIN pelicula AS P2 ON PA2.id_pelicula = P2.id_pelicula INNER JOIN pelicula_categoria
												 AS PCAT2 ON P2.id_pelicula = PCAT2.id_pelicula INNER JOIN categoria AS C2 ON PCAT2.id_categoria = C2.id_categoria
												 WHERE C2.nombre = 'Horror')
ORDER BY CONCAT(A.apellido,';',A.nombre) 
--e. Identificar los 10 clientes con mayor promedio de días de retraso en sus devoluciones. 
--Considerar únicamente los alquileres del último semestre de actividad registrado en la base.
--Salida: Nombre y Apellido, cantidad de alquileres y promedio de días de retraso (2 decimales).
SELECT TOP 10 
    C.nombre,
    C.apellido,
    COUNT(A.id_alquiler) AS CantidadAlquileres,
    ROUND(AVG(CASE 
        WHEN DATEDIFF(DAY, A.fecha_alquiler, A.fecha_devolucion) - P.duracion_alquiler > 0
        THEN DATEDIFF(DAY, A.fecha_alquiler, A.fecha_devolucion) - P.duracion_alquiler
        ELSE 0
    END), 2) AS PromedioDiasRetraso
FROM cliente AS C 
INNER JOIN alquiler AS A ON C.id_cliente = A.id_cliente
INNER JOIN inventario AS I ON I.id_inventario = A.id_inventario
INNER JOIN pelicula AS P ON I.id_pelicula = P.id_pelicula
WHERE A.fecha_alquiler >= DATEADD(MONTH, -6, (SELECT MAX(fecha_alquiler) FROM alquiler))
GROUP BY C.id_cliente, C.nombre, C.apellido
ORDER BY PromedioDiasRetraso DESC
--GROUP BY C.nombre--,DATEDIFF(DAY,a.fecha_alquiler,A.fecha_devolucion)
--ORDER BY 
--WHERE --DATEDIFF(DAY,a.fecha_alquiler,A.fecha_devolucion)>;


SELECT *
FROM PELICULA
--                                Fin Consultas


--Creacion de Triggers:
GO
CREATE OR ALTER TRIGGER UltimaActualizacion -- Esto es una abreviacion para en lugar de escribir
											--si la tabla no existe creala o si existe modificala
ON actor --  En realidad es sobre todas las tablas(ES LO QUE NECESITAMOS) 
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE actor
	SET ultima_actualizacion = GETDATE()
	WHERE id_actor IN (SELECT id_actor FROM inserted)
END 
GO