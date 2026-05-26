/*--------------------Formas de recuperar datos-----------------------------*/
/*
SELECT Puesto, Nombre, Apellido /*Aca selecciono unicamente lo que voy a traer*/
FROM Empleados /*Le digo a partir de las tablas que yo tengo*/
ORDER BY Puesto, Apellido; /*Esto lo ordena por los criterios que yo elija*/

/*Cambia la forma en que lo ordeno o llamo*/
SELECT Puesto, Nombre, Apellido /*Aca selecciono unicamente*/
FROM Empleados /*Le digo a partir de que tipo de tablas*/
ORDER BY Puesto ASC, Apellido DESC; /*Aca cambia la forma en que ordena segun el criterio que eleji(ORDEN DETERMINISTICO)*/
*/

/*Me permite filtrar las primeras 3 en el orden en que se crearon*/
/*SELECT TOP 3 Nombre , Apellido
FROM Empleados;*/

/*
SELECT Puesto,Nombre,Apellido
FROM Empleados
WHERE Puesto = 'Representante de Ventas';
*/

/*Si quiero discriminar osea "negarlo por asi decirlo" para que me  traiga todo lo contrario*/
/*SELECT Puesto,Nombre,Apellido
FROM Empleados
WHERE Puesto <> 'Representante de Ventas';
*/
/*
SELECT IDCliente,NombreEmpresa,Region
FROM Clientes
WHERE REGION IS DISTINCT FROM 'WA';
*/

/*
SELECT IDCliente,NombreEmpresa,Region
FROM Clientes
WHERE REGION IS NULL; /*Esta es la forma de comparar si un tipo de dato es nulo*/
/*Podria agregar si quisiera seguido al where si quisiera ordenar  segun el criterio que quisiese*/
*/
/*
SELECT Nombre,Apellido
FROM Empleados
WHERE Nombre = 'J' AND 'M';
;*/

/*
/*Listar nombre apellido y fecha de nacimiento  de los empleados nacidos
antes de 1975 */
SELECT Nombre,Apellido,FechaNacimiento
FROM Empleados
WHERE FechaNacimiento < '19750101'
*/
/*
SELECT Saludo,Apellido
FROM Empleados
WHERE Saludo LIKE 'S%';
;*/

/*Ahora verifico con el otro comodin ->*/
/*SELECT Saludo,Nombre,Apellido
FROM Empleados
WHERE Saludo LIKE 'S_.' */

/*Seleccionar nombre y apellido de los representatntes de ventas cuyo saludo es sr*/
/*SELECT Saludo,Nombre,Apellido,Puesto
FROM Empleados
WHERE Puesto='Representante de Ventas' AND Saludo = 'Sr.'
*/

/*Seleccionar nombre apellido y ciudad de todos los empleados de la ciudad
de Seattle o Redmond*/
/*SELECT Nombre,Apellido,Ciudad
FROM Empleados
WHERE Ciudad in ('Seattle','Redmond')*/

/*Listar todos los pedidos del año 2019*/
/*SELECT NombreEnvio, FechaPedido
FROM Pedidos
WHERE FechaPedido >= '2019/01/01' AND FechaPedido < '2020/01/01'; */


/*--------------------Funciones de agrupamiento-----------------------------*/

/*Hallar Cuantas ciudades diferentes tienen empleadoS*/
SELECT COUNT(DISTINCT Ciudad)
FROM Empleados

/*Total de unidades pedidas del producto 3*/

SELECT SUM(Cantidad)
FROM [Detalles Pedido]
WHERE IDProducto =3 

/*Precio unitario promedio de los productos*/
SELECT AVG(PrecioUnitario)
FROM [Detalles Pedido];

/* Encontrar la fecha de la primera y ultima contratacion de empleados*/

SELECT MIN(FechaAlta) AS PrimeraContratacion,MAX(FechaAlta) AS UltimaContratacion
FROM Empleados

/*Obtener el nro de empleados de cada ciudad en la que haya al menos dos empleados*/
SELECT Ciudad, COUNT(*) AS CantEmpl /* Traer todos los empleados*/            
FROM Empleados /*De la tabla de empleados*/
GROUP BY Ciudad /*Con el having tengo que agrupar antes de hacer la condicion*/
HAVING COUNT(IDEmpleado)>1; /**/

/*Hallar el numero de representantes de ventas en cada ciudad que cuente con al menos
dos .Ordenar segun el numero de empleados*/
/*SELECT Ciudad, COUNT(*) AS CantEmpleados
FROM Empleados
WHERE Puesto = 'Representante de Ventas'
GROUP BY Ciudad
HAVING COUNT(IDEmpleado)>1
;
*/
/*--------------------SubConsultas-----------------------------*/

