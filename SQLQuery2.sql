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
--Listar el numero de proveedores que NO suministran el arituclo 20
SELECT IDPROV
FROM PROVEEDORES AS P
WHERE IDPROV NOT IN (SELECT C.IDPROV
				  FROM CONTRATOS AS C
				  WHERE C.IDART = 20)

