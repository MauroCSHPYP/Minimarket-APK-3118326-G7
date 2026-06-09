import 'package:flutter/material.dart';
import 'package:proyecto_minimarket_apk/opciones.dart';

void main(List<String> args) {
  runApp(principal());
}

class principal extends StatelessWidget {
  const principal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Minimarket (APK)",
      home: opciones(),
    );
  }
}
