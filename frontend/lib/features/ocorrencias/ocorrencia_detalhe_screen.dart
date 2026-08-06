import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../design_system/design_system.dart';
import '../../shared/widgets/pcpe_button.dart';

/// Tela de Visualização da Ocorrência (F28) — Modo Somente Leitura.
///
/// Exibe todos os dados da ocorrência organizados por seções.
/// Dados mockados por ocorrência — preparada para futura integração
/// com GET /ocorrencias/:id.
class OcorrenciaDetalheScreen extends StatelessWidget {
  final Map<String, dynamic> ocorrencia;

  const OcorrenciaDetalheScreen({super.key, required this.ocorrencia});

  @override
  Widget build(BuildContext context) {
    final status = ocorrencia['status'] as String;
    final ehRascunho = status == 'Rascunho';
    final ehASinc = status == 'A sincronizar';
    final ehConcluida = status == 'Concluída';
    final ehEnviada = status == 'Enviada ao SPP';
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: AppBar(
        backgroundColor: PCPEColors.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Detalhes da Ocorrência',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PCPEColors.black)),
            Text(ocorrencia['protocolo'] as String,
                style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildStatusBadge(status),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // ══════════════════════════════════════════════════
          // Resumo
          // ══════════════════════════════════════════════════
          _buildSectionCard('Resumo', Icons.summarize, children: [
            _field('Protocolo', ocorrencia['protocolo'] as String),
            _field('NIC', (ocorrencia['nic'] as String).isNotEmpty ? ocorrencia['nic'] as String : 'Não informado'),
            _field('Natureza', ocorrencia['natureza'] as String),
            _field('Data/Hora', '${ocorrencia['data']} ${ocorrencia['hora']}'),
            _field('Município', ocorrencia['municipio'] as String),
            _field('Bairro', ocorrencia['bairro'] as String),
            _field('Unidade', 'DHPP - ${ocorrencia['municipio']}'),
            _field('Agente', 'Ag. Fabio Fernandes'),
            _field('Status', status),
          ]),
          const SizedBox(height: 12),
          // ══════════════════════════════════════════════════
          // 1. Identificação
          // ══════════════════════════════════════════════════
          _buildSectionCard('Identificação', Icons.description_outlined, children: [
            _field('Protocolo', ocorrencia['protocolo'] as String),
            _field('Nº BO', ehRascunho ? 'Não informado' : 'BO-2026-${ocorrencia['protocolo']}'),
            _field('Natureza', ocorrencia['natureza'] as String),
            _field('Classificação', 'Homicídio'),
            _field('Data', ocorrencia['data'] as String),
            _field('Hora', ocorrencia['hora'] as String),
            _field('Unidade', 'DHPP - ${ocorrencia['municipio']}'),
            _field('Agente', 'Ag. Fabio Fernandes'),
          ]),
          const SizedBox(height: 12),
          // ══════════════════════════════════════════════════
          // 2. Local do Crime
          // ══════════════════════════════════════════════════
          _buildSectionCard('Local do Crime', Icons.location_on_outlined, children: [
            _field('Logradouro', 'Rua Projetada, s/n'),
            _field('Número', '88'),
            _field('Bairro', ocorrencia['bairro'] as String),
            _field('Município', ocorrencia['municipio'] as String),
            _field('UF', 'PE'),
            _field('Ponto de Referência', 'Próximo à praça central'),
            _field('Tipo do Local', 'Via Pública'),
            _field('Coordenadas', '-8.0476, -34.8770'),
            _field('Observações', 'Local com iluminação precária. Fluxo intenso de pedestres.'),
          ]),
          const SizedBox(height: 12),
          // ══════════════════════════════════════════════════
          // 3. Pessoas Envolvidas
          // ══════════════════════════════════════════════════
          _buildSectionCard('Pessoas Envolvidas', Icons.people_outline, children: [
            _buildPessoaGrupo('VÍTIMAS', [
              {'nome': ocorrencia['vitima'] as String, 'nic': ocorrencia['nic'] as String, 'sexo': 'Masculino', 'idade': '34 anos', 'cpf': '123.456.789-00'},
            ]),
            _buildPessoaGrupo('SUSPEITOS', [
              {'nome': 'Desconhecido', 'sexo': 'Masculino', 'idade': 'Aprox. 25-30 anos'},
            ]),
            _buildPessoaGrupo('TESTEMUNHAS', [
              {'nome': 'Helena Souza', 'sexo': 'Feminino', 'telefone': '(81) 99999-0001'},
            ]),
          ]),
          const SizedBox(height: 12),
          // ══════════════════════════════════════════════════
          // 4. Veículos (mock se houver)
          // ══════════════════════════════════════════════════
          _buildSectionCard('Veículos', Icons.directions_car, children: [
            _veiculoItem('ABC-1234', 'Fiat', 'Uno', 'Branco', 'Abandonado', 'Veículo encontrado com as portas abertas.'),
            _veiculoItem('DEF-5678', 'Volkswagen', 'Gol', 'Prata', 'Apreendido', ''),
          ]),
          const SizedBox(height: 12),
          // 5. Objetos
          _buildSectionCard('Objetos', Icons.inventory_2, children: [
            _objetoItem('Arma de Fogo', 'Revólver calibre .38', '1 unidade', 'Próximo ao corpo da vítima'),
            _objetoItem('Documento', 'Carteira de identidade', '1 unidade', 'No bolso da vítima'),
          ]),
          const SizedBox(height: 12),
          // 6. Vestígios
          _buildSectionCard('Vestígios', Icons.biotech, children: [
            _vestigioItem('Biológico', 'Manchas de sangue', 'Calçada em frente ao nº 88', 'Coletado por perícia'),
            _vestigioItem('Balístico', 'Estojo de munição', 'Via pública, a 2m do corpo', 'Coletado por perícia'),
          ]),
          const SizedBox(height: 12),
          // ══════════════════════════════════════════════════
          // 5 (7). Narrativa
          // ══════════════════════════════════════════════════
          _buildSectionCard('Narrativa', Icons.edit_note, children: [
            const Text(
              'No dia informado, por volta das 14h30, a equipe de plantão foi acionada via CIODS '
              'para atender ocorrência no endereço supracitado. No local, foi constatado o óbito da '
              'vítima com ferimentos compatíveis com disparo de arma de fogo. Foram realizadas as '
              'diligências iniciais, coleta de vestígios e acionamento da perícia criminal.',
              style: TextStyle(fontSize: 13, height: 1.6, color: PCPEColors.darkGray),
            ),
            const SizedBox(height: 8),
            _field('Data do Registro', '${ocorrencia['data']} ${ocorrencia['hora']}'),
            _field('Autor', 'Ag. Fabio Fernandes'),
          ]),
          const SizedBox(height: 12),
          // ══════════════════════════════════════════════════
          // 6 (8). Fotografias
          // ══════════════════════════════════════════════════
          _buildSectionCard('Fotografias', Icons.photo_camera_outlined, children: [
            Wrap(spacing: 8, runSpacing: 8, children: List.generate(4, (_) => Container(
              width: 100, height: 75,
              decoration: BoxDecoration(color: PCPEColors.cardGray, borderRadius: BorderRadius.circular(4), border: Border.all(color: PCPEColors.surfaceGray)),
              child: const Icon(Icons.image, size: 28, color: PCPEColors.lightGray),
            ))),
          ]),
          const SizedBox(height: 12),
          // ══════════════════════════════════════════════════
          // 7 (9). Histórico
          // ══════════════════════════════════════════════════
          _buildSectionCard('Histórico', Icons.timeline, children: [
            _timelineItem('Ocorrência criada', '${ocorrencia['data']} ${ocorrencia['hora']}'),
            _timelineItem('Rascunho atualizado', '${ocorrencia['data']} ${ocorrencia['hora']}'),
            if (!ehRascunho) _timelineItem('Ocorrência concluída', '${ocorrencia['data']} 18:00'),
            if (ehConcluida || ehEnviada || ehASinc) _timelineItem('Ocorrência sincronizada', '${ocorrencia['data']} 18:05'),
            if (ehConcluida || ehEnviada) _timelineItem('PDF gerado', '${ocorrencia['data']} 18:10'),
            if (ehEnviada) _timelineItem('Enviada ao SPP', '${ocorrencia['dataEnvioSpp'] ?? ocorrencia['data']} ${ocorrencia['horaEnvioSpp'] ?? '16:42'}'),
          ]),
          // ══════════════════════════════════════════════════
          // Dados do SPP (apenas Enviada ao SPP)
          // ══════════════════════════════════════════════════
          if (ehEnviada && ocorrencia['dataEnvioSpp'] != null) ...[
            const SizedBox(height: 12),
            _buildSectionCard('Dados do Envio ao SPP', Icons.send, children: [
              _field('Data do Envio', ocorrencia['dataEnvioSpp'] as String),
              _field('Hora do Envio', ocorrencia['horaEnvioSpp'] as String),
              _field('Protocolo SPP', ocorrencia['protocoloSpp'] as String),
              _field('Arquivo PDF', '${ocorrencia['protocolo']}.pdf'),
              _field('Tamanho do PDF', '2.8 MB'),
              _field('Situação', 'Enviado com sucesso'),
            ]),
          ],
          const SizedBox(height: 24),
          // ══════════════════════════════════════════════════
          // Ações conforme status
          // ══════════════════════════════════════════════════
          if (ehRascunho) ...[
            PCPEButton(label: 'Continuar preenchimento', icon: Icons.edit, fullWidth: true, height: 48, onPressed: () => context.go('/nova-ocorrencia')),
          ],
          if (ehASinc) ...[
            PCPEButton(label: 'Sincronizar', icon: Icons.sync, fullWidth: true, height: 48, onPressed: () { Navigator.of(context).pop(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sincronizar (simulado).'), backgroundColor: PCPEColors.darkGray, behavior: SnackBarBehavior.floating)); }),
            const SizedBox(height: 8),
          ],
          if (ehConcluida) ...[
            Row(children: [Expanded(child: PCPEButton(label: 'Gerar PDF', icon: Icons.picture_as_pdf_outlined, outlined: true, height: 48, onPressed: _mock)), const SizedBox(width: 8), Expanded(child: PCPEButton(label: 'Imprimir', icon: Icons.print_outlined, outlined: true, height: 48, onPressed: _mock))]),
            const SizedBox(height: 8),
            PCPEButton(label: 'Enviar ao SPP', icon: Icons.send, fullWidth: true, height: 48, onPressed: _mock),
            const SizedBox(height: 8),
          ],
          if (ehEnviada) ...[
            Row(children: [Expanded(child: PCPEButton(label: 'Gerar PDF', icon: Icons.picture_as_pdf_outlined, outlined: true, height: 48, onPressed: _mock)), const SizedBox(width: 8), Expanded(child: PCPEButton(label: 'Imprimir', icon: Icons.print_outlined, outlined: true, height: 48, onPressed: _mock))]),
          ],
          const SizedBox(height: 8),
          PCPEButton(label: 'Voltar para Central', icon: Icons.arrow_back, fullWidth: true, height: 48, outlined: true, onPressed: () => Navigator.of(context).pop()),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  void _mock() {}

  // ── Helpers ─────────────────────────────────────────────────

  Widget _buildStatusBadge(String status) {
    final Color color;
    final IconData icon;
    switch (status) {
      case 'Rascunho': color = PCPEColors.primary; icon = Icons.edit_note; break;
      case 'A sincronizar': color = PCPEColors.warning; icon = Icons.sync_problem; break;
      case 'Concluída': color = PCPEColors.success; icon = Icons.check_circle; break;
      case 'Enviada ao SPP': color = PCPEColors.primaryDark; icon = Icons.send; break;
      default: color = PCPEColors.primary; icon = Icons.circle;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.4))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: color), const SizedBox(width: 4), Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color))]),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, {required List<Widget> children}) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      color: PCPEColors.pureWhite,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: PCPEColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18, color: PCPEColors.primary)),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PCPEColors.black)),
          ]),
          const SizedBox(height: 16),
          ...children,
        ]),
      ),
    );
  }

  Widget _field(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 130, child: Text('$label:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: PCPEColors.black))),
    ]),
  );

  Widget _buildPessoaGrupo(String titulo, List<Map<String, String>> pessoas) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), decoration: BoxDecoration(color: PCPEColors.cardGray, borderRadius: BorderRadius.circular(4)), child: Text(titulo, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PCPEColors.darkGray, letterSpacing: 1))),
        const SizedBox(height: 8),
        ...pessoas.map((p) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: PCPEColors.surfaceGray), borderRadius: BorderRadius.circular(6)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p['nome']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Wrap(spacing: 16, runSpacing: 2, children: [
              if (p.containsKey('nic') && p['nic']!.isNotEmpty) _miniField('NIC', p['nic']!),
              if (p.containsKey('sexo')) _miniField('Sexo', p['sexo']!),
              if (p.containsKey('idade')) _miniField('Idade', p['idade']!),
              if (p.containsKey('cpf')) _miniField('CPF', p['cpf']!),
              if (p.containsKey('telefone')) _miniField('Tel', p['telefone']!),
            ]),
          ]),
        )),
      ]),
    );
  }

  Widget _miniField(String l, String v) => Text('$l: $v', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray));

  Widget _veiculoItem(String placa, String marca, String modelo, String cor, String situacao, String obs) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(border: Border.all(color: PCPEColors.surfaceGray), borderRadius: BorderRadius.circular(6)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$marca $modelo — $placa', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      const SizedBox(height: 2),
      Text('Cor: $cor  •  Situação: $situacao', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
      if (obs.isNotEmpty) ...[const SizedBox(height: 2), Text('Obs: $obs', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray))],
    ]),
  );

  Widget _objetoItem(String tipo, String desc, String qtd, String local) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(border: Border.all(color: PCPEColors.surfaceGray), borderRadius: BorderRadius.circular(6)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$tipo — $desc', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      Text('Quantidade: $qtd  •  Local: $local', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
    ]),
  );

  Widget _vestigioItem(String tipo, String desc, String local, String coleta) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(border: Border.all(color: PCPEColors.surfaceGray), borderRadius: BorderRadius.circular(6)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$tipo — $desc', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      Text('Local: $local  •  $coleta', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
    ]),
  );

  Widget _timelineItem(String evento, String data) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: PCPEColors.primary, shape: BoxShape.circle)),
      const SizedBox(width: 10),
      Expanded(child: Text(evento, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
      Text(data, style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
    ]),
  );
}