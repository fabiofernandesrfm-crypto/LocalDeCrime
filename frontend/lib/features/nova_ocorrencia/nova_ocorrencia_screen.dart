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
import 'wizard/step4_veiculos.dart';
import 'wizard/step5_objetos.dart';
import 'wizard/step6_vestigios.dart';
import 'wizard/step7_fotografias.dart';
import 'wizard/step8_narrativa.dart';
import 'wizard/step9_revisao.dart';
import 'wizard/step10_finalizacao.dart';

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
    switch (_currentStep) {
      case 0:
        return Step1Identificacao(
          data: _data,
          onChanged: () => setState(() {}),
        );
      case 1:
        return Step2LocalCrime(
          data: _data,
          onChanged: () => setState(() {}),
        );
      case 2:
        return Step3Pessoas(
          data: _data,
          onChanged: () => setState(() {}),
        );
      case 3:
        return Step4Veiculos(
          data: _data,
          onChanged: () => setState(() {}),
        );
      case 4:
        return Step5Objetos(
          data: _data,
          onChanged: () => setState(() {}),
        );
      case 5:
        return Step6Vestigios(
          data: _data,
          onChanged: () => setState(() {}),
        );
      case 6:
        return Step7Fotografias(
          data: _data,
          onChanged: () => setState(() {}),
        );
      case 7:
        return Step8Narrativa(
          data: _data,
          onChanged: () => setState(() {}),
        );
      case 8:
        return Step9Revisao(
          data: _data,
          onEditSection: _goToStep,
        );
      case 9:
        return Step10Finalizacao(data: _data);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isFinalStep = _currentStep == 9;
    final isReviewStep = _currentStep == 8;

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
                  small: isMobile,
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
                padding: const EdgeInsets.all(16),
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
                            label: 'Voltar',
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
                          label: isReviewStep ? 'Finalizar Registro' : 'Próximo',
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