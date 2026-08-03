import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_input.dart';
import '../../shared/widgets/pcpe_avatar.dart';

class PessoasScreen extends StatefulWidget {
  const PessoasScreen({super.key});

  @override
  State<PessoasScreen> createState() => _PessoasScreenState();
}

class _PessoasScreenState extends State<PessoasScreen> {
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _data = const [
    {'nome': 'José da Silva Santos', 'cpf': '***.123.456-**', 'tipo': 'Vítima', 'status': 0},
    {'nome': 'Maria Oliveira Lima', 'cpf': '***.789.012-**', 'tipo': 'Testemunha', 'status': 1},
    {'nome': 'Pedro Henrique Costa', 'cpf': '***.345.678-**', 'tipo': 'Suspeito', 'status': 2},
    {'nome': 'Ana Carolina Ferreira', 'cpf': '***.901.234-**', 'tipo': 'Vítima', 'status': 3},
    {'nome': 'Lucas Martins Alves', 'cpf': '***.567.890-**', 'tipo': 'Perito', 'status': 0},
    {'nome': 'Juliana Souza Mendes', 'cpf': '***.432.109-**', 'tipo': 'Testemunha', 'status': 1},
    {'nome': 'Roberto Nascimento', 'cpf': '***.876.543-**', 'tipo': 'Suspeito', 'status': 2},
    {'nome': 'Fernanda Barbosa', 'cpf': '***.210.987-**', 'tipo': 'Vítima', 'status': 3},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tiposColor = {'Vítima': PCPEColors.error, 'Testemunha': PCPEColors.info, 'Suspeito': PCPEColors.warning, 'Perito': PCPEColors.success};

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Pessoas',
        subtitle: '${_data.length} pessoas cadastradas',
        actions: [
          IconButton(icon: const Icon(Icons.person_add), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: PCPEInput(hint: 'Buscar por nome ou CPF...', prefixIcon: Icons.search, controller: _searchController)),
                const SizedBox(width: 12),
                PCPEButton(label: 'Filtro', icon: Icons.tune, outlined: true, onPressed: () {}),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final item = _data[index];
                final tipo = item['tipo'] as String;
                final tipoColor = tiposColor[tipo] ?? PCPEColors.primary;
                return PCPECard(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      PCPEAvatar(name: item['nome'] as String, size: 44, backgroundColor: tipoColor.withValues(alpha: 0.1)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['nome'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PCPEColors.black)),
                            Text(item['cpf'], style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: tipoColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: tipoColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(tipo, style: TextStyle(fontSize: 11, color: tipoColor, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}