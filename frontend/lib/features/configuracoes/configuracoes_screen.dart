import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_card.dart';
import '../../shared/widgets/pcpe_header.dart';
import '../../shared/widgets/pcpe_section_title.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  bool _darkMode = false;
  bool _pushNotifications = true;
  bool _soundAlerts = false;
  bool _occurrenceNotifications = true;
  bool _autoLock = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: const PCPEHeader(title: 'Configurações', subtitle: 'Preferências do sistema'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          const PCPESectionTitle(title: 'Aparência', icon: Icons.palette_outlined),
          PCPECard(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(4),
            child: SwitchListTile(
              value: _darkMode,
              onChanged: (v) => setState(() => _darkMode = v),
              title: const Text('Modo Escuro', style: TextStyle(fontSize: 14, color: PCPEColors.black)),
              subtitle: const Text('Tema escuro desativado', style: TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
              activeThumbColor: PCPEColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const PCPESectionTitle(title: 'Notificações', icon: Icons.notifications_outlined),
          PCPECard(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                SwitchListTile(
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                  title: const Text('Notificações Push', style: TextStyle(fontSize: 14, color: PCPEColors.black)),
                  activeThumbColor: PCPEColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _soundAlerts,
                  onChanged: (v) => setState(() => _soundAlerts = v),
                  title: const Text('Alertas Sonoros', style: TextStyle(fontSize: 14, color: PCPEColors.black)),
                  activeThumbColor: PCPEColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _occurrenceNotifications,
                  onChanged: (v) => setState(() => _occurrenceNotifications = v),
                  title: const Text('Notificações de Ocorrências', style: TextStyle(fontSize: 14, color: PCPEColors.black)),
                  activeThumbColor: PCPEColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const PCPESectionTitle(title: 'Segurança', icon: Icons.security_outlined),
          PCPECard(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.fingerprint, color: PCPEColors.primary),
                  title: const Text('Autenticação Biométrica', style: TextStyle(fontSize: 14, color: PCPEColors.black)),
                  subtitle: const Text('Configurar digital', style: TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                  trailing: const Icon(Icons.chevron_right, color: PCPEColors.lightGray),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: PCPEColors.primary),
                  title: const Text('Alterar Senha', style: TextStyle(fontSize: 14, color: PCPEColors.black)),
                  subtitle: const Text('Última alteração: há 30 dias', style: TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                  trailing: const Icon(Icons.chevron_right, color: PCPEColors.lightGray),
                  onTap: () {},
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _autoLock,
                  onChanged: (v) => setState(() => _autoLock = v),
                  title: const Text('Bloqueio Automático', style: TextStyle(fontSize: 14, color: PCPEColors.black)),
                  subtitle: const Text('Após 5 minutos de inatividade', style: TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                  activeThumbColor: PCPEColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const PCPESectionTitle(title: 'Sobre o Sistema', icon: Icons.info_outline),
          PCPECard(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.android, color: PCPEColors.primary),
                  title: Text('Versão do Aplicativo', style: TextStyle(fontSize: 14, color: PCPEColors.black)),
                  subtitle: Text('1.0.0 (Build 20260315)', style: TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: PCPEColors.primary),
                  title: const Text('Sobre', style: TextStyle(fontSize: 14, color: PCPEColors.black)),
                  trailing: const Icon(Icons.chevron_right, color: PCPEColors.lightGray),
                  onTap: () => context.go('/sobre'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'PCPE v1.0.0 © 2026 Polícia Civil de Pernambuco',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: PCPEColors.mediumGray.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}