SELECT NombreEmpresa,IDCliente
FROM Clientes
WHERE IDCliente = (SELECT Pedidos.IDCliente
				   FROM Pedidos
		  		   WHERE IDPedido = 10290)

/*Se necesita obtener los datos del pedido con el mayor ID*/
/*Esta query lo q tiene de malo es que solo devuelve el id del pedido no los datos*/
SELECT MAX(IdPedido) AS MayorId
FROM Pedidos
/*Ahora si lo hago con la subConsulta*/
SELECT IDPedido,FechaEnvio,IDEmpleado						 
FROM Pedidos
WHERE IDPedido=(SELECT MAX(P.IDPedido) 
				FROM Pedidos as P)
/*Devolver todos los pedidos de aquellos apellidos de los empleados que empiezan con la letra C*/
SELECT IDPedido,IDEmpleado/*Lo unico que necesito a comparar es el idPedido*/
FROM Pedidos
WHERE IDEmpleado IN (SELECT E.IDEmpleado  /*Hay q utilizar operador de conjunto pq puede fallar si existiera mas de un empleado*/
				    FROM Empleados AS E
				    WHERE E.Apellido LIKE 'C%')

/*Ejemplo de una subconsulta correlacionada*/
SELECT IDPedido, IDCliente
FROM Pedidos AS O
WHERE 20 < ( SELECT IDPedido
			 FROM [Detalles Pedido]AS OD 
			 WHERE OD.IDPedido = O.IDPedido AND OD.IDProducto = 23)

/*Devuelve los pedidos con el maximo numero para cadaa cliente*/
SELECT IDCliente,IDEmpleado,NombreEnvio
FROM Pedidos AS P1
WHERE P1.IDCliente=(SELECT MAX(P2.IDCliente) 
					FROM Pedidos AS P2 
					WHERE P1.IDCliente = P2.IDCliente)

/*--------------------SubConsultas con exists-----------------------------*/
/*Una consulta para obtener los clientes de España que han realizado pedidos*/
SELECT *
FROM Clientes AS C 
WHERE Pais = 'España' AND EXISTS(SELECT* 
								FROM Pedidos AS P1 
								WHERE C.IDCliente = P1.IDCliente);
/*No es necesario que sea el operador and exists con el in tambien alcanza*/
SELECT *
FROM Clientes AS C 
WHERE Pais = 'España' AND IDCliente IN(SELECT IDCliente
									   FROM Pedidos AS P1 
									   WHERE C.IDCliente = P1.IDCliente);

/*Si quiero buscar lo opuesto osea Clientes que no tienen pedidos de españa*/
SELECT *
FROM Clientes AS C 
WHERE Pais = 'España' AND IDCliente NOT IN(SELECT IDCliente 
									       FROM Pedidos AS P1 
									       WHERE P1.IDCliente IS NOT NULL);--Aca lo agrego para que no de ese error 
										   --si uno de los registro tiene valores nulos

/*La diferencia principal es que el IN no acepta valores null en su registro,
por ende solo va a devolver un registro si y solo si NO tiene valores NULL.*/

/*--------------------JOINS-----------------------------*/
--Reporte completo entre pedidos y IDempleado
SELECT Apellido,P.IDEmpleado,p.FechaPedido
FROM Pedidos AS P INNER JOIN Empleados AS E ON P.IDEmpleado = E.IDEmpleado

--Crear un reporte que muestre idpedido, y nombre de la empresa que realizo el pedido,
--, y el nombre y apellido del empleado que lo ingreso.
--Solo mostrar pedidos efectuados despues del 1 de enero de 2021 que fueron despachadas luego d ela fecha requerida
--Ordenar por nombre de empresa
SELECT P.IDPedido, C.NombreEmpresa,E.Nombre,E.Apellido
FROM Pedidos AS P INNER JOIN Clientes AS C ON
P.IDCliente= C.IDCliente JOIN  --Esto es nuevo le agregamos 
Empleados AS E ON E.IDEmpleado = P.IDEmpleado
WHERE P.FechaPedido>'20210101' AND P.FechaEnvio>P.FechaRequerida
ORDER BY C.NombreEmpresa;

--Crear un reporte que muestre el numero de empleados y clientes de cada ciudad que tenga empleados en ella
SELECT COUNT(DISTINCT C.IDCliente)AS CantidadClientes,COUNT(DISTINCT E.IDEmpleado)AS CantidadEmpleados,E.Ciudad AS CiudadEmpleado,C.Ciudad AS CiudadCliente
FROM Empleados AS E INNER JOIN Clientes AS C ON E.ciudad = C.Ciudad --Osea se lo agregamos despues
GROUP BY C.Ciudad,E.Ciudad
--Ahora si yo quisiera pudiera ejecutar de la misma forma para verificar los que quedaron fuera con
--LEFT RIGHT incluso hacer un FULL OUTER.
;  

