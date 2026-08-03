import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_status_chip.dart';
import '../../shared/widgets/pcpe_input.dart';

class VeiculosScreen extends StatefulWidget {
  const VeiculosScreen({super.key});

  @override
  State<VeiculosScreen> createState() => _VeiculosScreenState();
}

class _VeiculosScreenState extends State<VeiculosScreen> {
  final _searchController = TextEditingController();

  static const _data = [
    {'placa': 'KLM-1234', 'modelo': 'Honda Civic', 'cor': 'Preto', 'ano': '2022', 'ocorrencia': 'OC-2026-001247', 'status': 0},
    {'placa': 'ABC-7D89', 'modelo': 'Fiat Strada', 'cor': 'Branco', 'ano': '2020', 'ocorrencia': 'OC-2026-001245', 'status': 1},
    {'placa': 'DEF-5G67', 'modelo': 'Toyota Corolla', 'cor': 'Prata', 'ano': '2023', 'ocorrencia': 'OC-2026-001244', 'status': 2},
    {'placa': 'GHI-9J01', 'modelo': 'VW Gol', 'cor': 'Vermelho', 'ano': '2019', 'ocorrencia': 'OC-2026-001243', 'status': 3},
    {'placa': 'JKL-2M34', 'modelo': 'Chevrolet Onix', 'cor': 'Azul', 'ano': '2021', 'ocorrencia': 'OC-2026-001242', 'status': 0},
    {'placa': 'MNO-6P78', 'modelo': 'Ford Ranger', 'cor': 'Cinza', 'ano': '2024', 'ocorrencia': 'OC-2026-001241', 'status': 1},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statuses = [PCPEStatus.emAndamento, PCPEStatus.pendente, PCPEStatus.concluido, PCPEStatus.ativo];

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Veículos',
        subtitle: '${_data.length} veículos registrados',
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: PCPEInput(hint: 'Buscar por placa ou modelo...', prefixIcon: Icons.search, controller: _searchController),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final item = _data[index];
                return PCPECard(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: PCPEColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.directions_car, color: PCPEColors.warning, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(item['modelo'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PCPEColors.black)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: PCPEColors.primary.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(item['placa'] as String, style: const TextStyle(fontSize: 11, color: PCPEColors.primary, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${item['cor']} • ${item['ano']}', style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                            const SizedBox(height: 2),
                            Text(item['ocorrencia'] as String, style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
                          ],
                        ),
                      ),
                      PCPEStatusChip(status: statuses[index % statuses.length]),
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