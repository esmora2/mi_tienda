import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/producto_viewmodel.dart';
import 'producto_crud_screen.dart';
import 'producto_detalle_screen.dart';

class ProductosListScreen extends StatelessWidget {
  const ProductosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductoViewModel>(context);
    final productos = vm.productos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
      ),
      body: productos.isEmpty
          ? const Center(child: Text('No hay productos.'))
          : ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  producto.imagen,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                producto.nombre,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text('\$${producto.precio.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductoDetalleScreen(producto: producto),
                  ),
                );
              },
            ),
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductoCrudScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
