USE practica1

--Listar el numero de todos los articulos
SELECT IDART
FROM ARTICULOS

--Listar el numero,nombre, categoría y ciudad de todos los proveedores
SELECT IDPROV,NOMBRE,CATEGORIA,CIUDAD 
FROM PROVEEDORES

--Obtener el numero y la categoira de los proveedores que residen en rosario
SELECT IDPROV,CATEGORIA 
FROM PROVEEDORES AS P
WHERE P.CIUDAD = 'Rosario'

--Listar el nro de proveedor de aquellos proveedores de Rosario cuya categoría sea mayor a 20
SELECT IDPROV,CATEGORIA 
FROM PROVEEDORES AS P
WHERE P.CIUDAD = 'Rosario' AND P.CATEGORIA>20 --Reciclo la query anterior
--Respecto a la anterior a los que la categoria no sea 20
SELECT IDPROV,CATEGORIA 
FROM PROVEEDORES AS P
WHERE P.CIUDAD = 'Rosario' AND P.CATEGORIA<>20
--Listar el numero de proveedores que suministran el arituclo 20
SELECT IDPROV
FROM PROVEEDORES AS P
WHERE IDPROV IN (SELECT C.IDPROV
				  FROM CONTRATOS AS C
				  WHERE C.IDART = 20)
--Listar el numero de proveedores que NO suministran el articulo 20
SELECT IDPROV
FROM PROVEEDORES AS P
WHERE IDPROV NOT IN (SELECT C.IDPROV
				  FROM CONTRATOS AS C
				  WHERE C.IDART = 20)
--Listar el numero de proveedores con la misma categoria que el proveedor 6 
SELECT *
FROM PROVEEDORES AS P1
WHERE P1.CATEGORIA IN (SELECT P2.CATEGORIA 
					   FROM PROVEEDORES AS P2 
					   WHERE P2.IDPROV='6')

--Listar el numero de proveedor, articulo y ciudad para aquellos proveedores
--y articulos que residen en la misma ciudad
SELECT DISTINCT P.CIUDAD AS Ciudad,A.IDART,P.IDPROV
FROM PROVEEDORES AS P INNER JOIN ARTICULOS AS A ON
P.CIUDAD = A.CIUDAD
--GROUP BY P.CIUDAD,A.CIUDAD,A.IDART,P.IDPROV;

--Se desea una lista con n° de proveedor, n° de articulo y nombre de la ciudad de 
-- los proveedores que suministran artículos que se depositan en la misma ciudad 
--donde ellos residen
SELECT A.IDART, P.IDPROV, A.CIUDAD AS CIUDAD
FROM CONTRATOS AS C INNER JOIN ARTICULOS AS A ON C.IDART = A.IDART 
INNER JOIN PROVEEDORES AS P ON P.IDPROV = C.IDPROV
WHERE A.CIUDAD = P.CIUDAD

--11. Listar el número de aquellos artículos suministrados por 
--proveedores residentes en córdoba

SELECT A.IDART--, P.IDPROV, P.CIUDAD AS CIUDAD
FROM CONTRATOS AS C INNER JOIN ARTICULOS AS A ON C.IDART = A.IDART 
INNER JOIN PROVEEDORES AS P ON P.IDPROV = C.IDPROV
WHERE P.CIUDAD = 'Córdoba';

--12. Listar la descripción de los artículos depositados en Córdoba que son suministrados 
---por proveedores residentes en Córdoba
SELECT A.[desc] --, P.IDPROV, P.CIUDAD AS CIUDAD,A.ciudad
FROM CONTRATOS AS C INNER JOIN ARTICULOS AS A ON C.IDART = A.IDART 
INNER JOIN PROVEEDORES AS P ON P.IDPROV = C.IDPROV
WHERE P.CIUDAD = 'Córdoba' AND A.CIUDAD = 'Córdoba';

--13. Obtener el número de aquellos artículos cuyo peso esté entre 4 y 8 kilos 
--o sean provistos por el proveedor 3.
SELECT A.IDART, A.PESO,P.IDPROV
FROM CONTRATOS AS C INNER JOIN ARTICULOS AS A ON C.IDART = A.IDART 
INNER JOIN PROVEEDORES AS P ON P.IDPROV = C.IDPROV
WHERE P.IDPROV = 3 OR A.PESO IN (4,5,6,7,8);
--14. Obtener la descripción de los artículos que se depositan en la misma ciudad
--donde está el depósito del artículo 50
SELECT A.[DESC]--,A.CIUDAD
FROM ARTICULOS AS A
WHERE A.CIUDAD = (SELECT A2.CIUDAD
					FROM ARTICULOS AS A2
					WHERE A2.IDART = 50) 
--15. Obtener los detalles de los proveedores que suministra los artículos 10 o 60.
SELECT DISTINCT P.IDPROV,P.NOMBRE,P.CATEGORIA--,A.IDART
FROM CONTRATOS AS C INNER JOIN ARTICULOS AS A ON C.IDART = A.IDART 
INNER JOIN PROVEEDORES AS P ON P.IDPROV = C.IDPROV
WHERE A.IDART = 10 OR A.IDART = 60 
--16. Obtener los detalles de los proveedores que suministra los artículos 10 Y 60.
SELECT DISTINCT P.IDPROV,P.NOMBRE,P.CATEGORIA
FROM CONTRATOS AS C INNER JOIN ARTICULOS AS A ON C.IDART = A.IDART 
INNER JOIN PROVEEDORES AS P ON P.IDPROV = C.IDPROV
WHERE C.IDART  = 10 AND EXISTS(SELECT A.IDART 
								FROM CONTRATOS AS C2
								WHERE C2.IDART =60 AND C.IDPROV = C2.IDPROV)
--17. Obtener el nombre de aquellos proveedores que suministran el artículo 10
SELECT P.NOMBRE
FROM CONTRATOS AS C INNER JOIN PROVEEDORES AS P ON C.IDPROV = P.IDPROV
WHERE C.IDART = 10;
--18. Obtener el nombre de aquellos proveedores que no suministran el art 10
SELECT DISTINCT P.NOMBRE
FROM CONTRATOS AS C INNER JOIN PROVEEDORES AS P ON C.IDPROV = P.IDPROV
WHERE C.IDART <>10 AND NOT EXISTS (SELECT *
								FROM CONTRATOS AS C2 
								WHERE C2.IDPROV = P.IDPROV AND C2.IDART=10);

--19. Obtener los detalles de los proveedores que suministran todos los artículos.
SELECT P.IDPROV,P.NOMBRE,P.CATEGORIA
FROM CONTRATOS AS C INNER JOIN ARTICULOS AS A ON C.IDART = A.IDART
INNER JOIN PROVEEDORES AS P ON C.IDPROV = P.IDPROV
WHERE NOT EXISTS(SELECT *
				FROM ARTICULOS AS A2
				WHERE NOT EXISTS(SELECT *
								 FROM CONTRATOS AS C2
								 WHERE C2.IDPROV = C.IDPROV AND C2.IDART = A2.IDART))