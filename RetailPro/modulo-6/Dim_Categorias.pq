let
    Fuente = Excel.Workbook(File.Contents(RutaArchivo), null, true),
    HojaCategorias = Fuente{[Item = "categorias", Kind = "Sheet"]}[Data],
    EncabezadosPromovidos = Table.PromoteHeaders(
        HojaCategorias,
        [PromoteAllScalars = true]
    ),
    TiposCorregidos = Table.TransformColumnTypes(
        EncabezadosPromovidos,
        {
            {"id_categoria", Int64.Type},
            {"nombre_categoria", type text},
            {"descripcion", type text}
        },
        "es-AR"
    )
in
    TiposCorregidos
