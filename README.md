# RetailPro

Proyecto académico de análisis de datos para una distribuidora de productos tecnológicos. El objetivo es construir un flujo reproducible que permita analizar ventas, clientes, productos y categorías desde PostgreSQL hasta Power BI.

## Objetivo de negocio

El proyecto busca explicar las variaciones de ventas, reconocer los productos y clientes de mayor aporte y preparar un modelo que facilite el análisis por período, categoría y canal.

## Herramientas utilizadas

- PostgreSQL para el diseño de la base y las consultas SQL.
- Power Query para la extracción, limpieza y transformación de datos.
- Power BI para el modelo en estrella, las medidas DAX y la validación visual.
- Git y GitHub para el versionado y la publicación de los entregables.
- ChatGPT como apoyo para revisar código y documentación; los resultados numéricos fueron validados contra los datos originales.

## Estructura principal

```text
RetailPro/
├── ventas_tech_db.sql
├── m4_consultas_negocio.sql
├── m5_consultas_joins.sql
├── modulo-6/
│   ├── 00_RutaArchivo.pq
│   ├── Dim_Categorias.pq
│   ├── Dim_Clientes.pq
│   ├── Dim_Productos.pq
│   ├── Fact_Ventas.pq
│   └── Pipeline_ETL_Fernandez_Curutchet_Juan_Cruz.pbix
└── modulo-8/
    └── Fernandez_Curutchet_Juan_Cruz_Checkpoint2.pbix
```

## Modelo de datos

La base relacional incluye las tablas `categorias`, `clientes`, `productos` y `ventas`. En Power BI se utiliza un modelo en estrella con `Fact_Ventas` relacionada con `Dim_Clientes`, `Dim_Productos` y `Dim_Fechas`; `Dim_Categorias` se conecta con `Dim_Productos`.

## Cómo ejecutar los scripts SQL

### Requisitos

- PostgreSQL instalado.
- Una base de datos llamada `ventas_tech_db`.
- Acceso mediante `psql` o pgAdmin.

### Orden de ejecución

1. Crear la base de datos si todavía no existe:

```sql
CREATE DATABASE ventas_tech_db;
```

2. Conectarse a `ventas_tech_db` y ejecutar el script de estructura y carga:

```bash
psql -U postgres -d ventas_tech_db -f RetailPro/ventas_tech_db.sql
```

3. Ejecutar las consultas de negocio del Módulo 4:

```bash
psql -U postgres -d ventas_tech_db -f RetailPro/m4_consultas_negocio.sql
```

4. Ejecutar las consultas con JOIN y UNION ALL del Módulo 5:

```bash
psql -U postgres -d ventas_tech_db -f RetailPro/m5_consultas_joins.sql
```

El script principal elimina las tablas existentes antes de crearlas nuevamente. Debe ejecutarse únicamente sobre la base académica del proyecto.

## Entregables por módulo

| Módulo | Entregable | Contenido |
|---|---|---|
| M3 | `ventas_tech_db.sql` | DDL, claves, restricciones y datos iniciales |
| M4 | `m4_consultas_negocio.sql` | Métricas mensuales, productos y clientes |
| M5 | `m5_consultas_joins.sql` | JOINs, registros sin movimiento y UNION ALL |
| M6 | `modulo-6/` | Transformaciones Power Query y pipeline ETL |
| M8 | `modulo-8/` | Modelo en estrella, calendario y medidas DAX |

## Validación

Los resultados se contrastaron con la carga inicial de 10 ventas. Antes de usar el proyecto con otra fuente, deben actualizarse las rutas de Power Query, verificarse los tipos de datos y volver a validarse las relaciones y medidas.

## Autor

Juan Cruz Fernandez Curutchet
