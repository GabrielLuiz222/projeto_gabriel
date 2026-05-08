import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Custo {
  String descriacao;
  double valor;

  Custo({
    required this.descriacao,
    required this.valor,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Gastos',
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: const MyHomePage(),
    );
  }
}