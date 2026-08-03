import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 10: Finalização
class Step10Finalizacao extends StatelessWidget {
  final OcorrenciaWizardData data;

  const Step10Finalizacao({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          // Ícone de sucesso
          TweenAnimationBuilder<double>(
            duration: PCPEAnimations.slow,
            curve: PCPEAnimations.easeOutBack,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: PCPEColors.successLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: PCPEColors.success.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle,
                size: 56,
                color: PCPEColors.success,
              ),
            ),
          ),
          const SizedBox(height: 28),
          // Título
          const Text(
            'Ocorrência Registrada\ncom Sucesso',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: PCPEColors.black,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'O registro foi concluído e armazenado no sistema.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: PCPEColors.darkGray.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          // Card do protocolo
          PCPECard(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            child: Column(
              children: [
                const Text(
                  'PROTOCOLO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: PCPEColors.mediumGray,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: PCPEColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: PCPEColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    data.protocoloFinal ?? '---',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: PCPEColors.primary,
                      letterSpacing: 1,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Card de detalhes
          PCPECard(
            child: Column(
              children: [
                _buildDetailRow(Icons.calendar_today, 'Data', data.dataFinalizacao != null
                    ? '${data.dataFinalizacao!.day.toString().padLeft(2, '0')}/${data.dataFinalizacao!.month.toString().padLeft(2, '0')}/${data.dataFinalizacao!.year}'
                    : '—'),
                const Divider(height: 24, color: PCPEColors.surfaceGray),
                _buildDetailRow(Icons.access_time, 'Hora', data.horaFinalizacao ?? '—'),
                const Divider(height: 24, color: PCPEColors.surfaceGray),
                _buildDetailRow(Icons.groups, 'Equipe', data.equipeResponsavel),
                const Divider(height: 24, color: PCPEColors.surfaceGray),
                _buildDetailRow(Icons.person, 'Responsável', 'Dr. Carlos Eduardo'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Botões de ação
          PCPEButton(
            label: 'Visualizar Ocorrência',
            icon: Icons.visibility,
            fullWidth: true,
            height: 52,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.info_outline, color: PCPEColors.pureWhite, size: 18),
                      SizedBox(width: 10),
                      Text('Visualização da ocorrência (simulado)', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  backgroundColor: PCPEColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PCPEButton(
                  label: 'Nova Ocorrência',
                  icon: Icons.add,
                  fullWidth: true,
                  outlined: true,
                  height: 52,
                  onPressed: () => context.go('/nova-ocorrencia'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PCPEButton(
                  label: 'Imprimir',
                  icon: Icons.print,
                  fullWidth: true,
                  outlined: true,
                  height: 52,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.print, color: PCPEColors.pureWhite, size: 18),
                            SizedBox(width: 10),
                            Text('Relatório enviado para impressão (simulado)', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                        backgroundColor: PCPEColors.info,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: PCPEColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: PCPEColors.primary),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: PCPEColors.mediumGray,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PCPEColors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}