import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_section_title.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: const PCPEHeader(title: 'Sobre', subtitle: 'Informações do sistema', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Logo Section
            PCPECard(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: PCPEColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: PCPEColors.primary.withValues(alpha: 0.2), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: PCPEColors.primary.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.shield, size: 40, color: PCPEColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Text('PCPE', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: PCPEColors.primary, letterSpacing: 3)),
                  const SizedBox(height: 4),
                  const Text('Polícia Civil de Pernambuco', style: TextStyle(fontSize: 14, color: PCPEColors.black)),
                  const SizedBox(height: 8),
                  Text(
                    'Sistema de Registro de Atendimentos em Locais de Crime',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: PCPEColors.darkGray.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: PCPEColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Versão 1.0.0 • Build 20260315', style: TextStyle(fontSize: 12, color: PCPEColors.primary, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const PCPESectionTitle(title: 'Informações Técnicas', icon: Icons.code),
            PCPECard(
              child: Column(
                children: [
                  _buildInfoRow('Plataforma', 'Flutter 3.12+ • Material 3'),
                  const Divider(),
                  _buildInfoRow('Arquitetura', 'Riverpod + GoRouter • Clean Architecture'),
                  const Divider(),
                  _buildInfoRow('Suporte', 'Mobile (Android/iOS) • Tablet • PWA (Web)'),
                  const Divider(),
                  _buildInfoRow('Banco de Dados', 'PostgreSQL • Prisma ORM'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const PCPESectionTitle(title: 'Instituição', icon: Icons.account_balance),
            PCPECard(
              child: Column(
                children: [
                  _buildInfoRow('Órgão', 'Polícia Civil de Pernambuco'),
                  const Divider(),
                  _buildInfoRow('Unidade', 'DTI – UNISA'),
                  const Divider(),
                  _buildInfoRow('Localização', 'Recife - Pernambuco - Brasil'),
                  const Divider(),
                  _buildInfoRow('Diretoria', 'Unidade de Sistemas'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const PCPESectionTitle(title: 'Desenvolvimento', icon: Icons.engineering_outlined),
            PCPECard(
              child: Column(
                children: [
                  _buildInfoRow('Time', 'DTI – UNISA'),
                  const Divider(),
                  _buildInfoRow('Design System', 'PCPE Design System'),
                  const Divider(),
                  _buildInfoRow('Licença', '© 2026 Polícia Civil de Pernambuco'),
                  const Divider(),
                  _buildInfoRow('Status', 'Versão de Demonstração Institucional'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sistema desenvolvido pela DTI – UNISA.\nUnidade de Sistemas — Polícia Civil de Pernambuco.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: PCPEColors.mediumGray.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, color: PCPEColors.black)),
          ),
        ],
      ),
    );
  }
}