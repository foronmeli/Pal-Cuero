import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/producto_service.dart';
import '../widgets/producto_card.dart';
import 'agregar_producto_page.dart';
import 'producto_detail_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final ProductoService _service = const ProductoService(
    baseUrl: 'https://dummyjson.com/c/7fae-4cd6-4863-a3a4',
    usarFallbackLocal: true,
  );
  late Future<List<Producto>> _futureProductos;
  final List<Producto> _productosNuevos = [];
  final Set<int> _productosEliminados = {};

  @override
  void initState() {
    super.initState();
    _futureProductos = _service.obtenerProductos();
  }

  Future<void> _recargarProductos() async {
    setState(() {
      _futureProductos = _service.obtenerProductos();
      _productosNuevos.clear();
      _productosEliminados.clear();
    });
    await _futureProductos;
  }

  Future<void> _irAgregarProducto() async {
    final nuevo = await Navigator.push<Producto>(
      context,
      MaterialPageRoute(builder: (_) => const AgregarProductoPage()),
    );

    if (nuevo != null) {
      await _service.agregarProducto(nuevo);

      setState(() {
        _productosNuevos.add(nuevo);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto agregado exitosamente')),
        );
      }
    }
  }

  Future<void> _eliminarProducto(Producto producto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Seguro que deseas eliminar "${producto.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade400),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await _service.eliminarProducto(producto.id);

    setState(() {
      _productosNuevos.remove(producto);
      _productosEliminados.add(producto.id);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pal' Cuero — Admin"),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Producto>>(
        future: _futureProductos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Ocurrió un error al cargar los productos.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _futureProductos = _service.obtenerProductos();
                        });
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final productosLista = [
            ...?(snapshot.data?.where((p) => !_productosEliminados.contains(p.id))),
            ..._productosNuevos.where((p) => !_productosEliminados.contains(p.id)),
          ];

          if (productosLista.isEmpty) {
            return const Center(
              child: Text('No hay productos registrados.'),
            );
          }

          return RefreshIndicator(
            onRefresh: _recargarProductos,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: productosLista.length,
              itemBuilder: (context, index) {
                final producto = productosLista[index];

                return ProductoCard(
                  producto: producto,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductoDetailPage(producto: producto),
                      ),
                    );
                  },
                  onDelete: () => _eliminarProducto(producto),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irAgregarProducto,
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
        tooltip: 'Agregar producto',
        child: const Icon(Icons.add),
      ),
    );
  }
}