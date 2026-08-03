import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import 'pcpe_button.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PCPEColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: PCPEColors.gold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off, size: 64, color: PCPEColors.gold),
            ),
            const SizedBox(height: 24),
            const Text(
              '404',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: PCPEColors.gold, letterSpacing: 2),
            ),
            const SizedBox(height: 8),
            const Text(
              'Página não encontrada',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: PCPEColors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'A rota solicitada não existe ou foi movida.',
              style: TextStyle(fontSize: 14, color: PCPEColors.lightGray),
            ),
            const SizedBox(height: 32),
            PCPEButton(
              label: 'Voltar ao Dashboard',
              icon: Icons.dashboard,
              onPressed: () => context.go('/dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}