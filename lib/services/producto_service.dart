import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/productos_data.dart';
import '../models/producto.dart';

class ProductoService {
  final String baseUrl;
  final bool usarFallbackLocal;

  const ProductoService({required this.baseUrl, this.usarFallbackLocal = true});

  Future<List<Producto>> obtenerProductos() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) {
        throw Exception('No se pudieron cargar los productos');
      }

      final dynamic decoded = jsonDecode(response.body);

      final List<dynamic> lista = decoded is Map
          ? decoded['products']
          : decoded;

      return lista.map((item) {
        final map = item as Map<String, dynamic>;
        return Producto(
          id: map['id'] as int,
          nombre: (map['title'] ?? '') as String,
          categoria: (map['category'] ?? '') as String,
          descripcionCorta: (map['description'] ?? '') as String,
          descripcionLarga: (map['description'] ?? '') as String,
          precio: (map['price'] as num).toDouble(),
          imagen: (map['thumbnail'] ?? '') as String,
        );
      }).toList();
    } catch (e) {
      if (!usarFallbackLocal) rethrow;

      await Future.delayed(const Duration(seconds: 1));
      return productos;
    }
  }

  Future<void> agregarProducto(Producto producto) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/products/add'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'title': producto.nombre,
              'category': producto.categoria,
              'description': producto.descripcionLarga,
              'price': producto.precio,
            }),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('No se pudo agregar el producto');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> actualizarProducto(Producto producto) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/products/update/${producto.id}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'title': producto.nombre,
              'category': producto.categoria,
              'description': producto.descripcionLarga,
              'price': producto.precio,
            }),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) {
        throw Exception('No se pudo actualizar el producto');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> eliminarProducto(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/products/$id'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('No se pudo eliminar el producto');
      }
    } catch (e) {
      if (!usarFallbackLocal) rethrow;
    }
  }
}
