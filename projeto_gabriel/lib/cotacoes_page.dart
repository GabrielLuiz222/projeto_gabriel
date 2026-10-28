
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
  String? erro;

  Future<void> buscarCotacoes() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resposta = await http.get(
        Uri.parse(
          'https://dolarapi.com/v1/cotizaciones',
        ),
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
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    buscarCotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    carregando ? null : buscarCotacoes,
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar cotações'),
              ),
            ),
            const SizedBox(height: 16),

            if (carregando)
              const CircularProgressIndicator(),

            if (erro != null)
              Text(
                erro!,
                style: const TextStyle(color: Colors.red),
              ),

            Expanded(
              child: ListView.builder(
                itemCount: cotacoes.length,
                itemBuilder: (context, index) {
                  final item = cotacoes[index];

                  return Card(
                    child: ListTile(
                      title: Text(
                        item['nombre']?.toString()
                            ?? 'Cotação',
                      ),
                      subtitle: Text(
                        'Compra: ${item['compra']}'
                        '\nVenda: ${item['venta']}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(
                        Icons.currency_exchange,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
