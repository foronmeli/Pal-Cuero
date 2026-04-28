import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/producto.dart';

class ProductoService {
  static const String collectionName = 'productos';

  ProductoService({FirebaseFirestore? firestore})
      : _productsRef = (firestore ?? FirebaseFirestore.instance)
            .collection(collectionName);

  final CollectionReference<Map<String, dynamic>> _productsRef;

  Future<List<Producto>> obtenerProductos() async {
    final snapshot = await _productsRef.get();
    return _mapSnapshot(snapshot);
  }

  Stream<List<Producto>> observarProductos() {
    return _productsRef
        .snapshots(includeMetadataChanges: true)
        .map(_mapSnapshot);
  }

  Future<Producto> agregarProducto(Producto producto) async {
    final docRef = _productsRef.doc(producto.id.toString());
    final productoNormalizado = producto.copyWith(pendingSync: false);

    try {
      await docRef.set({
        ...productoNormalizado.toFirestore(),
        'id': productoNormalizado.id,
        'createdAtMs': DateTime.now().millisecondsSinceEpoch,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return productoNormalizado;
    } on FirebaseException {
      return productoNormalizado.copyWith(pendingSync: true);
    } catch (_) {
      return productoNormalizado.copyWith(pendingSync: true);
    }
  }

  Future<void> eliminarProducto(int id) async {
    await _productsRef.doc(id.toString()).delete();
  }

  Future<Producto> actualizarProducto(Producto producto) async {
    final docRef = _productsRef.doc(producto.id.toString());
    final productoActualizado = producto.copyWith(pendingSync: false);

    try {
      await docRef.update(productoActualizado.toFirestore());
      return productoActualizado;
    } on FirebaseException {
      return productoActualizado.copyWith(pendingSync: true);
    } catch (_) {
      return productoActualizado.copyWith(pendingSync: true);
    }
  }

  int generarNuevoId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  List<Producto> _mapSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final productos = snapshot.docs
        .map((doc) => Producto.fromFirestore(
              doc.data(),
              fallbackId: doc.id,
              pendingSyncOverride: doc.metadata.hasPendingWrites,
            ))
        .toList();

    productos.sort((a, b) => b.id.compareTo(a.id));
    return productos;
  }

  String describirError(Object error) {
    if (error is FirebaseException) {
      debugPrint(
        'Firestore error [${error.code}] in ${error.plugin}: ${error.message}',
      );
      return error.message ??
          'No se pudo completar la operacion en Firebase (${error.code}).';
    }

    debugPrint('Unexpected product service error: $error');
    return 'Ocurrio un error inesperado.';
  }
}
