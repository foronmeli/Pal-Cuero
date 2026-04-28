import 'package:flutter/material.dart';

class ProductoImage extends StatelessWidget {
  const ProductoImage({
    super.key,
    required this.imagePath,
    required this.height,
    required this.width,
  });

  final String imagePath;
  final double height;
  final double width;

  bool get _isNetworkImage {
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (imagePath.isNotEmpty) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: Colors.brown.shade100,
      child: const Icon(Icons.image_not_supported, size: 48),
    );
  }
}
