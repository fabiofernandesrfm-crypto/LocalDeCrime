import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/sessao_provider.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_avatar.dart';
import '../../shared/widgets/pcpe_section_title.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: const PCPEHeader(title: 'Perfil', subtitle: 'Informações do usuário'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            PCPECard(
              child: Column(
                children: [
                  const PCPEAvatar(name: 'Fabio Fernandes dos Santos', size: 80, showBadge: true),
                  const SizedBox(height: 16),
                  const Text('Fabio Fernandes dos Santos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: PCPEColors.black)),
                  const SizedBox(height: 4),
                  Text('Login: fabiofernandes', style: TextStyle(fontSize: 13, color: PCPEColors.darkGray.withValues(alpha: 0.8))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: PCPEColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: PCPEColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: const Text('Agente de Polícia Civil', style: TextStyle(fontSize: 13, color: PCPEColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const PCPESectionTitle(title: 'Informações Profissionais', icon: Icons.work_outline),
            PCPECard(
              child: Column(
                children: [
                  _buildInfoRow(Icons.business, 'Unidade', 'Diretoria de Tecnologia'),
                  const Divider(),
                  _buildInfoRow(Icons.location_on, 'Lotação', 'Recife - PE'),
                  const Divider(),
                  _buildInfoRow(Icons.calendar_today, 'Admissão', '10/03/2010 (15 anos)'),
                  const Divider(),
                  _buildInfoRow(Icons.star, 'Especialidade', 'Desenvolvimento de Sistemas'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const PCPESectionTitle(title: 'Contato', icon: Icons.contact_mail_outlined),
            PCPECard(
              child: Column(
                children: [
                  _buildInfoRow(Icons.email_outlined, 'Email', 'fabio.fernandes@pcpe.pe.gov.br'),
                  const Divider(),
                  _buildInfoRow(Icons.phone_outlined, 'Telefone', '(81) 99999-9999'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const PCPESectionTitle(title: 'Status', icon: Icons.circle),
            PCPECard(
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: PCPEColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('Em serviço', style: TextStyle(fontSize: 14, color: PCPEColors.success, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PCPEButton(
              label: 'Editar Perfil',
              icon: Icons.edit,
              fullWidth: true,
              outlined: true,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            PCPEButton(
              label: 'Sair do Sistema',
              icon: Icons.logout,
              fullWidth: true,
              backgroundColor: PCPEColors.errorLight,
              foregroundColor: PCPEColors.error,
              onPressed: () {
                ref.read(sessaoProvider.notifier).stop();
                context.go('/login');
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: PCPEColors.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14, color: PCPEColors.black, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}