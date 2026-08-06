import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/mock/organizacao_pcpe_mock.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 1: Identificação da Ocorrência
class Step1Identificacao extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step1Identificacao({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<Step1Identificacao> createState() => _Step1IdentificacaoState();
}

class _Step1IdentificacaoState extends State<Step1Identificacao> {
  // ── Controllers para os dropdowns pesquisáveis ──────────────
  late TextEditingController _diretoriaController;
  late TextEditingController _divisaoController;
  late TextEditingController _unidadeController;

  // ── Opções filtradas ────────────────────────────────────────
  List<String> _diretoriasFiltradas = [];
  List<String> _divisoesFiltradas = [];
  List<String> _unidadesFiltradas = [];

  @override
  void initState() {
    super.initState();
    _diretoriaController = TextEditingController(text: widget.data.diretoria);
    _divisaoController = TextEditingController(text: widget.data.divisao);
    _unidadeController = TextEditingController(text: widget.data.unidadeResponsavel);

    _atualizarDiretoriasFiltradas('');
  }

  @override
  void dispose() {
    _diretoriaController.dispose();
    _divisaoController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  // ── Helpers de lista ────────────────────────────────────────

  List<String> get _todasDiretorias =>
      diretoriasMock.map((d) => d.nome).toList();

  List<String> _divisoesDaDiretoria(String diretoriaNome) {
    final diretoria = diretoriasMock.where((d) => d.nome == diretoriaNome).firstOrNull;
    if (diretoria == null) return [];
    return diretoria.divisoes.map((div) => div.nome).toList();
  }

  List<String> _unidadesDaDivisao(String diretoriaNome, String divisaoNome) {
    final diretoria = diretoriasMock.where((d) => d.nome == diretoriaNome).firstOrNull;
    if (diretoria == null) return [];
    final divisao = diretoria.divisoes.where((div) => div.nome == divisaoNome).firstOrNull;
    if (divisao == null) return [];
    return divisao.unidades.map((u) => u.nome).toList();
  }

  // ── Filtro de pesquisa ──────────────────────────────────────

  void _atualizarDiretoriasFiltradas(String query) {
    setState(() {
      _diretoriasFiltradas = _filtrar(_todasDiretorias, query);
    });
  }

  void _atualizarDivisoesFiltradas(String query) {
    final todas = _divisoesDaDiretoria(widget.data.diretoria);
    setState(() {
      _divisoesFiltradas = _filtrar(todas, query);
    });
  }

  void _atualizarUnidadesFiltradas(String query) {
    final todas = _unidadesDaDivisao(widget.data.diretoria, widget.data.divisao);
    setState(() {
      _unidadesFiltradas = _filtrar(todas, query);
    });
  }

  List<String> _filtrar(List<String> lista, String query) {
    if (query.isEmpty) return lista;
    final lower = query.toLowerCase();
    return lista.where((item) => item.toLowerCase().contains(lower)).toList();
  }

  // ── Handlers de seleção ─────────────────────────────────────

  void _onDiretoriaChanged(String? value) {
    if (value == null || value == widget.data.diretoria) return;
    widget.data.diretoria = value;
    widget.data.divisao = '';
    widget.data.unidadeResponsavel = '';
    _divisaoController.clear();
    _unidadeController.clear();
    _atualizarDivisoesFiltradas('');
    setState(() {
      _unidadesFiltradas = [];
    });
    widget.onChanged();
  }

  void _onDivisaoChanged(String? value) {
    if (value == null || value == widget.data.divisao) return;
    widget.data.divisao = value;
    widget.data.unidadeResponsavel = '';
    _unidadeController.clear();
    _atualizarUnidadesFiltradas('');
    widget.onChanged();
  }

  void _onUnidadeChanged(String? value) {
    if (value == null || value == widget.data.unidadeResponsavel) return;
    widget.data.unidadeResponsavel = value;
    widget.onChanged();
  }

  // ── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card: Protocolo e Identificação
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Identificação do Registro',
                  icon: Icons.description_outlined,
                ),
                const SizedBox(height: 16),
                // Protocolo (somente leitura)
                PCPEInput(
                  label: 'Nº do Protocolo',
                  prefixIcon: Icons.qr_code_2,
                  controller: TextEditingController(text: widget.data.numeroProtocolo),
                  readOnly: true,
                ),
                const SizedBox(height: 14),
                PCPEInput(
                  label: 'Nº do BO',
                  hint: 'Boletim de Ocorrência',
                  prefixIcon: Icons.tag,
                  controller: TextEditingController(text: widget.data.numeroBO),
                  onChanged: (v) {
                    widget.data.numeroBO = v;
                    widget.onChanged();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Card: Classificação
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Classificação da Ocorrência',
                  icon: Icons.category_outlined,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Natureza',
                  value: widget.data.natureza,
                  items: const [
                    'Crime contra a vida',
                    'Crime contra o patrimônio',
                    'Crime contra a dignidade sexual',
                    'Tráfico de entorpecentes',
                    'Crime ambiental',
                    'Crime cibernético',
                    'Outros',
                  ],
                  onChanged: (v) {
                    widget.data.natureza = v;
                    widget.onChanged();
                  },
                ),
                const SizedBox(height: 14),
                _buildDropdown(
                  label: 'Tipo da Ocorrência',
                  value: widget.data.tipoOcorrencia,
                  items: const [
                    'Homicídio Doloso',
                    'Homicídio Culposo',
                    'Latrocínio',
                    'Feminicídio',
                    'Lesão Corporal',
                    'Tentativa de Homicídio',
                    'Morte Suspeita',
                  ],
                  onChanged: (v) {
                    widget.data.tipoOcorrencia = v;
                    widget.onChanged();
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius: BorderRadius.circular(10),
                        child: PCPEInput(
                          label: 'Data',
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                          controller: TextEditingController(
                            text: widget.data.dataOcorrencia != null
                                ? '${widget.data.dataOcorrencia!.day.toString().padLeft(2, '0')}/${widget.data.dataOcorrencia!.month.toString().padLeft(2, '0')}/${widget.data.dataOcorrencia!.year}'
                                : '',
                          ),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context),
                        borderRadius: BorderRadius.circular(10),
                        child: PCPEInput(
                          label: 'Hora',
                          prefixIcon: Icons.access_time,
                          readOnly: true,
                          controller: TextEditingController(
                            text: widget.data.horaOcorrencia != null
                                ? '${widget.data.horaOcorrencia!.hour.toString().padLeft(2, '0')}:${widget.data.horaOcorrencia!.minute.toString().padLeft(2, '0')}'
                                : '',
                          ),
                          onTap: () => _selectTime(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Card: Status e Prioridade
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Prioridade e Responsáveis',
                  icon: Icons.shield_outlined,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: 'Prioridade',
                        value: widget.data.prioridade,
                        items: const ['Baixa', 'Média', 'Alta', 'Urgente'],
                        onChanged: (v) {
                          widget.data.prioridade = v;
                          widget.onChanged();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        label: 'Status',
                        value: widget.data.status,
                        items: const ['Em andamento', 'Concluído', 'Arquivado', 'Pendente'],
                        onChanged: (v) {
                          widget.data.status = v;
                          widget.onChanged();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── HIERARQUIA DE UNIDADES ────────────────────
                const PCPESectionTitle(
                  title: 'Unidade Responsável',
                  icon: Icons.account_tree_outlined,
                ),
                const SizedBox(height: 12),

                // 1º Campo: DIRETORIA
                _buildSearchableDropdown(
                  label: 'Diretoria',
                  controller: _diretoriaController,
                  filteredOptions: _diretoriasFiltradas,
                  enabled: true,
                  onSearchChanged: _atualizarDiretoriasFiltradas,
                  onSelected: _onDiretoriaChanged,
                ),
                const SizedBox(height: 12),

                // 2º Campo: DIVISÃO
                _buildSearchableDropdown(
                  label: 'Divisão',
                  controller: _divisaoController,
                  filteredOptions: _divisoesFiltradas,
                  enabled: widget.data.diretoria.isNotEmpty,
                  onSearchChanged: _atualizarDivisoesFiltradas,
                  onSelected: _onDivisaoChanged,
                ),
                const SizedBox(height: 12),

                // 3º Campo: UNIDADE
                _buildSearchableDropdown(
                  label: 'Unidade',
                  controller: _unidadeController,
                  filteredOptions: _unidadesFiltradas,
                  enabled: widget.data.divisao.isNotEmpty,
                  onSearchChanged: _atualizarUnidadesFiltradas,
                  onSelected: _onUnidadeChanged,
                ),

                const SizedBox(height: 14),
                _buildDropdown(
                  label: 'Equipe Responsável',
                  value: widget.data.equipeResponsavel,
                  items: const [
                    'Equipe Delta - Plantão A',
                    'Equipe Alfa - Plantão B',
                    'Equipe Bravo - Plantão C',
                    'Equipe Charlie - Plantão D',
                  ],
                  onChanged: (v) {
                    widget.data.equipeResponsavel = v;
                    widget.onChanged();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Data/Time Pickers ─────────────────────────────────────

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.data.dataOcorrencia ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: PCPEColors.primary,
              onPrimary: PCPEColors.pureWhite,
              surface: PCPEColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      widget.data.dataOcorrencia = picked;
      widget.onChanged();
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.data.horaOcorrencia ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: PCPEColors.primary,
              onPrimary: PCPEColors.pureWhite,
              surface: PCPEColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      widget.data.horaOcorrencia = picked;
      widget.onChanged();
    }
  }

  // ── Widget: Dropdown comum ─────────────────────────────────

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      style: const TextStyle(color: PCPEColors.black, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: PCPEColors.cardGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PCPEColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: PCPEColors.darkGray, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: (v) => onChanged(v!),
      icon: const Icon(Icons.keyboard_arrow_down, color: PCPEColors.mediumGray),
      isExpanded: true,
    );
  }

  // ── Widget: Dropdown pesquisável ───────────────────────────

  Widget _buildSearchableDropdown({
    required String label,
    required TextEditingController controller,
    required List<String> filteredOptions,
    required bool enabled,
    required void Function(String query) onSearchChanged,
    required void Function(String? value) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: enabled
              ? () => _showSearchablePicker(
                    label: label,
                    options: filteredOptions,
                    currentValue: controller.text,
                    onSelected: onSelected,
                    controller: controller,
                    onSearchChanged: onSearchChanged,
                  )
              : null,
          child: AbsorbPointer(
            absorbing: true,
            child: TextField(
              controller: controller,
              enabled: enabled,
              style: const TextStyle(color: PCPEColors.black, fontSize: 14),
              decoration: InputDecoration(
                labelText: label,
                hintText: enabled ? 'Pesquisar...' : 'Selecione o campo acima primeiro',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.keyboard_arrow_down, color: PCPEColors.mediumGray),
                filled: true,
                fillColor: PCPEColors.cardGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: PCPEColors.primary, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
                ),
                labelStyle: const TextStyle(color: PCPEColors.darkGray, fontSize: 14),
                hintStyle: const TextStyle(color: PCPEColors.mediumGray, fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSearchablePicker({
    required String label,
    required List<String> options,
    required String currentValue,
    required void Function(String?) onSelected,
    required TextEditingController controller,
    required void Function(String) onSearchChanged,
  }) {
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return _SearchablePickerContent(
          label: label,
          options: options,
          currentValue: currentValue,
          onSelected: (value) {
            controller.text = value;
            onSelected(value);
            Navigator.pop(sheetContext);
          },
          onSearchChanged: onSearchChanged,
        );
      },
    );
  }
}

// ── Widget interno do Bottom Sheet de pesquisa ──────────────

class _SearchablePickerContent extends StatefulWidget {
  final String label;
  final List<String> options;
  final String currentValue;
  final void Function(String) onSelected;
  final void Function(String) onSearchChanged;

  const _SearchablePickerContent({
    required this.label,
    required this.options,
    required this.currentValue,
    required this.onSelected,
    required this.onSearchChanged,
  });

  @override
  State<_SearchablePickerContent> createState() => _SearchablePickerContentState();
}

class _SearchablePickerContentState extends State<_SearchablePickerContent> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    final displayOptions = _searchController.text.isEmpty
        ? options
        : options
            .where((o) => o.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: PCPEColors.mediumGray.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Título
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Selecionar ${widget.label}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: PCPEColors.black,
                ),
              ),
            ),
            // Campo de pesquisa
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: PCPEColors.black, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Pesquisar ${widget.label.toLowerCase()}...',
                  prefixIcon: const Icon(Icons.search, color: PCPEColors.mediumGray),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearchChanged('');
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: PCPEColors.cardGray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: PCPEColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (query) {
                  widget.onSearchChanged(query);
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 8),
            // Contagem
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${displayOptions.length} ${displayOptions.length == 1 ? 'item' : 'itens'}',
                  style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Lista
            Expanded(
              child: displayOptions.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum resultado encontrado',
                        style: TextStyle(color: PCPEColors.mediumGray, fontSize: 14),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: displayOptions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final option = displayOptions[index];
                        final isSelected = option == widget.currentValue;
                        return ListTile(
                          title: Text(
                            option,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? PCPEColors.primary : PCPEColors.black,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: PCPEColors.primary, size: 20)
                              : null,
                          selected: isSelected,
                          selectedTileColor: PCPEColors.primaryLight.withValues(alpha: 0.2),
                          onTap: () => widget.onSelected(option),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}