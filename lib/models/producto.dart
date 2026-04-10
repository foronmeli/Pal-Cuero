class Producto {
  final int id;
  final String nombre;
  final String categoria;
  final String descripcionCorta;
  final String descripcionLarga;
  final double precio;
  final String imagen;

  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.descripcionCorta,
    required this.descripcionLarga,
    required this.precio,
    required this.imagen,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int,
      nombre: (json['nombre'] ?? '') as String,
      categoria: (json['categoria'] ?? '') as String,
      descripcionCorta:
          (json['descripcion_corta'] ?? json['descripcionCorta'] ?? '') as String,
      descripcionLarga:
          (json['descripcion_larga'] ?? json['descripcionLarga'] ?? '') as String,
      precio: (json['precio'] as num).toDouble(),
      imagen: (json['imagen'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'descripcion_corta': descripcionCorta,
      'descripcion_larga': descripcionLarga,
      'precio': precio,
      'imagen': imagen,
    };
  }
}
