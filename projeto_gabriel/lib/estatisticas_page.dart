import 'package:flutter/material.dart';
import 'models/custo.dart';


class EstatisticasPage extends StatelessWidget {
  final List<Custo> transactions;

  const EstatisticasPage({super.key, required this.transactions});

//CALCULOS DO CÓDIGO
  double get total {
    double soma = 0;
    for (var gasto in transactions) {
      soma += gasto.valor;
    }
    return soma;
  }

  double get media {
    if (transactions.isEmpty) return 0;
    return total / transactions.length;
  }

  double get maior {
    if (transactions.isEmpty) return 0;

    double maiorValor = transactions.first.valor;

    for (var gasto in transactions) {
      if (gasto.valor > maiorValor) {
        maiorValor = gasto.valor;
      }
    }

    return maiorValor;
  }

  double get menor {
    if (transactions.isEmpty) return 0;

    double menorValor = transactions.first.valor;

    for (var gasto in transactions) {
      if (gasto.valor < menorValor) {
        menorValor = gasto.valor;
      }
    }

    return menorValor;
  }

  int get quantidade => transactions.length;

//FUNÇÃO PARA CRIAR O CARD DO VALOR
  Widget cardValor(String titulo, double valor, IconData icone) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icone, color: Colors.green, size: 30),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: valor),
          duration: const Duration(milliseconds: 1200),
          builder: (context, value, child) {
            return Text(
              "R\$ ${value.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            );
          },
        ),
      ),
    );
  }

//FUNÇÃO PARA CRIAR O CARD DA QUANTIDADE DE GASTOS
  Widget cardQuantidade() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const Icon(Icons.receipt_long, color: Colors.green, size: 30),
        title: const Text(
          "Quantidade de Gastos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: quantidade.toDouble()),
          duration: const Duration(milliseconds: 1200),
          builder: (context, value, child) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            );
          },
        ),
      ),
    );
  }

//FUNÇÃO PARA CRIAR A TELA DE ESTATÍSTICAS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Estatísticas"), centerTitle: true),
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
                    "Resumo Financeiro",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),

                  const SizedBox(height: 10),

                  //ANIMAÇÃO DO CARD DO VALOR TOTAL
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: total),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return Text(
                        "R\$ ${value.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            cardQuantidade(),

            cardValor("Maior Gasto", maior, Icons.trending_up),

            cardValor("Menor Gasto", menor, Icons.trending_down),

            cardValor("Média dos Gastos", media, Icons.calculate),
          ],
        ),
      ),
    );
  }
}
