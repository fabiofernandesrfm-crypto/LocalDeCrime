import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/models/media_item.dart';
import 'ocorrencia_wizard_data.dart';

// ═════════════════════════════════════════════════════════════════
// Modelo de Resultado da Validação
// ═════════════════════════════════════════════════════════════════

enum ValidationStatus { pronto, alertas, pendente }

class _ItemValidacao {
  final String mensagem;
  final bool ok;
  const _ItemValidacao({required this.mensagem, required this.ok});
}

class _ResultadoValidacao {
  final ValidationStatus status;
  final List<_ItemValidacao> obrigatorios;
  final List<_ItemValidacao> alertas;
  final List<_ItemValidacao> informativos;

  const _ResultadoValidacao({
    required this.status,
    required this.obrigatorios,
    required this.alertas,
    required this.informativos,
  });
}

/// Etapa 8: Pré-Visualização do Documento Oficial (PDF) com Validação Inteligente.
///
/// F16 — Inclui painel de validação orientativa antes do PDF.
/// Nenhum dado é alterado automaticamente. Nenhum fluxo é bloqueado.
class Step8PreviewPdf extends StatefulWidget {
  final OcorrenciaWizardData data;
  final VoidCallback? onVoltarEdicao;

  Step8PreviewPdf({
    super.key,
    required this.data,
    this.onVoltarEdicao,
  });

  @override
  State<Step8PreviewPdf> createState() => _Step8PreviewPdfState();
}

class _Step8PreviewPdfState extends State<Step8PreviewPdf> {
  bool _pendenciasRevisadas = false;

  OcorrenciaWizardData get data => widget.data;
  VoidCallback? get onVoltarEdicao => widget.onVoltarEdicao;

  // ═══════════════════════════════════════════════════════════════
  // Motor de Validação
  // ═══════════════════════════════════════════════════════════════

