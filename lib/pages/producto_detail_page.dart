import 'package:flutter/material.dart';
import 'package:pal_cuero/pages/agregar_producto_page.dart';

import '../models/producto.dart';

class ProductoDetailPage extends StatelessWidget {
  final Producto producto;

  const ProductoDetailPage({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto.nombre),
        backgroundColor: const Color.fromARGB(255, 148, 204, 16),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              producto.imagen,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 240,
                  alignment: Alignment.center,
                  color: const Color.fromARGB(255, 205, 206, 204),
                  child: const Icon(Icons.image_not_supported, size: 48),
                );
              },
            ),
            SizedBox(height: 16),
            Padding(
              padding:  const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 148, 204, 16),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final productoEditado = await Navigator.push<Producto>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgregarProductoPage(
                            pageName: 'Editar Producto',
                            productoExistente: producto,
                          ),
                        ),
                      );

                      if (productoEditado != null && context.mounted) {
                        Navigator.pop(context, productoEditado);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 20),
                        Text('Editar'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      producto.nombre,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Text(
                    '\$${producto.precio.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 148, 204, 16),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Chip(
                label: Text(producto.categoria),
                backgroundColor: Colors.brown.shade50,
                labelStyle: TextStyle(color: const Color.fromARGB(255, 51, 54, 47)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                producto.descripcionLarga,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
