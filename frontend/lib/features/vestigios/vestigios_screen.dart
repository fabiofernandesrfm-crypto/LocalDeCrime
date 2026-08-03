import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_status_chip.dart';
import '../../shared/widgets/pcpe_input.dart';

class VestigiosScreen extends StatefulWidget {
  const VestigiosScreen({super.key});

  @override
  State<VestigiosScreen> createState() => _VestigiosScreenState();
}

class _VestigiosScreenState extends State<VestigiosScreen> {
  final _searchController = TextEditingController();

  static const _data = [
    {'tipo': 'Impressão Digital', 'local': 'Maçaneta da porta', 'coletado': '15/03/2026', 'status': 0, 'ocorrencia': 'OC-2026-001247'},
    {'tipo': 'Amostra de Sangue', 'local': 'Chão da sala', 'coletado': '15/03/2026', 'status': 1, 'ocorrencia': 'OC-2026-001246'},
    {'tipo': 'Projétil', 'local': 'Parede do quarto', 'coletado': '14/03/2026', 'status': 2, 'ocorrencia': 'OC-2026-001246'},
    {'tipo': 'Fibra Têxtil', 'local': 'Tapete', 'coletado': '14/03/2026', 'status': 3, 'ocorrencia': 'OC-2026-001245'},
    {'tipo': 'Resíduo de Pólvora', 'local': 'Mãos da vítima', 'coletado': '13/03/2026', 'status': 0, 'ocorrencia': 'OC-2026-001244'},
    {'tipo': 'Cabelo/Fio', 'local': 'Sofá', 'coletado': '13/03/2026', 'status': 1, 'ocorrencia': 'OC-2026-001243'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statuses = [PCPEStatus.emAndamento, PCPEStatus.pendente, PCPEStatus.concluido, PCPEStatus.ativo];
    final tiposColor = {'Impressão Digital': PCPEColors.primary, 'Amostra de Sangue': PCPEColors.error, 'Projétil': PCPEColors.warning, 'Fibra Têxtil': PCPEColors.info, 'Resíduo de Pólvora': PCPEColors.success, 'Cabelo/Fio': PCPEColors.primary};

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Vestígios',
        subtitle: '${_data.length} vestígios registrados',
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: PCPEInput(hint: 'Buscar vestígios...', prefixIcon: Icons.search, controller: _searchController),
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: tipoColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.fingerprint, color: tipoColor, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['tipo'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: PCPEColors.black)),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 12, color: PCPEColors.mediumGray),
                                    const SizedBox(width: 4),
                                    Text(item['local'] as String, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PCPEStatusChip(status: statuses[index % statuses.length]),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 12, color: PCPEColors.mediumGray),
                          const SizedBox(width: 4),
                          Text(item['coletado'] as String, style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: PCPEColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(item['ocorrencia'] as String, style: const TextStyle(fontSize: 10, color: PCPEColors.primary, fontWeight: FontWeight.w500)),
                          ),
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