/*--------------------Combinacion de una tabla consigo misma*/
--El registro pide traer para cada empleado quien es su jefe
SELECT	E1.IDEmpleado AS EmpleadoID, E2.JefeID AS JefeID
FROM Empleados AS E1 LEFT JOIN Empleados AS E2 ON E1.IDEmpleado = E2.IDEmpleado --
ORDER BY E1.IDEmpleado

/*--------------------DIVISION RELACIONAL-----------------------------*/

SELECT IDCliente
FROM Pedidos
WHERE IDEmpleado IN (SELECT Empleados.IDEmpleado FROM Empleados WHERE PAIS = 'EE.UU.')
GROUP BY IDCliente --Hasta aca estoy guardando separando los pedidos que son de estados unidos y agrupandolos segun eel id del cliente
HAVING COUNT(DISTINCT IDEmpleado) = (SELECT COUNT(*)FROM Empleados WHERE Pais = 'EE.UU.')-- Aca comparo la cantidad de empleados americanos DISTINTOS que atendieron 
-- a ese cliente, contra el total de empleados americanos que existen.
-- Si son iguales, significa que el cliente compró con TODOS ellos.

--Aca tenemos otra forma de aplicar la division relacional 
--Y es aplicando la logica de predicados
SELECT IDCliente FROM Clientes AS C
WHERE NOT EXISTS (SELECT *
				  FROM Empleados AS E
				  WHERE PAIS = 'EE.UU.' AND NOT EXISTS (SELECT * 
														FROM Pedidos AS P
														WHERE P.IDCliente = C.IDCliente   --Tratar de leer desde dentro hacia fuera
														AND P.IDEmpleado = E.IDEmpleado))

/*--------------------Practica Pampero-----------------------------*/

--Seleccione todos los campos de la tabla cliente, ordenados por nombre del contacto de la empresa, alfabéticamente.

SELECT * 
FROM Clientes AS C
ORDER BY C.NombreEmpresa
--2. Seleccione todos los campos de la tabla pedidos, ordenados por fecha de la orden, descendentemente. 
SELECT * 
FROM Pedidos AS P
ORDER BY P.FechaPedido DESC

--3. Seleccione todos los campos de la tabla detalle de pedidos, ordenados por cantidad pedida.
--Ascendentemente. 

SELECT * 
FROM Pedidos AS P
ORDER BY P.EnvioPor ASC

--4. Obtener todos los productos, cuyo nombre comienzan con la letra P y tienen un precio unitario
--comprendido entre 10 y 120
SELECT * 
FROM Productos AS P
WHERE P.NombreProducto LIKE 'P%'AND P.PrecioUnitario BETWEEN 10 AND 120

--5. Obtener todos los clientes de los países de: EE.UU., Francia y Reino Unido.
SELECT *
FROM Clientes AS C
WHERE C.Pais IN ('EE.UU','Francia','Reino Unido')

--6. Obtener todos los productos descontinuados y sin stock, 
--que pertenecen a la categoría 1, 4 y 6.
SELECT * 
FROM Productos AS P
WHERE (P.Discontinuado =1 OR P.UnidadesEnStock = 0) AND P.IDCategoria IN (1,4,6)
-- Asumo que el tipo de dato TinyInt es un dato como 1(Descontinuado) o 0(NO descontinuado)
--7. Obtener todos los pedidos hechos por el empleado con código: 2, 5, 7 y 8 en el año 2019

SELECT * 
FROM Pedidos AS P
WHERE P.IDEmpleado IN (2,5,7,8)--AND (P.FechaPedido >= '20190101' AND P.FechaPedido <='20191231')
							   AND YEAR(P.FechaPedido) = 2019 ;--Esta forma es mas eficiente y limpia al final
--9. Seleccionar todos los clientes que no cuenten con FAX, del País de EE.UU.
SELECT *
FROM Clientes AS C
WHERE C.Pais = 'EE.UU' AND C.Fax IS NULL --Al parecer analizando solo la tabla no contamos con ningun cliente
--de nacionalidad estadounidense

--10. Seleccionar todos los empleados que cuentan con un jefe. 
SELECT * 
FROM Empleados AS E
WHERE E.JefeID IS NOT NULL

--11. Seleccionar todos los campos del cliente, cuya empresa empiecen con letra O hasta la S y pertenezcan al
--país de EE.UU., ordenarlos por la dirección. 
SELECT *
FROM Clientes AS C
WHERE LEFT(UPPER(C.NombreEmpresa), 1) BETWEEN 'O' AND 'S' AND C.Pais = 'EE.UU.'
ORDER BY C.Direccion

