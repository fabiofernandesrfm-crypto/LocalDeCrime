import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 9: Revisão completa da ocorrência
class Step9Revisao extends StatelessWidget {
  final OcorrenciaWizardData data;
  final void Function(int step) onEditSection;

  const Step9Revisao({
    super.key,
    required this.data,
    required this.onEditSection,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PCPECard(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PCPEColors.infoLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: PCPEColors.info, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Revise todas as informações antes de finalizar o registro.',
                          style: TextStyle(fontSize: 13, color: PCPEColors.info),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildReviewCard(
            title: 'Identificação da Ocorrência',
            icon: Icons.description_outlined,
            index: 0,
            children: [
              _buildField(context, 'Protocolo', data.numeroProtocolo),
              _buildField(context, 'Nº BO', data.numeroBO, emptyText: 'Não informado'),
              _buildField(context, 'Nº Inquérito', data.numeroInquerito, emptyText: 'Não informado'),
              _buildField(context, 'Natureza', data.natureza),
              _buildField(context, 'Tipo da Ocorrência', data.tipoOcorrencia),
              _buildField(context, 'Data', data.dataOcorrencia != null
                  ? '${data.dataOcorrencia!.day.toString().padLeft(2, '0')}/${data.dataOcorrencia!.month.toString().padLeft(2, '0')}/${data.dataOcorrencia!.year}'
                  : 'Não informada'),
              _buildField(context, 'Hora', data.horaOcorrencia != null
                  ? '${data.horaOcorrencia!.hour.toString().padLeft(2, '0')}:${data.horaOcorrencia!.minute.toString().padLeft(2, '0')}'
                  : 'Não informada'),
              _buildField(context, 'Prioridade', data.prioridade),
              _buildField(context, 'Status', data.status),
              _buildField(context, 'Diretoria', data.diretoria, emptyText: 'Não informada'),
              _buildField(context, 'Divisão', data.divisao, emptyText: 'Não informada'),
              _buildField(context, 'Unidade', data.unidadeResponsavel, emptyText: 'Não informada'),
              _buildField(context, 'Equipe', data.equipeResponsavel),
            ],
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            title: 'Local do Crime',
            icon: Icons.location_on_outlined,
            index: 1,
            children: [
              _buildField(context, 'UF', data.uf, emptyText: 'Não informado'),
              _buildField(context, 'Município', data.municipio, emptyText: 'Não informado'),
              _buildField(context, 'Bairro', data.bairro, emptyText: 'Não informado'),
              _buildField(context, 'Logradouro', data.logradouro, emptyText: 'Não informado'),
              _buildField(context, 'Número', data.numero, emptyText: 'S/N'),
              _buildField(context, 'Complemento', data.complemento, emptyText: '—'),
              _buildField(context, 'CEP', data.cep, emptyText: '—'),
              _buildField(context, 'Ponto de Referência', data.pontoReferencia, emptyText: '—'),
              _buildField(context, 'Coordenadas', data.gpsCapturado
                  ? '${data.latitude}, ${data.longitude}'
                  : 'GPS não capturado'),
            ],
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            title: 'Pessoas Envolvidas',
            icon: Icons.people_outline,
            index: 2,
            extra: data.pessoas.isEmpty
                ? const Text('Nenhuma pessoa cadastrada',
                    style: TextStyle(fontSize: 13, color: PCPEColors.mediumGray, fontStyle: FontStyle.italic))
                : Column(
                    children: data.pessoas.map((p) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: PCPEColors.cardGray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _tipoColor(p.tipo).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(p.tipo, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _tipoColor(p.tipo))),
                              ),
                              const SizedBox(width: 8),
                              Text(p.nome, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            ],
                          ),
                          if (p.cpf.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text('CPF: ${p.cpf}', style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray)),
                          ],
                        ],
                      ),
                    )).toList(),
                  ),
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            title: 'Veículos',
            icon: Icons.directions_car_outlined,
            index: 3,
            extra: data.veiculos.isEmpty
                ? const Text('Nenhum veículo cadastrado',
                    style: TextStyle(fontSize: 13, color: PCPEColors.mediumGray, fontStyle: FontStyle.italic))
                : Column(
                    children: data.veiculos.map((v) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: PCPEColors.cardGray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.directions_car, size: 18, color: PCPEColors.primary),
                          const SizedBox(width: 8),
                          Text('${v.marca} ${v.modelo}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          const Spacer(),
                          Text(v.placa, style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray)),
                        ],
                      ),
                    )).toList(),
                  ),
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            title: 'Objetos',
            icon: Icons.inventory_2_outlined,
            index: 4,
            extra: data.objetos.isEmpty
                ? const Text('Nenhum objeto cadastrado',
                    style: TextStyle(fontSize: 13, color: PCPEColors.mediumGray, fontStyle: FontStyle.italic))
                : Column(
                    children: data.objetos.map((o) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: PCPEColors.cardGray, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Text(o.descricao, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          const Spacer(),
                          Text('x${o.quantidade}', style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray)),
                        ],
                      ),
                    )).toList(),
                  ),
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            title: 'Vestígios',
            icon: Icons.biotech_outlined,
            index: 5,
            extra: data.vestigios.isEmpty
                ? const Text('Nenhum vestígio cadastrado',
                    style: TextStyle(fontSize: 13, color: PCPEColors.mediumGray, fontStyle: FontStyle.italic))
                : Column(
                    children: data.vestigios.map((v) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: PCPEColors.cardGray, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(v.coletado ? Icons.check_circle : Icons.pending, size: 16, color: v.coletado ? PCPEColors.success : PCPEColors.warning),
                          const SizedBox(width: 8),
                          Expanded(child: Text(v.descricao, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    )).toList(),
                  ),
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            title: 'Fotografias e Mídias',
            icon: Icons.photo_camera_outlined,
            index: 6,
            extra: data.midias.isEmpty
                ? const Text('Nenhuma mídia registrada',
                    style: TextStyle(fontSize: 13, color: PCPEColors.mediumGray, fontStyle: FontStyle.italic))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${data.midias.length} mídia(s) registrada(s)',
                          style: const TextStyle(fontSize: 13, color: PCPEColors.success, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      ...data.midias.map((m) => Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: PCPEColors.cardGray,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(m.tipoIcon, size: 14, color: m.placeholderColor),
                            const SizedBox(width: 8),
                            Text(m.legenda.isNotEmpty ? m.legenda : m.tipoLabel,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                            const Spacer(),
                            Text(m.tipoLabel,
                                style: TextStyle(fontSize: 11, color: m.placeholderColor)),
                          ],
                        ),
                      )),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            title: 'Narrativa',
            icon: Icons.edit_note,
            index: 7,
            children: [
              if (data.narrativa.isNotEmpty)
                Text(data.narrativa, style: const TextStyle(fontSize: 13, height: 1.5, color: PCPEColors.darkGray), maxLines: 5, overflow: TextOverflow.ellipsis)
              else
                const Text('Narrativa não preenchida', style: TextStyle(fontSize: 13, color: PCPEColors.mediumGray, fontStyle: FontStyle.italic)),
              const SizedBox(height: 10),
              const Text('Providências:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: PCPEColors.black)),
              const SizedBox(height: 4),
              if (data.providenciasAdotadas.isNotEmpty)
                Text(data.providenciasAdotadas, style: const TextStyle(fontSize: 13, height: 1.5, color: PCPEColors.darkGray), maxLines: 3, overflow: TextOverflow.ellipsis)
              else
                const Text('Não informadas', style: TextStyle(fontSize: 13, color: PCPEColors.mediumGray, fontStyle: FontStyle.italic)),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String title,
    required IconData icon,
    required int index,
    List<Widget>? children,
    Widget? extra,
  }) {
    return PCPECard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PCPEColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: PCPEColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: PCPEColors.black,
                  ),
                ),
              ),
              PCPEButton(
                label: 'Editar',
                icon: Icons.edit,
                small: true,
                outlined: true,
                onPressed: () => onEditSection(index),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (children != null)
            ...children.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: c,
                )),
          if (extra != null) extra,
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, String label, String value, {String emptyText = '—'}) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final display = value.isNotEmpty ? value : emptyText;
    final isEmpty = value.isEmpty;
    final labelWidth = isMobile ? 95.0 : 120.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: PCPEColors.mediumGray,
            ),
          ),
        ),
        Expanded(
          child: Text(
            display,
            style: TextStyle(
              fontSize: 13,
              color: isEmpty ? PCPEColors.lightGray : PCPEColors.black,
              fontWeight: isEmpty ? FontWeight.normal : FontWeight.w500,
              fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }

  Color _tipoColor(String tipo) {
    switch (tipo) {
      case 'Vítima':
        return PCPEColors.error;
      case 'Suspeito':
        return PCPEColors.warning;
      case 'Testemunha':
        return PCPEColors.info;
      case 'Comunicante':
        return PCPEColors.success;
      default:
        return PCPEColors.mediumGray;
    }
  }
}