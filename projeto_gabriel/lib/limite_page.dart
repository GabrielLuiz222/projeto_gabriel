import 'package:flutter/material.dart';
import 'main.dart';

class MetaPage extends StatefulWidget {
  final List<Custo> transactions;

  const MetaPage({super.key, required this.transactions});

  @override
  State<MetaPage> createState() => _MetaPageState();
}

class _MetaPageState extends State<MetaPage> {
  final TextEditingController metaController = TextEditingController(
    text: "1000",
  );

  double meta = 1000;

  double get total {
    double soma = 0;
    for (var gasto in widget.transactions) {
      soma += gasto.valor;
    }
    return soma;
  }

  double get restante {
    double valor = meta - total;
    return valor < 0 ? 0 : valor;
  }

  double get excedente {
    if (total <= meta) return 0;
    return total - meta;
  }

  double get porcentagem {
    if (meta == 0) return 0;

    double p = total / meta;

    if (p > 1) {
      p = 1;
    }

    return p;
  }

  void atualizarMeta() {
    double? valor = double.tryParse(metaController.text.replaceAll(",", "."));

    if (valor != null && valor > 0) {
      setState(() {
        meta = valor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool ultrapassou = total > meta;

    return Scaffold(
      appBar: AppBar(title: const Text("Meta Financeira"), centerTitle: true),

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
                    "Meta do Mês",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "R\$ ${meta.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: metaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Alterar Meta",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: atualizarMeta,
                child: const Text("Salvar Meta"),
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Você gastou: R\$ ${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            LinearProgressIndicator(
              value: porcentagem,
              minHeight: 14,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey.shade300,
              color: ultrapassou ? Colors.red : Colors.green,
            ),

            const SizedBox(height: 8),

            Text(
              "${(porcentagem * 100).toStringAsFixed(0)}%",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.green,
                ),
                title: const Text("Valor Restante"),
                trailing: Text(
                  "R\$ ${restante.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            if (ultrapassou)
              Card(
                color: Colors.red.shade100,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: const Text("Meta ultrapassada"),
                  subtitle: Text(
                    "Você excedeu R\$ ${excedente.toStringAsFixed(2)}",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