--12. Seleccionar todos los campos del cliente, cuya empresa empiecen con las letras de la B a la G, y
--pertenezcan al país de Reino Unido, ordenarlos por nombre de la empresa

SELECT * 
FROM CLIENTES AS C
WHERE LEFT(UPPER(C.NombreEmpresa),1) BETWEEN 'B' AND 'G' AND C.Pais = 'Reino Unido'
ORDER BY C.NombreEmpresa

--13. Seleccionar los productos vigentes cuyos precios unitarios están entre 35 y 250, sin stock en almacén,
--pertenecientes a las categorías 1, 3, 4, 6 y 8, que son distribuidos por los proveedores, 2, 4, 6, 7, 8 y 9.
SELECT *
FROM Productos AS P
WHERE P.DISCONTINUADO=0 AND P.IDProveedor IN (2,4,6,7,8,9)
AND P.IDProveedor IN (2, 4, 6, 7, 8,9)AND P.PrecioUnitario>35 AND P.PrecioUnitario<250--AND P.PrecioUnitario BETWEEN 35 AND 250 --No es valido pq el ejercicio dice q tiene q estar entre no incluyentes
AND P.UnidadesEnStock = 0;
--14. Seleccionar todos los campos de los productos descontinuados, que pertenezcan a los proveedores con
--códigos: 1, 3, 7, 8 y 9, que tengan stock en almacén, y al mismo tiempo que sus precios unitarios estén
--entre 39 y 190, ordenados por código de proveedores y precio unitario de manera ascendente. 
SELECT IDProducto 
FROM Productos AS P
WHERE P.Discontinuado = 1 AND P.IDProveedor IN (1, 3, 7, 8, 9)
AND P.UnidadesEnStock>0 AND P.PrecioUnitario >39AND P.PrecioUnitario <190-- AND P.PrecioUnitario BETWEEN 39 AND 190 --Misma condicion que ejercicios anteriores tiene que estar entre un rango(NO usar between)
ORDER BY P.IDProveedor ASC, p.PrecioUnitario ASC 
--Esto se va a ordenar, y si solo si hay un empate es que entra en juego el segundo ordenador

--15. Seleccionar los 7 productos con precio más caro, que cuenten con stock en almacén
SELECT TOP 7 P.PrecioUnitario,P.IDProducto,p.UnidadesEnStock,p.NombreProducto
FROM Productos AS P
WHERE P.UnidadesEnStock >0
ORDER BY P.PrecioUnitario DESC;

--16. Seleccionar los 9 productos, con menos stock en almacén, que pertenezcan a la categoría 3, 5 y 8. 
SELECT TOP 9*
FROM PRODUCTOS AS P
WHERE P.IDCategoria IN (3,5,8)
ORDER BY P.UnidadesEnStock ASC

--17. Seleccionar los pedidos, realizados por el empleado con código entre el 2 y 5, además de los clientes con
--código que comienzan con las letras de la A hasta la G, del 31 de enero de cualquier año. 
SELECT * 
FROM PEDIDOS AS P
WHERE P.IDEmpleado BETWEEN 2 AND 5 OR --(LEFT(UPPER(P.IDCliente),1) BETWEEN 'A' AND 'G'--Verificar difrencias entre usar between y mayor/menor
										(LEFT(UPPER(P.IDCliente),1)>= 'A' AND LEFT(UPPER(P.IDCliente),1) <'G' --Con el between estaba trayendo Incluso hasta la g pq utiliza el >=
										AND DAY(P.FechaPedido) = 31
										AND MONTH(P.FechaPedido) = 12)
									   --AND P.FechaPedido LIKE '____0131') --Cuidado con el uso de las fechas con el like con las fechas
									   --Deberia haber formateado la fecha en todo caso
ORDER BY P.IDEmpleado

--18. Seleccionar los pedidos, realizados por el empleado con código 3, de cualquier año, pero solo de los
--últimos 5 meses (agosto-diciembre) 

SELECT * 
FROM Pedidos AS P 
WHERE MONTH(P.FechaPedido)>7 AND P.IDEmpleado = 3;--Podría si hubiera querido tomar >=8 es solo cuestion de logica

--19. Seleccionar los detalles de los pedidos, que tengan un monto de cantidad pedida entre 10 y 250
SELECT *
FROM [Detalles Pedido] AS P
WHERE P.Cantidad>10 AND P.Cantidad<250;--P.Cantidad BETWEEN 10 AND 250;

