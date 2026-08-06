import 'dart:math';
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

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: PCPEHeader(
        title: 'Dashboard',
        subtitle: 'Visão geral do sistema',
        actions: [
          IconButton(
            icon: const Badge(smallSize: 8, child: Icon(Icons.notifications_outlined, color: PCPEColors.darkGray)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting + Agent Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PCPECard(
                padding: const EdgeInsets.all(0),
                showBorder: false,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1B1B1B),
                        Color(0xFF2D2D2D),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const PCPEAvatar(
                        name: 'Fabio Fernandes dos Santos',
                        size: 56,
                        showBadge: true,
                        backgroundColor: PCPEColors.pureWhite,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Agente Fabio Fernandes dos Santos',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: PCPEColors.pureWhite),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'DTI – UNISA • Em serviço',
                              style: TextStyle(fontSize: 13, color: PCPEColors.primary, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _buildMiniStat(Icons.cases_outlined, '12 ativos', PCPEColors.pureWhite),
                                const SizedBox(width: 16),
                                _buildMiniStat(Icons.check_circle_outline, '147 concluídos', PCPEColors.pureWhite),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Estatísticas principais com indicadores
            _buildStatisticsGrid(context, isMobile),
            const SizedBox(height: 20),

            // Ações Rápidas
            const PCPESectionTitle(
              title: 'Ações Rápidas',
              subtitle: 'Atalhos para as principais operações',
              icon: Icons.flash_on,
            ),
            SizedBox(
              height: 104,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildQuickAction(context, 'Nova Ocorrência', Icons.add_circle_outline, '/nova-ocorrencia'),
                  _buildQuickAction(context, 'Ocorrências', Icons.folder_outlined, '/ocorrencias'),
                  _buildQuickAction(context, 'Rascunhos', Icons.edit_note, '/ocorrencias'),
                  _buildQuickAction(context, 'Sincronizar', Icons.sync, '/sincronizacao'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Gráfico ilustrativo (placeholder)
            const PCPESectionTitle(
              title: 'Estatísticas',
              subtitle: 'Desempenho nos últimos 12 meses',
              icon: Icons.bar_chart,
            ),
            _buildChartPlaceholder(context),
            const SizedBox(height: 20),

            // Mapa ilustrativo (placeholder)
            const PCPESectionTitle(
              title: 'Mapa de Ocorrências',
              subtitle: 'Distribuição geográfica das investigações',
              icon: Icons.map_outlined,
            ),
            _buildMapPlaceholder(context),
            const SizedBox(height: 20),

            // Ocorrências Recentes + Atendimentos em Andamento
            _buildTwoColumnSection(context, isMobile),
            const SizedBox(height: 20),

            // Atividades Recentes
            const PCPESectionTitle(
              title: 'Atividades Recentes',
              subtitle: 'Últimas ações registradas no sistema',
              icon: Icons.history,
            ),
            ...List.generate(4, (i) => _buildActivityItem(i)),
            const SizedBox(height: 16),

            // Ver todos
            Center(
              child: PCPEButton(
                label: 'Ver Todas as Ocorrências',
                icon: Icons.arrow_forward,
                outlined: true,
                onPressed: () => context.go('/ocorrencias'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, bool isMobile) {
    final items = [
      {'title': 'Registradas', 'value': '1.247', 'icon': Icons.folder_open, 'color': PCPEColors.primary, 'subtitle': 'Total de ocorrências', 'route': '/ocorrencias'},
      {'title': 'Rascunhos', 'value': '23', 'icon': Icons.edit_note, 'color': PCPEColors.mediumGray, 'subtitle': 'Aguardando conclusão', 'route': '/ocorrencias'},
      {'title': 'Concluídas', 'value': '1.198', 'icon': Icons.check_circle_outline, 'color': PCPEColors.success, 'subtitle': 'PDF disponível', 'route': '/ocorrencias'},
      {'title': 'A sincronizar', 'value': '26', 'icon': Icons.sync_problem, 'color': PCPEColors.warning, 'subtitle': 'Aguardando envio ao SPP', 'route': '/ocorrencias'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width < 360 ? 1 : width < 600 ? 2 : 4;
          final spacing = 12.0;
          final totalSpacing = spacing * (crossAxisCount - 1);
          final itemWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: items.map((item) {
              return SizedBox(
                width: itemWidth,
                child: PCPEStatisticCard(
                  title: item['title'] as String,
                  value: item['value'] as String,
                  icon: item['icon'] as IconData,
                  color: item['color'] as Color?,
                  subtitle: item['subtitle'] as String?,
                  onTap: () => context.go(item['route'] as String),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.9), fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, IconData icon, String route) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: PCPEColors.pureWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: PCPEColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 24, color: PCPEColors.primary),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: PCPEColors.darkGray, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartPlaceholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PCPECard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _buildLegendDot(PCPEColors.mediumGray, 'Em Rascunho'),
                _buildLegendDot(PCPEColors.success, 'Concluídas'),
                _buildLegendDot(PCPEColors.warning, 'Aguard. Sinc.'),
                _buildLegendDot(PCPEColors.primary, 'Sincronizadas'),
              ],
            ),
            const SizedBox(height: 4),
            const Text('2026', style: TextStyle(fontSize: 12, color: PCPEColors.mediumGray, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: CustomPaint(
                size: const Size(double.infinity, 180),
                painter: _ChartPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: PCPEColors.darkGray)),
      ],
    );
  }

  Widget _buildMapPlaceholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PCPECard(
        padding: const EdgeInsets.all(0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: PCPEColors.primarySoft,
            ),
            child: Stack(
              children: [
                CustomPaint(size: const Size(double.infinity, 200), painter: _MapPlaceholderPainter()),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map, size: 48, color: PCPEColors.primary.withValues(alpha: 0.3)),
                      const SizedBox(height: 8),
                      Text(
                        'Mapa de Ocorrências',
                        style: TextStyle(fontSize: 14, color: PCPEColors.primary.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Visualização geográfica disponível em breve',
                        style: TextStyle(fontSize: 11, color: PCPEColors.primary.withValues(alpha: 0.3)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTwoColumnSection(BuildContext context, bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildOcorrenciasSection(context),
          const SizedBox(height: 20),
          _buildAtendimentosSection(context),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildOcorrenciasSection(context)),
          const SizedBox(width: 12),
          Expanded(child: _buildAtendimentosSection(context)),
        ],
      ),
    );
  }

  Widget _buildOcorrenciasSection(BuildContext context) {
    return PCPECard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: PCPEColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.folder_outlined, size: 16, color: PCPEColors.primary),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Últimas Ocorrências', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: PCPEColors.black)),
              ),
              TextButton(
                onPressed: () => context.go('/ocorrencias'),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('Ver todas', style: TextStyle(fontSize: 11, color: PCPEColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(4, (i) => _buildOcorrenciaItem(context, i)),
        ],
      ),
    );
  }

  Widget _buildAtendimentosSection(BuildContext context) {
    return PCPECard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: PCPEColors.darkGray.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.medical_services_outlined, size: 16, color: PCPEColors.darkGray),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Atendimentos em Andamento', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: PCPEColors.black)),
              ),
              TextButton(
                onPressed: () => context.go('/atendimentos'),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('Ver todas', style: TextStyle(fontSize: 11, color: PCPEColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(4, (i) => _buildAtendimentoItem(i)),
        ],
      ),
    );
  }

  Widget _buildOcorrenciaItem(BuildContext context, int index) {
    final statuses = [PCPEStatus.emAndamento, PCPEStatus.pendente, PCPEStatus.concluido, PCPEStatus.urgente];
    final titles = ['Roubo a residência - Boa Viagem', 'Homicídio doloso - Centro', 'Furto de veículo - Derby', 'Lesão corporal - Imbiribeira'];
    final dates = ['Hoje, 14:30', 'Hoje, 11:15', 'Ontem, 20:45', 'Ontem, 16:00'];
    final ids = ['OC-1247', 'OC-1246', 'OC-1245', 'OC-1244'];

    return InkWell(
      onTap: () => context.go('/ocorrencias'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 36,
              decoration: BoxDecoration(
                color: statuses[index].color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titles[index], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: PCPEColors.black)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(ids[index], style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text(dates[index], style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
                    ],
                  ),
                ],
              ),
            ),
            PCPEStatusChip(status: statuses[index], showIcon: false),
          ],
        ),
      ),
    );
  }

  Widget _buildAtendimentoItem(int index) {
    final tipos = ['Investigação Preliminar', 'Perícia Criminal', 'Análise Balística', 'Genética Forense'];
    final locais = ['Boa Viagem', 'DTI – UNISA', 'Derby', 'DEATH – Homicídios'];
    final statuses = [PCPEStatus.emAndamento, PCPEStatus.pendente, PCPEStatus.concluido, PCPEStatus.emAndamento];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: PCPEColors.darkGray.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.medical_services, size: 14, color: PCPEColors.darkGray),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tipos[index], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: PCPEColors.black)),
                Text(locais[index], style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
              ],
            ),
          ),
          PCPEStatusChip(status: statuses[index], showIcon: false),
        ],
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final icons = [Icons.add_circle_outline, Icons.edit, Icons.check_circle_outline, Icons.sync];
    final titles = ['Nova ocorrência registrada', 'Atendimento atualizado', 'Perícia concluída', 'Dados sincronizados'];
    final subtitles = ['OC-1247 • Roubo a residência', 'Atendimento #3892 • Investigação', 'OC-1245 • Furto de veículo', '12 registros enviados ao servidor'];
    final times = ['Há 15 min', 'Há 2 horas', 'Há 4 horas', 'Há 6 horas'];
    final colors = [PCPEColors.primary, PCPEColors.warning, PCPEColors.success, PCPEColors.primaryDark];

    return PCPECard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors[index].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icons[index], size: 18, color: colors[index]),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titles[index], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: PCPEColors.black)),
                Text(subtitles[index], style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
              ],
            ),
          ),
          Text(times[index], style: const TextStyle(fontSize: 11, color: PCPEColors.lightGray)),
        ],
      ),
    );
  }
}

