import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_status_chip.dart';
import '../../shared/widgets/pcpe_input.dart';

class ObjetosScreen extends StatefulWidget {
  const ObjetosScreen({super.key});

  @override
  State<ObjetosScreen> createState() => _ObjetosScreenState();
}

class _ObjetosScreenState extends State<ObjetosScreen> {
  final _searchController = TextEditingController();

  static const _data = [
    {'descricao': 'Faca de cozinha - Tramontina', 'categoria': 'Arma Branca', 'ocorrencia': 'OC-2026-001247', 'status': 0},
    {'descricao': 'Celular Samsung Galaxy', 'categoria': 'Eletrônico', 'ocorrencia': 'OC-2026-001246', 'status': 1},
    {'descricao': 'Carteira de couro marrom', 'categoria': 'Documento', 'ocorrencia': 'OC-2026-001245', 'status': 2},
    {'descricao': 'Chave de fenda', 'categoria': 'Ferramenta', 'ocorrencia': 'OC-2026-001245', 'status': 3},
    {'descricao': 'Cápsula de projétil 9mm', 'categoria': 'Munição', 'ocorrencia': 'OC-2026-001246', 'status': 0},
    {'descricao': 'Notebook Dell Inspiron', 'categoria': 'Eletrônico', 'ocorrencia': 'OC-2026-001244', 'status': 1},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statuses = [PCPEStatus.emAndamento, PCPEStatus.pendente, PCPEStatus.concluido, PCPEStatus.ativo];
    final catColors = [PCPEColors.error, PCPEColors.info, PCPEColors.success, PCPEColors.warning, PCPEColors.primary];

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Objetos',
        subtitle: '${_data.length} objetos apreendidos',
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
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
                  _buildFilterChip('Arma Branca', false),
                  _buildFilterChip('Eletrônicos', false),
                  _buildFilterChip('Documentos', false),
                  _buildFilterChip('Munições', false),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: PCPEInput(hint: 'Buscar objetos...', prefixIcon: Icons.search, controller: _searchController),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final item = _data[index];
                final catColor = catColors[index % catColors.length];
                return PCPECard(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.category_outlined, color: catColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['descricao'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PCPEColors.black)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: catColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(item['categoria'] as String, style: TextStyle(fontSize: 10, color: catColor, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 8),
                                Text(item['ocorrencia'] as String, style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
                              ],
                            ),
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