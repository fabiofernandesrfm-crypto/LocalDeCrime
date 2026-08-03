import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_section_title.dart';

class SincronizacaoScreen extends StatefulWidget {
  const SincronizacaoScreen({super.key});

  @override
  State<SincronizacaoScreen> createState() => _SincronizacaoScreenState();
}

class _SincronizacaoScreenState extends State<SincronizacaoScreen> {
  bool _syncing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: const PCPEHeader(title: 'Sincronização', subtitle: 'Status da sincronização de dados'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            PCPECard(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: PCPEColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: PCPEColors.success.withValues(alpha: 0.3), width: 2),
                    ),
                    child: const Icon(Icons.cloud_done, size: 36, color: PCPEColors.success),
                  ),
                  const SizedBox(height: 16),
                  const Text('Sincronizado', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: PCPEColors.black)),
                  const SizedBox(height: 4),
                  Text('Última sincronização: 15/03/2026 16:45', style: TextStyle(fontSize: 13, color: PCPEColors.darkGray.withValues(alpha: 0.8))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem('1.247', 'Ocorrências'),
                      Container(width: 1, height: 30, color: PCPEColors.lightGray.withValues(alpha: 0.4)),
                      _buildStatItem('3.892', 'Atendimentos'),
                      Container(width: 1, height: 30, color: PCPEColors.lightGray.withValues(alpha: 0.4)),
                      _buildStatItem('8.942', 'Registros'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const PCPESectionTitle(title: 'Ações de Sincronização', icon: Icons.sync),
            PCPECard(
              child: Column(
                children: [
                  _buildSyncAction(Icons.upload, 'Enviar dados pendentes', '12 registros aguardando', false),
                  const Divider(),
                  _buildSyncAction(Icons.download, 'Baixar atualizações', 'Última: há 2 horas', false),
                  const Divider(),
                  _buildSyncAction(Icons.backup, 'Backup completo', 'Backup local e na nuvem', false),
                  const Divider(),
                  _buildSyncAction(Icons.restore, 'Forçar sincronização', 'Sincronizar todos os dados', true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PCPEButton(
              label: _syncing ? 'Sincronizando...' : 'Sincronizar Agora',
              icon: Icons.sync,
              fullWidth: true,
              loading: _syncing,
              onPressed: () {
                final messenger = ScaffoldMessenger.of(context);
                setState(() => _syncing = true);
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() => _syncing = false);
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Sincronização concluída com sucesso!'), backgroundColor: PCPEColors.success),
                    );
                  }
                });
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PCPEColors.primary)),
          Text(label, style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
        ],
      ),
    );
  }

  Widget _buildSyncAction(IconData icon, String title, String subtitle, bool isForced) {
    final color = isForced ? PCPEColors.warning : PCPEColors.primary;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, color: PCPEColors.black)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
      trailing: const Icon(Icons.chevron_right, color: PCPEColors.lightGray),
      onTap: () {},
    );
  }
}