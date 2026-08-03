import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_input.dart';
import '../../shared/widgets/pcpe_section_title.dart';
import '../../shared/widgets/pcpe_status_chip.dart';

class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {
  final _searchController = TextEditingController();

  static const _relatorios = [
    {'titulo': 'Relatório Mensal - Março/2026', 'tipo': 'Estatístico', 'data': '15/03/2026', 'status': 2, 'paginas': 24},
    {'titulo': 'Laudo Pericial - OC-2026-001247', 'tipo': 'Técnico', 'data': '15/03/2026', 'status': 0, 'paginas': 12},
    {'titulo': 'Relatório de Atendimentos', 'tipo': 'Operacional', 'data': '14/03/2026', 'status': 2, 'paginas': 8},
    {'titulo': 'Análise Balística - OC-2026-001246', 'tipo': 'Técnico', 'data': '14/03/2026', 'status': 3, 'paginas': 15},
    {'titulo': 'Relatório Semanal - 10 a 14/03', 'tipo': 'Estatístico', 'data': '14/03/2026', 'status': 2, 'paginas': 6},
    {'titulo': 'Mapa de Ocorrências por Bairro', 'tipo': 'Geográfico', 'data': '13/03/2026', 'status': 2, 'paginas': 18},
    {'titulo': 'Relatório de Produtividade', 'tipo': 'Administrativo', 'data': '13/03/2026', 'status': 1, 'paginas': 10},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const statuses = [PCPEStatus.emAndamento, PCPEStatus.pendente, PCPEStatus.concluido, PCPEStatus.ativo];

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Relatórios',
        subtitle: '${_relatorios.length} relatórios disponíveis',
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: PCPEInput(hint: 'Buscar relatórios...', prefixIcon: Icons.search, controller: _searchController)),
                const SizedBox(width: 12),
                PCPEButton(label: 'Gerar Novo', icon: Icons.add_chart, outlined: true, onPressed: () {}),
              ],
            ),
          ),
          const PCPESectionTitle(title: 'Relatórios Recentes', icon: Icons.assessment, subtitle: 'Ordenado por data'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _relatorios.length,
              itemBuilder: (context, index) {
                final r = _relatorios[index];
                final status = statuses[index % statuses.length];
                return PCPECard(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 56,
                        decoration: BoxDecoration(
                          color: status.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r['titulo'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PCPEColors.black)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: PCPEColors.primary.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(r['tipo'] as String, style: const TextStyle(fontSize: 10, color: PCPEColors.primary, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.calendar_today, size: 10, color: PCPEColors.mediumGray),
                                const SizedBox(width: 4),
                                Text(r['data'] as String, style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
                                const SizedBox(width: 8),
                                const Icon(Icons.pages, size: 10, color: PCPEColors.mediumGray),
                                const SizedBox(width: 4),
                                Text('${r['paginas']} pág.', style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.download, color: PCPEColors.primary, size: 20), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.share, color: PCPEColors.mediumGray, size: 20), onPressed: () {}),
                        ],
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