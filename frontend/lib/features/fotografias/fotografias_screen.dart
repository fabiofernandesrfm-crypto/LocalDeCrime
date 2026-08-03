import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_input.dart';

class FotografiasScreen extends StatefulWidget {
  const FotografiasScreen({super.key});

  @override
  State<FotografiasScreen> createState() => _FotografiasScreenState();
}

class _FotografiasScreenState extends State<FotografiasScreen> {
  final _searchController = TextEditingController();
  bool _isGridView = true;

  static const _data = [
    {'arquivo': 'IMG_20260315_001.jpg', 'descricao': 'Fachada da residência', 'data': '15/03/2026 14:35', 'ocorrencia': 'OC-2026-001247', 'status': 2},
    {'arquivo': 'IMG_20260315_002.jpg', 'descricao': 'Sala principal', 'data': '15/03/2026 14:38', 'ocorrencia': 'OC-2026-001247', 'status': 2},
    {'arquivo': 'IMG_20260315_003.jpg', 'descricao': 'Objeto perfurante', 'data': '15/03/2026 11:20', 'ocorrencia': 'OC-2026-001246', 'status': 3},
    {'arquivo': 'IMG_20260314_004.jpg', 'descricao': 'Veículo danificado', 'data': '14/03/2026 20:50', 'ocorrencia': 'OC-2026-001245', 'status': 2},
    {'arquivo': 'IMG_20260314_005.jpg', 'descricao': 'Marcas de sangue', 'data': '14/03/2026 16:05', 'ocorrencia': 'OC-2026-001244', 'status': 0},
    {'arquivo': 'IMG_20260314_006.jpg', 'descricao': 'Local do crime - visão geral', 'data': '14/03/2026 09:25', 'ocorrencia': 'OC-2026-001243', 'status': 1},
    {'arquivo': 'IMG_20260313_007.jpg', 'descricao': 'Entorpecentes apreendidos', 'data': '13/03/2026 22:15', 'ocorrencia': 'OC-2026-001242', 'status': 3},
    {'arquivo': 'IMG_20260313_008.jpg', 'descricao': 'Arma de fogo', 'data': '13/03/2026 18:50', 'ocorrencia': 'OC-2026-001241', 'status': 2},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColors = [PCPEColors.warning, PCPEColors.primary, PCPEColors.success, PCPEColors.info];

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Fotografias',
        subtitle: '${_data.length} fotografias registradas',
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view, color: PCPEColors.primary),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: PCPEInput(hint: 'Buscar fotografias...', prefixIcon: Icons.search, controller: _searchController)),
                const SizedBox(width: 12),
                PCPEButton(label: 'Capturar', icon: Icons.camera_alt, onPressed: () {}),
              ],
            ),
          ),
          Expanded(
            child: _isGridView ? _buildGridView(statusColors) : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Color> statusColors) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _data.length,
      itemBuilder: (context, index) {
        final item = _data[index];
        return Container(
          decoration: BoxDecoration(
            color: PCPEColors.pureWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: statusColors[index % 4].withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: Icon(Icons.image, size: 48, color: statusColors[index % 4].withValues(alpha: 0.4)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['descricao'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: PCPEColors.black), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(item['data'] as String, style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _data.length,
      itemBuilder: (context, index) {
        final item = _data[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: PCPEColors.pureWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: PCPEColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, color: PCPEColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['descricao'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: PCPEColors.black)),
                    const SizedBox(height: 2),
                    Text('${item['data']} • ${item['ocorrencia']}', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: PCPEColors.lightGray),
            ],
          ),
        );
      },
    );
  }
}