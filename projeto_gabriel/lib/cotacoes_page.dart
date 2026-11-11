import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CotacoesPage extends StatefulWidget {
  const CotacoesPage({super.key});

  @override
  State<CotacoesPage> createState() => _CotacoesPageState();
}

class _CotacoesPageState extends State<CotacoesPage> {
  List<dynamic> cotacoes = [];
  bool carregando = false;
  bool mostrandoSplash = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      iniciarTela();
    });
  }

  Future<void> iniciarTela() async {
    buscarCotacoes();

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      mostrandoSplash = false;
    });
  }

  Future<void> buscarCotacoes() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resposta = await http.get(
        Uri.parse('https://dolarapi.com/v1/cotizaciones'),
      );

      if (resposta.statusCode != 200) {
        throw Exception('Não foi possível consultar a API.');
      }

      final dados = jsonDecode(resposta.body);

      setState(() {
        cotacoes = dados as List<dynamic>;
      });
    } catch (e) {
      setState(() {
        erro = 'Erro ao carregar as cotações.';
      });
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  String formatarValor(dynamic valor) {
    final numero = double.tryParse(valor?.toString() ?? '');

    if (numero == null) {
      return valor?.toString() ?? '-';
    }

    return numero.toStringAsFixed(2);
  }

  Widget splashCotacoes() {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.currency_exchange,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              "Cotações",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Consulte o câmbio atual",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget cardResumo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            "Moedas disponíveis",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            cotacoes.length.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Valores em peso argentino (ARS)",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget cardCotacao(dynamic item) {
    final nome = item['nombre']?.toString() ?? 'Cotação';
    final moeda = item['moneda']?.toString() ?? '';
    final compra = formatarValor(item['compra']);
    final venda = formatarValor(item['venta']);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.currency_exchange,
          color: Colors.green,
          size: 30,
        ),
        title: Text(
          nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          moeda.isEmpty
              ? 'Compra: $compra  •  Venda: $venda'
              : '$moeda\nCompra: $compra  •  Venda: $venda',
        ),
        isThreeLine: moeda.isNotEmpty,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Venda",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              venda,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mostrandoSplash) {
      return splashCotacoes();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotações'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            cardResumo(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: carregando ? null : buscarCotacoes,
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar cotações'),
              ),
            ),
            const SizedBox(height: 16),
            if (carregando)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: CircularProgressIndicator(color: Colors.green),
              ),
            if (erro != null)
              Card(
                color: Colors.red.shade100,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: const Text('Não foi possível atualizar'),
                  subtitle: Text(erro!),
                ),
              ),
            Expanded(
              child: cotacoes.isEmpty && !carregando && erro == null
                  ? const Center(
                      child: Text(
                        "Nenhuma cotação encontrada",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: cotacoes.length,
                      itemBuilder: (context, index) {
                        return cardCotacao(cotacoes[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
