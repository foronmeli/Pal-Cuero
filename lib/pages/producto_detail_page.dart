import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../widgets/producto_image.dart';

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
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductoImage(
              imagePath: producto.imagen,
              width: double.infinity,
              height: 240,
            ),
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
                      color: Colors.brown.shade700,
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
                labelStyle: TextStyle(color: Colors.brown.shade700),
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
