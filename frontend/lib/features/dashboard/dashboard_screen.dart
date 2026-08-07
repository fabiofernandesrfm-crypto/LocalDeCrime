import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_section_title.dart';
import '../../shared/widgets/pcpe_statistic_card.dart';
import '../../shared/widgets/pcpe_status_chip.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_avatar.dart';

/// Dashboard Operacional — Usuario de Campo (F37).
///
/// Foco exclusivo em:
/// • O que tenho pendente?
/// • O que preciso concluir?
/// • O que precisa sincronizar?
/// • Quais sao as ocorrencias recentes da minha Unidade?
///
/// Componentes gerenciais (graficos, mapa, BI) preservados para o perfil MANAGER.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  /// Dados mock de pendencias — substitutivel por repository
  static const _pendencias = [
    {'protocolo': 'PCPE-2026-817115', 'natureza': 'Latrocínio', 'municipio': 'Jaboatão dos Guararapes', 'bairro': 'Piedade', 'data': '05/08', 'hora': '22:40', 'vitima': 'Carlos Eduardo', 'status': 'Rascunho', 'alteracao': '1 hora'},
    {'protocolo': 'PCPE-2026-817109', 'natureza': 'Morte Violenta a Esclarecer', 'municipio': 'Camaragibe', 'bairro': 'Aldeia', 'data': '05/08', 'hora': '11:00', 'vitima': 'Pedro Lima', 'status': 'A sincronizar', 'alteracao': '5 horas'},
    {'protocolo': 'PCPE-2026-817103', 'natureza': 'Feminicídio', 'municipio': 'Recife', 'bairro': 'Imbiribeira', 'data': '04/08', 'hora': '15:45', 'vitima': 'Juliana Costa', 'status': 'Rascunho', 'alteracao': '8 horas'},
    {'protocolo': 'PCPE-2026-817097', 'natureza': 'Homicídio Doloso', 'municipio': 'Recife', 'bairro': 'Casa Amarela', 'data': '03/08', 'hora': '23:55', 'vitima': 'Fabio Fernandes', 'status': 'A sincronizar', 'alteracao': '1 dia'},
  ];

  static const _recentes = [
    {'protocolo': 'PCPE-2026-817120', 'natureza': 'Homicídio Doloso Consumado', 'municipio': 'Recife', 'bairro': 'Boa Viagem', 'data': '06/08', 'hora': '14:35', 'vitima': 'João da Silva', 'status': 'Concluída'},
    {'protocolo': 'PCPE-2026-817118', 'natureza': 'Feminicídio', 'municipio': 'Olinda', 'bairro': 'Bairro Novo', 'data': '06/08', 'hora': '09:10', 'vitima': 'Maria Oliveira', 'status': 'A sincronizar'},
    {'protocolo': 'PCPE-2026-817112', 'natureza': 'Homicídio Doloso Tentado', 'municipio': 'Paulista', 'bairro': 'Janga', 'data': '05/08', 'hora': '18:15', 'vitima': 'Ana Beatriz', 'status': 'Concluída'},
    {'protocolo': 'PCPE-2026-817106', 'natureza': 'Homicídio Doloso Consumado', 'municipio': 'São Lourenço da Mata', 'bairro': 'Centro', 'data': '04/08', 'hora': '20:30', 'vitima': 'Marcos Vinícius', 'status': 'Concluída'},
    {'protocolo': 'PCPE-2026-817100', 'natureza': 'Latrocínio', 'municipio': 'Olinda', 'bairro': 'Rio Doce', 'data': '04/08', 'hora': '08:20', 'vitima': 'Roberto Alves', 'status': 'Concluída'},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: AppBar(
        backgroundColor: PCPEColors.pureWhite,
        elevation: 0,
        toolbarHeight: 56,
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: PCPEColors.black)),
          Text('Ambiente Operacional', style: TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
        ]),
        actions: [
          IconButton(icon: const Badge(smallSize: 8, child: Icon(Icons.notifications_outlined, color: PCPEColors.darkGray)), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Agente ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PCPECard(padding: const EdgeInsets.all(0), showBorder: false, child: Container(
              decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1B1B1B), Color(0xFF2D2D2D)]), borderRadius: BorderRadius.all(Radius.circular(14))),
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                const PCPEAvatar(name: 'Fabio Fernandes dos Santos', size: 52, showBadge: true, backgroundColor: PCPEColors.pureWhite),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Ag. Fabio Fernandes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: PCPEColors.pureWhite)),
                  const SizedBox(height: 2),
                  const Text('Agente de Polícia Civil', style: TextStyle(fontSize: 12, color: PCPEColors.primary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text('Unidade: DTI – UNISA', style: TextStyle(fontSize: 11, color: PCPEColors.pureWhite.withValues(alpha: 0.7))),
                ])),
              ]),
            )),
          ),
          const SizedBox(height: 16),

          // ── Cards Operacionais ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(builder: (context, constraints) {
              final w = constraints.maxWidth;
              final cols = w < 360 ? 1 : w < 600 ? 2 : 4;
              final sp = 8.0;
              final iw = (w - sp * (cols - 1)) / cols;
              return Wrap(spacing: sp, runSpacing: sp, children: [
                SizedBox(width: iw, child: PCPEStatisticCard(title: 'Registradas', value: '16', icon: Icons.folder_open, color: PCPEColors.primary, subtitle: 'Total de ocorrências', onTap: () => context.go('/ocorrencias'))),
                SizedBox(width: iw, child: PCPEStatisticCard(title: 'Rascunhos', value: '5', icon: Icons.edit_note, color: PCPEColors.mediumGray, subtitle: 'Aguardando conclusão', onTap: () => context.go('/ocorrencias', extra: {'status': 'Rascunhos'}))),
                SizedBox(width: iw, child: PCPEStatisticCard(title: 'Concluídas', value: '9', icon: Icons.check_circle_outline, color: PCPEColors.success, subtitle: 'Prontas para envio', onTap: () => context.go('/ocorrencias', extra: {'status': 'Concluídas'}))),
                SizedBox(width: iw, child: PCPEStatisticCard(title: 'A sincronizar', value: '3', icon: Icons.sync_problem, color: PCPEColors.warning, subtitle: 'Aguardando sinc.', onTap: () => context.go('/ocorrencias', extra: {'status': 'A sincronizar'}))),
              ]);
            }),
          ),
          const SizedBox(height: 16),

          // ── Ações Rápidas ───────────────────────────────────
          const PCPESectionTitle(title: 'Ações Rápidas', icon: Icons.flash_on, subtitle: 'Atalhos para as principais operações'),
          SizedBox(height: 92, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), children: [
            _qa(context, 'Nova Ocorrência', Icons.add_circle_outline, '/nova-ocorrencia'),
            _qa(context, 'Ocorrências', Icons.folder_outlined, '/ocorrencias', extra: null),
            _qa(context, 'Rascunhos', Icons.edit_note, '/ocorrencias', extra: {'status': 'Rascunhos'}),
            _qa(context, 'Sincronizar', Icons.sync, '/ocorrencias', extra: {'status': 'A sincronizar'}),
          ])),
          const SizedBox(height: 20),

          // ── Pendências ───────────────────────────────────────
          const PCPESectionTitle(title: 'Pendências', icon: Icons.pending_actions, subtitle: 'Registros que precisam de atenção'),
          const SizedBox(height: 8),
          ..._pendencias.map((p) => PCPECard(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['protocolo'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PCPEColors.black)),
                const SizedBox(height: 2),
                Text('${p['natureza']} — ${p['municipio']} • ${p['bairro']}', style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
                const SizedBox(height: 2),
                Text('Vítima: ${p['vitima']}  •  ${p['data']} ${p['hora']}  •  Atualizada há ${p['alteracao']}', style: const TextStyle(fontSize: 10, color: PCPEColors.lightGray)),
              ])),
              const SizedBox(width: 8),
              PCPEButton(label: p['status'] == 'Rascunho' ? 'Continuar' : 'Sincronizar', icon: p['status'] == 'Rascunho' ? Icons.edit : Icons.sync, small: true, height: 30, outlined: p['status'] != 'Rascunho', onPressed: () => context.go('/nova-ocorrencia')),
            ]),
          )),
          const SizedBox(height: 20),

          // ── Ocorrências Recentes da Unidade ──────────────────
          const PCPESectionTitle(title: 'Ocorrências Recentes da Unidade', icon: Icons.location_on, subtitle: 'Últimos registros da DTI – UNISA'),
          const SizedBox(height: 8),
          ..._recentes.map((r) => PCPECard(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(r['protocolo'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PCPEColors.black))),
                  PCPEStatusChip(status: _mapStatus(r['status'] as String)),
                ]),
                const SizedBox(height: 2),
                Text('${r['natureza']} — ${r['municipio']} • ${r['bairro']}', style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
                const SizedBox(height: 2),
                Text('Vítima: ${r['vitima']}  •  ${r['data']} ${r['hora']}', style: const TextStyle(fontSize: 10, color: PCPEColors.lightGray)),
              ])),
              const SizedBox(width: 8),
              PCPEButton(label: 'Visualizar', icon: Icons.visibility_outlined, small: true, height: 30, outlined: true, onPressed: () { context.go('/ocorrencias'); }),
            ]),
          )),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  PCPEStatus _mapStatus(String s) {
    switch (s) {
      case 'Rascunho': return PCPEStatus.rascunho;
      case 'A sincronizar': return PCPEStatus.enviadoSpp;
      case 'Concluída': return PCPEStatus.concluido;
      case 'Enviada ao SPP': return PCPEStatus.enviadoSpp;
      default: return PCPEStatus.emAndamento;
    }
  }

  /// Componentes gerenciais (gráfico, mapa, BI) preservados no código
  /// para futura reutilizacao no perfil MANAGER.
  static Widget _qa(BuildContext context, String label, IconData icon, String route, {Map<String, dynamic>? extra}) {
    return GestureDetector(
      onTap: () => context.go(route, extra: extra),
      child: Container(width: 88, margin: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(color: PCPEColors.pureWhite, borderRadius: BorderRadius.circular(12), border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: PCPEColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 22, color: PCPEColors.primary)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: PCPEColors.darkGray, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}