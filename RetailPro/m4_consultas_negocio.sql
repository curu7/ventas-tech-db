-- ============================================================
-- RetailPro - Modulo 4
-- Pre-entrega: Consultas SQL de negocio
-- Titulo: Extrayendo metricas clave con SQL
-- Alumno: Juan Cruz Fernandez Curutchet
-- Motor: PostgreSQL
-- Base de datos: ventas_tech_db
-- ============================================================

-- ============================================================
-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL
-- Total facturado, cantidad de pedidos y ticket promedio por mes.
-- ============================================================

SELECT
    EXTRACT(MONTH FROM fecha_venta)::INTEGER AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

-- ============================================================
-- CONSULTA 2: RANKING DE PRODUCTOS
-- Top 5 de productos por facturacion total.
-- ============================================================

SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC
LIMIT 5;

-- ============================================================
-- CONSULTA 3: CLIENTES RECURRENTES
-- Clientes con mas de un pedido, cantidad de pedidos y gasto total.
-- ============================================================

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- ============================================================
-- CONSULTA 4: MESES POR ENCIMA O POR DEBAJO DEL PROMEDIO
-- Se agrega "Igual al promedio" para contemplar empates correctamente.
-- ============================================================

WITH facturacion_mensual AS (
    SELECT
        EXTRACT(MONTH FROM fecha_venta)::INTEGER AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
),
promedio_mensual AS (
    SELECT AVG(total_facturado) AS promedio_general
    FROM facturacion_mensual
)
SELECT
    fm.mes,
    fm.total_facturado,
    ROUND(pm.promedio_general, 2) AS promedio_mensual_general,
    CASE
        WHEN fm.total_facturado > pm.promedio_general THEN 'Por encima'
        WHEN fm.total_facturado < pm.promedio_general THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM facturacion_mensual AS fm
CROSS JOIN promedio_mensual AS pm
ORDER BY fm.mes;

-- ============================================================
-- HALLAZGOS
-- ============================================================

-- 1. En marzo se registraron 10 pedidos, con una facturacion total de
--    6444.00 y un ticket promedio de 644.40 por pedido.
-- 2. El producto 1 lidera el ranking con 3 unidades vendidas y 3600.00
--    de facturacion, equivalente al 55.87% del total registrado.
-- 3. Los cinco clientes son recurrentes porque realizaron 2 pedidos cada uno.
--    El cliente 1 fue el de mayor gasto, con un total de 2640.00.
