import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../design_system/design_system.dart';

/// Stepper responsivo PCPE.
///
/// Desktop: horizontal com ícones e labels.
/// Tablet: vertical com ícones e labels condensados.
/// Mobile: indicador simplificado com progresso numérico.

class PCPEStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;
  final List<IconData> icons;
  final void Function(int step)? onStepTapped;
  final bool allowNavigation;

  const PCPEStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
    required this.icons,
    this.onStepTapped,
    this.allowNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);
    final isMobile = breakpoints.isMobile;
    final isTablet = breakpoints.isTablet;

    if (isMobile) {
      return _buildMobileStepper(context);
    }
    return _buildHorizontalStepper(context, isCompact: isTablet);
  }

  Widget _buildHorizontalStepper(BuildContext context, {bool isCompact = false}) {
    final paddingV = isCompact ? 14.0 : 20.0;
    final paddingH = isCompact ? 10.0 : 16.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      decoration: BoxDecoration(
        color: PCPEColors.pureWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index == currentStep;
              final isCompleted = index < currentStep;
              return Expanded(
                child: _buildStepItem(
                  context,
                  index: index,
                  isActive: isActive,
                  isCompleted: isCompleted,
                  isCompact: isCompact,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStepper(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: PCPEColors.pureWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PCPEColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icons[currentStep],
                  size: 20,
                  color: PCPEColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Etapa ${currentStep + 1} de $totalSteps',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: PCPEColors.mediumGray,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      labels[currentStep],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: PCPEColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (currentStep + 1) / totalSteps,
              backgroundColor: PCPEColors.surfaceGray,
              valueColor: const AlwaysStoppedAnimation<Color>(PCPEColors.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required int index,
    required bool isActive,
    required bool isCompleted,
    required bool isCompact,
  }) {
    final circleSize = isActive ? (isCompact ? 32.0 : 38.0) : (isCompact ? 28.0 : 32.0);
    final checkSize = isCompact ? 14.0 : 18.0;
    final numberFontSize = isActive ? (isCompact ? 12.0 : 14.0) : (isCompact ? 10.0 : 12.0);
    final labelFontSize = isCompact ? 8.0 : 10.0;
    final lineHeight = isCompact ? 2.0 : 3.0;

    return InkWell(
      onTap: allowNavigation ? () => onStepTapped?.call(index) : null,
      borderRadius: BorderRadius.circular(8),
      splashColor: PCPEColors.primary.withValues(alpha: 0.05),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isCompact ? 1.0 : 2.0, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Linha de conexão + círculo
            Row(
              children: [
                if (index > 0)
                  Expanded(
                    child: Container(
                      height: lineHeight,
                      margin: EdgeInsets.symmetric(horizontal: isCompact ? 1.0 : 2.0),
                      decoration: BoxDecoration(
                        color: index <= currentStep
                            ? PCPEColors.primary
                            : PCPEColors.lightGray.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
                // Círculo do step
                AnimatedContainer(
                  duration: PCPEAnimations.normal,
                  curve: PCPEAnimations.standard,
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isCompleted ? PCPEColors.primary : PCPEColors.surfaceGray,
                    border: Border.all(
                      color: isActive || isCompleted
                          ? PCPEColors.primary
                          : PCPEColors.lightGray.withValues(alpha: 0.4),
                      width: 2,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: PCPEColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: isCompleted
                      ? Icon(Icons.check, size: checkSize, color: PCPEColors.pureWhite)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: numberFontSize,
                            fontWeight: FontWeight.w700,
                            color: isActive ? PCPEColors.pureWhite : PCPEColors.mediumGray,
                          ),
                        ),
                ),
                if (index < totalSteps - 1)
                  Expanded(
                    child: Container(
                      height: lineHeight,
                      margin: EdgeInsets.symmetric(horizontal: isCompact ? 1.0 : 2.0),
                      decoration: BoxDecoration(
                        color: index < currentStep
                            ? PCPEColors.primary
                            : PCPEColors.lightGray.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 6),
            // Label
            Text(
              labels[index],
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive || isCompleted ? PCPEColors.black : PCPEColors.mediumGray,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}