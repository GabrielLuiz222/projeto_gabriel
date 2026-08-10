import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LimitePage extends StatefulWidget {
  final List transactions;

  const LimitePage({
    super.key,
    required this.transactions,
  });

  @override
  State<LimitePage> createState() => _LimitePageState();
}

class _LimitePageState extends State<LimitePage> {
  final TextEditingController limiteController =
      TextEditingController(text: "1000");

  double limite = 1000;
  bool animar = false;


  // CARREGAR LIMITE SALVO


  @override
  void initState() {
    super.initState();
    carregarLimite();
  }

  Future<void> carregarLimite() async {
    final prefs = await SharedPreferences.getInstance();

    final limiteSalvo = prefs.getDouble('limite');

    if (limiteSalvo != null) {
      setState(() {
        limite = limiteSalvo;
        limiteController.text = limiteSalvo.toString();
      });
    }
  }


  // SALVAR LIMITE


  Future<void> atualizarLimite() async {
    double? valor = double.tryParse(
      limiteController.text.replaceAll(",", "."),
    );

    if (valor != null && valor > 0) {
      // Acessa o SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // Salva o limite
      await prefs.setDouble('limite', valor);

      // Atualiza a tela
      setState(() {
        limite = valor;
        animar = true;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            animar = false;
          });
        }
      });

      // Mensagem de confirmação
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Limite salvo com sucesso!"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }


  // CÁLCULOS


  double get total {
    double soma = 0;

    for (var gasto in widget.transactions) {
      soma += gasto.valor;
    }

    return soma;
  }

  double get restante {
    double valor = limite - total;

    return valor < 0 ? 0 : valor;
  }

  double get excedente {
    if (total <= limite) return 0;

    return total - limite;
  }

  double get porcentagem {
    if (limite == 0) return 0;

    double p = total / limite;

    if (p > 1) {
      p = 1;
    }

    return p;
  }


  // LIBERAR CONTROLLER


  @override
  void dispose() {
    limiteController.dispose();
    super.dispose();
  }


  // INTERFACE


  @override
  Widget build(BuildContext context) {
    bool ultrapassou = total > limite;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Limite Financeiro"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

          
            // CARD DO LIMITE
          

            AnimatedScale(
              scale: animar ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,

              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  children: [

                    const Text(
                      "Limite do Mês",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "R\$ ${limite.toStringAsFixed(2)}",

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

          
            // CAMPO PARA ALTERAR LIMITE
          

            TextField(
              controller: limiteController,

              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),

              decoration: InputDecoration(
                labelText: "Alterar Limite",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

          
            // BOTÃO SALVAR
          

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: atualizarLimite,

                child: const Text("Salvar Limite"),
              ),
            ),

            const SizedBox(height: 30),

          
            // VALOR GASTO
          

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

          
            // BARRA DE PROGRESSO
          

            LinearProgressIndicator(
              value: porcentagem,

              minHeight: 14,

              borderRadius: BorderRadius.circular(10),

              backgroundColor: Colors.grey.shade300,

              color: ultrapassou
                  ? Colors.red
                  : Colors.green,
            ),

            const SizedBox(height: 8),

            Text(
              "${(porcentagem * 100).toStringAsFixed(0)}%",

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

          
            // VALOR RESTANTE
          

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

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

          
            // LIMITE ULTRAPASSADO
          

            if (ultrapassou)
              Card(
                color: Colors.red.shade100,

                elevation: 4,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: ListTile(
                  leading: const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),

                  title: const Text(
                    "Limite ultrapassado",
                  ),

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