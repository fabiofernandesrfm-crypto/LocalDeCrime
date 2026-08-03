import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_status_chip.dart';
import '../../shared/widgets/pcpe_input.dart';

class AtendimentosScreen extends StatefulWidget {
  const AtendimentosScreen({super.key});

  @override
  State<AtendimentosScreen> createState() => _AtendimentosScreenState();
}

class _AtendimentosScreenState extends State<AtendimentosScreen> {
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _data = const [
    {'tipo': 'Perícia Criminal', 'local': 'Boa Viagem', 'data': '15/03/2026', 'perito': 'Dr. Carlos Eduardo', 'status': 0, 'protocolo': 'ATD-3892'},
    {'tipo': 'Necropsia', 'local': 'IML - Centro', 'data': '15/03/2026', 'perito': 'Dra. Ana Beatriz', 'status': 1, 'protocolo': 'ATD-3891'},
    {'tipo': 'Balística', 'local': 'Derby', 'data': '14/03/2026', 'perito': 'Dr. Marcos Vinícius', 'status': 2, 'protocolo': 'ATD-3890'},
    {'tipo': 'DNA Forense', 'local': 'Laboratório Central', 'data': '14/03/2026', 'perito': 'Dra. Juliana Costa', 'status': 3, 'protocolo': 'ATD-3889'},
    {'tipo': 'Informática Forense', 'local': 'Centro', 'data': '13/03/2026', 'perito': 'Dr. Roberto Alves', 'status': 0, 'protocolo': 'ATD-3888'},
    {'tipo': 'Documentoscopia', 'local': 'Imbiribeira', 'data': '13/03/2026', 'perito': 'Dra. Ana Beatriz', 'status': 2, 'protocolo': 'ATD-3887'},
    {'tipo': 'Perícia Contábil', 'local': 'Boa Vista', 'data': '12/03/2026', 'perito': 'Dr. Carlos Eduardo', 'status': 3, 'protocolo': 'ATD-3886'},
    {'tipo': 'Engenharia Legal', 'local': 'Pina', 'data': '12/03/2026', 'perito': 'Dr. Marcos Vinícius', 'status': 1, 'protocolo': 'ATD-3885'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statuses = [PCPEStatus.emAndamento, PCPEStatus.pendente, PCPEStatus.concluido, PCPEStatus.ativo];
    final icons = [Icons.medical_services, Icons.science, Icons.biotech, Icons.computer, Icons.description, Icons.engineering];

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Atendimentos',
        subtitle: '${_data.length} atendimentos registrados',
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: PCPEInput(hint: 'Buscar por tipo, local ou perito...', prefixIcon: Icons.search, controller: _searchController)),
                const SizedBox(width: 12),
                PCPEButton(label: 'Novo', icon: Icons.add, onPressed: () {}),
              ],
            ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: PCPEColors.info.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(icons[index % icons.length], color: PCPEColors.info, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(item['tipo'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: PCPEColors.black)),
                                    ),
                                    PCPEStatusChip(status: statuses[index % statuses.length]),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(item['protocolo'] as String, style: const TextStyle(fontSize: 11, color: PCPEColors.primary, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: PCPEColors.mediumGray),
                          const SizedBox(width: 4),
                          Text(item['local'] as String, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                          const SizedBox(width: 12),
                          const Icon(Icons.calendar_today, size: 13, color: PCPEColors.mediumGray),
                          const SizedBox(width: 4),
                          Text(item['data'] as String, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                          const SizedBox(width: 12),
                          const Icon(Icons.person_outline, size: 13, color: PCPEColors.mediumGray),
                          const SizedBox(width: 4),
                          Flexible(child: Text(item['perito'] as String, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray), overflow: TextOverflow.ellipsis)),
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