import 'package:flutter/material.dart';

import '../models/producto.dart';

class AgregarProductoPage extends StatefulWidget {
  const AgregarProductoPage({super.key});

  @override
  State<AgregarProductoPage> createState() => _AgregarProductoPageState();
}

class _AgregarProductoPageState extends State<AgregarProductoPage> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _descripcionCortaController = TextEditingController();
  final _descripcionLargaController = TextEditingController();
  final _precioController = TextEditingController();

  String _categoriaSeleccionada = 'Carteras';

  final List<String> _categorias = ['Carteras', 'Correas'];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionCortaController.dispose();
    _descripcionLargaController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final nuevo = Producto(
      id: 0,
      nombre: _nombreController.text.trim(),
      categoria: _categoriaSeleccionada,
      descripcionCorta: _descripcionCortaController.text.trim(),
      descripcionLarga: _descripcionLargaController.text.trim(),
      precio: double.parse(_precioController.text.trim()),
      imagen: 'assets/producto1.jpg',
    );

    Navigator.pop(context, nuevo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: _categorias
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaSeleccionada = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descripcionCortaController,
                decoration: const InputDecoration(
                  labelText: 'Descripción corta',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción corta es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descripcionLargaController,
                decoration: const InputDecoration(
                  labelText: 'Descripción larga',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción larga es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(
                  labelText: 'Precio (COP)',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El precio es obligatorio';
                  }
                  final precio = double.tryParse(value.trim());
                  if (precio == null || precio <= 0) {
                    return 'Ingresa un precio válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botón guardar
              FilledButton(
                onPressed: _guardar,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.brown.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Guardar producto',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
