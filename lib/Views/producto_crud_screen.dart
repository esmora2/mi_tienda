import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Models/producto.dart';
import '../ViewModel/producto_viewmodel.dart';

class ProductoCrudScreen extends StatefulWidget {
  final Producto? productoExistente;

  const ProductoCrudScreen({
    super.key,
    this.productoExistente,
  });

  @override
  State<ProductoCrudScreen> createState() => _ProductoCrudScreenState();
}

class _ProductoCrudScreenState extends State<ProductoCrudScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _descripcion = '';
  double _precio = 0;
  File? _imagen;

  @override
  void initState() {
    super.initState();
    if (widget.productoExistente != null) {
      _nombre = widget.productoExistente!.nombre;
      _descripcion = widget.productoExistente!.descripcion;
      _precio = widget.productoExistente!.precio;
      _imagen = widget.productoExistente!.imagen;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imagen = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _imagen = File(pickedFile.path);
      });
    }
  }

  void _guardarProducto() {
    if (_formKey.currentState!.validate() && _imagen != null) {
      _formKey.currentState!.save();
      final vm = Provider.of<ProductoViewModel>(context, listen: false);

      if (widget.productoExistente != null) {
        // EDITAR
        vm.actualizarProducto(
          Producto(
            id: widget.productoExistente!.id,
            nombre: _nombre,
            precio: _precio,
            descripcion: _descripcion,
            imagen: _imagen!,
          ),
        );
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto actualizado correctamente')),
        );
      } else {
        // AGREGAR
        vm.agregarProducto(
          nombre: _nombre,
          precio: _precio,
          descripcion: _descripcion,
          imagen: _imagen!,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto agregado correctamente')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.productoExistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Producto' : 'Agregar Producto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _imagen != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imagen!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Galería'),
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Cámara'),
                            onPressed: _takePhoto,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: _nombre,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: const Icon(Icons.label),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? 'Ingrese un nombre' : null,
                      onSaved: (value) => _nombre = value!,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _precio != 0 ? _precio.toString() : '',
                      decoration: InputDecoration(
                        labelText: 'Precio',
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                      value!.isEmpty ? 'Ingrese un precio' : null,
                      onSaved: (value) => _precio = double.parse(value!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _descripcion,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        prefixIcon: const Icon(Icons.description),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? 'Ingrese descripción' : null,
                      onSaved: (value) => _descripcion = value!,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(esEdicion
                          ? 'Guardar Cambios'
                          : 'Agregar Producto'),
                      onPressed: _guardarProducto,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
