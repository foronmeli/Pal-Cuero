import 'package:flutter/material.dart';
import 'pages/admin_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pal' Cuero",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 146, 204, 52)),
        useMaterial3: true,
      ),
      home: const AdminHomePage(),
    );
  }
}
