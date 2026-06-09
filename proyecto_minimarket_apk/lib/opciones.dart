import 'package:flutter/material.dart';
import 'package:proyecto_minimarket_apk/inventario.dart';
import 'package:proyecto_minimarket_apk/marcas.dart';
import 'package:proyecto_minimarket_apk/productos.dart';
import 'package:proyecto_minimarket_apk/tipos_producto.dart';

class opciones extends StatefulWidget {
  const opciones({super.key});

  @override
  State<opciones> createState() => _opcionesState();
}

class _opcionesState extends State<opciones> {
  String ddlVlrTipoProducto = tipos_producto
      .elementAt(0)["ID_TIPO_PRODUCTO"]
      .toString();
  String ddlVlrMarca = marcas.elementAt(0)["ID_MARCA"].toString();

  final TextEditingController nombreProdCtrl = TextEditingController();
  final TextEditingController descripcionProdCtrl = TextEditingController();
  final TextEditingController valorProdCtrl = TextEditingController();
  final TextEditingController cantidadProdInventarioCtrl =
      TextEditingController();
  final TextEditingController sampleProdCtrl = TextEditingController();

  /// Método para la edición del producto (muestra la ventana modal de edición).
  void _editarProducto(int index) {
    nombreProdCtrl.text = productos[index]["NOMBRE_PRODUCTO"];
    descripcionProdCtrl.text = productos[index]["DESCRIPCION_PRODUCTO"];
    valorProdCtrl.text = productos[index]["VALOR"].toString();

    //print("Tipo producto: ${productos[index]["ID_TIPO_PRODUCTO"]}");
    //print("Marca: ${productos[index]["ID_MARCA"]}");

    ddlVlrTipoProducto = productos[index]["ID_TIPO_PRODUCTO"].toString();
    ddlVlrMarca = productos[index]["ID_MARCA"].toString();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Editar producto'),
            backgroundColor: Color.fromRGBO(0, 120, 215, 1),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
          body: ListView(
            children: [
              DropdownButton(
                hint: Text("Tipo de producto"),
                icon: Icon(Icons.arrow_drop_down),
                items: tipos_producto.map((map) {
                  return DropdownMenuItem<String>(
                    value: map["ID_TIPO_PRODUCTO"].toString(),
                    child: Text(map["NOMBRE_TIPO_PRODUCTO"]),
                  );
                }).toList(),
                value: ddlVlrTipoProducto,
                onChanged: (String? value) {
                  setState(() {
                    ddlVlrTipoProducto = value!;
                  });
                },
              ),
              DropdownButton(
                hint: Text("Marca"),
                icon: Icon(Icons.arrow_drop_down),
                value: ddlVlrMarca,
                onChanged: (String? value) {
                  setState(() {
                    ddlVlrMarca = value!;
                  });
                },
                items: marcas.map((map) {
                  return DropdownMenuItem<String>(
                    value: map["ID_MARCA"].toString(),
                    child: Text(map["NOMBRE_MARCA"]),
                  );
                }).toList(),
              ),
              TextField(
                controller: nombreProdCtrl,
                decoration: InputDecoration(labelText: 'Nombre del producto'),
              ),
              TextField(
                controller: descripcionProdCtrl,
                decoration: InputDecoration(
                  labelText: 'Descripción del producto',
                ),
              ),
              TextField(
                controller: valorProdCtrl,
                decoration: InputDecoration(labelText: 'Valor del producto'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _actualizarProducto(index);
                },
                label: Text('Actualizar'),
                icon: Icon(Icons.update),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Método que actualiza el producto seleccionado.
  void _actualizarProducto(int index) {
    final String nombreProd = nombreProdCtrl.text;
    final String descrProd = descripcionProdCtrl.text;
    final String valorProd = valorProdCtrl.text;

    if (nombreProd.isNotEmpty && descrProd.isNotEmpty && valorProd.isNotEmpty) {
      setState(() {
        productos[index] = {
          "ID_PRODUCTO": productos[index]["ID_PRODUCTO"],
          "ID_TIPO_PRODUCTO": int.parse(ddlVlrTipoProducto.toString()),
          "ID_MARCA": int.parse(ddlVlrMarca.toString()),
          "NOMBRE_PRODUCTO": nombreProd,
          "DESCRIPCION_PRODUCTO": descrProd,
          "VALOR": valorProd,
        };
      });

      // Reiniciar variables:
      nombreProdCtrl.clear();
      descripcionProdCtrl.clear();
      valorProdCtrl.clear();
      ddlVlrTipoProducto = tipos_producto
          .elementAt(0)["ID_TIPO_PRODUCTO"]
          .toString();
      ddlVlrMarca = marcas.elementAt(0)["ID_MARCA"].toString();

      Navigator.pop(context); // NOTE: you can pop item too
    }
  }

  /// Método para eliminar el producto.
  void _eliminarProducto(int index) {
    setState(() {
      productos.removeAt(index);
    });
  }

  /// Método para confirmar la eliminación del producto.
  void _confirmarEliminacionProducto(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensaje de confirmación'),
          content: Text('¿Está seguro que desea eliminar este producto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarProducto(index);
                Navigator.of(context).pop();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  /// Método para la edición del inventario (muestra la ventana modal de edición).
  void _editarInventario(int index) {
    cantidadProdInventarioCtrl.text =
        (inventario_productos[index]['CANTIDAD'].toString().isEmpty ||
            inventario_productos[index]['CANTIDAD'].toString() == "null")
        ? "0"
        : inventario_productos[index]['CANTIDAD'].toString();

    sampleProdCtrl.text =
        "Producto: ${productos[inventario_productos[index]['ID_PRODUCTO'] - 1]['NOMBRE_PRODUCTO']}\r\nDescripción: ${productos[inventario_productos[index]['ID_PRODUCTO'] - 1]['DESCRIPCION_PRODUCTO']}\r\nTipo de producto: ${tipos_producto[productos[inventario_productos[index]['ID_PRODUCTO'] - 1]['ID_TIPO_PRODUCTO'] - 1]['NOMBRE_TIPO_PRODUCTO']}\r\nMarca: ${marcas[productos[inventario_productos[index]['ID_PRODUCTO'] - 1]['ID_MARCA'] - 1]['NOMBRE_MARCA']}";

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Editar inventario del producto'),
            backgroundColor: Color.fromRGBO(0, 120, 215, 1),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
          body: ListView(
            children: [
              /*Text(
                'Producto: ${productos[inventario_productos[index]['ID_PRODUCTO'] - 1]['NOMBRE_PRODUCTO']}',
                textAlign: TextAlign.left,
              ),
              Text(
                'Descripción: ${productos[inventario_productos[index]['ID_PRODUCTO'] - 1]['DESCRIPCION_PRODUCTO']}',
                textAlign: TextAlign.left,
              ),
              Text(
                'Tipo de producto: ${tipos_producto[productos[inventario_productos[index]['ID_PRODUCTO'] - 1]['ID_TIPO_PRODUCTO'] - 1]['NOMBRE_TIPO_PRODUCTO']}',
                textAlign: TextAlign.left,
              ),
              Text(
                'Marca: ${marcas[productos[inventario_productos[index]['ID_PRODUCTO'] - 1]['ID_MARCA'] - 1]['NOMBRE_MARCA']}',
                textAlign: TextAlign.left,
              ),*/
              TextField(
                controller: sampleProdCtrl,
                enabled: false,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              TextField(
                controller: cantidadProdInventarioCtrl,
                decoration: InputDecoration(labelText: 'Cantidad del producto'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _actualizarinventarioProducto(index);
                },
                label: Text('Actualizar'),
                icon: Icon(Icons.update),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Método que actualiza el inventario (OJO, solo la cantidad del producto seleccionado).
  void _actualizarinventarioProducto(int index) {
    final String cantInventProd = cantidadProdInventarioCtrl.text;
    bool? isCantidadNumber = double.tryParse(cantInventProd) != null;

    if (cantInventProd.isNotEmpty &&
        cantInventProd.toLowerCase() != "null" &&
        cantInventProd != "0" &&
        isCantidadNumber) {
      setState(() {
        inventario_productos[index] = {
          "ID_INVENTARIO": inventario_productos[index]["ID_INVENTARIO"],
          "ID_PRODUCTO": inventario_productos[index]["ID_PRODUCTO"],
          "CANTIDAD": int.parse(cantidadProdInventarioCtrl.text),
        };
      });

      // Reiniciar variables:
      cantidadProdInventarioCtrl.clear();

      Navigator.pop(context); // NOTE: you can pop item too
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minimarket - menú principal"),
        backgroundColor: Color.fromRGBO(0, 120, 215, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Card(
            elevation: 6,
            child: ListTile(
              leading: Icon(Icons.add_shopping_cart),
              title: Text("Productos"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setStateSB) => Scaffold(
                        appBar: AppBar(
                          title: Text('Listado de productos'),
                          backgroundColor: Color.fromRGBO(0, 120, 215, 1),
                          foregroundColor: Colors.white,
                        ),
                        body: ListView.builder(
                          itemCount: productos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                leading: Text(
                                  productos[index]['ID_PRODUCTO'].toString(),
                                ),
                                title: Text(
                                  productos[index]['NOMBRE_PRODUCTO'],
                                ),
                                subtitle: Text(
                                  //tipos_producto[productos[index]['ID_TIPO_PRODUCTO'] - 1]['NOMBRE_TIPO_PRODUCTO'], // El "-1" es por el posicionamiento (index) de los elementos de detalle.
                                  "Tipo de producto: ${tipos_producto[productos[index]['ID_TIPO_PRODUCTO'] - 1]['NOMBRE_TIPO_PRODUCTO']}\r\nMarca: ${marcas[productos[index]['ID_MARCA'] - 1]['NOMBRE_MARCA']}",
                                ),
                                trailing: Text(
                                  productos[index]['VALOR'].toString(),
                                ),
                                onTap: () => _editarProducto(index),
                                onLongPress: () =>
                                    _confirmarEliminacionProducto(index),
                              ),
                            );
                          },
                        ),
                        floatingActionButton: FloatingActionButton(
                          backgroundColor: Color.fromRGBO(0, 120, 215, 1),
                          child: Icon(Icons.add_box_outlined),
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return NewItemCreateView(); // We moved this logic on the next block.
                              },
                            );

                            // So, we wait ;and refresh the UI.
                            // Notice I haved used "setStateSB" inside "StatefulBuilder":
                            setStateSB(() {});
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 6,
            child: ListTile(
              leading: Icon(Icons.warehouse_outlined),
              title: Text("Inventario"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setStateSB) => Scaffold(
                        appBar: AppBar(
                          title: Text('Productos en inventario'),
                          backgroundColor: Color.fromRGBO(0, 120, 215, 1),
                          foregroundColor: Colors.white,
                        ),
                        body: ListView.builder(
                          itemCount: inventario_productos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color:
                                  (inventario_productos[index]['CANTIDAD']
                                          .toString()
                                          .isEmpty ||
                                      inventario_productos[index]['CANTIDAD']
                                              .toString() ==
                                          "null")
                                  ? Colors.red
                                  : Colors.white,
                              child: ListTile(
                                textColor:
                                    (inventario_productos[index]['CANTIDAD']
                                            .toString()
                                            .isEmpty ||
                                        inventario_productos[index]['CANTIDAD']
                                                .toString() ==
                                            "null")
                                    ? Colors.white
                                    : Colors.black,
                                leading: Text(
                                  inventario_productos[index]['ID_INVENTARIO']
                                      .toString(),
                                ),
                                title: Text(
                                  productos[index]['NOMBRE_PRODUCTO'],
                                  //inventario_productos[index]['ID_PRODUCTO']
                                ),
                                subtitle: Text(
                                  "Tipo de producto: ${tipos_producto[productos[inventario_productos[index]['ID_PRODUCTO'] - 1]['ID_TIPO_PRODUCTO'] - 1]['NOMBRE_TIPO_PRODUCTO']}\r\nMarca: ${marcas[productos[inventario_productos[index]['ID_PRODUCTO'] - 1]['ID_MARCA'] - 1]['NOMBRE_MARCA']}",
                                ),
                                trailing: Text(
                                  (inventario_productos[index]['CANTIDAD']
                                              .toString()
                                              .isEmpty ||
                                          inventario_productos[index]['CANTIDAD']
                                                  .toString() ==
                                              "null")
                                      ? "0"
                                      : inventario_productos[index]['CANTIDAD']
                                            .toString(),
                                ),
                                onTap: () => _editarInventario(index),
                              ),
                            );
                          },
                        ),

                        /// NOTA: En esta sección se puede incluir el código para insertar el inventario, pero,
                        /// para efectos de demostración, se omite este paso.
                        /// Como se demostró en el funcionamiento de "Producto", se requiere una
                        /// mayor cantidad de código fuente y comprensión del manejo de estados de los
                        /// widgets para visualizar los cambios hechos en la data.
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// "Producto" class.
/// NOTES FROM SO USER: Too much for callback, using class.
/// Also, try using it for the map  as well if fits,else new class.
/// OK u are using GLobal List<Map> I am skipping using it; but you should use it.
/// Credits: https://stackoverflow.com/a/79954275/4092887
class Product {
  Product({
    required this.tipoProd,
    required this.marcaProd,
    required this.nombreProd,
    required this.descrProd,
    required this.valorProd,
  });

  // For dropdowns:
  final String tipoProd;
  final String marcaProd;

  final String nombreProd;
  final String descrProd;
  final String valorProd;

  // yap cloning with - you can search online
  Product copyWith(
    String? tipoProd,
    String? marcaProd,
    String? nombreProd,
    String? descrProd,
    String? valorProd,
  ) {
    return Product(
      tipoProd: tipoProd ?? this.tipoProd,
      marcaProd: marcaProd ?? this.marcaProd,
      nombreProd: nombreProd ?? this.nombreProd,
      descrProd: descrProd ?? this.descrProd,
      valorProd: valorProd ?? this.valorProd,
    );
  }
}

/// Widget - new class to handle new created "Producto" item.
/// you can always pass through constructor.
class NewItemCreateView extends StatefulWidget {
  const NewItemCreateView({
    super.key,
    this.ddlVlrTipoProducto,
    this.ddlVlrMarca,
  });

  // Just for default initial value
  final String? ddlVlrTipoProducto;
  final String? ddlVlrMarca;

  @override
  State<NewItemCreateView> createState() => _NewItemCreateViewState();
}

/// Class - new class to handle new created "Producto" item - for state handling.
class _NewItemCreateViewState extends State<NewItemCreateView> {
  late String? ddlVlrTipoProducto =
      widget.ddlVlrTipoProducto; // get from parent widget
  late String? ddlVlrMarca = widget
      .ddlVlrMarca; // late is good, but explore initState and didUpdateWidget methods.

  // Whatever require for form put here:
  final TextEditingController nombreProdCtrl = TextEditingController();
  final TextEditingController descripcionProdCtrl = TextEditingController();
  final TextEditingController valorProdCtrl = TextEditingController();

  /// Guardar producto
  void _agregarProducto() {
    final String nombre = nombreProdCtrl.text;
    final String descr = descripcionProdCtrl.text;
    final String valor = valorProdCtrl.text;

    //print("=> ddlVlrTipoProducto: ${ddlVlrTipoProducto}");
    //print("=> ddlVlrMarca: ${ddlVlrMarca}");

    if (nombre.isNotEmpty && descr.isNotEmpty && valor.isNotEmpty) {
      final nuevoProducto = {
        "ID_PRODUCTO": productos.length + 1,
        //"ID_TIPO_PRODUCTO": int.tryParse(ddlVlrTipoProducto ?? "") ?? 0 - 1,
        //"ID_MARCA": int.parse(ddlVlrMarca ?? "0") - 1,
        "ID_TIPO_PRODUCTO": int.parse(ddlVlrTipoProducto.toString()),
        "ID_MARCA": int.parse(ddlVlrMarca.toString()),
        "NOMBRE_PRODUCTO": nombre,
        "DESCRIPCION_PRODUCTO": descr,
        "VALOR": valor,
      };

      setState(() {
        productos.add(nuevoProducto);
      });

      // Reiniciar variables:
      nombreProdCtrl.clear();
      descripcionProdCtrl.clear();
      valorProdCtrl.clear();
      ddlVlrTipoProducto = tipos_producto
          .elementAt(0)["ID_TIPO_PRODUCTO"]
          .toString();
      ddlVlrMarca = marcas.elementAt(0)["ID_MARCA"].toString();

      Navigator.pop(context); // NOTE: you can pop item too
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 120, 215, 1),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        title: Text("Nuevo producto"),
      ),
      body: ListView(
        children: [
          DropdownButton(
            hint: Text("Tipo de producto"),
            icon: Icon(Icons.arrow_drop_down),
            items: tipos_producto.map((map) {
              return DropdownMenuItem<String>(
                value: map["ID_TIPO_PRODUCTO"].toString(),
                child: Text(map["NOMBRE_TIPO_PRODUCTO"]),
              );
            }).toList(),
            value: ddlVlrTipoProducto,
            onChanged: (String? value) {
              setState(() {
                ddlVlrTipoProducto = value!;
              });
            },
          ),
          DropdownButton(
            hint: Text("Marca"),
            icon: Icon(Icons.arrow_drop_down),
            value: ddlVlrMarca,
            onChanged: (String? value) {
              setState(() {
                ddlVlrMarca = value!;
              });
            },
            items: marcas.map((map) {
              return DropdownMenuItem<String>(
                value: map["ID_MARCA"].toString(),
                child: Text(map["NOMBRE_MARCA"]),
              );
            }).toList(),
          ),
          TextField(
            controller: nombreProdCtrl,
            decoration: InputDecoration(labelText: "Nombre del producto"),
          ),
          TextField(
            controller: descripcionProdCtrl,
            decoration: InputDecoration(labelText: "Descripción del producto"),
          ),
          TextField(
            controller: valorProdCtrl,
            decoration: InputDecoration(labelText: "Valor/precio del producto"),
          ),
          ElevatedButton.icon(
            label: Text("Guardar"),
            icon: Icon(Icons.save),
            onPressed: _agregarProducto,
          ),
        ],
      ),
    );
  }
}