--20. Seleccionar los detalles de los pedidos, cuyo monto del pedido estén entre 10 y 100. 
SELECT *
FROM [Detalles Pedido] AS d 
WHERE d.Cantidad * (d.PrecioUnitario*(1-d.Descuento))>10 AND
	  d.Cantidad * (d.PrecioUnitario*(1-d.Descuento))<100;

--21. Informar los diferentes países que se encuentra en la tabla Clientes
SELECT DISTINCT	c.Pais
FROM Clientes AS C
--22. Mostrar los 10 productos más vendidos e incluyendo a los empates en el último registro
SELECT TOP 10 WITH TIES*-- Anotar : Con el with ties <-- Incluimos con este with ties los empates
FROM Productos AS P
ORDER BY P.UnidadesEnPedidos DESC
--23. Visualizar el máximo y mínimo precio de los productos por categoría, mostrar el nombre de la categoría.
SELECT C.NombreCategoria AS Categoria, MAX(P.PrecioUnitario) AS Maximo,Min(P.PrecioUnitario) AS Minimo
FROM PRODUCTOS AS P INNER JOIN Categorias AS C ON P.IDCategoria = C.IDCategoria
GROUP BY C.NombreCategoria
--24. Visualizar el máximo y mínimo precio de los productos por proveedor, mostrar el nombre del proveedor
SELECT PROV.NombreContacto,MAX(PR.PrecioUnitario)AS Maximo,MIN(PR.PrecioUnitario)AS Minimo
FROM PRODUCTOS AS PR INNER JOIN Proveedores AS PROV ON PR.IDProveedor = PROV.IDProveedor
GROUP BY PROV.NombreContacto
--25. Seleccionar las categorías que tengan más 5 productos. Mostrar el nombre de la categoría y el número de
--productos.
SELECT C.NombreCategoria AS NombreCategoria,COUNT(P.IDProducto) AS NProductos
FROM Productos as p INNER JOIN Categorias AS C ON P.IDCategoria = C.IDCategoria
GROUP BY C.NombreCategoria
HAVING COUNT(P.IDProducto)>5
--26. Calcular cuántos clientes existen en cada País.
SELECT C.Pais,COUNT(C.IDCliente)
FROM Clientes AS C
GROUP BY C.Pais
--27. Calcular cuántos clientes existen en cada Ciudad.
SELECT C.CIUDAD,COUNT(C.IDCliente) AS CantidadDeClientes
FROM CLIENTES AS C
GROUP BY C.Ciudad
--28. Calcular cuántos proveedores existen en cada Ciudad y País.
SELECT P.Ciudad AS ProveedoresEnCiudad,COUNT(P.Ciudad)AS CantidadCiudad--,P.Pais AS ProveedoresEnPais,COUNT(P.Pais)AS CantidadPais
FROM Proveedores AS P
GROUP BY P.Ciudad--,P.Pais 
--Para realizar esta consulta se tiene que hacer por separado para q sea mas prolijo y de una forma limpia
SELECT P.Pais , COUNT(P.IDProveedor) AS CantidadDeProveedores-- Tambien podria funcionar con COUNT(P.PAIS) ,pq de esta forma contaria cada registro como un length()
FROM Proveedores AS P
GROUP BY P.Pais

--29. Calcular el stock total de los productos por cada categoría. Mostrar el nombre de la categoría y el stock
SELECT c.NombreCategoria AS Categoria, SUM(P.UnidadesEnStock) AS UnidadesEnStock
FROM PRODUCTOS AS P INNER JOIN Categorias AS C ON C.IDCategoria = P.IDCategoria
GROUP BY c.NombreCategoria
--por categoría.
--30. Mostrar el número de pedidos realizados de cada uno de los clientes por año. 
SELECT C.IDCliente,COUNT(P.IDPedido) AS CantidadDePedidos,YEAR(P.FechaPedido) AS Año 
FROM Clientes AS C INNER JOIN Pedidos AS P ON C.IDCliente = P.IDCliente
GROUP BY C.IDCliente,YEAR(P.FechaPedido)
ORDER BY C.IDCliente
--ORDER BY YEAR(P.FechaPedido)DESC
--ORDER BY YEAR(P.FechaPedido)
--31. Calcular el stock total de los productos por cada categoría. Mostrar el nombre de la categoría y el stock
--por categoría. Solamente las categorías 2, 5 y 8.
SELECT C.NombreCategoria,SUM(P.UnidadesEnStock) AS UnidadesStock
FROM PRODUCTOS AS P INNER JOIN Categorias AS C ON P.IDCategoria = C.IDCategoria
GROUP BY C.NombreCategoria,P.IDCategoria
HAVING P.IDCategoria IN (2,5,8); 
--Esta version es mas eficiente pq filtra primero el where antes de contarlo
--en la funcion del select
SELECT C.NombreCategoria, SUM(P.UnidadesEnStock) AS UnidadesStock
FROM PRODUCTOS AS P 
INNER JOIN Categorias AS C ON P.IDCategoria = C.IDCategoria
WHERE C.IDCategoria IN (2, 5, 8)
GROUP BY C.NombreCategoria;

