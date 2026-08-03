import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_status_chip.dart';
import '../../shared/widgets/pcpe_input.dart';

class OcorrenciasScreen extends StatefulWidget {
  const OcorrenciasScreen({super.key});

  @override
  State<OcorrenciasScreen> createState() => _OcorrenciasScreenState();
}

class _OcorrenciasScreenState extends State<OcorrenciasScreen> {
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _data = const [
    {'id': 'OC-2026-001247', 'titulo': 'Roubo a residência', 'status': 1, 'data': '15/03/2026 14:30', 'perito': 'Dr. Carlos Eduardo', 'local': 'Boa Viagem', 'tipo': 'Roubo'},
    {'id': 'OC-2026-001246', 'titulo': 'Homicídio doloso', 'status': 3, 'data': '15/03/2026 11:15', 'perito': 'Dra. Ana Beatriz', 'local': 'Centro', 'tipo': 'Homicídio'},
    {'id': 'OC-2026-001245', 'titulo': 'Furto de veículo', 'status': 2, 'data': '14/03/2026 20:45', 'perito': 'Dr. Marcos Vinícius', 'local': 'Derby', 'tipo': 'Furto'},
    {'id': 'OC-2026-001244', 'titulo': 'Lesão corporal', 'status': 4, 'data': '14/03/2026 16:00', 'perito': 'Dr. Carlos Eduardo', 'local': 'Imbiribeira', 'tipo': 'Lesão'},
    {'id': 'OC-2026-001243', 'titulo': 'Estupro - Zona Norte', 'status': 1, 'data': '14/03/2026 09:20', 'perito': 'Dra. Juliana Costa', 'local': 'Zona Norte', 'tipo': 'Estupro'},
    {'id': 'OC-2026-001242', 'titulo': 'Tráfico de drogas', 'status': 2, 'data': '13/03/2026 22:10', 'perito': 'Dr. Roberto Alves', 'local': 'Centro', 'tipo': 'Tráfico'},
    {'id': 'OC-2026-001241', 'titulo': 'Latrocínio', 'status': 5, 'data': '13/03/2026 18:45', 'perito': 'Dra. Ana Beatriz', 'local': 'Boa Vista', 'tipo': 'Homicídio'},
    {'id': 'OC-2026-001240', 'titulo': 'Sequestro relâmpago', 'status': 3, 'data': '13/03/2026 15:30', 'perito': 'Dr. Marcos Vinícius', 'local': 'Pina', 'tipo': 'Sequestro'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statuses = [PCPEStatus.emAndamento, PCPEStatus.pendente, PCPEStatus.concluido, PCPEStatus.urgente, PCPEStatus.ativo, PCPEStatus.cancelado];

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Ocorrências',
        subtitle: '${_data.length} registros encontrados',
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/nova-ocorrencia'),
        backgroundColor: PCPEColors.primary,
        foregroundColor: PCPEColors.pureWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Todos', true),
                  _buildFilterChip('Em Andamento', false),
                  _buildFilterChip('Pendentes', false),
                  _buildFilterChip('Concluídos', false),
                  _buildFilterChip('Urgentes', false),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: PCPEInput(
                    hint: 'Buscar por ID, título ou perito...',
                    prefixIcon: Icons.search,
                    controller: _searchController,
                  ),
                ),
                const SizedBox(width: 12),
                PCPEButton(
                  label: 'Filtrar',
                  icon: Icons.tune,
                  outlined: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final item = _data[index];
                return PCPECard(
                  onTap: () {},
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: PCPEColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: PCPEColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: Text(item['id'] as String, style: const TextStyle(fontSize: 11, color: PCPEColors.primary, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: PCPEColors.warningLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(item['tipo'] as String, style: const TextStyle(fontSize: 10, color: PCPEColors.warning, fontWeight: FontWeight.w500)),
                          ),
                          const Spacer(),
                          PCPEStatusChip(status: statuses[index % statuses.length]),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(item['titulo'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: PCPEColors.black)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: PCPEColors.mediumGray),
                          const SizedBox(width: 4),
                          Text(item['local'] as String, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today, size: 14, color: PCPEColors.mediumGray),
                          const SizedBox(width: 4),
                          Text(item['data'] as String, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                          const SizedBox(width: 16),
                          const Icon(Icons.person_outline, size: 14, color: PCPEColors.mediumGray),
                          const SizedBox(width: 4),
                          Text(item['perito'] as String, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                          const Spacer(),
                          const Icon(Icons.chevron_right, color: PCPEColors.primary),
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

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: selected ? PCPEColors.pureWhite : PCPEColors.darkGray)),
        selected: selected,
        selectedColor: PCPEColors.primary,
        backgroundColor: PCPEColors.pureWhite,
        side: BorderSide(color: selected ? PCPEColors.primary : PCPEColors.lightGray.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (v) {},
      ),
    );
  }
}