  _ResultadoValidacao _validar() {
    final obrigatorios = <_ItemValidacao>[];
    final alertas = <_ItemValidacao>[];
    final informativos = <_ItemValidacao>[];

    // ── Dados obrigatórios ─────────────────────────────────────
    obrigatorios.add(_ItemValidacao(
      mensagem: 'Número do Protocolo',
      ok: data.numeroProtocolo.isNotEmpty,
    ));
    // Número do BO NÃO é obrigatório. Não gerar alerta.
    obrigatorios.add(_ItemValidacao(
      mensagem: 'Unidade Responsável',
      ok: data.unidadeResponsavel.isNotEmpty,
    ));
    obrigatorios.add(_ItemValidacao(
      mensagem: 'Local do Crime (Logradouro)',
      ok: data.logradouro.isNotEmpty,
    ));
    obrigatorios.add(_ItemValidacao(
      mensagem: 'Data da Ocorrência',
      ok: data.dataOcorrencia != null,
    ));
    obrigatorios.add(_ItemValidacao(
      mensagem: 'Hora da Ocorrência',
      ok: data.horaOcorrencia != null,
    ));
    final temPessoa = data.pessoas.isNotEmpty;
    obrigatorios.add(_ItemValidacao(
      mensagem: 'Pelo menos uma pessoa cadastrada',
      ok: temPessoa,
    ));
    obrigatorios.add(_ItemValidacao(
      mensagem: 'Narrativa preenchida',
      ok: data.narrativa.isNotEmpty,
    ));

    // ── Validação das pessoas envolvidas ───────────────────────
    for (final p in data.pessoas) {
      final nome = p.nome.isNotEmpty ? p.nome : '${p.tipo} sem nome';
      if (p.nome.isEmpty) {
        alertas.add(_ItemValidacao(
          mensagem: '$nome: Nome não informado',
          ok: false,
        ));
      }
      // NIC é obrigatório apenas para Vítimas
      if (p.tipo == 'Vítima' && p.nic.isEmpty) {
        alertas.add(_ItemValidacao(
          mensagem: '$nome (Vítima): NIC não informado',
          ok: false,
        ));
      }
    }

    // ── Validação dos veículos ─────────────────────────────────
    for (final v in data.veiculos) {
      final idVeiculo = v.placa.isNotEmpty ? v.placa : 'Veículo sem placa';
      if (v.placa.isEmpty) {
        alertas.add(_ItemValidacao(
          mensagem: '$idVeiculo: Placa não informada',
          ok: false,
        ));
      }
      if (v.marca.isEmpty) {
        alertas.add(_ItemValidacao(
          mensagem: '$idVeiculo: Marca não informada',
          ok: false,
        ));
      }
      if (v.modelo.isEmpty) {
        alertas.add(_ItemValidacao(
          mensagem: '$idVeiculo: Modelo não informado',
          ok: false,
        ));
      }
    }

    // ── Validação dos objetos ──────────────────────────────────
    for (final o in data.objetos) {
      if (o.descricao.isEmpty) {
        alertas.add(_ItemValidacao(
          mensagem: 'Objeto sem descrição identificado',
          ok: false,
        ));
      }
    }

    // ── Validação dos vestígios ────────────────────────────────
    for (final v in data.vestigios) {
      final idVestigio = v.descricao.isNotEmpty ? v.descricao : 'Vestígio sem descrição';
      if (v.tipo.isEmpty) {
        alertas.add(_ItemValidacao(
          mensagem: '$idVestigio: Tipo não informado',
          ok: false,
        ));
      }
      if (v.descricao.isEmpty) {
        alertas.add(_ItemValidacao(
          mensagem: 'Vestígio sem descrição',
          ok: false,
        ));
      }
    }

    // ── Validação da narrativa ─────────────────────────────────
    if (data.narrativa.isNotEmpty && data.narrativa.length < 50) {
      alertas.add(const _ItemValidacao(
        mensagem: 'Recomenda-se complementar a narrativa para maior riqueza de detalhes.',
        ok: false,
      ));
    }

    // ── Resumo de fotografias ──────────────────────────────────
    final fotosLocal = data.midiasLocal.where((m) => m.type == MediaType.photo).length;
    int fotosPessoas = 0;
    for (final p in data.pessoas) {
      fotosPessoas += p.midias.where((m) => m.type == MediaType.photo).length;
    }
    int fotosVeiculos = 0;
    for (final v in data.veiculos) {
      fotosVeiculos += v.midias.where((m) => m.type == MediaType.photo).length;
    }
    int fotosObjetos = 0;
    for (final o in data.objetos) {
      fotosObjetos += o.midias.where((m) => m.type == MediaType.photo).length;
    }
    int fotosVestigios = 0;
    for (final v in data.vestigios) {
      fotosVestigios += v.midias.where((m) => m.type == MediaType.photo).length;
    }
    final totalFotos = fotosLocal + fotosPessoas + fotosVeiculos + fotosObjetos + fotosVestigios;

    if (totalFotos == 0) {
      informativos.add(const _ItemValidacao(
        mensagem: 'Nenhuma fotografia registrada.',
        ok: true,
      ));
    } else {
      informativos.add(_ItemValidacao(
        mensagem: 'Fotos do Local: $fotosLocal',
        ok: true,
      ));
      informativos.add(_ItemValidacao(
        mensagem: 'Fotos das Pessoas: $fotosPessoas',
        ok: true,
      ));
      informativos.add(_ItemValidacao(
        mensagem: 'Fotos dos Veículos: $fotosVeiculos',
        ok: true,
      ));
      informativos.add(_ItemValidacao(
        mensagem: 'Fotos dos Objetos: $fotosObjetos',
        ok: true,
      ));
      informativos.add(_ItemValidacao(
        mensagem: 'Fotos dos Vestígios: $fotosVestigios',
        ok: true,
      ));
    }

    // ── Determinar status geral ────────────────────────────────
    final temPendencias = obrigatorios.any((i) => !i.ok);
    final temAlertas = alertas.isNotEmpty;

    final status = temPendencias
        ? ValidationStatus.pendente
        : temAlertas
            ? ValidationStatus.alertas
            : ValidationStatus.pronto;

    return _ResultadoValidacao(
      status: status,
      obrigatorios: obrigatorios,
      alertas: alertas,
      informativos: informativos,
    );
  }

