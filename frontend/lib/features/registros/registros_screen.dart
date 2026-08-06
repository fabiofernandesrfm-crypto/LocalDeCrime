import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_system.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_input.dart';
import '../../shared/widgets/pcpe_section_title.dart';
import '../../shared/widgets/pcpe_status_chip.dart';

/// Tela de Registros (F19).
///
/// Lista os registros de ocorrências do sistema com filtros e status.
/// Preparada para integração futura com APIs — camada de dados separada.
class RegistrosScreen extends StatefulWidget {
  const RegistrosScreen({super.key});

  @override
  State<RegistrosScreen> createState() => _RegistrosScreenState();
}

class _RegistrosScreenState extends State<RegistrosScreen> {
  final _protocoloCtrl = TextEditingController();
  final _nicCtrl = TextEditingController();
  String? _filtroMunicipio;
  String? _filtroStatus;
  bool _filtrosVisiveis = false;

  // ═══════════════════════════════════════════════════════════════
  // Camada de dados mock — substituível por Repository futuramente
  // ═══════════════════════════════════════════════════════════════
  static const _registros = [
    {
      'protocolo': 'PCPE-2026-001247',
      'nic': 'NIC-2026-001',
      'data': '15/03/2026',
      'municipio': 'Recife',
      'natureza': 'Homicídio Doloso',
      'agente': 'Ag. Carlos Eduardo',
      'unidade': 'DHPP - Recife',
      'status': PCPEStatus.concluido,
    },
    {
      'protocolo': 'PCPE-2026-001248',
      'nic': '',
      'data': '14/03/2026',
      'municipio': 'Jaboatão dos Guararapes',
      'natureza': 'Homicídio Culposo',
      'agente': 'Ag. Fabio Fernandes',
      'unidade': 'DHPP - Recife',
      'status': PCPEStatus.emAndamento,
    },
    {
      'protocolo': 'PCPE-2026-001249',
      'nic': 'NIC-2026-003',
      'data': '14/03/2026',
      'municipio': 'Olinda',
      'natureza': 'Feminicídio',
      'agente': 'Ag. Maria Silva',
      'unidade': 'DHPP - Olinda',
      'status': PCPEStatus.rascunho,
    },
    {
      'protocolo': 'PCPE-2026-001250',
      'nic': 'NIC-2026-004',
      'data': '13/03/2026',
      'municipio': 'Paulista',
      'natureza': 'Homicídio Doloso',
      'agente': 'Ag. João Santos',
      'unidade': 'DHPP - Paulista',
      'status': PCPEStatus.enviadoSpp,
    },
    {
      'protocolo': 'PCPE-2026-001251',
      'nic': '',
      'data': '12/03/2026',
      'municipio': 'Cabo de Santo Agostinho',
      'natureza': 'Latrocínio',
      'agente': 'Ag. Ana Costa',
      'unidade': 'DHPP - Cabo',
      'status': PCPEStatus.pendente,
    },
    {
      'protocolo': 'PCPE-2026-001252',
      'nic': 'NIC-2026-006',
      'data': '11/03/2026',
      'municipio': 'Recife',
      'natureza': 'Homicídio Doloso',
      'agente': 'Ag. Pedro Lima',
      'unidade': 'DHPP - Recife',
      'status': PCPEStatus.concluido,
    },
    {
      'protocolo': 'PCPE-2026-001253',
      'nic': '',
      'data': '10/03/2026',
      'municipio': 'Jaboatão dos Guararapes',
      'natureza': 'Homicídio Doloso',
      'agente': 'Ag. Carlos Eduardo',
      'unidade': 'DHPP - Jaboatão',
      'status': PCPEStatus.rascunho,
    },
  ];

  final _municipios = [
    'Recife',
    'Jaboatão dos Guararapes',
    'Olinda',
    'Paulista',
    'Cabo de Santo Agostinho',
  ];

  final _statusOptions = [
    PCPEStatus.rascunho,
    PCPEStatus.emAndamento,
    PCPEStatus.concluido,
    PCPEStatus.enviadoSpp,
    PCPEStatus.pendente,
  ];

