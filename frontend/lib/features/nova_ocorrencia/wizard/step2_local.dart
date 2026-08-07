import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import '../../../shared/widgets/media_capture_section.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 2: Local do Crime (F32).
///
/// GPS como ação principal. Fotografias reposicionadas próximo ao topo.
/// Campos preenchidos automaticamente sempre que possível.
class Step2LocalCrime extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;
  const Step2LocalCrime({super.key, required this.data, required this.onChanged});
  @override
  State<Step2LocalCrime> createState() => _Step2LocalCrimeState();
}

class _Step2LocalCrimeState extends State<Step2LocalCrime> {
  String get _gpsTexto => widget.data.gpsCapturado ? '${widget.data.latitude}, ${widget.data.longitude}' : 'GPS nao disponivel';

  void _capturarGPS() {
    widget.data.simularCapturaGPS();
    // Auto-preencher dados a partir do GPS simulado
    if (!widget.data.gpsCapturado) return;
    if (widget.data.uf.isEmpty) widget.data.uf = 'PE';
    if (widget.data.municipio.isEmpty) widget.data.municipio = 'Recife';
    if (widget.data.bairro.isEmpty) widget.data.bairro = 'Boa Viagem';
    if (widget.data.logradouro.isEmpty) widget.data.logradouro = 'Av. Conselheiro Aguiar';
    if (widget.data.cep.isEmpty) widget.data.cep = '51021-000';
    widget.onChanged();
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [const Icon(Icons.check_circle, color: PCPEColors.pureWhite, size: 18), const SizedBox(width: 10), Text('GPS capturado: ${widget.data.latitude}, ${widget.data.longitude}', style: const TextStyle(fontSize: 13))]),
      backgroundColor: PCPEColors.success, behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // ── 1. CAPTURAR LOCALIZAÇÃO (ação principal) ──────────
        PCPECard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PCPESectionTitle(title: 'Capturar Localizacao', icon: Icons.gps_fixed, subtitle: 'Acao principal da etapa. Obtenha coordenadas GPS do local.'),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: PCPEInput(label: 'Latitude', hint: '-8.0476...', prefixIcon: Icons.arrow_upward, controller: TextEditingController(text: widget.data.latitude), readOnly: true)),
              const SizedBox(width: 12),
              Expanded(child: PCPEInput(label: 'Longitude', hint: '-34.877...', prefixIcon: Icons.arrow_forward, controller: TextEditingController(text: widget.data.longitude), readOnly: true)),
            ]),
            const SizedBox(height: 14),
            PCPEButton(
              label: widget.data.gpsCapturado ? 'GPS Capturado' : 'Capturar GPS (Simulado)',
              icon: widget.data.gpsCapturado ? Icons.check_circle : Icons.gps_fixed,
              fullWidth: true,
              backgroundColor: widget.data.gpsCapturado ? PCPEColors.success : PCPEColors.primary,
              onPressed: _capturarGPS,
            ),
            if (widget.data.gpsCapturado) ...[
              const SizedBox(height: 8),
              Text('UF, municipio, bairro e logradouro preenchidos automaticamente.', style: TextStyle(fontSize: 10, color: PCPEColors.success, fontStyle: FontStyle.italic)),
            ],
          ]),
        ),
        const SizedBox(height: 12),
        // ── 2. FOTOGRAFIAS DO LOCAL (próximo ao topo) ─────────
        MediaCaptureSection(
          midias: widget.data.midiasLocal,
          onChanged: () => setState(() {}),
          title: 'Fotografias do Local',
          icon: Icons.photo_camera_outlined,
          subtitle: 'Visao geral, fachada, acesso, ambiente, perimetro',
          gpsTexto: _gpsTexto,
        ),
        const SizedBox(height: 12),
        // ── 3. ENDEREÇO (dados preenchidos automaticamente) ────
        PCPECard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PCPESectionTitle(title: 'Endereco do Local', icon: Icons.home_outlined, subtitle: 'Preenchido automaticamente. Confira e complemente.'),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(flex: 2, child: PCPEInput(label: 'UF', hint: 'PE', prefixIcon: Icons.map, controller: TextEditingController(text: widget.data.uf), onChanged: (v) { widget.data.uf = v; widget.onChanged(); })),
              const SizedBox(width: 12),
              Expanded(flex: 5, child: PCPEInput(label: 'Municipio', hint: 'Municipio', prefixIcon: Icons.location_city, controller: TextEditingController(text: widget.data.municipio), onChanged: (v) { widget.data.municipio = v; widget.onChanged(); })),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: PCPEInput(label: 'Bairro', hint: 'Bairro', prefixIcon: Icons.location_on, controller: TextEditingController(text: widget.data.bairro), onChanged: (v) { widget.data.bairro = v; widget.onChanged(); })),
              const SizedBox(width: 12),
              Expanded(child: PCPEInput(label: 'CEP', hint: '00000-000', prefixIcon: Icons.mail_outline, controller: TextEditingController(text: widget.data.cep), onChanged: (v) { widget.data.cep = v; widget.onChanged(); })),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(flex: 4, child: PCPEInput(label: 'Logradouro', hint: 'Rua, Avenida...', prefixIcon: Icons.add_road, controller: TextEditingController(text: widget.data.logradouro), onChanged: (v) { widget.data.logradouro = v; widget.onChanged(); })),
              const SizedBox(width: 12),
              Expanded(child: PCPEInput(label: 'Numero', hint: 'Nº', controller: TextEditingController(text: widget.data.numero), onChanged: (v) { widget.data.numero = v; widget.onChanged(); })),
            ]),
            const SizedBox(height: 12),
            PCPEInput(label: 'Complemento', hint: 'Apartamento, Bloco...', prefixIcon: Icons.info_outline, controller: TextEditingController(text: widget.data.complemento), onChanged: (v) { widget.data.complemento = v; widget.onChanged(); }),
            const SizedBox(height: 12),
            PCPEInput(label: 'Ponto de Referencia', hint: 'Proximo ao...', prefixIcon: Icons.place_outlined, controller: TextEditingController(text: widget.data.pontoReferencia), onChanged: (v) { widget.data.pontoReferencia = v; widget.onChanged(); }),
          ]),
        ),
        const SizedBox(height: 12),
        // ── 4. MAPA ILUSTRATIVO ────────────────────────────────
        PCPECard(
          padding: const EdgeInsets.all(0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 0), child: PCPESectionTitle(title: 'Mapa Ilustrativo', icon: Icons.map_outlined)),
            const SizedBox(height: 16),
            Container(
              height: 200, decoration: BoxDecoration(color: PCPEColors.surfaceGray, border: Border(top: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.3)), bottom: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.3)))),
              child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: PCPEColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.location_on, size: 48, color: PCPEColors.primary)),
                const SizedBox(height: 16),
                const Text('Mapa Indisponivel\nModo Simulacao', textAlign: TextAlign.center, style: TextStyle(color: PCPEColors.mediumGray, fontSize: 14, height: 1.5)),
                if (widget.data.latitude.isNotEmpty) ...[const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: PCPEColors.successLight, borderRadius: BorderRadius.circular(8)), child: Text('${widget.data.latitude}, ${widget.data.longitude}', style: const TextStyle(color: PCPEColors.success, fontSize: 12, fontWeight: FontWeight.w600)))],
              ])),
            ),
          ]),
        ),
        const SizedBox(height: 24),
      ]),
    );
  }
}