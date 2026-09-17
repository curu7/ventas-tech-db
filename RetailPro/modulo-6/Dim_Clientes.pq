let
    Fuente = Excel.Workbook(File.Contents(RutaArchivo), null, true),
    HojaClientes = Fuente{[Item = "clientes", Kind = "Sheet"]}[Data],
    EncabezadosPromovidos = Table.PromoteHeaders(
        HojaClientes,
        [PromoteAllScalars = true]
    ),
    TiposCorregidos = Table.TransformColumnTypes(
        EncabezadosPromovidos,
        {
            {"id_cliente", Int64.Type},
            {"nombre_cliente", type text},
            {"email", type text},
            {"ciudad", type text},
            {"pais", type text},
            {"segmento", type text},
            {"fecha_registro", type date}
        },
        "es-AR"
    ),

    // La dimensión debe tener una fila única por id_cliente para funcionar
    // como lado 1 de las relaciones y evitar duplicar ventas en el modelo.
    ClientesUnicos = Table.Distinct(TiposCorregidos, {"id_cliente"}),

    // Conservamos los clientes con datos de contacto incompletos porque sus
    // claves siguen siendo válidas; eliminarlos podría dejar ventas sin cliente.
    EmailCompleto = Table.ReplaceValue(
        ClientesUnicos,
        null,
        "Sin dato",
        Replacer.ReplaceValue,
        {"email"}
    ),
    CiudadCompleta = Table.ReplaceValue(
        EmailCompleto,
        null,
        "Sin dato",
        Replacer.ReplaceValue,
        {"ciudad"}
    )
in
    CiudadCompleta
