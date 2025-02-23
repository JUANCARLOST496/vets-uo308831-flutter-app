import 'package:flutter/material.dart';
import 'pages/login_page.dart'; // Importa la nueva pantalla de inicio de sesión

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
          const LoginPage(), // Muestra la pantalla de inicio de sesión primero
    );
  }
}
