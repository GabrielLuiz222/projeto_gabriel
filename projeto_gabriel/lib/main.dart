import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Custo {
  String descricao;
  double valor;

  Custo({
    required this.descricao,
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

class _MyHomePageState extends State<MyHomePage> {
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

            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhum gasto cadastrado",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {

                        final transaction =
                            transactions[index];

                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.attach_money,
                              color: Colors.green,
                            ),

                            title:
                                Text(transaction.descricao),

                            trailing: Text(
                              "R\$ ${transaction.valor.toStringAsFixed(2)}",
                            ),
                          ),
                        );
                      }
                    )
            )
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,

        child: const Icon(Icons.add),

        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPage(),
            ),
          );

          if (result != null) {
            addTransaction(result);
          }
        },
      ),
    );
  }
}
  class AddPage extends StatefulWidget {
  const AddPage({super.key}); 

 @override
  State<AddPage> createState() => _AddPage();
  }
  class _AddPage extends State<AddPage> {
    final descricaoController = TextEditingController();
    final valorController = TextEditingController();

    void save() {
      if (descricaoController.text.isEmpty || 
          valorController.text.isEmpty) {
            return;
          }
          final transaction = Custo(
            descricao: descricaoController.text,
            valor: double.parse(valorController.text),
          );
          Navigator.pop(context, transaction);
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Adicionar Gasto"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              TextField(
                controller: descricaoController,

                decoration: InputDecoration(
                  labelText: "Descrição",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: valorController,

                keyboardType: TextInputType.number,

                decoration:  InputDecoration(
                  labelText: "Valor",

                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: save,

                  child: const Text("Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
    