--32. Obtener el nombre del cliente, nombre de proveedor, nombre del empleado y el nombre de los productos
--que están en el pedido 10250.
SELECT p.IDCliente AS NombreCliente,e.Nombre AS NombreEmpleado,PROV.NombreContacto AS NombreProveedor,PROD.NombreProducto AS NombreProducto,P.IDPedido
FROM Pedidos AS P INNER JOIN [Detalles Pedido] AS D ON P.IDPedido = D.IDPedido  --Hasta aca uni el pedido con el detalle
INNER JOIN Empleados AS E ON E.IDEmpleado = P.IDEmpleado --Uno tambien los empleados
INNER JOIN PRODUCTOS AS PROD ON PROD.IDProducto = D.IDProducto --y aca del mismo detalle busco los productos
INNER JOIN Proveedores AS PROV ON PROV.IDProveedor = PROD.IDProveedor --
WHERE P.IDPedido = 10250 

--33. Mostrar el número de pedidos realizados de cada uno de los empleados en cada año.
SELECT E.IDEmpleado,YEAR(P.FechaPedido) AS AñoRealizado,COUNT(E.IDEmpleado) AS Cantidad
FROM Pedidos AS P INNER JOIN Empleados AS E ON P.IDEmpleado = E.IDEmpleado
GROUP BY E.IDEmpleado,YEAR(P.FechaPedido)
--34. Mostrar el número de pedidos realizados de cada uno de los clientes por cada mes y año.
SELECT C.IDCliente AS IdCliente,MONTH(P.FechaPedido) AS Mes,YEAR(P.FechaPedido) AS Año
FROM PEDIDOS AS P INNER JOIN Clientes AS C ON P.IDCliente = C.IDCliente
GROUP BY C.IDCliente,MONTH(P.FechaPedido),YEAR(P.FechaPedido)

--35. Contar el número de pedidos que se han realizado por año y meses.
SELECT YEAR(P.FechaPedido)AS AÑO,COUNT(P.FechaPedido)AS CantidadPedidos,MONTH(P.FechaPedido) AS MES
FROM Pedidos AS P
GROUP BY YEAR(P.FechaPedido),MONTH(P.FechaPedido)

--36. Seleccionar el nombre de la empresa del cliente, el código del pedido, la fecha del pedido, código del
--producto, cantidad pedida del producto, nombre del producto, el nombre de la empresa proveedora y la
--ciudad del proveedor.
SELECT C.NombreEmpresa AS NombreEmpresa, PED.IDPedido AS IDPedido,PED.FechaPedido AS FechaPedido,PROD.IDProducto AS IDProducto,
PED.EnvioPor AS CantidadPedida, PROD.NombreProducto as NombreProducto,PROV.NombreEmpresa AS NombreEmpresa, PROV.Ciudad as CiudadProveedor
FROM Clientes AS C INNER JOIN PEDIDOS AS PED ON PED.IDCliente = C.IDCliente
INNER JOIN [Detalles Pedido] AS DET ON DET.IDPedido = PED.IDPedido 
INNER JOIN Productos AS PROD ON PROD.IDProducto = DET.IDProducto
INNER JOIN Proveedores AS PROV ON PROV.IDProveedor = PROD.IDProveedor;


--37. Seleccionar el nombre de la empresa del cliente, nombre del contacto, el código del pedido, la fecha del
--pedido, código del producto, cantidad pedida del producto, nombre del producto y el nombre de la
--empresa proveedora, usar JOIN. Solamente las empresas proveedoras que comienzan con la letra de la A
--hasta la letra G, además la cantidad pedida del producto debe estar entre 18 y 190.
SELECT C.NombreEmpresa AS NombreEmpresaCliente, c.NombreContacto as NombreContacto,
PED.FechaPedido AS FechaPedido,PROD.IDProducto AS CodigoProducto,DET.Cantidad AS CantidadPedida,
PROD.NombreProducto as NombreProducto,PROV.NombreEmpresa AS NombreEmpresaProveedora
FROM Clientes AS C INNER JOIN Pedidos as PED ON PED.IDCliente = C.IDCliente
INNER JOIN [Detalles Pedido] AS DET ON DET.IDPedido = PED.IDPedido
INNER JOIN Productos AS PROD ON PROD.IDProducto = DET.IDProducto
INNER JOIN Proveedores AS PROV ON PROV.IDProveedor = PROD.IDProveedor
WHERE LEFT(UPPER(PROV.NombreEmpresa),1)>'A' AND LEFT(UPPER(PROV.NombreEmpresa),1)<'G'
AND DET.Cantidad>18 AND DET.Cantidad<190
--38. Seleccionar cuantos proveedores tengo en cada país, considerando solo a los nombres de los
--proveedores que comienzan con la letra E hasta la letra P, además de mostrar solo los países donde tenga
--más de 2 proveedores.
SELECT PROV.Pais,COUNT(PROV.IDProveedor) AS CantidadDeProveedores
FROM Proveedores AS PROV
WHERE LEFT(UPPER(PROV.NombreContacto),1)>='E' AND LEFT(UPPER(PROV.NombreContacto),1)<'P'
GROUP BY PROV.Pais
HAVING COUNT(PROV.IDProveedor)>2 ;

