import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/producto.dart';
import 'producto_service.dart';

class ProductRemoteService {
  ProductRemoteService({FirebaseFirestore? firestore})
      : _productsRef = (firestore ?? FirebaseFirestore.instance)
            .collection(ProductoService.collectionName);

  final CollectionReference<Map<String, dynamic>> _productsRef;

  Future<void> upsertProduct(Producto product) async {
    await _productsRef.doc(product.id.toString()).set({
      ...product.toFirestore(),
      'id': product.id,
      'createdAtMs': DateTime.now().millisecondsSinceEpoch,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Producto>> fetchProducts() async {
    final snapshot = await _productsRef.get();
    final productos = snapshot.docs.map((doc) {
      return Producto.fromFirestore(
        doc.data(),
        fallbackId: doc.id,
        pendingSyncOverride: doc.metadata.hasPendingWrites,
      );
    }).toList();

    productos.sort((a, b) => b.id.compareTo(a.id));
    return productos;
  }
}
