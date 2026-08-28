import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'models/custo.dart';
import 'estatisticas_page.dart';
import 'limite_page.dart';
import 'database/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Gastos',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SplashScreen(),
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

  @override
  void initState() {
    super.initState();

    carregarGastos();
  }

  Future<void> carregarGastos() async {
    final gastos = await DatabaseHelper.instance.buscarGastos();

    setState(() {
      transactions = gastos;
    });
  }

  double get total {
    double total = 0;

    for (var custo in transactions) {
      total += custo.valor;
    }
    return total;
  }

  Future<void> addTransaction(Custo custo) async {
    await DatabaseHelper.instance.inserirGasto(custo);

    await carregarGastos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controle Financeiro"),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EstatisticasPage(transactions: transactions),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.savings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LimitePage(transactions: transactions),
                ),
              );
            },
          ),
        ],
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
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                        final transaction = transactions[index];

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),

                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 12),

                            child: ListTile(
                              // EDITAR GASTO
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddPage(custo: transaction),
                                  ),
                                );

                                if (result != null) {
                                  await DatabaseHelper.instance.atualizarGasto(
                                    result,
                                  );

                                  await carregarGastos();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Gasto alterado com sucesso",
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },

                              title: Text(
                                transaction.descricao,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              subtitle: Text(
                                "Categoria: ${transaction.categoria}",
                              ),

                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "R\$ ${transaction.valor.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // EXCLUIR GASTO
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await DatabaseHelper.instance
                                          .deletarGasto(transaction.id!);

                                      await carregarGastos();

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Gasto removido"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,

        child: const Icon(Icons.add),

        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPage()),
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
  final Custo? custo;

  const AddPage({super.key, this.custo});

  @override
  State<AddPage> createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();

  String categoriaSelecionada = "Alimentação";

  final List<String> categorias = [
    "Alimentação",
    "Transporte",
    "Roupas",
    "Saúde",
    "Pet",
  ];

  @override
  void initState() {
    super.initState();

    if (widget.custo != null) {
      descricaoController.text = widget.custo!.descricao;
      valorController.text = widget.custo!.valor.toString();
      categoriaSelecionada = widget.custo!.categoria;
    }
  }

  void save() {
    if (descricaoController.text.isEmpty || valorController.text.isEmpty) {
      return;
    }

    double? valor = double.tryParse(valorController.text.replaceAll(',', '.'));

    if (valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite um valor maior que zero"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final transaction = Custo(
      id: widget.custo?.id,
      descricao: descricaoController.text,
      valor: valor,
      categoria: categoriaSelecionada,
    );

    Navigator.pop(context, transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.custo == null ? "Adicionar Gasto" : "Editar Gasto"),
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
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: valorController,

              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                labelText: "Valor",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: categoriaSelecionada,

              decoration: InputDecoration(
                labelText: "Categoria",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              items: categorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  categoriaSelecionada = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: save,

                child: Text(
                  widget.custo == null ? "Salvar" : "Salvar Alterações",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
