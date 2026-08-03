import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/pcpe_header.dart';

class LinhaDoTempoScreen extends StatelessWidget {
  const LinhaDoTempoScreen({super.key});

  static const _eventos = [
    {'hora': '14:30', 'data': '15/03/2026', 'evento': 'Registro da ocorrência', 'descricao': 'Dr. Carlos Eduardo registrou a ocorrência OC-2026-001247', 'icone': Icons.create, 'cor': 0},
    {'hora': '14:38', 'data': '15/03/2026', 'evento': 'Fotografia anexada', 'descricao': '2 fotografias da fachada e sala principal', 'icone': Icons.camera_alt, 'cor': 1},
    {'hora': '14:45', 'data': '15/03/2026', 'evento': 'Vestígio coletado', 'descricao': 'Impressão digital na maçaneta da porta', 'icone': Icons.fingerprint, 'cor': 2},
    {'hora': '15:00', 'data': '15/03/2026', 'evento': 'Objeto apreendido', 'descricao': 'Faca de cozinha - Tramontina', 'icone': Icons.category, 'cor': 3},
    {'hora': '15:10', 'data': '15/03/2026', 'evento': 'Pessoa envolvida', 'descricao': 'José da Silva Santos - Vítima', 'icone': Icons.person, 'cor': 4},
    {'hora': '15:20', 'data': '15/03/2026', 'evento': 'Atendimento iniciado', 'descricao': 'Perícia Criminal - Dra. Ana Beatriz', 'icone': Icons.medical_services, 'cor': 5},
    {'hora': '16:00', 'data': '15/03/2026', 'evento': 'Relatório parcial', 'descricao': 'Relatório preliminar gerado', 'icone': Icons.description, 'cor': 6},
    {'hora': '16:30', 'data': '15/03/2026', 'evento': 'Ocorrência concluída', 'descricao': 'Status alterado para Concluído', 'icone': Icons.check_circle, 'cor': 7},
  ];

  @override
  Widget build(BuildContext context) {
    const cores = [PCPEColors.primary, PCPEColors.info, PCPEColors.warning, PCPEColors.success, PCPEColors.error, PCPEColors.primary, PCPEColors.info, PCPEColors.success];
    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: const PCPEHeader(title: 'Linha do Tempo', subtitle: 'OC-2026-001247 • Roubo a residência', actions: [
        IconButton(icon: Icon(Icons.filter_list), onPressed: SizedBox.shrink),
      ]),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _eventos.length,
        itemBuilder: (context, index) {
          final evento = _eventos[index];
          final isLast = index == _eventos.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 48,
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: cores[index].withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: cores[index].withValues(alpha: 0.3), width: 2),
                      ),
                      child: Icon(evento['icone'] as IconData, size: 16, color: cores[index]),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 80,
                        color: PCPEColors.lightGray.withValues(alpha: 0.4),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16, left: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: PCPEColors.pureWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: cores[index].withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('${evento['hora']} • ${evento['data']}', style: TextStyle(fontSize: 11, color: cores[index], fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(evento['evento'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PCPEColors.black)),
                      const SizedBox(height: 4),
                      Text(evento['descricao'] as String, style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}