  @override
  void dispose() {
    _protocoloCtrl.dispose();
    _nicCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtrados {
    return _registros.where((r) {
      if (_protocoloCtrl.text.isNotEmpty &&
          !(r['protocolo'] as String)
              .toLowerCase()
              .contains(_protocoloCtrl.text.toLowerCase())) {
        return false;
      }
      if (_nicCtrl.text.isNotEmpty &&
          !(r['nic'] as String)
              .toLowerCase()
              .contains(_nicCtrl.text.toLowerCase())) {
        return false;
      }
      if (_filtroMunicipio != null && r['municipio'] != _filtroMunicipio) {
        return false;
      }
      if (_filtroStatus != null &&
          (r['status'] as PCPEStatus).label != _filtroStatus) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final registros = _filtrados;

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: AppBar(
        backgroundColor: PCPEColors.pureWhite,
        elevation: 0,
        shadowColor: Colors.black12,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Registros',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: PCPEColors.black,
              ),
            ),
            Text(
              'Sistema de Registro de Atendimento em Local de Crime',
              style: TextStyle(fontSize: 11, color: PCPEColors.mediumGray),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _filtrosVisiveis ? Icons.filter_list_off : Icons.filter_list,
              color: _filtrosVisiveis ? PCPEColors.primary : PCPEColors.darkGray,
            ),
            tooltip: 'Filtros',
            onPressed: () => setState(() => _filtrosVisiveis = !_filtrosVisiveis),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros expansíveis
          if (_filtrosVisiveis)
            Container(
              color: PCPEColors.pureWhite,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PCPEInput(
                          hint: 'Nº Protocolo',
                          prefixIcon: Icons.search,
                          controller: _protocoloCtrl,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PCPEInput(
                          hint: 'NIC',
                          prefixIcon: Icons.badge_outlined,
                          controller: _nicCtrl,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _filtroMunicipio,
                          decoration: _ddDecoration('Município'),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Todos'),
                            ),
                            ..._municipios.map((m) =>
                                DropdownMenuItem(value: m, child: Text(m))),
                          ],
                          onChanged: (v) =>
                              setState(() => _filtroMunicipio = v),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _filtroStatus,
                          decoration: _ddDecoration('Situação'),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Todas'),
                            ),
                            ..._statusOptions.map((s) => DropdownMenuItem(
                                value: s.label, child: Text(s.label))),
                          ],
                          onChanged: (v) =>
                              setState(() => _filtroStatus = v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // Contador
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const PCPESectionTitle(
                  title: 'Registros',
                  icon: Icons.description_outlined,
                  subtitle: '',
                ),
                const Spacer(),
                Text(
                  '${registros.length} registro(s)',
                  style: const TextStyle(
                    fontSize: 12,
                    color: PCPEColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          // Listagem
          Expanded(
            child: registros.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 48, color: PCPEColors.mediumGray.withValues(alpha: 0.4)),
                        const SizedBox(height: 12),
                        const Text(
                          'Nenhum registro encontrado',
                          style: TextStyle(fontSize: 14, color: PCPEColors.mediumGray),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: registros.length,
                    itemBuilder: (context, index) {
                      final r = registros[index];
                      final status = r['status'] as PCPEStatus;
                      return PCPECard(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        padding: const EdgeInsets.all(14),
                        onTap: () => _abrirRegistro(context, r),
                        child: Row(
                          children: [
                            // Barra de status
                            Container(
                              width: 4,
                              height: 64,
                              decoration: BoxDecoration(
                                color: status.color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          r['protocolo'] as String,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: PCPEColors.black,
                                          ),
                                        ),
                                      ),
                                      PCPEStatusChip(status: status),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${r['natureza']} — ${r['municipio']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: PCPEColors.darkGray,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.person_outline,
                                          size: 12, color: PCPEColors.mediumGray),
                                      const SizedBox(width: 4),
                                      Text(
                                        r['agente'] as String,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: PCPEColors.mediumGray),
                                      ),
                                      const SizedBox(width: 12),
                                      const Icon(Icons.calendar_today,
                                          size: 12, color: PCPEColors.mediumGray),
                                      const SizedBox(width: 4),
                                      Text(
                                        r['data'] as String,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: PCPEColors.mediumGray),
                                      ),
                                      if ((r['nic'] as String).isNotEmpty) ...[
                                        const SizedBox(width: 12),
                                        const Icon(Icons.badge_outlined,
                                            size: 12, color: PCPEColors.mediumGray),
                                        const SizedBox(width: 4),
                                        Text(
                                          r['nic'] as String,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: PCPEColors.mediumGray),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right,
                                color: PCPEColors.lightGray),
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

  void _abrirRegistro(BuildContext context, Map<String, dynamic> registro) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _RegistroDetalheScreen(registro: registro),
      ),
    );
  }

  InputDecoration _ddDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: PCPEColors.cardGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: PCPEColors.primary, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      labelStyle: const TextStyle(color: PCPEColors.darkGray, fontSize: 12),
    );
  }
}

// ═════════════════════════════════════════════════════════════════
// Tela de Visualização do Registro (mock)
// ═════════════════════════════════════════════════════════════════

class _RegistroDetalheScreen extends StatelessWidget {
  final Map<String, dynamic> registro;

  const _RegistroDetalheScreen({required this.registro});

  @override
  Widget build(BuildContext context) {
    final status = registro['status'] as PCPEStatus;
    final ehRascunho = status == PCPEStatus.rascunho;

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: AppBar(
        backgroundColor: PCPEColors.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: PCPEColors.primary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          registro['protocolo'] as String,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: PCPEColors.black,
          ),
        ),
        actions: [
          PCPEStatusChip(status: status),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ══════════════════════════════════════════════════
            // Identificação
            // ══════════════════════════════════════════════════
            PCPECard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PCPESectionTitle(
                    title: 'Identificação',
                    icon: Icons.description_outlined,
                    subtitle: '',
                  ),
                  const SizedBox(height: 12),
                  _campo('Protocolo', registro['protocolo'] as String),
                  _campo(
                      'NIC',
                      (registro['nic'] as String).isNotEmpty
                          ? registro['nic'] as String
                          : 'Não informado'),
                  _campo('Data da Ocorrência', registro['data'] as String),
                  _campo('Natureza', registro['natureza'] as String),
                  _campo('Município', registro['municipio'] as String),
                  _campo('Unidade', registro['unidade'] as String),
                  _campo('Agente Responsável', registro['agente'] as String),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // ══════════════════════════════════════════════════
            // Local do Crime
            // ══════════════════════════════════════════════════
            PCPECard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PCPESectionTitle(
                    title: 'Local do Crime',
                    icon: Icons.location_on_outlined,
                    subtitle: '',
                  ),
                  const SizedBox(height: 12),
                  _campo('Logradouro', 'Av. Conde da Boa Vista, 1234'),
                  _campo('Bairro', 'Boa Vista'),
                  _campo('Município', registro['municipio'] as String),
                  _campo('Coordenadas', '-8.0476, -34.8770'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // ══════════════════════════════════════════════════
            // Pessoas Envolvidas
            // ══════════════════════════════════════════════════
            PCPECard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PCPESectionTitle(
                    title: 'Pessoas Envolvidas',
                    icon: Icons.people_outline,
                    subtitle: '',
                  ),
                  const SizedBox(height: 12),
                  _pessoaBloco('Vítima', 'João da Silva', nic: 'NIC-2026-001'),
                  _pessoaBloco('Suspeito', 'Desconhecido'),
                  _pessoaBloco('Testemunha', 'Maria Oliveira'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // ══════════════════════════════════════════════════
            // Narrativa
            // ══════════════════════════════════════════════════
            PCPECard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PCPESectionTitle(
                    title: 'Narrativa',
                    icon: Icons.edit_note,
                    subtitle: '',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No dia 15 de março de 2026, por volta das 14h30, a equipe de plantão '
                    'foi acionada via CIODS para atender a uma ocorrência de homicídio no '
                    'endereço supracitado. No local, foi constatado o óbito da vítima, '
                    'apresentando ferimentos compatíveis com disparo de arma de fogo.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: PCPEColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PCPEColors.infoLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.mic, size: 14, color: PCPEColors.info),
                        SizedBox(width: 6),
                        Text(
                          'Áudio da narrativa anexado.',
                          style: TextStyle(
                            fontSize: 12,
                            color: PCPEColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // ══════════════════════════════════════════════════
            // Fotografias (placeholder)
            // ══════════════════════════════════════════════════
            PCPECard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PCPESectionTitle(
                    title: 'Fotografias',
                    icon: Icons.photo_camera_outlined,
                    subtitle: '',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(3, (i) {
                      return Container(
                        width: 100,
                        height: 75,
                        decoration: BoxDecoration(
                          color: PCPEColors.cardGray,
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: PCPEColors.surfaceGray),
                        ),
                        child: const Icon(Icons.image,
                            size: 28, color: PCPEColors.lightGray),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // ══════════════════════════════════════════════════
            // Ações
            // ══════════════════════════════════════════════════
            if (ehRascunho)
              PCPEButton(
                label: 'Continuar Edição',
                icon: Icons.edit,
                fullWidth: true,
                height: 48,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Redirecionando para edição...'),
                      backgroundColor: PCPEColors.darkGray,
                    ),
                  );
                },
              ),
            if (ehRascunho) const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: PCPEButton(
                    label: 'Gerar PDF',
                    icon: Icons.picture_as_pdf_outlined,
                    fullWidth: true,
                    outlined: true,
                    height: 48,
                    onPressed: () => _mock(context, 'Gerar PDF'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PCPEButton(
                    label: 'Imprimir',
                    icon: Icons.print_outlined,
                    fullWidth: true,
                    outlined: true,
                    height: 48,
                    onPressed: () => _mock(context, 'Imprimir'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            PCPEButton(
              label: 'Enviar ao SPP',
              icon: Icons.send_outlined,
              fullWidth: true,
              height: 48,
              backgroundColor: PCPEColors.primary,
              foregroundColor: PCPEColors.pureWhite,
              onPressed: () => _mock(context, 'Enviar ao SPP'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _campo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PCPEColors.darkGray),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  const TextStyle(fontSize: 13, color: PCPEColors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pessoaBloco(String tipo, String nome, {String? nic}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: PCPEColors.cardGray,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: PCPEColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tipo,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: PCPEColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                if (nic != null)
                  Text(
                    'NIC: $nic',
                    style: const TextStyle(
                        fontSize: 11, color: PCPEColors.mediumGray),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mock(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action (simulado)'),
        backgroundColor: PCPEColors.darkGray,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}