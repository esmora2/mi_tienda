import 'dart:io';
import 'package:flutter/foundation.dart';
import '../Models/producto.dart';

class ProductoViewModel extends ChangeNotifier {
  final List<Producto> _productos = [];

  List<Producto> get productos => List.unmodifiable(_productos);

  void agregarProducto({
    required String nombre,
    required double precio,
    required String descripcion,
    required File imagen,
  }) {
    final producto = Producto(
      id: DateTime.now().toString(),
      nombre: nombre,
      precio: precio,
      descripcion: descripcion,
      imagen: imagen,
    );
    _productos.add(producto);
    notifyListeners();
  }

  void eliminarProducto(String id) {
    _productos.removeWhere((producto) => producto.id == id);
    notifyListeners();
  }

  void actualizarProducto(Producto actualizado) {
    final index = _productos.indexWhere((p) => p.id == actualizado.id);
    if (index != -1) {
      _productos[index] = actualizado;
      notifyListeners();
    }
  }

}
