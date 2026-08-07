import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/pcpe_status_chip.dart';
import 'ocorrencia_wizard_data.dart';

enum StatusOcorrencia { rascunho, concluida, aSincronizar, enviadaSpp }

/// Etapa 9: Finalizacao (F40).
///
/// Fluxo completo: Rascunho → Concluida → A sincronizar → Enviada ao SPP.
class Step9Finalizacao extends StatefulWidget {
  final OcorrenciaWizardData data;
  const Step9Finalizacao({super.key, required this.data});
  @override State<Step9Finalizacao> createState() => _Step9FinalizacaoState();
}

class _Step9FinalizacaoState extends State<Step9Finalizacao> {
  StatusOcorrencia _status = StatusOcorrencia.concluida;
  bool _sincronizando = false;
  bool _enviando = false;

  static const _rotulos = {
    StatusOcorrencia.rascunho: 'Rascunho',
    StatusOcorrencia.concluida: 'Concluída',
    StatusOcorrencia.aSincronizar: 'A sincronizar',
    StatusOcorrencia.enviadaSpp: 'Enviada ao SPP',
  };

  @override Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: 24),
      // Icone de sucesso
      Container(width: 100, height: 100, alignment: Alignment.center, decoration: BoxDecoration(color: PCPEColors.successLight, shape: BoxShape.circle), child: Icon(_status == StatusOcorrencia.enviadaSpp ? Icons.check_circle : Icons.check_circle_outline, size: 56, color: _status == StatusOcorrencia.enviadaSpp ? PCPEColors.success : PCPEColors.mediumGray)),
      const SizedBox(height: 28),
      Text(_status == StatusOcorrencia.enviadaSpp ? 'Ocorrência Enviada\ncom Sucesso' : 'Ocorrência Registrada\ncom Sucesso', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: PCPEColors.black, height: 1.3)),
      const SizedBox(height: 12),
      Text('Protocolo: ${widget.data.numeroProtocolo}', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: PCPEColors.darkGray.withValues(alpha: 0.8))),
      const SizedBox(height: 8),
      // Status chip
      Center(child: PCPEStatusChip(status: _statusPcpe())),
      const SizedBox(height: 28),
      // Card de informacoes
      PCPECard(child: Column(children: [
        _detail(Icons.calendar_today, 'Data', _data()), const Divider(height: 24, color: PCPEColors.surfaceGray),
        _detail(Icons.access_time, 'Hora', _hora()), const Divider(height: 24, color: PCPEColors.surfaceGray),
        _detail(Icons.groups, 'Equipe', widget.data.equipeResponsavel), const Divider(height: 24, color: PCPEColors.surfaceGray),
        _detail(Icons.person, 'Responsavel', 'Ag. Fabio Fernandes'),
      ])),
      const SizedBox(height: 32),
      // Acoes conforme status
      ..._acoes(context),
      const SizedBox(height: 32),
    ]));
  }

  List<Widget> _acoes(BuildContext ctx) {
    switch (_status) {
      case StatusOcorrencia.concluida:
        return [
          PCPEButton(label: 'Sincronizar Ocorrência', icon: Icons.sync, fullWidth: true, height: 52, onPressed: _sincronizando ? null : _sincronizar),
          const SizedBox(height: 12),
          PCPEButton(label: 'Enviar ao SPP', icon: Icons.send_outlined, fullWidth: true, height: 52, backgroundColor: PCPEColors.primary, foregroundColor: PCPEColors.pureWhite, onPressed: _enviando ? null : _enviarSpp),
          const SizedBox(height: 12),
          PCPEButton(label: 'Gerar PDF', icon: Icons.picture_as_pdf_outlined, fullWidth: true, height: 52, outlined: true, onPressed: () => _mock(ctx, 'Gerar PDF')),
          const SizedBox(height: 12),
          PCPEButton(label: 'Imprimir', icon: Icons.print, fullWidth: true, height: 52, outlined: true, onPressed: () => _mock(ctx, 'Imprimir')),
          const SizedBox(height: 24), const Divider(color: PCPEColors.surfaceGray), const SizedBox(height: 16),
          PCPEButton(label: 'Nova Ocorrência', icon: Icons.add, fullWidth: true, outlined: true, height: 52, onPressed: () => ctx.go('/nova-ocorrencia')),
        ];
      case StatusOcorrencia.aSincronizar:
        return [
          if (_sincronizando) const Center(child: CircularProgressIndicator(color: PCPEColors.primary)) else ...[
            PCPEButton(label: 'Sincronizar Agora', icon: Icons.sync, fullWidth: true, height: 52, backgroundColor: PCPEColors.primary, foregroundColor: PCPEColors.pureWhite, onPressed: _sincronizar),
          ],
          const SizedBox(height: 12),
          PCPEButton(label: 'Gerar PDF', icon: Icons.picture_as_pdf_outlined, fullWidth: true, height: 52, outlined: true, onPressed: () => _mock(ctx, 'Gerar PDF')),
          const SizedBox(height: 24), const Divider(color: PCPEColors.surfaceGray), const SizedBox(height: 16),
          PCPEButton(label: 'Nova Ocorrência', icon: Icons.add, fullWidth: true, outlined: true, height: 52, onPressed: () => ctx.go('/nova-ocorrencia')),
        ];
      case StatusOcorrencia.enviadaSpp:
        return [
          PCPEButton(label: 'Gerar PDF', icon: Icons.picture_as_pdf_outlined, fullWidth: true, height: 52, outlined: true, onPressed: () => _mock(ctx, 'Gerar PDF')),
          const SizedBox(height: 12),
          PCPEButton(label: 'Imprimir', icon: Icons.print, fullWidth: true, height: 52, outlined: true, onPressed: () => _mock(ctx, 'Imprimir')),
          const SizedBox(height: 24), const Divider(color: PCPEColors.surfaceGray), const SizedBox(height: 16),
          PCPEButton(label: 'Nova Ocorrência', icon: Icons.add, fullWidth: true, outlined: true, height: 52, onPressed: () => ctx.go('/nova-ocorrencia')),
        ];
      case StatusOcorrencia.rascunho:
        return [];
    }
  }

  void _sincronizar() {
    setState(() => _sincronizando = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() { _sincronizando = false; _status = StatusOcorrencia.enviadaSpp; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sincronização concluída com sucesso.'), backgroundColor: PCPEColors.success, behavior: SnackBarBehavior.floating));
    });
  }

  void _enviarSpp() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: PCPEColors.pureWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Text('Enviar ao SPP?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: const Text('O PDF oficial será enviado ao Sistema de Procedimentos Policiais. Deseja continuar?', style: TextStyle(fontSize: 13)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: PCPEColors.darkGray))),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: PCPEColors.primary, foregroundColor: PCPEColors.pureWhite), onPressed: () { Navigator.pop(ctx); _executarEnvio(); }, child: const Text('Confirmar Envio')),
      ],
    ));
  }

  void _executarEnvio() {
    setState(() => _enviando = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() { _enviando = false; _status = StatusOcorrencia.enviadaSpp; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ocorrência enviada ao SPP com sucesso.'), backgroundColor: PCPEColors.success, behavior: SnackBarBehavior.floating));
    });
  }

  PCPEStatus _statusPcpe() {
    switch (_status) { case StatusOcorrencia.concluida: return PCPEStatus.concluido; case StatusOcorrencia.aSincronizar: return PCPEStatus.enviadoSpp; case StatusOcorrencia.enviadaSpp: return PCPEStatus.enviadoSpp; default: return PCPEStatus.emAndamento; }
  }

  String _data() { final d = DateTime.now(); return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}'; }
  String _hora() { final d = DateTime.now(); return '${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}'; }

  Widget _detail(IconData icon, String label, String value) => Row(children: [
    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: PCPEColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18, color: PCPEColors.primary)),
    const SizedBox(width: 14),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.mediumGray)), const SizedBox(height: 2), Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PCPEColors.black))]),
  ]);

  void _mock(BuildContext ctx, String a) => ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('$a (simulado).'), backgroundColor: PCPEColors.darkGray, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
}