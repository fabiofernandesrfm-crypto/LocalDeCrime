import 'package:flutter/material.dart';
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
              _buildField('Protocolo', data.numeroProtocolo),
              _buildField('Nº BO', data.numeroBO, emptyText: 'Não informado'),
              _buildField('Nº Inquérito', data.numeroInquerito, emptyText: 'Não informado'),
              _buildField('Natureza', data.natureza),
              _buildField('Tipo da Ocorrência', data.tipoOcorrencia),
              _buildField('Data', data.dataOcorrencia != null
                  ? '${data.dataOcorrencia!.day.toString().padLeft(2, '0')}/${data.dataOcorrencia!.month.toString().padLeft(2, '0')}/${data.dataOcorrencia!.year}'
                  : 'Não informada'),
              _buildField('Hora', data.horaOcorrencia != null
                  ? '${data.horaOcorrencia!.hour.toString().padLeft(2, '0')}:${data.horaOcorrencia!.minute.toString().padLeft(2, '0')}'
                  : 'Não informada'),
              _buildField('Prioridade', data.prioridade),
              _buildField('Status', data.status),
              _buildField('Unidade', data.unidadeResponsavel),
              _buildField('Equipe', data.equipeResponsavel),
            ],
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            title: 'Local do Crime',
            icon: Icons.location_on_outlined,
            index: 1,
            children: [
              _buildField('UF', data.uf, emptyText: 'Não informado'),
              _buildField('Município', data.municipio, emptyText: 'Não informado'),
              _buildField('Bairro', data.bairro, emptyText: 'Não informado'),
              _buildField('Logradouro', data.logradouro, emptyText: 'Não informado'),
              _buildField('Número', data.numero, emptyText: 'S/N'),
              _buildField('Complemento', data.complemento, emptyText: '—'),
              _buildField('CEP', data.cep, emptyText: '—'),
              _buildField('Ponto de Referência', data.pontoReferencia, emptyText: '—'),
              _buildField('Coordenadas', data.gpsCapturado
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
            title: 'Fotografias',
            icon: Icons.photo_camera_outlined,
            index: 6,
            extra: data.fotografias.isEmpty
                ? const Text('Nenhuma fotografia registrada',
                    style: TextStyle(fontSize: 13, color: PCPEColors.mediumGray, fontStyle: FontStyle.italic))
                : Text('${data.fotografias.length} fotografia(s) registrada(s)',
                    style: const TextStyle(fontSize: 13, color: PCPEColors.success, fontWeight: FontWeight.w600)),
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

  Widget _buildField(String label, String value, {String emptyText = '—'}) {
    final display = value.isNotEmpty ? value : emptyText;
    final isEmpty = value.isEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
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