--39. Obtener el número de productos, por cada categoría. Mostrando el nombre de la categoría, el nombre del
--producto, y el total de productos por categoría, solamente de las categorías 3, 5 y 8. Ordenar por el nombre
--de la categoría.
SELECT C.NombreCategoria AS Categoria,
(SELECT COUNT(P2.IDProducto)
FROM Productos AS P2
WHERE P2.IDCategoria =C.IDCategoria)AS Cantidad,
P.NombreProducto AS NombreProducto
FROM Productos AS P INNER JOIN Categorias AS C ON P.IDCategoria = C.IDCategoria
WHERE C.IDCategoria IN(3,5,8)
--GROUP BY C.NombreCategoria,P.NombreProducto  --No agrupar por el nombre de categoria
ORDER BY C.NombreCategoria

--40. Mostar el número del pedido, la fecha del pedido y el importe total de cada pedido.
SELECT P.IDPedido AS IDDelPedido,P.FechaPedido AS FechaPedido,
(SELECT SUM(DET.Cantidad * (DET.PrecioUnitario*(1-DET.Descuento)))
FROM [Detalles Pedido] AS DET
WHERE DET.IDPedido = P.IDPedido) AS ImporteTotal
FROM PEDIDOS AS P INNER JOIN [Detalles Pedido] AS DET ON DET.IDPedido=P.IDPedido
GROUP BY P.IDPedido,P.FechaPedido;


--41. Mostrar el nombre de producto y en cuantos pedidos de compra se encuentra.
SELECT DISTINCT PROD.IDProducto,PROD.NombreProducto,
(SELECT COUNT(DET2.IDProducto)
FROM [Detalles Pedido] AS DET2
WHERE PROD.IDProducto = DET2.IDProducto)AS CantidadDePedidos
FROM[Detalles Pedido]AS D 
INNER JOIN Productos AS PROD ON D.IDProducto = PROD.IDProducto
ORDER BY PROD.IDProducto;
--42. Muestre los productos cuyo precio es mayor al promedio de precio de todos los productos
SELECT P.NombreProducto,P.IDProducto,P.PrecioUnitario
FROM Productos AS P
WHERE P.PrecioUnitario>(SELECT AVG(PrecioUnitario)
						FROM PRODUCTOS AS P2);

--43. ¿Qué empleados no tienen como jefe al empleado cuyo apellido es Buchanan? Mostrar ID, y saludo,
--nombre y apellido concatenados.
SELECT E.IDEmpleado ,E.Saludo,CONCAT(E.Nombre,'-',E.Apellido)AS NombreYApellido
FROM Empleados AS E
WHERE E.JefeID <>(SELECT E2.IDEmpleado
				  FROM Empleados AS E2
				  WHERE E2.Apellido = 'Buchanan')OR E.JefeID IS NULL;
--44. Se desea armar parejas de representantes de ventas de Estados Unidos (EE. UU.). Hay que considerar que
--no se deben repetir parejas. De cada empleado se desea mostrar concatenados el saludo, nombre y
--apellido.
--Como hago parejas ->Con un join
SELECT e.Saludo,CONCAT(E.Nombre,'-',E.Apellido)AS NombreApellidoPar1,E2.Saludo,CONCAT(E2.Nombre,'-',E2.Apellido)AS NombreApellidoPar2
FROM Empleados AS E INNER JOIN Empleados AS E2 ON E.Puesto = E2.Puesto
WHERE E.Puesto = 'Representante de ventas' AND E.Pais = 'EE.UU.' 
AND E2.Puesto = 'Representante de ventas'AND E2.Pais = 'EE.UU.'
AND E.IDEmpleado<E2.IDEmpleado
--Para considerar solo a las parejas y no encontrar las mismas repetidas agrego
--la condicion de considerar aquellas parejas en donde el primer empleado
--siempre sea menor que el 2do

