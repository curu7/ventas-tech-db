# Pipeline ETL de TechStore

## Archivo final requerido

Guardar el proyecto como `Pipeline_ETL_Fernandez_Curutchet_Juan_Cruz.pbix`.

## Decisiones de limpieza

- `Dim_Clientes`: se elimina el duplicado por `id_cliente`. Los nulos de `email`
  y `ciudad` se reemplazan por `Sin dato`. La ausencia de esos atributos no
  invalida la clave del cliente y eliminar la fila podría dejar ventas sin una
  dimensión asociada.
- `Dim_Productos`: se elimina el duplicado por `id_producto`. El precio nulo del
  producto 109 se reemplaza por 130, valor que aparece de manera consistente en
  `precio_unitario` para sus ventas. La categoría nula del producto 111 se asigna
  a `Computación` porque el nombre y la subcategoría indican que es una laptop.
- `Fact_Ventas`: se usa un merge `Left Outer` para conservar las 50 operaciones.
  Se expanden solamente `nombre_producto` y `categoria`.

## Cómo cargar las consultas

1. Descargar `Pipeline_ETL_Dataset.xlsx` y copiar su ruta completa.
2. Abrir Power BI Desktop y entrar en **Transformar datos**.
3. Crear una **Consulta en blanco**, abrir el **Editor avanzado**, pegar el
   contenido de `00_RutaArchivo.pq` y nombrarla `RutaArchivo`.
4. Reemplazar la ruta de ejemplo por la ubicación real del Excel.
5. Crear cuatro consultas en blanco adicionales. Pegar el código de cada archivo
   `.pq` y usar exactamente estos nombres:
   - `Dim_Clientes`
   - `Dim_Productos`
   - `Dim_Categorias`
   - `Fact_Ventas`
6. Deshabilitar la carga de `RutaArchivo`; es solo un parámetro de conexión.
7. Verificar los conteos antes de cerrar:
   - `Dim_Clientes`: 11 filas.
   - `Dim_Productos`: 12 filas.
   - `Dim_Categorias`: 4 filas.
   - `Fact_Ventas`: 50 filas.
8. Confirmar que `Fact_Ventas` incluya `nombre_producto` y `categoria`.
9. Elegir **Cerrar y aplicar** y comprobar que no haya errores.
10. Guardar como `Pipeline_ETL_Fernandez_Curutchet_Juan_Cruz.pbix`.

Los comentarios técnicos ya están incluidos en `Dim_Clientes`, `Dim_Productos`
y `Fact_Ventas`, por lo que se supera el mínimo de dos consultas documentadas.
