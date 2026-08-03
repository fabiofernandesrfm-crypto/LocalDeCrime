import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 2: Local do Crime
class Step2LocalCrime extends StatelessWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step2LocalCrime({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card: Endereço
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Endereço do Local',
                  icon: Icons.home_outlined,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PCPEInput(
                        label: 'UF',
                        hint: 'PE',
                        prefixIcon: Icons.map,
                        controller: TextEditingController(text: data.uf),
                        onChanged: (v) {
                          data.uf = v;
                          onChanged();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 5,
                      child: PCPEInput(
                        label: 'Município',
                        hint: 'Município',
                        prefixIcon: Icons.location_city,
                        controller: TextEditingController(text: data.municipio),
                        onChanged: (v) {
                          data.municipio = v;
                          onChanged();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: PCPEInput(
                        label: 'Bairro',
                        hint: 'Bairro',
                        prefixIcon: Icons.location_on,
                        controller: TextEditingController(text: data.bairro),
                        onChanged: (v) {
                          data.bairro = v;
                          onChanged();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PCPEInput(
                        label: 'CEP',
                        hint: '00000-000',
                        prefixIcon: Icons.mail_outline,
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: data.cep),
                        onChanged: (v) {
                          data.cep = v;
                          onChanged();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: PCPEInput(
                        label: 'Logradouro',
                        hint: 'Rua, Avenida...',
                        prefixIcon: Icons.add_road,
                        controller: TextEditingController(text: data.logradouro),
                        onChanged: (v) {
                          data.logradouro = v;
                          onChanged();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PCPEInput(
                        label: 'Número',
                        hint: 'Nº',
                        controller: TextEditingController(text: data.numero),
                        onChanged: (v) {
                          data.numero = v;
                          onChanged();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                PCPEInput(
                  label: 'Complemento',
                  hint: 'Apartamento, Bloco...',
                  prefixIcon: Icons.info_outline,
                  controller: TextEditingController(text: data.complemento),
                  onChanged: (v) {
                    data.complemento = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 14),
                PCPEInput(
                  label: 'Ponto de Referência',
                  hint: 'Próximo ao...',
                  prefixIcon: Icons.place_outlined,
                  controller: TextEditingController(text: data.pontoReferencia),
                  onChanged: (v) {
                    data.pontoReferencia = v;
                    onChanged();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Card: Coordenadas GPS
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Coordenadas Geográficas',
                  icon: Icons.gps_fixed,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: PCPEInput(
                        label: 'Latitude',
                        hint: '-8.0476...',
                        prefixIcon: Icons.arrow_upward,
                        controller: TextEditingController(text: data.latitude),
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PCPEInput(
                        label: 'Longitude',
                        hint: '-34.877...',
                        prefixIcon: Icons.arrow_forward,
                        controller: TextEditingController(text: data.longitude),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                PCPEButton(
                  label: data.gpsCapturado ? 'GPS Capturado' : 'Capturar GPS (Simulado)',
                  icon: data.gpsCapturado ? Icons.check_circle : Icons.gps_fixed,
                  fullWidth: true,
                  backgroundColor:
                      data.gpsCapturado ? PCPEColors.success : PCPEColors.primary,
                  onPressed: () {
                    data.simularCapturaGPS();
                    onChanged();
                    HapticFeedback.mediumImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: PCPEColors.pureWhite, size: 18),
                            const SizedBox(width: 10),
                            Text(
                              'GPS capturado: ${data.latitude}, ${data.longitude}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        backgroundColor: PCPEColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Card: Mapa
          PCPECard(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: PCPESectionTitle(
                    title: 'Mapa Ilustrativo',
                    icon: Icons.map_outlined,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: PCPEColors.surfaceGray,
                    border: Border(
                      top: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
                      bottom: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: PCPEColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            size: 48,
                            color: PCPEColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Mapa Indisponível\nModo Simulação',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: PCPEColors.mediumGray,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        if (data.latitude.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: PCPEColors.successLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${data.latitude}, ${data.longitude}',
                              style: const TextStyle(
                                color: PCPEColors.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}