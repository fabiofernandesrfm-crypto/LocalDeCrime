import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_status_chip.dart';
import '../../shared/widgets/pcpe_input.dart';

class EquipesScreen extends StatefulWidget {
  const EquipesScreen({super.key});

  @override
  State<EquipesScreen> createState() => _EquipesScreenState();
}

class _EquipesScreenState extends State<EquipesScreen> {
  final _searchController = TextEditingController();

  static const _equipes = [
    {'nome': 'Equipe Alpha', 'lider': 'Dr. Carlos Eduardo', 'membros': 5, 'especialidade': 'Perícia Criminal', 'status': 0},
    {'nome': 'Equipe Bravo', 'lider': 'Dra. Ana Beatriz', 'membros': 4, 'especialidade': 'Medicina Legal', 'status': 1},
    {'nome': 'Equipe Charlie', 'lider': 'Dr. Marcos Vinícius', 'membros': 6, 'especialidade': 'Balística', 'status': 2},
    {'nome': 'Equipe Delta', 'lider': 'Dra. Juliana Costa', 'membros': 3, 'especialidade': 'DNA Forense', 'status': 3},
    {'nome': 'Equipe Echo', 'lider': 'Dr. Roberto Alves', 'membros': 4, 'especialidade': 'Informática', 'status': 0},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statuses = [PCPEStatus.ativo, PCPEStatus.emAndamento, PCPEStatus.pendente, PCPEStatus.concluido];

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Equipes',
        subtitle: '${_equipes.length} equipes ativas',
        actions: [
          IconButton(icon: const Icon(Icons.group_add), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: PCPEInput(hint: 'Buscar equipes...', prefixIcon: Icons.search, controller: _searchController),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _equipes.length,
              itemBuilder: (context, index) {
                final e = _equipes[index];
                return PCPECard(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: PCPEColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.groups, color: PCPEColors.primary, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e['nome'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: PCPEColors.black)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline, size: 12, color: PCPEColors.mediumGray),
                                    const SizedBox(width: 4),
                                    Text(e['lider'] as String, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: PCPEColors.info.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(e['especialidade'] as String, style: const TextStyle(fontSize: 10, color: PCPEColors.info, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.people_outline, size: 12, color: PCPEColors.mediumGray.withValues(alpha: 0.8)),
                                    const SizedBox(width: 4),
                                    Text('${e['membros']} membros', style: TextStyle(fontSize: 11, color: PCPEColors.mediumGray.withValues(alpha: 0.8))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PCPEStatusChip(status: statuses[index % statuses.length]),
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