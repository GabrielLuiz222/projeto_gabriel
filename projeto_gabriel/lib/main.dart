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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
} 

class _HomePageState extends State<HomePage> {

  List<Custo> transactions = [];

 double get total {
    double total = 0;

    for (var custo in transactions) {
      total += custo.valor;
    }
    return total;
  }

  void addTransaction(Custo custo) { 
    setState(() { 
      transactions.add(custo); });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controle Financeiro"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [

                  const Text(
                    "Total de Gastos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "R\$ ${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ]
        )));
      }}