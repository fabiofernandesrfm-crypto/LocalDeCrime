import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_input.dart';
import '../../shared/widgets/pcpe_avatar.dart';

class _UsuarioMock {
  final String nome;
  final String usuario;
  final String cargo;
  final String unidade;
  final String status;
  final String email;
  final String ultimoAcesso;
  final bool isFirst;

  const _UsuarioMock({
    required this.nome,
    required this.usuario,
    required this.cargo,
    required this.unidade,
    required this.status,
    required this.email,
    required this.ultimoAcesso,
    this.isFirst = false,
  });

  bool get isActive => status != 'Inativo';
}

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final _searchController = TextEditingController();

  String _filtroUnidade = 'Todas';
  String _filtroCargo = 'Todos';
  String _filtroStatus = 'Todos';
  bool _showFilters = false;

  final List<_UsuarioMock> _usuarios = const [
    _UsuarioMock(
      nome: 'Fabio Fernandes dos Santos',
      usuario: 'fabiofernandes',
      cargo: 'Agente de Polícia Civil',
      unidade: 'DTI – UNISA',
      status: 'Em serviço',
      email: 'fabio.fernandes@pcpe.pe.gov.br',
      ultimoAcesso: 'Hoje',
      isFirst: true,
    ),
    _UsuarioMock(
      nome: 'Carlos Eduardo Silva',
      usuario: 'carloseduardo',
      cargo: 'Delegado de Polícia',
      unidade: 'DTI – UNISA',
      status: 'Em serviço',
      email: 'carlos.eduardo@pcpe.pe.gov.br',
      ultimoAcesso: 'Hoje',
    ),
    _UsuarioMock(
      nome: 'Ana Beatriz Oliveira',
      usuario: 'anabeatriz',
      cargo: 'Escrivã de Polícia',
      unidade: 'DTI – UNISA',
      status: 'Em serviço',
      email: 'ana.beatriz@pcpe.pe.gov.br',
      ultimoAcesso: 'Hoje',
    ),
    _UsuarioMock(
      nome: 'Marcos Vinícius Lima',
      usuario: 'marcosvinicius',
      cargo: 'Agente de Polícia Civil',
      unidade: 'DEATH – Homicídios',
      status: 'Em serviço',
      email: 'marcos.vinicius@pcpe.pe.gov.br',
      ultimoAcesso: 'Ontem',
    ),
    _UsuarioMock(
      nome: 'Juliana Costa Melo',
      usuario: 'julianacosta',
      cargo: 'Perita Criminal',
      unidade: 'DEATH – Homicídios',
      status: 'Ausente',
      email: 'juliana.costa@pcpe.pe.gov.br',
      ultimoAcesso: '23/07/2026',
    ),
    _UsuarioMock(
      nome: 'Roberto Alves Neto',
      usuario: 'robertoalves',
      cargo: 'Delegado de Polícia',
      unidade: 'DEPATRI – Patrimônio',
      status: 'Em serviço',
      email: 'roberto.alves@pcpe.pe.gov.br',
      ultimoAcesso: 'Hoje',
    ),
    _UsuarioMock(
      nome: 'Fernanda Lima Souza',
      usuario: 'fernandalima',
      cargo: 'Agente de Polícia Civil',
      unidade: 'DEPATRI – Patrimônio',
      status: 'Em serviço',
      email: 'fernanda.lima@pcpe.pe.gov.br',
      ultimoAcesso: 'Ontem',
    ),
    _UsuarioMock(
      nome: 'Paulo Henrique Rocha',
      usuario: 'paulohenrique',
      cargo: 'Perito Criminal',
      unidade: 'Instituto de Identificação',
      status: 'Inativo',
      email: 'paulo.rocha@pcpe.pe.gov.br',
      ultimoAcesso: '10/06/2026',
    ),
    _UsuarioMock(
      nome: 'Sandra Menezes Cruz',
      usuario: 'sandramenezes',
      cargo: 'Escrivã de Polícia',
      unidade: 'Instituto de Identificação',
      status: 'Em serviço',
      email: 'sandra.menezes@pcpe.pe.gov.br',
      ultimoAcesso: 'Hoje',
    ),
    _UsuarioMock(
      nome: 'Ricardo Antunes Moreira',
      usuario: 'ricardoantunes',
      cargo: 'Investigador de Polícia',
      unidade: 'DTI – UNISA',
      status: 'Em serviço',
      email: 'ricardo.antunes@pcpe.pe.gov.br',
      ultimoAcesso: 'Hoje',
    ),
  ];

  List<_UsuarioMock> get _filteredUsuarios {
    return _usuarios.where((u) {
      final query = _searchController.text.toLowerCase();
      final matchSearch = query.isEmpty ||
          u.nome.toLowerCase().contains(query) ||
          u.usuario.toLowerCase().contains(query) ||
          u.cargo.toLowerCase().contains(query);

      final matchUnidade = _filtroUnidade == 'Todas' || u.unidade == _filtroUnidade;
      final matchCargo = _filtroCargo == 'Todos' || u.cargo == _filtroCargo;
      final matchStatus = _filtroStatus == 'Todos' || u.status == _filtroStatus;

      return matchSearch && matchUnidade && matchCargo && matchStatus;
    }).toList();
  }

  List<String> get _unidades {
    final set = _usuarios.map((u) => u.unidade).toSet();
    return ['Todas', ...set.toList()..sort()];
  }

  List<String> get _cargos {
    final set = _usuarios.map((u) => u.cargo).toSet();
    return ['Todos', ...set.toList()..sort()];
  }

  List<String> get _statuses {
    final set = _usuarios.map((u) => u.status).toSet();
    return ['Todos', ...set.toList()..sort()];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Em serviço':
        return PCPEColors.success;
      case 'Ausente':
        return PCPEColors.warning;
      case 'Inativo':
        return PCPEColors.mediumGray;
      default:
        return PCPEColors.mediumGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarios = _filteredUsuarios;
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Usuários',
        subtitle: '${usuarios.length} usuários encontrados',
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            tooltip: 'Filtros',
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: PCPEInput(
                    hint: 'Buscar por nome, usuário ou cargo...',
                    prefixIcon: Icons.search,
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                PCPEButton(
                  label: 'Novo Usuário',
                  icon: Icons.add,
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Summary cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildSummaryCard('Total', '${_usuarios.length}', PCPEColors.primary, Icons.people),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  'Em serviço',
                  '${_usuarios.where((u) => u.status == 'Em serviço').length}',
                  PCPEColors.success,
                  Icons.check_circle,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  'Ausentes',
                  '${_usuarios.where((u) => u.status == 'Ausente').length}',
                  PCPEColors.warning,
                  Icons.access_time,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  'Inativos',
                  '${_usuarios.where((u) => u.status == 'Inativo').length}',
                  PCPEColors.mediumGray,
                  Icons.block,
                ),
              ],
            ),
          ),

          // Filters row
          if (_showFilters)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: PCPECard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, size: 16, color: PCPEColors.primary),
                    const SizedBox(width: 8),
                    const Text('Filtros:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    _buildDropdown('Unidade', _filtroUnidade, _unidades, (v) => setState(() => _filtroUnidade = v ?? 'Todas')),
                    const SizedBox(width: 12),
                    _buildDropdown('Cargo', _filtroCargo, _cargos, (v) => setState(() => _filtroCargo = v ?? 'Todos')),
                    const SizedBox(width: 12),
                    _buildDropdown('Status', _filtroStatus, _statuses, (v) => setState(() => _filtroStatus = v ?? 'Todos')),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Table
          Expanded(
            child: isWide ? _buildTable(usuarios) : _buildList(usuarios),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label:', style: const TextStyle(fontSize: 11, color: PCPEColors.darkGray)),
        const SizedBox(width: 6),
        SizedBox(
          width: 160,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              style: const TextStyle(fontSize: 12, color: PCPEColors.black),
              items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 12)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(List<_UsuarioMock> usuarios) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(PCPEColors.cardGray),
          horizontalMargin: 16,
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('Foto', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))),
            DataColumn(label: Text('Nome', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))),
            DataColumn(label: Text('Usuário', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))),
            DataColumn(label: Text('Cargo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))),
            DataColumn(label: Text('Unidade', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))),
            DataColumn(label: Text('Status', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))),
            DataColumn(label: Text('Último Acesso', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))),
            DataColumn(label: Text('Ações', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))),
          ],
          rows: usuarios.map((u) {
            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                if (u.isFirst) return PCPEColors.primary.withValues(alpha: 0.04);
                return null;
              }),
              cells: [
                DataCell(PCPEAvatar(name: u.nome, size: 32)),
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(u.nome, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: u.isFirst ? PCPEColors.primary : PCPEColors.black)),
                    if (u.isFirst) const Text('(Você)', style: TextStyle(fontSize: 10, color: PCPEColors.primary, fontWeight: FontWeight.w500)),
                  ],
                )),
                DataCell(Text(u.usuario, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray))),
                DataCell(Text(u.cargo, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray))),
                DataCell(Text(u.unidade, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray))),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(color: _getStatusColor(u.status), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(u.status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _getStatusColor(u.status))),
                    ],
                  ),
                ),
                DataCell(Text(u.ultimoAcesso, style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray))),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(Icons.visibility_outlined, 'Visualizar', PCPEColors.primary),
                      const SizedBox(width: 4),
                      _buildActionButton(Icons.edit_outlined, 'Editar', PCPEColors.warning),
                      const SizedBox(width: 4),
                      _buildActionButton(Icons.admin_panel_settings_outlined, 'Permissões', PCPEColors.primaryDark),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildList(List<_UsuarioMock> usuarios) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        final u = usuarios[index];
        return PCPECard(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  PCPEAvatar(
                    name: u.nome,
                    size: 44,
                    showBadge: u.isActive,
                    badgeColor: u.isActive ? PCPEColors.success : PCPEColors.mediumGray,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              u.nome,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: u.isFirst ? PCPEColors.primary : PCPEColors.black),
                            ),
                            if (u.isFirst) ...[
                              const SizedBox(width: 6),
                              const Text('(Você)', style: TextStyle(fontSize: 10, color: PCPEColors.primary, fontWeight: FontWeight.w500)),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('@${u.usuario} • ${u.cargo}', style: const TextStyle(fontSize: 11, color: PCPEColors.darkGray)),
                        const SizedBox(height: 1),
                        Text(u.unidade, style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 7, height: 7,
                              decoration: BoxDecoration(color: _getStatusColor(u.status), shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 4),
                            Text(u.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: _getStatusColor(u.status))),
                            const SizedBox(width: 12),
                            const Icon(Icons.access_time, size: 12, color: PCPEColors.lightGray),
                            const SizedBox(width: 2),
                            Text(u.ultimoAcesso, style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionChip(Icons.visibility_outlined, 'Ver', PCPEColors.primary),
                  const SizedBox(width: 8),
                  _buildActionChip(Icons.edit_outlined, 'Editar', PCPEColors.warning),
                  const SizedBox(width: 8),
                  _buildActionChip(Icons.admin_panel_settings_outlined, 'Permissões', PCPEColors.primaryDark),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: PCPEColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: PCPEColors.darkGray)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String tooltip, Color color) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }
}