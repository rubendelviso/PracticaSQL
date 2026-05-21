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
WHERE (P.Discontinuado= 1 OR P.UnidadesEnStock = 0) AND P.IDCategoria IN (1,4,6)
-- Asumo que el tipo de dato TinyInt es un dato como 1(Descontinuado) o 0(NO descontinuado)
--7. Obtener todos los pedidos hechos por el empleado con código: 2, 5, 7 y 8 en el año 2019

SELECT * 
FROM Pedidos AS P
WHERE P.IDEmpleado IN (2,5,7,8)AND (P.FechaPedido >= '20190101' AND P.FechaPedido <='20191231')

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