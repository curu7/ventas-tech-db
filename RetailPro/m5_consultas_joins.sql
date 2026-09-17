-- ============================================================
-- RetailPro - Modulo 5
-- Pre-entrega: Consultas con JOINs para el proyecto
-- Titulo: Cruzando tablas para enriquecer el analisis
-- Alumno: Juan Cruz Fernandez Curutchet
-- Motor: PostgreSQL
-- Base de datos: ventas_tech_db
-- ============================================================

-- ============================================================
-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)
-- Combina cada venta con cliente, producto y categoria.
-- La ciudad y la categoria permiten agrupar y filtrar en Power BI.
-- ============================================================

SELECT
    v.id_venta,
    v.fecha_venta AS fecha,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.ciudad,
    p.id_producto,
    p.nombre_producto AS descripcion_producto,
    cat.nombre_categoria AS categoria_producto,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;

-- ============================================================
-- CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN)
-- En los datos actuales devuelve cero filas porque todos compraron.
-- La consulta detectara automaticamente futuros clientes sin compras.
-- ============================================================

SELECT
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.id_cliente;

-- ============================================================
-- CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN)
-- En los datos actuales devuelve cero filas porque todos tienen ventas.
-- ============================================================

SELECT
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.id_producto;

-- ============================================================
-- CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL)
-- Como la tabla ventas no contiene canal, se crean dos origenes de ejemplo:
-- ventas hasta el 10/03 como Online y ventas posteriores como Presencial.
-- UNION ALL conserva todas las operaciones, incluso si dos coinciden.
-- ============================================================

WITH ventas_por_canal AS (
    SELECT
        fecha_venta AS fecha,
        cantidad * precio_unitario AS total,
        'Online' AS canal
    FROM ventas
    WHERE fecha_venta <= DATE '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta AS fecha,
        cantidad * precio_unitario AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE fecha_venta > DATE '2024-03-10'
)
SELECT
    canal,
    COUNT(*) AS cantidad_ventas,
    SUM(total) AS total_facturado
FROM ventas_por_canal
GROUP BY canal
ORDER BY total_facturado DESC;

-- Resultado esperado con los datos de M3:
-- Online: 5 ventas y 3620.00 de facturacion.
-- Presencial: 5 ventas y 2824.00 de facturacion.