  int _contarFotos() {
    int count = data.midiasLocal.where((m) => m.type == MediaType.photo).length;
    for (final p in data.pessoas) {
      count += p.midias.where((m) => m.type == MediaType.photo).length;
    }
    for (final v in data.veiculos) {
      count += v.midias.where((m) => m.type == MediaType.photo).length;
    }
    for (final o in data.objetos) {
      count += o.midias.where((m) => m.type == MediaType.photo).length;
    }
    for (final v in data.vestigios) {
      count += v.midias.where((m) => m.type == MediaType.photo).length;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dataEmissao =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final horaEmissao =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final validacao = _validar();

    return Column(
      children: [
        // ── Barra de Ações (topo) ──────────────────────────────
        _buildActionBar(context),
        // ── Painel de Validação (oculto após revisão) ───────────
        if (!_pendenciasRevisadas) _buildPainelValidacao(validacao),
        // ── Conteúdo do Documento ───────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Container(
                  decoration: BoxDecoration(
                    color: PCPEColors.pureWhite,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ── Cabeçalho Institucional ───────────────
                      _buildCabecalho(dataEmissao, horaEmissao),
                      _buildDivider(),
                      // ── Seção: Identificação ──────────────────
                      _buildSecaoIdentificacao(),
                      _buildDivider(),
                      // ── Seção: Local do Crime ─────────────────
                      _buildSecaoLocalCrime(),
                      _buildDivider(),
                      // ── Seção: Pessoas Envolvidas ─────────────
                      _buildSecaoPessoas(),
                      _buildDivider(),
                      // ── Seção: Veículos ────────────────────────
                      _buildSecaoVeiculos(),
                      _buildDivider(),
                      // ── Seção: Objetos ─────────────────────────
                      _buildSecaoObjetos(),
                      _buildDivider(),
                      // ── Seção: Vestígios ───────────────────────
                      _buildSecaoVestigios(),
                      _buildDivider(),
                      // ── Seção: Fotografias ─────────────────────
                      _buildSecaoFotografias(),
                      _buildDivider(),
                      // ── Seção: Narrativa ───────────────────────
                      _buildSecaoNarrativa(),
                      _buildDivider(),
                      // ── Rodapé Institucional ───────────────────
                      _buildRodape(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Barra de Ações
  // ═══════════════════════════════════════════════════════════════

  Widget _buildActionBar(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);
    final isMobile = breakpoints.isMobile;

    return Container(
      color: PCPEColors.pureWhite,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 16,
        vertical: isMobile ? 6 : 10,
      ),
      child: SafeArea(
        bottom: false,
        child: isMobile
            ? Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _actionButtons(context, compact: true),
              )
            : Row(
                children: [
                  ..._actionButtons(context),
                ],
              ),
      ),
    );
  }

  List<Widget> _actionButtons(BuildContext context, {bool compact = false}) {
    final buttonPadding = compact
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 6);

    final voltarBtn = _ActionButton(
      label: compact ? 'Editar' : 'Voltar para Editar',
      icon: Icons.edit_outlined,
      padding: buttonPadding,
      outlined: true,
      onPressed: onVoltarEdicao!,
    );

    if (_pendenciasRevisadas) {
      return [
        if (onVoltarEdicao != null) voltarBtn,
        _ActionButton(
          label: compact ? 'Concluir' : 'Concluir Ocorrência',
          icon: Icons.check_circle,
          padding: buttonPadding,
          primary: true,
          onPressed: () => _handleConcluirOcorrencia(context),
        ),
      ];
    }

    return [
      if (onVoltarEdicao != null) voltarBtn,
      _ActionButton(
        label: compact ? 'Prosseguir' : 'Prosseguir',
        icon: Icons.arrow_forward,
        padding: buttonPadding,
        primary: true,
        onPressed: () => _handleProsseguir(context),
      ),
    ];
  }

  void _handleProsseguir(BuildContext context) {
    final validacao = _validar();
    if (validacao.status == ValidationStatus.pendente) {
      _showConfirmacaoDialog(context);
      return;
    }
    // Sem pendências: avança direto para conclusão
    setState(() => _pendenciasRevisadas = true);
  }

  void _handleConcluirOcorrencia(BuildContext context) {
    _mockAction(context, 'Concluir Ocorrência');
  }

  void _showConfirmacaoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: PCPEColors.pureWhite,
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                size: 22, color: PCPEColors.warning),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Revisão da Ocorrência',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: PCPEColors.black,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'A ocorrência possui algumas informações que poderão ser complementadas posteriormente.\n\n'
          'Deseja voltar para editar ou concluir a ocorrência?',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: PCPEColors.darkGray,
          ),
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: () => Navigator.of(ctx).pop(),
            icon: const Icon(Icons.edit, size: 16),
            label: const Text(
              'Voltar para Editar',
              style: TextStyle(fontSize: 13),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: PCPEColors.darkGray,
              side: const BorderSide(color: PCPEColors.surfaceGray),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _pendenciasRevisadas = true);
            },
            icon: const Icon(Icons.check, size: 16),
            label: const Text(
              'Prosseguir para Conclusão',
              style: TextStyle(fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: PCPEColors.primary,
              foregroundColor: PCPEColors.pureWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  void _mockAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ação "$action" será implementada em sprint futura.'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        backgroundColor: PCPEColors.darkGray,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Painel de Validação da Ocorrência (F16)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildPainelValidacao(_ResultadoValidacao v) {
    // Status colors
    final Color statusColor;
    final String statusEmoji;
    final String statusTitulo;
    final String statusSubtitulo;

    switch (v.status) {
      case ValidationStatus.pronto:
        statusColor = PCPEColors.success;
        statusEmoji = '●';
        statusTitulo = 'Pronta para geração do PDF';
        statusSubtitulo = 'Todos os campos obrigatórios foram preenchidos.';
        break;
      case ValidationStatus.alertas:
        statusColor = PCPEColors.warning;
        statusEmoji = '●';
        statusTitulo = 'Possui alertas para revisão';
        statusSubtitulo = 'Verifique os itens destacados antes de prosseguir.';
        break;
      case ValidationStatus.pendente:
        statusColor = PCPEColors.error;
        statusEmoji = '●';
        statusTitulo = 'Existem pendências obrigatórias';
        statusSubtitulo = 'Preencha os campos obrigatórios antes da geração do PDF.';
        break;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      decoration: BoxDecoration(
        color: PCPEColors.pureWhite,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: PCPEColors.surfaceGray),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Indicador Geral ──────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        v.status == ValidationStatus.pronto
                            ? Icons.check_circle
                            : v.status == ValidationStatus.alertas
                                ? Icons.warning_amber_rounded
                                : Icons.error_outline,
                        size: 20,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                statusEmoji,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: statusColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                statusTitulo,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: PCPEColors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            statusSubtitulo,
                            style: TextStyle(
                              fontSize: 11,
                              color: PCPEColors.darkGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // ── Resumo numérico ──────────────────────────────
                Row(
                  children: [
                    _buildContador(
                      'Obrigatórios',
                      v.obrigatorios.where((i) => i.ok).length,
                      v.obrigatorios.length,
                      PCPEColors.success,
                    ),
                    const SizedBox(width: 16),
                    _buildContador(
                      'Pendências',
                      v.obrigatorios.where((i) => !i.ok).length +
                          v.alertas.length,
                      null,
                      PCPEColors.error,
                    ),
                    const SizedBox(width: 16),
                    _buildContador(
                      'Alertas',
                      v.alertas.length,
                      null,
                      PCPEColors.warning,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // ── Lista de obrigatórios ────────────────────────
                _buildGrupoItens(
                  'Dados Obrigatórios',
                  Icons.checklist,
                  v.obrigatorios,
                  corTitulo: PCPEColors.darkGray,
                ),
                // ── Lista de alertas ─────────────────────────────
                if (v.alertas.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildGrupoItens(
                    'Alertas para Revisão',
                    Icons.warning_amber_rounded,
                    v.alertas,
                    corTitulo: PCPEColors.warning,
                  ),
                ],
                // ── Lista de informativos ────────────────────────
                if (v.informativos.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildGrupoItens(
                    'Informações',
                    Icons.info_outline,
                    v.informativos,
                    corTitulo: PCPEColors.darkGray,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContador(
      String label, int valor, int? total, Color cor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: cor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: PCPEColors.darkGray,
          ),
        ),
        Text(
          total != null ? '$valor/$total' : '$valor',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: cor,
          ),
        ),
      ],
    );
  }

  Widget _buildGrupoItens(
      String titulo, IconData icon, List<_ItemValidacao> itens,
      {Color corTitulo = PCPEColors.darkGray}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: corTitulo),
            const SizedBox(width: 6),
            Text(
              titulo,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: corTitulo,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...itens.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.ok ? Icons.check_circle : Icons.cancel,
                    size: 14,
                    color: item.ok ? PCPEColors.success : PCPEColors.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.mensagem,
                      style: TextStyle(
                        fontSize: 11,
                        color: item.ok
                            ? PCPEColors.darkGray
                            : PCPEColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Cabeçalho Institucional
  // ═══════════════════════════════════════════════════════════════

  Widget _buildCabecalho(String dataEmissao, String horaEmissao) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 20),
      child: Column(
        children: [
          // Brasão
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B1B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.shield,
              size: 36,
              color: PCPEColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          // POLÍCIA CIVIL DE PERNAMBUCO
          Text(
            'POLÍCIA CIVIL DE PERNAMBUCO',
            textAlign: TextAlign.center,
            style: PCPETypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: PCPEColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Departamento de Homicídios e Proteção à Pessoa (DHPP)',
            textAlign: TextAlign.center,
            style: PCPETypography.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: PCPEColors.darkGray,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Sistema de Registro de Atendimento em Local de Crime',
            textAlign: TextAlign.center,
            style: PCPETypography.bodySmall.copyWith(
              color: PCPEColors.mediumGray,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Desenvolvido pela DTI-UNISA — Unidade de Sistemas',
            textAlign: TextAlign.center,
            style: PCPETypography.labelSmall.copyWith(
              color: PCPEColors.lightGray,
            ),
          ),
          const SizedBox(height: 16),
          // Data/Hora de emissão e Protocolo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Emitido em: $dataEmissao às $horaEmissao',
                style: PCPETypography.bodySmall.copyWith(
                  color: PCPEColors.darkGray,
                ),
              ),
              const SizedBox(width: 24),
              Text(
                'Protocolo: ${data.numeroProtocolo}',
                style: PCPETypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: PCPEColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Seção: Identificação
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSecaoIdentificacao() {
    return _buildSecaoContainer(
      titulo: 'IDENTIFICAÇÃO DA OCORRÊNCIA',
      children: [
        _buildCampo('Número do Protocolo', data.numeroProtocolo),
        _buildCampo('Número do BO',
            data.numeroBO.isNotEmpty ? data.numeroBO : 'Não informado'),
        _buildCampo(
            'Data',
            data.dataOcorrencia != null
                ? '${data.dataOcorrencia!.day.toString().padLeft(2, '0')}/${data.dataOcorrencia!.month.toString().padLeft(2, '0')}/${data.dataOcorrencia!.year}'
                : 'Não informada'),
        _buildCampo(
            'Hora',
            data.horaOcorrencia != null
                ? '${data.horaOcorrencia!.hour.toString().padLeft(2, '0')}:${data.horaOcorrencia!.minute.toString().padLeft(2, '0')}'
                : 'Não informada'),
        _buildCampo('Natureza', data.natureza),
        _buildCampo('Tipo da Ocorrência', data.tipoOcorrencia),
        _buildCampo('Unidade Responsável',
            data.unidadeResponsavel.isNotEmpty ? data.unidadeResponsavel : 'Não informada'),
        _buildCampo('Equipe Responsável', data.equipeResponsavel),
        _buildCampo('Prioridade', data.prioridade),
        _buildCampo('Status', data.status),
        if (data.numeroInquerito.isNotEmpty)
          _buildCampo('Nº Inquérito', data.numeroInquerito),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Seção: Local do Crime
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSecaoLocalCrime() {
    return _buildSecaoContainer(
      titulo: 'LOCAL DO CRIME',
      children: [
        _buildCampo('UF', data.uf),
        _buildCampo('Município',
            data.municipio.isNotEmpty ? data.municipio : 'Não informado'),
        _buildCampo(
            'Bairro', data.bairro.isNotEmpty ? data.bairro : 'Não informado'),
        _buildCampo('Logradouro',
            data.logradouro.isNotEmpty ? data.logradouro : 'Não informado'),
        _buildCampo('Número',
            data.numero.isNotEmpty ? data.numero : 'S/N'),
        _buildCampo(
            'Complemento', data.complemento.isNotEmpty ? data.complemento : '—'),
        _buildCampo('CEP', data.cep.isNotEmpty ? data.cep : '—'),
        _buildCampo('Ponto de Referência',
            data.pontoReferencia.isNotEmpty ? data.pontoReferencia : '—'),
        _buildCampo(
            'Coordenadas',
            data.gpsCapturado
                ? '${data.latitude}, ${data.longitude}'
                : 'GPS não capturado'),
        _buildCampo('Fotos do Local',
            '${data.midiasLocal.length} fotografia(s)'),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Seção: Pessoas Envolvidas
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSecaoPessoas() {
    if (data.pessoas.isEmpty) {
      return _buildSecaoContainer(
        titulo: 'PESSOAS ENVOLVIDAS',
        children: [
          _buildTextoVazio('Nenhuma pessoa cadastrada.'),
        ],
      );
    }

    final vitimas = data.pessoas.where((p) => p.tipo == 'Vítima').toList();
    final suspeitos = data.pessoas.where((p) => p.tipo == 'Suspeito').toList();
    final testemunhas =
        data.pessoas.where((p) => p.tipo == 'Testemunha').toList();
    final noticiantes =
        data.pessoas.where((p) => p.tipo == 'Noticiante').toList();

    final List<Widget> categorias = [];

    if (vitimas.isNotEmpty) {
      categorias.add(_buildSubSecaoPessoas('VÍTIMAS', vitimas, isVitima: true));
    }
    if (suspeitos.isNotEmpty) {
      categorias
          .add(_buildSubSecaoPessoas('SUSPEITOS', suspeitos));
    }
    if (testemunhas.isNotEmpty) {
      categorias
          .add(_buildSubSecaoPessoas('TESTEMUNHAS', testemunhas));
    }
    if (noticiantes.isNotEmpty) {
      categorias
          .add(_buildSubSecaoPessoas('NOTICIANTES', noticiantes));
    }

    return _buildSecaoContainer(
      titulo: 'PESSOAS ENVOLVIDAS',
      children: categorias,
    );
  }

  Widget _buildSubSecaoPessoas(String categoria, List<PessoaEnvolvida> pessoas,
      {bool isVitima = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da subcategoria
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: BoxDecoration(
              color: PCPEColors.cardGray,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              categoria,
              style: PCPETypography.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: PCPEColors.darkGray,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...pessoas.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final p = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: PCPEColors.surfaceGray),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$idx. ${p.nome.isNotEmpty ? p.nome : '(sem nome)'}',
                        style: PCPETypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: PCPEColors.black,
                        ),
                      ),
                      if (p.midias.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.photo_camera,
                            size: 14,
                            color: PCPEColors.primary.withValues(alpha: 0.7)),
                        const SizedBox(width: 2),
                        Text(
                          '${p.midias.length}',
                          style: PCPETypography.bodySmall.copyWith(
                            color: PCPEColors.primary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildLinhaInfo('CPF',
                      p.cpf.isNotEmpty ? p.cpf : 'Não informado'),
                  if (isVitima)
                    _buildLinhaInfo(
                        'NIC', p.nic.isNotEmpty ? p.nic : 'Não informado'),
                  _buildLinhaInfo('Endereço',
                      p.endereco.isNotEmpty ? p.endereco : 'Não informado'),
                  _buildLinhaInfo('Telefone',
                      p.telefone.isNotEmpty ? p.telefone : 'Não informado'),
                  if (p.dataNascimento != null)
                    _buildLinhaInfo(
                        'Data de Nascimento',
                        '${p.dataNascimento!.day.toString().padLeft(2, '0')}/${p.dataNascimento!.month.toString().padLeft(2, '0')}/${p.dataNascimento!.year}'),
                  if (p.observacoes.isNotEmpty)
                    _buildLinhaInfo('Observações', p.observacoes),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Seção: Veículos
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSecaoVeiculos() {
    if (data.veiculos.isEmpty) {
      return _buildSecaoContainer(
        titulo: 'VEÍCULOS',
        children: [
          _buildTextoVazio('Nenhum veículo cadastrado.'),
        ],
      );
    }

    return _buildSecaoContainer(
      titulo: 'VEÍCULOS',
      children: data.veiculos.asMap().entries.map((entry) {
        final idx = entry.key + 1;
        final v = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: PCPEColors.surfaceGray),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_car,
                      size: 16, color: PCPEColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$idx. ${v.marca.isNotEmpty ? v.marca : '—'} ${v.modelo.isNotEmpty ? v.modelo : '—'}',
                      style: PCPETypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: PCPEColors.black,
                      ),
                    ),
                  ),
                  if (v.midias.isNotEmpty) ...[
                    Icon(Icons.photo_camera,
                        size: 14,
                        color: PCPEColors.primary.withValues(alpha: 0.7)),
                    const SizedBox(width: 2),
                    Text(
                      '${v.midias.length}',
                      style: PCPETypography.bodySmall.copyWith(
                        color: PCPEColors.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              _buildLinhaInfo(
                  'Placa', v.placa.isNotEmpty ? v.placa : 'Não informada'),
              _buildLinhaInfo('Cor', v.cor.isNotEmpty ? v.cor : 'Não informada'),
              _buildLinhaInfo(
                  'Ano', v.ano.isNotEmpty ? v.ano : 'Não informado'),
              _buildLinhaInfo('Situação', v.situacao),
              if (v.observacoes.isNotEmpty)
                _buildLinhaInfo('Observações', v.observacoes),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Seção: Objetos
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSecaoObjetos() {
    if (data.objetos.isEmpty) {
      return _buildSecaoContainer(
        titulo: 'OBJETOS',
        children: [
          _buildTextoVazio('Nenhum objeto cadastrado.'),
        ],
      );
    }

    return _buildSecaoContainer(
      titulo: 'OBJETOS',
      children: data.objetos.asMap().entries.map((entry) {
        final idx = entry.key + 1;
        final o = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: PCPEColors.surfaceGray),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.inventory_2,
                      size: 16, color: PCPEColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$idx. ${o.descricao.isNotEmpty ? o.descricao : '(sem descrição)'}',
                      style: PCPETypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: PCPEColors.black,
                      ),
                    ),
                  ),
                  if (o.midias.isNotEmpty) ...[
                    Icon(Icons.photo_camera,
                        size: 14,
                        color: PCPEColors.primary.withValues(alpha: 0.7)),
                    const SizedBox(width: 2),
                    Text(
                      '${o.midias.length}',
                      style: PCPETypography.bodySmall.copyWith(
                        color: PCPEColors.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              _buildLinhaInfo('Categoria',
                  o.categoria.isNotEmpty ? o.categoria : 'Não informada'),
              _buildLinhaInfo('Quantidade', '${o.quantidade}'),
              _buildLinhaInfo('Situação', o.situacao),
              if (o.observacoes.isNotEmpty)
                _buildLinhaInfo('Observações', o.observacoes),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Seção: Vestígios
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSecaoVestigios() {
    if (data.vestigios.isEmpty) {
      return _buildSecaoContainer(
        titulo: 'VESTÍGIOS',
        children: [
          _buildTextoVazio('Nenhum vestígio cadastrado.'),
        ],
      );
    }

    return _buildSecaoContainer(
      titulo: 'VESTÍGIOS',
      children: data.vestigios.asMap().entries.map((entry) {
        final idx = entry.key + 1;
        final v = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: PCPEColors.surfaceGray),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    v.coletado ? Icons.check_circle : Icons.pending,
                    size: 16,
                    color: v.coletado ? PCPEColors.success : PCPEColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$idx. ${v.descricao.isNotEmpty ? v.descricao : '(sem descrição)'}',
                      style: PCPETypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: PCPEColors.black,
                      ),
                    ),
                  ),
                  if (v.midias.isNotEmpty) ...[
                    Icon(Icons.photo_camera,
                        size: 14,
                        color: PCPEColors.primary.withValues(alpha: 0.7)),
                    const SizedBox(width: 2),
                    Text(
                      '${v.midias.length}',
                      style: PCPETypography.bodySmall.copyWith(
                        color: PCPEColors.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              _buildLinhaInfo(
                  'Tipo', v.tipo.isNotEmpty ? v.tipo : 'Não informado'),
              _buildLinhaInfo('Localização',
                  v.localizacao.isNotEmpty ? v.localizacao : 'Não informada'),
              _buildLinhaInfo(
                  'Coletado', v.coletado ? 'Sim' : 'Não'),
              _buildLinhaInfo('Responsável',
                  v.responsavel.isNotEmpty ? v.responsavel : 'Não informado'),
              if (v.observacoes.isNotEmpty)
                _buildLinhaInfo('Observações', v.observacoes),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Seção: Fotografias
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSecaoFotografias() {
    final Map<String, List<MediaItem>> fotosOrganizadas = {};

    // Fotos do Local
    if (data.midiasLocal.any((m) => m.type == MediaType.photo)) {
      fotosOrganizadas['Fotos do Local'] =
          data.midiasLocal.where((m) => m.type == MediaType.photo).toList();
    }

    // Fotos das Pessoas
    final fotosPessoas = <MediaItem>[];
    for (final p in data.pessoas) {
      fotosPessoas.addAll(p.midias.where((m) => m.type == MediaType.photo));
    }
    if (fotosPessoas.isNotEmpty) {
      fotosOrganizadas['Fotos das Pessoas'] = fotosPessoas;
    }

    // Fotos dos Veículos
    final fotosVeiculos = <MediaItem>[];
    for (final v in data.veiculos) {
      fotosVeiculos.addAll(v.midias.where((m) => m.type == MediaType.photo));
    }
    if (fotosVeiculos.isNotEmpty) {
      fotosOrganizadas['Fotos dos Veículos'] = fotosVeiculos;
    }

    // Fotos dos Objetos
    final fotosObjetos = <MediaItem>[];
    for (final o in data.objetos) {
      fotosObjetos.addAll(o.midias.where((m) => m.type == MediaType.photo));
    }
    if (fotosObjetos.isNotEmpty) {
      fotosOrganizadas['Fotos dos Objetos'] = fotosObjetos;
    }

    // Fotos dos Vestígios
    final fotosVestigios = <MediaItem>[];
    for (final v in data.vestigios) {
      fotosVestigios.addAll(v.midias.where((m) => m.type == MediaType.photo));
    }
    if (fotosVestigios.isNotEmpty) {
      fotosOrganizadas['Fotos dos Vestígios'] = fotosVestigios;
    }

    if (fotosOrganizadas.isEmpty) {
      return _buildSecaoContainer(
        titulo: 'FOTOGRAFIAS',
        children: [
          _buildTextoVazio('Nenhuma fotografia registrada.'),
        ],
      );
    }

    final List<Widget> categoriasFotos = [];
    for (final entry in fotosOrganizadas.entries) {
      categoriasFotos.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da categoria
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: PCPEColors.cardGray,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  entry.key.toUpperCase(),
                  style: PCPETypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: PCPEColors.darkGray,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Galeria de miniaturas
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.value.map((media) {
                  return _buildThumbnail(media);
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }

    return _buildSecaoContainer(
      titulo: 'FOTOGRAFIAS',
      children: categoriasFotos,
    );
  }

  /// Miniatura proporcional que representa como a foto aparecerá no PDF.
  Widget _buildThumbnail(MediaItem media) {
    return Container(
      width: 120,
      height: 90,
      decoration: BoxDecoration(
        color: media.placeholderColor.withValues(alpha: 0.15),
        border: Border.all(color: PCPEColors.surfaceGray),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: 28,
            color: media.placeholderColor.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              media.legenda.isNotEmpty ? media.legenda : 'Foto ${media.id}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: PCPETypography.labelSmall.copyWith(
                color: media.placeholderColor.withValues(alpha: 0.8),
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Seção: Narrativa
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSecaoNarrativa() {
    final List<Widget> children = [];

    // Texto da narrativa
    if (data.narrativa.isNotEmpty) {
      children.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: PCPEColors.surfaceGray),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            data.narrativa,
            style: PCPETypography.bodyMedium.copyWith(
              height: 1.6,
              color: PCPEColors.black,
            ),
          ),
        ),
      );
    } else {
      children.add(
        _buildTextoVazio('Narrativa não preenchida.'),
      );
    }


    // Observações
    if (data.observacoesGerais.isNotEmpty) {
      children.add(const SizedBox(height: 12));
      children.add(_buildSubTitulo('Observações Complementares'));
      children.add(const SizedBox(height: 6));
      children.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: PCPEColors.surfaceGray),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            data.observacoesGerais,
            style: PCPETypography.bodyMedium.copyWith(
              height: 1.6,
              color: PCPEColors.darkGray,
            ),
          ),
        ),
      );
    }

    // Providências
    if (data.providenciasAdotadas.isNotEmpty) {
      children.add(const SizedBox(height: 12));
      children.add(_buildSubTitulo('Providências Adotadas'));
      children.add(const SizedBox(height: 6));
      children.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: PCPEColors.surfaceGray),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            data.providenciasAdotadas,
            style: PCPETypography.bodyMedium.copyWith(
              height: 1.6,
              color: PCPEColors.darkGray,
            ),
          ),
        ),
      );
    }

    return _buildSecaoContainer(
      titulo: 'NARRATIVA DO FATO',
      children: children,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Rodapé Institucional
  // ═══════════════════════════════════════════════════════════════

  Widget _buildRodape() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
      child: Column(
        children: [
          // Linha separadora
          Container(
            height: 1,
            color: PCPEColors.surfaceGray,
          ),
          const SizedBox(height: 12),
          Text(
            'Documento gerado pelo Sistema de Registro de Atendimento em Local de Crime',
            textAlign: TextAlign.center,
            style: PCPETypography.labelSmall.copyWith(
              color: PCPEColors.lightGray,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Polícia Civil de Pernambuco',
            textAlign: TextAlign.center,
            style: PCPETypography.labelSmall.copyWith(
              fontWeight: FontWeight.w500,
              color: PCPEColors.mediumGray,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'DTI-UNISA — Unidade de Sistemas',
            textAlign: TextAlign.center,
            style: PCPETypography.labelSmall.copyWith(
              color: PCPEColors.lightGray,
            ),
          ),
          const SizedBox(height: 10),
          // Número da página (placeholder para paginação futura)
          Text(
            'Página 1',
            textAlign: TextAlign.center,
            style: PCPETypography.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: PCPEColors.darkGray,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Widgets auxiliares de layout
  // ═══════════════════════════════════════════════════════════════

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: PCPEColors.surfaceGray,
    );
  }

  Widget _buildSecaoContainer({
    required String titulo,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção
          Text(
            titulo,
            style: PCPETypography.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: PCPEColors.black,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 2,
            color: PCPEColors.primary,
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCampo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              '$label:',
              style: PCPETypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: PCPEColors.darkGray,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: PCPETypography.bodyMedium.copyWith(
                color: PCPEColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinhaInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: PCPETypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: PCPEColors.darkGray,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: PCPETypography.bodySmall.copyWith(
                color: PCPEColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTitulo(String texto) {
    return Text(
      texto,
      style: PCPETypography.bodySmall.copyWith(
        fontWeight: FontWeight.w700,
        color: PCPEColors.darkGray,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextoVazio(String texto) {
    return Text(
      texto,
      style: PCPETypography.bodyMedium.copyWith(
        fontStyle: FontStyle.italic,
        color: PCPEColors.mediumGray,
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════
// Botão da barra de ações
// ═════════════════════════════════════════════════════════════════

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final bool outlined;
  final bool primary;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.outlined = false,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (primary) {
      return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          label: Text(label, style: const TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: PCPEColors.primary,
            foregroundColor: PCPEColors.pureWhite,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 0,
          ),
        ),
      );
    }

    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        style: OutlinedButton.styleFrom(
          foregroundColor: PCPEColors.darkGray,
          side: const BorderSide(color: PCPEColors.surfaceGray),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: PCPEColors.darkGray),
      label: Text(label,
          style: const TextStyle(
              fontSize: 12,
              color: PCPEColors.darkGray,
              fontWeight: FontWeight.w500)),
      style: TextButton.styleFrom(
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}