--45. ¿Qué clientes compraron productos que son suministrados por proveedores que residen en la misma
--región que ellos? Mostrar ID, Nombre de la empresa, nombre del contacto y región. Incluir en el resultado
--aquellos cuya región es NULL si la región del proveedor también es NULL. Ordenar por región.
SELECT DISTINCT c.IDCliente,C.NombreEmpresa,C.NombreContacto,C.Region
FROM Clientes AS C INNER JOIN PEDIDOS AS PED ON C.IDCliente = PED.IDCliente
INNER JOIN [Detalles Pedido] AS DET ON DET.IDPedido =PED.IDPedido 
INNER JOIN Productos AS PROD ON DET.IDProducto = PROD.IDProducto
INNER JOIN Proveedores AS PROV ON PROV.IDProveedor = PROD.IDProveedor
WHERE C.Region = PROV.Region OR (C.Region IS NULL AND PROV.Region IS NULL)
ORDER BY C.Region DESC

--46. Listar los productos (ID, Nombre, precio unitario, y nombre de su categoría). Mostrar solamente aquellos
--productos cuyo precio unitario esté por encima del precio promedio de su categoría. Ordenar por nombre
--de categoría y nombre de producto.
SELECT P.IDProducto AS ID,P.NombreProducto AS Nombre,P.PrecioUnitario AS Precio,c.NombreCategoria
FROM Productos AS P INNER JOIN Categorias AS C ON P.IDCategoria =C.IDCategoria
WHERE P.PrecioUnitario>(SELECT AVG(PrecioUnitario)
						FROM Productos AS P2
						WHERE P.IDCategoria = P2.IDCategoria)
ORDER BY C.NombreCategoria,P.NombreProducto
--47. Listar los proveedores junto con el producto más caro que suministran. Mostrar ID del proveedor, nombre
--de la empresa, ID del producto, nombre del producto. Ordenar por nombre de la empresa proveedora.
SELECT PROV.IDProveedor,PROD.IDProducto, PROD.NombreProducto
FROM PRODUCTOS AS PROD INNER JOIN Proveedores AS PROV ON PROD.IDProveedor =PROV.IDProveedor
WHERE PROD.PrecioUnitario = (SELECT MAX (P.PrecioUnitario)
						  FROM PRODUCTOS AS P
						  WHERE P.IDProveedor = PROV.IDProveedor)
GROUP BY PROV.IDProveedor, PROD.IDProducto, PROD.NombreProducto,PROV.NombreEmpresa
ORDER BY PROV.NombreEmpresa

--48. Armar un reporte que incluya a las ciudades y la cantidad de pedidos que se solicitaron despachar a cada
--ciudad. Hay que considerar que en el listado se deben mostrar todas las ciudades que se encuentran en
--la base de datos, y aquellas ciudades a las que no solicitaron despachar pedidos deben figurar mostrando
--como cantidad cero (0).
--Tengo que traer las tablas de toda la base
--SELECT PED.CiudadEnvio,COUNT(PED.CiudadEnvio) AS CantidadDePedidos--, PROV.Ciudad
--SELECT PED.CiudadEnvio,COUNT(PED.CiudadEnvio)
SELECT CIUDADES.CiudadEnvio,COUNT(PED.CiudadEnvio)
FROM (SELECT CiudadEnvio FROM Pedidos
	  UNION
	  SELECT Ciudad FROM Proveedores
	  UNION
	  SELECT Ciudad FROM Empleados
	  UNION
	  SELECT Ciudad FROM Clientes)AS CIUDADES
LEFT JOIN Pedidos AS PED ON CIUDADES.CiudadEnvio = PED.CiudadEnvio
GROUP BY CIUDADES.CiudadEnvio
--Pedidos AS PED LEFT JOIN Proveedores AS PROV ON PED.CiudadEnvio = PROV.Ciudad
--GROUP BY PED.CiudadEnvio, PROV.Ciudad
--HAVING COUNT(PED.CiudadEnvio)>=0 

--49. Armar un reporte de los pedidos despachados, agrupados por día de la semana en que fueron
--despachados (lunes, martes, etc.).
--50. Listar los clientes de España que realizaron pedidos durante el año 2020. Tener en cuenta que se deben
--mostrar TODOS los clientes de España. Para los que hayan realizado pedidos durante el año 2020, se
--deberá mostrar el último mes en el que realizaron un pedido, indicando el nombre del mes. Para los que
--no realizaron pedidos en el año 2020 se deberá mostrar "Sin Pedidos". Los resultados deberán estar
--ordenados por el nombre de la empresa cliente.



--Ejercicio de 