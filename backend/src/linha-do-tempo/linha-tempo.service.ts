import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { TimelineEventDto } from './dto/linha-do-tempo.dto';

@Injectable()
export class LinhaTempoService {
  constructor(private readonly prisma: PrismaService) {}

  async getTimeline(ocorrenciaId: string, currentUser: any, query?: { categoria?: string; ordem?: string }): Promise<TimelineEventDto[]> {
    await this.validarOcorrencia(ocorrenciaId, currentUser);

    const ocorrencia = await this.prisma.ocorrencia.findUnique({
      where: { id: ocorrenciaId },
      include: { usuario: { select: { id: true, nome: true, matricula: true, cargo: true } }, finalizadaPor: { select: { id: true, nome: true, matricula: true, cargo: true } } },
    });
    if (!ocorrencia) throw new NotFoundException('Ocorrência não encontrada.');

    const categoriasFiltro = query?.categoria ? query.categoria.split(',') : null;
    const ordem = query?.ordem === 'desc' ? 'desc' : 'asc';

    const eventos: TimelineEventDto[] = [];

    // ── Ocorrência + Histórico de Status ────────────────────
    eventos.push(this._mapOcorrencia(ocorrencia));

    const historico = await this.prisma.historicoStatusOcorrencia.findMany({
      where: { ocorrenciaId },
      orderBy: { alteradoEm: 'asc' },
      include: { alteradoPor: { select: { id: true, nome: true, matricula: true, cargo: true } } },
    });
    const temFinalizacaoNoHistorico = historico.some(h => h.tipo === 'FINALIZACAO');

    for (const h of historico) {
      let tipoEvento: string; let titulo: string;
      if (h.tipo === 'FINALIZACAO') { tipoEvento = 'OCORRENCIA_FINALIZADA'; titulo = 'Ocorrência finalizada'; }
      else if (h.tipo === 'REABERTURA') { tipoEvento = 'OCORRENCIA_REABERTA'; titulo = 'Ocorrência reaberta'; }
      else { tipoEvento = 'OCORRENCIA_ARQUIVADA'; titulo = 'Ocorrência arquivada'; }
      eventos.push({
        id: `hist-${h.id}`, tipo: tipoEvento, categoria: 'OCORRENCIA', titulo,
        descricao: h.motivo || null, dataHora: h.alteradoEm.toISOString(),
        entidadeId: ocorrencia.id, entidadeTipo: 'OCORRENCIA',
        usuario: h.alteradoPor ? { id: h.alteradoPor.id, nome: h.alteradoPor.nome, matricula: h.alteradoPor.matricula, cargo: h.alteradoPor.cargo } : null,
        metadata: { statusAnterior: h.statusAnterior, statusNovo: h.statusNovo, motivo: h.motivo },
      });
    }

    // Fallback legado
    if (!temFinalizacaoNoHistorico && ocorrencia.dataConclusao && ocorrencia.status === 'CONCLUIDA') {
      eventos.push({
        id: `legacy-finalizada-${ocorrencia.id}`, tipo: 'OCORRENCIA_FINALIZADA', categoria: 'OCORRENCIA',
        titulo: 'Ocorrência finalizada (legado)', descricao: ocorrencia.observacoesEncerramento || null,
        dataHora: ocorrencia.dataConclusao.toISOString(), entidadeId: ocorrencia.id, entidadeTipo: 'OCORRENCIA',
        usuario: ocorrencia.finalizadaPor ? { id: ocorrencia.finalizadaPor.id, nome: ocorrencia.finalizadaPor.nome, matricula: ocorrencia.finalizadaPor.matricula, cargo: ocorrencia.finalizadaPor.cargo } : null,
        metadata: { status: ocorrencia.status, legacy: true },
      });
    }

    // ── Pessoas ──────────────────────────────────────────────
    const pessoas = await this.prisma.pessoaEnvolvida.findMany({
      where: { ocorrenciaId },
      select: { id: true, nome: true, tipoEnvolvimento: true, identificada: true, nic: true, criadoEm: true },
      orderBy: { criadoEm: 'asc' },
    });
    for (const p of pessoas) {
      eventos.push({
        id: `pessoa-${p.id}`, tipo: 'PESSOA_ADICIONADA', categoria: 'PESSOA',
        titulo: p.nome || 'Pessoa não identificada', descricao: `${p.tipoEnvolvimento}${p.identificada ? '' : ' (não identificada)'}`,
        dataHora: p.criadoEm.toISOString(), entidadeId: p.id, entidadeTipo: 'PESSOA', usuario: null,
        metadata: { tipoEnvolvimento: p.tipoEnvolvimento, identificada: p.identificada, nic: p.nic },
      });
    }

    // ── Veículos, Objetos, Vestígios, Custódia, Fotos, Anexos ─ (código real preservado)
    const veiculos = await this.prisma.veiculoOcorrencia.findMany({
      where: { ocorrenciaId },
      select: { id: true, placa: true, marca: true, modelo: true, situacao: true, criadoEm: true, criadoPor: { select: { id: true, nome: true, matricula: true, cargo: true } } },
      orderBy: { criadoEm: 'asc' },
    });
    for (const v of veiculos) {
      eventos.push({
        id: `veiculo-${v.id}`, tipo: 'VEICULO_ADICIONADO', categoria: 'VEICULO',
        titulo: v.placa || `${v.marca || ''} ${v.modelo || ''}`.trim() || 'Veículo', descricao: v.situacao || null,
        dataHora: v.criadoEm.toISOString(), entidadeId: v.id, entidadeTipo: 'VEICULO',
        usuario: v.criadoPor ? { id: v.criadoPor.id, nome: v.criadoPor.nome, matricula: v.criadoPor.matricula, cargo: v.criadoPor.cargo } : null,
        metadata: { placa: v.placa, marca: v.marca, modelo: v.modelo },
      });
    }

    const objetos = await this.prisma.objetoOcorrencia.findMany({
      where: { ocorrenciaId },
      select: { id: true, categoria: true, descricao: true, marca: true, modelo: true, quantidade: true, criadoEm: true, criadoPor: { select: { id: true, nome: true, matricula: true, cargo: true } } },
      orderBy: { criadoEm: 'asc' },
    });
    for (const o of objetos) {
      eventos.push({
        id: `objeto-${o.id}`, tipo: 'OBJETO_ADICIONADO', categoria: 'OBJETO',
        titulo: o.descricao || o.categoria || 'Objeto', descricao: o.marca && o.modelo ? `${o.marca} ${o.modelo} (x${o.quantidade})` : `Quantidade: ${o.quantidade}`,
        dataHora: o.criadoEm.toISOString(), entidadeId: o.id, entidadeTipo: 'OBJETO',
        usuario: o.criadoPor ? { id: o.criadoPor.id, nome: o.criadoPor.nome, matricula: o.criadoPor.matricula, cargo: o.criadoPor.cargo } : null,
        metadata: { categoria: o.categoria, marca: o.marca, modelo: o.modelo, quantidade: o.quantidade },
      });
    }

    const vestigios = await this.prisma.vestigioOcorrencia.findMany({
      where: { ocorrenciaId },
      select: { id: true, categoria: true, descricao: true, coletado: true, situacao: true, criadoEm: true, acondicionado: true, acondicionadoEm: true, numeroLacre: true, lacradoEm: true, criadoPor: { select: { id: true, nome: true, matricula: true, cargo: true } } },
      orderBy: { criadoEm: 'asc' },
    });
    for (const v of vestigios) {
      eventos.push({
        id: `vestigio-${v.id}`, tipo: 'VESTIGIO_ADICIONADO', categoria: 'VESTIGIO',
        titulo: v.categoria || v.descricao || 'Vestígio', descricao: v.coletado ? 'Coletado' : 'Não coletado',
        dataHora: v.criadoEm.toISOString(), entidadeId: v.id, entidadeTipo: 'VESTIGIO',
        usuario: v.criadoPor ? { id: v.criadoPor.id, nome: v.criadoPor.nome, matricula: v.criadoPor.matricula, cargo: v.criadoPor.cargo } : null,
        metadata: { categoria: v.categoria, descricao: v.descricao, coletado: v.coletado, situacao: v.situacao },
      });
      if (v.acondicionado && v.acondicionadoEm) {
        eventos.push({ id: `acond-${v.id}`, tipo: 'VESTIGIO_ACONDICIONADO', categoria: 'VESTIGIO', titulo: 'Vestígio acondicionado', descricao: v.descricao || v.categoria || null, dataHora: v.acondicionadoEm.toISOString(), entidadeId: v.id, entidadeTipo: 'VESTIGIO', usuario: null, metadata: null });
      }
      if (v.numeroLacre && v.lacradoEm) {
        eventos.push({ id: `lacre-${v.id}`, tipo: 'VESTIGIO_LACRADO', categoria: 'VESTIGIO', titulo: `Lacre ${v.numeroLacre}`, descricao: v.descricao || v.categoria || null, dataHora: v.lacradoEm.toISOString(), entidadeId: v.id, entidadeTipo: 'VESTIGIO', usuario: null, metadata: { numeroLacre: v.numeroLacre } });
      }
    }

    const custodiaList = await this.prisma.movimentacaoCustodiaVestigio.findMany({
      where: { vestigio: { ocorrenciaId } },
      include: { registradoPor: { select: { id: true, nome: true, matricula: true, cargo: true } }, vestigio: { select: { id: true, descricao: true, categoria: true } } },
      orderBy: { movimentadoEm: 'asc' },
    });
    for (const c of custodiaList) {
      eventos.push({
        id: `custodia-${c.id}`, tipo: 'CUSTODIA_MOVIMENTADA', categoria: 'CUSTODIA',
        titulo: c.tipoMovimentacao, descricao: [c.origem, c.destino].filter(Boolean).join(' → ') || null,
        dataHora: c.movimentadoEm.toISOString(), entidadeId: c.id, entidadeTipo: 'CUSTODIA',
        usuario: c.registradoPor ? { id: c.registradoPor.id, nome: c.registradoPor.nome, matricula: c.registradoPor.matricula, cargo: c.registradoPor.cargo } : null,
        metadata: { vestigioId: c.vestigio.id, vestigio: c.vestigio.descricao || c.vestigio.categoria },
      });
    }

    const fotos = await this.prisma.fotografiaOcorrencia.findMany({
      where: { ocorrenciaId },
      select: { id: true, legenda: true, mimeType: true, pessoaId: true, veiculoId: true, objetoId: true, vestigioId: true, criadoEm: true, criadoPor: { select: { id: true, nome: true, matricula: true, cargo: true } } },
      orderBy: { criadoEm: 'asc' },
    });
    for (const f of fotos) {
      eventos.push({
        id: `foto-${f.id}`, tipo: 'FOTOGRAFIA_ADICIONADA', categoria: 'FOTOGRAFIA',
        titulo: f.legenda || 'Fotografia', descricao: null,
        dataHora: f.criadoEm.toISOString(), entidadeId: f.id, entidadeTipo: 'FOTOGRAFIA',
        usuario: f.criadoPor ? { id: f.criadoPor.id, nome: f.criadoPor.nome, matricula: f.criadoPor.matricula, cargo: f.criadoPor.cargo } : null,
        metadata: { mimeType: f.mimeType, pessoaId: f.pessoaId, veiculoId: f.veiculoId, objetoId: f.objetoId, vestigioId: f.vestigioId },
      });
    }

    const anexos = await this.prisma.anexoOcorrencia.findMany({
      where: { ocorrenciaId },
      select: { id: true, categoria: true, descricao: true, mimeType: true, arquivoOriginalNome: true, criadoEm: true, criadoPor: { select: { id: true, nome: true, matricula: true, cargo: true } } },
      orderBy: { criadoEm: 'asc' },
    });
    for (const a of anexos) {
      eventos.push({
        id: `anexo-${a.id}`, tipo: 'ANEXO_ADICIONADO', categoria: 'ANEXO',
        titulo: a.descricao || a.categoria || 'Anexo', descricao: a.arquivoOriginalNome,
        dataHora: a.criadoEm.toISOString(), entidadeId: a.id, entidadeTipo: 'ANEXO',
        usuario: a.criadoPor ? { id: a.criadoPor.id, nome: a.criadoPor.nome, matricula: a.criadoPor.matricula, cargo: a.criadoPor.cargo } : null,
        metadata: { categoria: a.categoria, mimeType: a.mimeType },
      });
    }

    let resultado = eventos.sort((a, b) => a.dataHora.localeCompare(b.dataHora));
    if (ordem === 'desc') resultado = resultado.reverse();
    if (categoriasFiltro) resultado = resultado.filter(e => categoriasFiltro.includes(e.categoria));
    return resultado;
  }

  private async validarOcorrencia(ocorrenciaId: string, currentUser: any) {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade.');
    const o = await this.prisma.ocorrencia.findUnique({ where: { id: ocorrenciaId }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    const u = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!u?.delegacia || o.delegaciaId !== u.delegacia.id) throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
  }

  private _mapOcorrencia(o: any): TimelineEventDto {
    return {
      id: `ocorrencia-${o.id}`, tipo: 'OCORRENCIA_CRIADA', categoria: 'OCORRENCIA',
      titulo: 'Ocorrência registrada', descricao: o.numeroBo,
      dataHora: o.criadoEm.toISOString(), entidadeId: o.id, entidadeTipo: 'OCORRENCIA',
      usuario: o.usuario ? { id: o.usuario.id, nome: o.usuario.nome, matricula: o.usuario.matricula, cargo: o.usuario.cargo } : null,
      metadata: { numeroBo: o.numeroBo, status: o.status, dataDoFato: o.dataOcorrencia?.toISOString() || null },
    };
  }
}