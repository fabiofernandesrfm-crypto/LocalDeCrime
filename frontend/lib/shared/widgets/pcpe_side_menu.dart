import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/sessao_provider.dart';
import 'pcpe_avatar.dart';

class SideMenuItem {
  final String label;
  final IconData icon;
  final String route;
  final bool isActive;
  final List<SideMenuItem>? children;

  const SideMenuItem({
    required this.label,
    required this.icon,
    required this.route,
    this.isActive = false,
    this.children,
  });
}

class PCPESideMenu extends ConsumerWidget {
  final String userName;
  final String userRole;
  final String? userUnit;
  final String currentRoute;
  final void Function(String route) onNavigate;

  const PCPESideMenu({
    super.key,
    required this.userName,
    required this.userRole,
    this.userUnit,
    required this.currentRoute,
    required this.onNavigate,
  });

  static const List<SideMenuItem> menuItems = [
    SideMenuItem(label: 'Dashboard', icon: Icons.dashboard_outlined, route: '/dashboard'),
    SideMenuItem(label: 'Nova Ocorrência', icon: Icons.add_circle_outline, route: '/nova-ocorrencia'),
    SideMenuItem(label: 'Ocorrências', icon: Icons.folder_outlined, route: '/ocorrencias'),
    SideMenuItem(label: 'Atendimentos', icon: Icons.medical_services_outlined, route: '/atendimentos'),
    SideMenuItem(label: 'Usuários', icon: Icons.people_outline, route: '/usuarios'),
    SideMenuItem(label: 'Pessoas', icon: Icons.person_outline, route: '/pessoas'),
    SideMenuItem(label: 'Vestígios', icon: Icons.fingerprint, route: '/vestigios'),
    SideMenuItem(label: 'Objetos', icon: Icons.category_outlined, route: '/objetos'),
    SideMenuItem(label: 'Veículos', icon: Icons.directions_car_outlined, route: '/veiculos'),
    SideMenuItem(label: 'Fotografias', icon: Icons.photo_library_outlined, route: '/fotografias'),
    SideMenuItem(label: 'Linha do Tempo', icon: Icons.timeline_outlined, route: '/linha-do-tempo'),
    SideMenuItem(label: 'Equipes', icon: Icons.groups_outlined, route: '/equipes'),
    SideMenuItem(label: 'Relatórios', icon: Icons.assessment_outlined, route: '/relatorios'),
  ];

  static const List<SideMenuItem> bottomItems = [
    SideMenuItem(label: 'Sincronização', icon: Icons.sync, route: '/sincronizacao'),
    SideMenuItem(label: 'Configurações', icon: Icons.settings_outlined, route: '/configuracoes'),
    SideMenuItem(label: 'Perfil', icon: Icons.person_outline, route: '/perfil'),
    SideMenuItem(label: 'Sobre', icon: Icons.info_outline, route: '/sobre'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: PCPEColors.pureWhite,
      child: SafeArea(
        child: Column(
          children: [
            // Header institucional
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B1B1B),
                    Color(0xFF2D2D2D),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: PCPEColors.primary.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shield, size: 26, color: PCPEColors.primary),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PCPE',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: PCPEColors.pureWhite,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'DTI – UNISA',
                            style: TextStyle(fontSize: 10, color: PCPEColors.pureWhite, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: PCPEColors.pureWhite.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const PCPEAvatar(name: 'Fabio Fernandes dos Santos', size: 36),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ag. Fabio Fernandes',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: PCPEColors.pureWhite),
                              ),
                              Text(
                                'Agente de Polícia Civil • DTI – UNISA',
                                style: TextStyle(fontSize: 10, color: PCPEColors.pureWhite.withValues(alpha: 0.8)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Menu items with module grouping
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Text(
                      'PRINCIPAL',
                      style: TextStyle(
                        fontSize: 10,
                        color: PCPEColors.mediumGray,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ...menuItems.sublist(0, 5).map((item) => _buildMenuItem(context, item)),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 4, 20, 4),
                    child: Text(
                      'REGISTROS',
                      style: TextStyle(
                        fontSize: 10,
                        color: PCPEColors.mediumGray,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ...menuItems.sublist(5).map((item) => _buildMenuItem(context, item)),
                  const SizedBox(height: 12),
                  const Divider(color: PCPEColors.lightGray, indent: 20, endIndent: 20),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
                    child: Text(
                      'SISTEMA',
                      style: TextStyle(
                        fontSize: 10,
                        color: PCPEColors.mediumGray,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ...bottomItems.map((item) => _buildMenuItem(context, item)),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.3))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 16, color: PCPEColors.mediumGray),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      ref.read(sessaoProvider.notifier).stop();
                      onNavigate('/login');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Sair do Sistema',
                      style: TextStyle(
                        fontSize: 12,
                        color: PCPEColors.darkGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'v1.0.0',
                    style: TextStyle(fontSize: 10, color: PCPEColors.mediumGray.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, SideMenuItem item) {
    final isActive = currentRoute == item.route;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      decoration: BoxDecoration(
        color: isActive ? PCPEColors.primary.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isActive
            ? Border(
                left: BorderSide(color: PCPEColors.primary, width: 3),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
        leading: Icon(
          item.icon,
          size: 20,
          color: isActive ? PCPEColors.primary : PCPEColors.mediumGray,
        ),
        title: Text(
          item.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? PCPEColors.primary : PCPEColors.darkGray,
          ),
        ),
        dense: true,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        onTap: () {
          onNavigate(item.route);
          Navigator.of(context).pop();
        },
        ),
      ),
    );
  }
}