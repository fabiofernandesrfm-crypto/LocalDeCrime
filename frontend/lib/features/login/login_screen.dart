import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/sessao_provider.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_input.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usuarioController = TextEditingController(text: 'fabiofernandes');
  final _senhaController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    final usuario = _usuarioController.text.trim();
    final senha = _senhaController.text.trim();

    // Credenciais de demonstração
    if (usuario == 'fabiofernandes' && senha == '123456') {
      ref.read(sessaoProvider.notifier).start();
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo Section
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          // Shield icon
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B1B1B),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: PCPEColors.primary.withValues(alpha: 0.25),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.shield, size: 40, color: PCPEColors.primary),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'PCPE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1B1B1B),
                              letterSpacing: 3,
                            ),
                          ),
                          const Text(
                            'POLÍCIA CIVIL DE PERNAMBUCO',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: PCPEColors.darkGray, letterSpacing: 1),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Departamento de Homicídios e Proteção à Pessoa',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10, color: PCPEColors.darkGray, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B1B1B),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Sistema de Registro de Atendimento em Local de Crime',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: PCPEColors.primary, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Login Card
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Acesso ao Sistema',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B)),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Informe suas credenciais institucionais',
                            style: TextStyle(fontSize: 13, color: PCPEColors.darkGray),
                          ),
                          const SizedBox(height: 24),
                          PCPEInput(
                            label: 'Usuário',
                            hint: 'Digite seu usuário',
                            prefixIcon: Icons.person_outline,
                            controller: _usuarioController,
                            validator: (v) => v?.isEmpty == true ? 'Usuário obrigatório' : null,
                          ),
                          const SizedBox(height: 16),
                          PCPEInput(
                            label: 'Senha',
                            hint: 'Digite sua senha',
                            prefixIcon: Icons.lock_outlined,
                            controller: _senhaController,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: PCPEColors.mediumGray,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (v) => v?.isEmpty == true ? 'Senha obrigatória' : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (v) => setState(() => _rememberMe = v ?? false),
                                      fillColor: WidgetStateProperty.all(const Color(0xFF1B1B1B)),
                                      checkColor: PCPEColors.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Lembrar acesso',
                                    style: TextStyle(fontSize: 13, color: PCPEColors.darkGray),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Esqueci a senha',
                                  style: TextStyle(fontSize: 13, color: PCPEColors.primary, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          PCPEButton(
                            label: 'Entrar no Sistema',
                            icon: Icons.login,
                            fullWidth: true,
                            onPressed: _handleLogin,
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Expanded(child: Divider(color: PCPEColors.lightGray)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('ou', style: TextStyle(color: PCPEColors.mediumGray, fontSize: 12)),
                              ),
                              Expanded(child: Divider(color: PCPEColors.lightGray)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          PCPEButton(
                            label: 'Autenticar com Certificado Digital',
                            icon: Icons.verified_user,
                            fullWidth: true,
                            outlined: true,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Versão 1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: PCPEColors.mediumGray),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Sistema desenvolvido pela UNISA',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: PCPEColors.lightGray),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '© Polícia Civil de Pernambuco',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: PCPEColors.mediumGray.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}