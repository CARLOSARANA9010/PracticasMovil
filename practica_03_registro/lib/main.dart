import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de productos',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const RegistroProductosPage(),
    );
  }
}

final class Producto {
  final String nombre;
  final String categoria;
  final double precio;
  final int existencia;

  Producto({
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.existencia,
  });

  double get valorInventario => precio * existencia;
}

class RegistroProductosPage extends StatefulWidget {
  const RegistroProductosPage({super.key});

  @override
  State<RegistroProductosPage> createState() => _RegistroProductosPageState();
}

class _RegistroProductosPageState extends State<RegistroProductosPage> {
  final formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final existenciaController = TextEditingController();

  String categoria = 'Tecnología';

  final List<Producto> productos = [];

  double get valorTotalInventario {
    return productos.fold(
      0,
      (total, producto) => total + producto.valorInventario,
    );
  }

  void agregarProducto() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final producto = Producto(
      nombre: nombreController.text.trim(),
      categoria: categoria,
      precio: double.parse(precioController.text),
      existencia: int.parse(existenciaController.text),
    );

    setState(() {
      productos.add(producto);

      nombreController.clear();
      precioController.clear();
      existenciaController.clear();
      categoria = 'Tecnología';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto agregado correctamente')),
    );
  }

  void eliminarProducto(int index) {
    final producto = productos[index];

    setState(() {
      productos.removeAt(index);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${producto.nombre} eliminado')));
  }

  @override
  void dispose() {
    nombreController.dispose();
    precioController.dispose();
    existenciaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de productos'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final anchoFormulario = constraints.maxWidth > 800
              ? 700.0
              : constraints.maxWidth;

          return Center(
            child: SizedBox(
              width: anchoFormulario,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nombreController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del producto',
                              prefixIcon: Icon(Icons.inventory_2),
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El nombre es obligatorio';
                              }

                              if (value.trim().length < 3) {
                                return 'El nombre debe tener al menos 3 caracteres';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: categoria,
                            decoration: const InputDecoration(
                              labelText: 'Categoría',
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Tecnología',
                                child: Text('Tecnología'),
                              ),
                              DropdownMenuItem(
                                value: 'Accesorios',
                                child: Text('Accesorios'),
                              ),
                              DropdownMenuItem(
                                value: 'Papelería',
                                child: Text('Papelería'),
                              ),
                              DropdownMenuItem(
                                value: 'Ropa',
                                child: Text('Ropa'),
                              ),
                              DropdownMenuItem(
                                value: 'Otros',
                                child: Text('Otros'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  categoria = value;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Selecciona una categoría';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: precioController,
                            decoration: const InputDecoration(
                              labelText: 'Precio',
                              prefixIcon: Icon(Icons.attach_money),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El precio es obligatorio';
                              }

                              final precio = double.tryParse(value);

                              if (precio == null) {
                                return 'Introduce un precio válido';
                              }

                              if (precio <= 0) {
                                return 'El precio debe ser mayor a 0';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: existenciaController,
                            decoration: const InputDecoration(
                              labelText: 'Existencia',
                              prefixIcon: Icon(Icons.numbers),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'La existencia es obligatoria';
                              }

                              final existencia = int.tryParse(value);

                              if (existencia == null) {
                                return 'Introduce un número entero';
                              }

                              if (existencia < 0) {
                                return 'La existencia no puede ser negativa';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: agregarProducto,
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar producto'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_wallet, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Valor total del inventario',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${valorTotalInventario.toStringAsFixed(2)}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Expanded(
                      child: productos.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inventory, size: 64),
                                  SizedBox(height: 12),
                                  Text('No hay productos registrados'),
                                  SizedBox(height: 4),
                                  Text(
                                    'Agrega un producto utilizando el formulario',
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: productos.length,
                              itemBuilder: (context, index) {
                                final producto = productos[index];

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text('${index + 1}'),
                                    ),
                                    title: Text(
                                      producto.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${producto.categoria} • '
                                      'Precio: \$${producto.precio.toStringAsFixed(2)} • '
                                      'Existencia: ${producto.existencia}\n'
                                      'Valor: \$${producto.valorInventario.toStringAsFixed(2)}',
                                    ),
                                    isThreeLine: true,
                                    trailing: IconButton(
                                      tooltip: 'Eliminar producto',
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        eliminarProducto(index);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