// Custom chart painter
class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rascunhoPaint = Paint()
      ..color = PCPEColors.mediumGray.withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final concluidasPaint = Paint()
      ..color = PCPEColors.success.withValues(alpha: 0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final agSincPaint = Paint()
      ..color = PCPEColors.warning.withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sincPaint = Paint()
      ..color = PCPEColors.primary.withValues(alpha: 0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..color = PCPEColors.lightGray.withValues(alpha: 0.2)
      ..strokeWidth = 0.5;

    // Grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 12 months
    final months = 12;

    // Rascunhos: low line (small values ~15-30)
    _drawChartLine(canvas, size, rascunhoPaint, months, _rascunhoData(), offset: 0.0);

    // Concluídas: high line (~80-120)
    _drawChartLine(canvas, size, concluidasPaint, months, _concluidasData(), offset: 0.0);

    // Aguardando Sinc: low line (~2-15)
    _drawChartLine(canvas, size, agSincPaint, months, _aguardandoSincData(), offset: 0.0);

    // Sincronizadas: tracks concluídas slightly below (~70-110)
    _drawChartLine(canvas, size, sincPaint, months, _sincronizadasData(), offset: 0.0);
  }

  List<double> _rascunhoData() => [18, 20, 22, 19, 23, 25, 21, 24, 26, 22, 28, 23];
  List<double> _concluidasData() => [95, 100, 98, 105, 102, 110, 108, 112, 115, 118, 120, 1198];
  List<double> _aguardandoSincData() => [8, 10, 6, 12, 9, 7, 11, 5, 14, 8, 15, 26];
  List<double> _sincronizadasData() => [87, 90, 92, 93, 93, 103, 97, 107, 110, 110, 115, 1172];

  void _drawChartLine(Canvas canvas, Size size, Paint paint, int count, List<double> data, {double offset = 0.0}) {
    final path = Path();
    final stepX = size.width / (count - 1);
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return;

    for (int i = 0; i < count; i++) {
      final x = stepX * i;
      final normalized = data[i] / maxVal;
      final y = size.height - (normalized * size.height * 0.85) - 10;
      if (i == 0) {
        path.moveTo(x, y.clamp(10, size.height - 10));
      } else {
        path.lineTo(x, y.clamp(10, size.height - 10));
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Placeholder map painter
class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = PCPEColors.primary.withValues(alpha: 0.06)
      ..strokeWidth = 0.5;

    final stepX = size.width / 8;
    final stepY = size.height / 6;

    for (int i = 0; i <= 8; i++) {
      canvas.drawLine(Offset(stepX * i, 0), Offset(stepX * i, size.height), gridPaint);
    }
    for (int i = 0; i <= 6; i++) {
      canvas.drawLine(Offset(0, stepY * i), Offset(size.width, stepY * i), gridPaint);
    }

    // Dots for occurrence markers
    final dotPaint = Paint()
      ..color = PCPEColors.primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final rng = Random(123);
    for (int i = 0; i < 15; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }

    // River line
    final riverPaint = Paint()
      ..color = PCPEColors.darkGray.withValues(alpha: 0.1)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final riverPath = Path();
    riverPath.moveTo(0, size.height * 0.5);
    riverPath.quadraticBezierTo(size.width * 0.3, size.height * 0.3, size.width * 0.5, size.height * 0.5);
    riverPath.quadraticBezierTo(size.width * 0.7, size.height * 0.7, size.width, size.height * 0.4);
    canvas.drawPath(riverPath, riverPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}