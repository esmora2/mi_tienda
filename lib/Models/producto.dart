import 'dart:io';

class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String descripcion;
  final File imagen;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.imagen,
  });
}
