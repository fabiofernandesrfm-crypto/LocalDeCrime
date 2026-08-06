import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../design_system/design_system.dart';
import '../../shared/widgets/pcpe_button.dart';
import 'wizard/ocorrencia_wizard_data.dart';
import 'wizard/pcpe_stepper.dart';
import 'wizard/step1_identificacao.dart';
import 'wizard/step2_local.dart';
import 'wizard/step3_pessoas.dart';
import 'wizard/step4_elementos_local.dart';
import 'wizard/step7_narrativa.dart';
import 'wizard/step8_preview_pdf.dart';
import 'wizard/step9_finalizacao.dart';

/// Tela principal do wizard de Nova Ocorrência.
///
/// REESTRUTURAÇÃO F17 — 7 etapas:
/// 1. Identificação
/// 2. Local do Crime (+ fotos do local)
/// 3. Pessoas (+ galeria por pessoa)
/// 4. Elementos Relacionados ao Local (Veículos + Objetos + Vestígios)
/// 5. Narrativa
/// 6. Pré-Visualização do PDF Oficial
/// 7. Finalização
class NovaOcorrenciaScreen extends StatefulWidget {
  const NovaOcorrenciaScreen({super.key});

  @override
  State<NovaOcorrenciaScreen> createState() => _NovaOcorrenciaScreenState();
}

class _NovaOcorrenciaScreenState extends State<NovaOcorrenciaScreen> {
  late final OcorrenciaWizardData _data;
  int _currentStep = 0;
  bool _salvandoRascunho = false;

  @override
  void initState() {
    super.initState();
    _data = OcorrenciaWizardData();
  }

  void _nextStep() {
    if (_currentStep < _data.totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _goToStep(int step) {
    if (step >= 0 && step < _data.totalSteps) {
      setState(() {
        _currentStep = step;
      });
    }
  }

  void _salvarRascunho() {
    setState(() => _salvandoRascunho = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _salvandoRascunho = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: PCPEColors.pureWhite, size: 18),
                const SizedBox(width: 10),
                Text(
                  'Rascunho salvo em ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} (simulado)',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            backgroundColor: PCPEColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _finalizarOcorrencia() {
    _data.gerarProtocoloFinal();
    _nextStep();
  }

  Widget _buildStepContent() {
    final stepWidget = switch (_currentStep) {
      0 => Step1Identificacao(data: _data, onChanged: () => setState(() {})),
      1 => Step2LocalCrime(data: _data, onChanged: () => setState(() {})),
      2 => Step3Pessoas(data: _data, onChanged: () => setState(() {})),
      3 => Step4ElementosLocal(data: _data, onChanged: () => setState(() {})),
      4 => Step7Narrativa(data: _data, onChanged: () => setState(() {})),
      5 => Step8PreviewPdf(data: _data, onVoltarEdicao: () => _goToStep(1)),
      6 => Step9Finalizacao(data: _data),
      _ => const SizedBox.shrink(),
    };

    if (_currentStep >= 6) return stepWidget;

    return Column(
      children: [
        _buildStepOrientation(),
        Expanded(child: stepWidget),
      ],
    );
  }

  Widget _buildStepOrientation() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: PCPEColors.primarySoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PCPEColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: PCPEColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Etapa ${_currentStep + 1} de ${_data.totalSteps}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: PCPEColors.primary,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _data.stepOrientations[_currentStep],
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: PCPEColors.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);
    final isMobile = breakpoints.isMobile;
    final isTablet = breakpoints.isTablet;
    final isDesktop = breakpoints.isDesktop;
    final isFinalStep = _currentStep == 6;
    final isReviewStep = _currentStep == 5;

    final bottomPadding = isDesktop ? 20.0 : 16.0;
    final contentPadding = isDesktop ? 24.0 : 16.0;

    return PopScope(
      canPop: isFinalStep,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_currentStep > 0) {
            _previousStep();
          } else {
            context.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: PCPEColors.background,
        appBar: AppBar(
          backgroundColor: PCPEColors.pureWhite,
          elevation: 0,
          shadowColor: Colors.black12,
          toolbarHeight: isDesktop ? 64 : 56,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            color: PCPEColors.primary,
            onPressed: () {
              if (_currentStep > 0 && !isFinalStep) {
                _previousStep();
              } else {
                context.pop();
              }
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nova Ocorrência',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: PCPEColors.black,
                ),
              ),
              Text(
                _data.stepLabels[_currentStep],
                style: TextStyle(
                  fontSize: 12,
                  color: PCPEColors.primary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            if (!isFinalStep)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: PCPEButton(
                  label: isMobile ? 'Salvar' : 'Salvar Rascunho',
                  icon: Icons.save_outlined,
                  small: isMobile || isTablet,
                  outlined: true,
                  loading: _salvandoRascunho,
                  onPressed: _salvarRascunho,
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            // Stepper
            PCPEStepper(
              currentStep: _currentStep,
              totalSteps: _data.totalSteps,
              labels: _data.stepLabels,
              icons: _data.stepIcons,
            ),
            // Content
            Expanded(
              child: AnimatedSwitcher(
                duration: PCPEAnimations.medium,
                switchInCurve: PCPEAnimations.easeOut,
                switchOutCurve: PCPEAnimations.easeOut,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.03, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: PCPEAnimations.standard,
                      )),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey('step_$_currentStep'),
                  child: _buildStepContent(),
                ),
              ),
            ),
            // Bottom navigation bar
            if (!isFinalStep)
              Container(
                padding: EdgeInsets.fromLTRB(
                  bottomPadding,
                  bottomPadding,
                  bottomPadding,
                  bottomPadding,
                ),
                decoration: BoxDecoration(
                  color: PCPEColors.pureWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                        child: PCPEButton(
                          label: _currentStep > 0 && _currentStep < _data.totalSteps - 1
                              ? _data.backButtonLabels[_currentStep]
                              : 'Voltar',
                          icon: Icons.arrow_back,
                          outlined: true,
                          fullWidth: true,
                          onPressed: _previousStep,
                        ),
                      ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: _currentStep > 0 ? 2 : 1,
                        child: PCPEButton(
                          label: isReviewStep ? 'Concluir Ocorrência' : _data.nextButtonLabels[_currentStep],
                          icon: isReviewStep ? Icons.check_circle : Icons.arrow_forward,
                          fullWidth: true,
                          onPressed: isReviewStep ? _finalizarOcorrencia : _nextStep,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}