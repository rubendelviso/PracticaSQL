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
SELECT pel.titulo,P.monto--pel.tarifa_alquiler, duracion_alquiler
--Como calcular ingreso total
FROM pelicula as pel INNER JOIN inventario AS I ON pel.id_pelicula = i.id_pelicula
INNER JOIN alquiler as al ON I.id_inventario = al.id_inventario INNER JOIN pago AS P ON
al.id_alquiler = P.id_alquiler
GROUP BY pel.titulo, P.monto
ORDER BY pel.titulo

--c. Generar un reporte de las películas de clasificación R que nunca fueron alquiladas,
--mostrando id, titulo, idioma y categoría. Ordenar por categoría y título.
--d. Identificar los actores que han participado en películas de la categoría Action pero nunca en la categoría Horror.
--Ordenar por apellido y nombre. Mostrar una sola columna con apellido y nombre, separados por coma.
--e. Identificar los 10 clientes con mayor promedio de días de retraso en sus devoluciones. 
--Considerar únicamente los alquileres del último semestre de actividad registrado en la base.
--Salida: Nombre y Apellido, cantidad de alquileres y promedio de días de retraso (2 decimales).
