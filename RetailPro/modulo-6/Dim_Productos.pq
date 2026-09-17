let
    Fuente = Excel.Workbook(File.Contents(RutaArchivo), null, true),
    HojaProductos = Fuente{[Item = "productos", Kind = "Sheet"]}[Data],
    EncabezadosPromovidos = Table.PromoteHeaders(
        HojaProductos,
        [PromoteAllScalars = true]
    ),
    TiposCorregidos = Table.TransformColumnTypes(
        EncabezadosPromovidos,
        {
            {"id_producto", Int64.Type},
            {"nombre_producto", type text},
            {"categoria", type text},
            {"subcategoria", type text},
            {"precio", type number},
            {"costo", type number},
            {"stock", Int64.Type},
            {"activo", Int64.Type}
        },
        "es-AR"
    ),

    // id_producto debe ser único para que el merge sea de muchos a uno y no
    // multiplique filas de Fact_Ventas; el ID 103 está repetido en el origen.
    ProductosUnicos = Table.Distinct(TiposCorregidos, {"id_producto"}),

    // El único precio nulo corresponde al producto 109. Se recupera como 130,
    // valor observado de forma consistente en precio_unitario de sus ventas.
    PrecioRecuperado = Table.ReplaceValue(
        ProductosUnicos,
        null,
        130,
        Replacer.ReplaceValue,
        {"precio"}
    ),

    // El producto 111 es una laptop (subcategoría Laptops), por lo que se asigna
    // a Computación en vez de dejar una categoría que impediría agruparlo.
    CategoriaCompleta = Table.ReplaceValue(
        PrecioRecuperado,
        null,
        "Computación",
        Replacer.ReplaceValue,
        {"categoria"}
    )
in
    CategoriaCompleta
