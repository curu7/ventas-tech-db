let
    Fuente = Excel.Workbook(File.Contents(RutaArchivo), null, true),
    HojaVentas = Fuente{[Item = "ventas", Kind = "Sheet"]}[Data],
    EncabezadosPromovidos = Table.PromoteHeaders(
        HojaVentas,
        [PromoteAllScalars = true]
    ),
    TiposCorregidos = Table.TransformColumnTypes(
        EncabezadosPromovidos,
        {
            {"id_venta", Int64.Type},
            {"fecha_venta", type date},
            {"id_cliente", Int64.Type},
            {"id_producto", Int64.Type},
            {"cantidad", Int64.Type},
            {"precio_unitario", type number},
            {"descuento", type number},
            {"total_venta", type number},
            {"canal", type text}
        },
        "es-AR"
    ),

    // Left Outer preserva las 50 ventas aunque aparezca una clave de producto
    // sin correspondencia; el control de calidad se mantiene en la tabla de hechos.
    MergeProductos = Table.NestedJoin(
        TiposCorregidos,
        {"id_producto"},
        Dim_Productos,
        {"id_producto"},
        "DatosProducto",
        JoinKind.LeftOuter
    ),
    ProductoExpandido = Table.ExpandTableColumn(
        MergeProductos,
        "DatosProducto",
        {"nombre_producto", "categoria"},
        {"nombre_producto", "categoria"}
    )
in
    ProductoExpandido
