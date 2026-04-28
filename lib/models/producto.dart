class Producto {
  final int id;
  final String nombre;
  final String categoria;
  final String descripcionCorta;
  final String descripcionLarga;
  final double precio;
  final String imagen;
  final bool pendingSync;

  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.descripcionCorta,
    required this.descripcionLarga,
    required this.precio,
    required this.imagen,
    required this.pendingSync,
  });

  Producto copyWith({
    int? id,
    String? nombre,
    String? categoria,
    String? descripcionCorta,
    String? descripcionLarga,
    double? precio,
    String? imagen,
    bool? pendingSync,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      descripcionCorta: descripcionCorta ?? this.descripcionCorta,
      descripcionLarga: descripcionLarga ?? this.descripcionLarga,
      precio: precio ?? this.precio,
      imagen: imagen ?? this.imagen,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'descripcionCorta': descripcionCorta,
      'descripcionLarga': descripcionLarga,
      'precio': precio,
      'imagen': imagen,
      'pendingSync': pendingSync,
    };
  }

  factory Producto.fromFirestore(
    Map<String, dynamic> data, {
    required String fallbackId,
    bool? pendingSyncOverride,
  }) {
    final rawId = data['id'];
    final resolvedId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ??
            int.tryParse(fallbackId) ??
            DateTime.now().millisecondsSinceEpoch;

    return Producto(
      id: resolvedId,
      nombre: data['nombre'] ?? '',
      categoria: data['categoria'] ?? '',
      descripcionCorta: data['descripcionCorta'] ?? '',
      descripcionLarga: data['descripcionLarga'] ?? '',
      precio: (data['precio'] as num?)?.toDouble() ?? 0.0,
      imagen: data['imagen'] ?? '',
      pendingSync: pendingSyncOverride ?? (data['pendingSync'] ?? false),
    );
  }
}
