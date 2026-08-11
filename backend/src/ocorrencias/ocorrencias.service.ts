import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOcorrenciaDto, UpdateOcorrenciaDto, OcorrenciaResponseDto, FinalizarOcorrenciaDto, ReabrirOcorrenciaDto, ArquivarOcorrenciaDto, SearchOcorrenciasDto, PaginatedOcorrenciasDto } from './dto/ocorrencias.dto';
import { RelatorioOcorrenciaDto } from './dto/relatorio-ocorrencia.dto';
import { PendenciasResponseDto, PendenciaDto } from './dto/pendencias-ocorrencia.dto';
import { isOcorrenciaEditavel } from '../common/ocorrencia-helper';
import { LinhaTempoService } from '../linha-do-tempo/linha-tempo.service';

const VALID_STATUS = ['ABERTA', 'EM_INVESTIGACAO', 'CONCLUIDA', 'ARQUIVADA'];

@Injectable()
export class OcorrenciasService {
  constructor(private readonly prisma: PrismaService, private readonly linhaTempoService: LinhaTempoService) {}

  async create(dto: CreateOcorrenciaDto, currentUser: any): Promise<OcorrenciaResponseDto> {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade vinculada.');
    const unidade = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true, municipio: true } });
    if (!unidade) throw new BadRequestException('Unidade do usuário não encontrada.');
    if (!unidade.municipioId) throw new BadRequestException('Unidade não possui vínculo com Município.');
    if (!unidade.delegacia) throw new BadRequestException('Unidade não possui Delegacia vinculada.');

    let numeroBo = '';
    for (let t = 0; t < 5; t++) {
      const ano = new Date().getFullYear();
      numeroBo = `HML-${ano}-${Math.random().toString(36).substring(2, 10).toUpperCase()}`;
      if (!(await this.prisma.ocorrencia.findUnique({ where: { numeroBo } }))) break;
      if (t === 4) throw new BadRequestException('Não foi possível gerar identificador.');
    }

    const o = await this.prisma.ocorrencia.create({
      data: { numeroBo, descricao: dto.descricao, observacoes: dto.observacoes, municipioId: unidade.municipioId, delegaciaId: unidade.delegacia.id, usuarioId: currentUser.id, status: 'ABERTA' },
      include: { usuario: true, municipio: true, delegacia: true },
    });
    return this.mapToResponse(o);
  }

  // ── Consulta Avançada ─────────────────────────────────────
  async search(dto: SearchOcorrenciasDto, currentUser: any): Promise<PaginatedOcorrenciasDto> {
    if (!currentUser.unidadeId) return { items: [], page: dto.page || 1, pageSize: dto.pageSize || 20, total: 0, totalPages: 0 };

    const unidade = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!unidade?.delegacia) return { items: [], page: dto.page || 1, pageSize: dto.pageSize || 20, total: 0, totalPages: 0 };

    // Isolamento por Unidade (obrigatório)
    const where: any = { delegaciaId: unidade.delegacia.id };

    // Filtros opcionais
    if (dto.numeroBo) where.numeroBo = { contains: dto.numeroBo, mode: 'insensitive' };
    if (dto.status && VALID_STATUS.includes(dto.status)) where.status = dto.status;
    if (dto.delegaciaId) where.delegaciaId = dto.delegaciaId;
    if (dto.municipioId) where.municipioId = dto.municipioId;
    if (dto.usuarioId) where.usuarioId = dto.usuarioId;
    if (dto.descricao) where.descricao = { contains: dto.descricao, mode: 'insensitive' };

    // ── Busca Global Inteligente ─────────────────────────
    if (dto.q) {
      where.OR = this._buildGlobalSearchOr(dto.q);
    }

    // ── Filtros relacionais (pesquisa operacional) ─────────
    if (dto.nomePessoa || dto.cpfPessoa) {
      const pessoaFilters: any = {};
      if (dto.nomePessoa) pessoaFilters.nome = { contains: dto.nomePessoa, mode: 'insensitive' };
      if (dto.cpfPessoa) pessoaFilters.cpf = { contains: dto.cpfPessoa };
      where.pessoasEnvolvidas = { some: pessoaFilters };
    }
    if (dto.placaVeiculo) {
      where.veiculosOcorrencia = { some: { placa: { contains: dto.placaVeiculo, mode: 'insensitive' } } };
    }
    if (dto.objetoDescricao) {
      where.objetosOcorrencia = { some: { descricao: { contains: dto.objetoDescricao, mode: 'insensitive' } } };
    }
    // Filtro de Vestígio + Custódia (compostos no mesmo some)
    const filtroVestigio: any = {};
    if (dto.descricaoVestigio) filtroVestigio.descricao = { contains: dto.descricaoVestigio, mode: 'insensitive' };
    if (dto.categoriaVestigio) filtroVestigio.categoria = { contains: dto.categoriaVestigio, mode: 'insensitive' };
    if (dto.numeroLacre) filtroVestigio.numeroLacre = { contains: dto.numeroLacre, mode: 'insensitive' };
    if (dto.tipoMovimentacaoCustodia) {
      filtroVestigio.movimentacoesCustodia = { some: { tipoMovimentacao: { contains: dto.tipoMovimentacaoCustodia, mode: 'insensitive' } } };
    }
    if (Object.keys(filtroVestigio).length > 0) {
      where.vestigiosOcorrencia = { some: filtroVestigio };
    }

    if (dto.legendaFoto) {
      where.fotografiasOcorrencia = { some: { legenda: { contains: dto.legendaFoto, mode: 'insensitive' } } };
    }
    if (dto.descricaoAnexo) {
      where.anexosOcorrencia = { some: { descricao: { contains: dto.descricaoAnexo, mode: 'insensitive' } } };
    }

    // Intervalo de datas
    if (dto.dataInicial || dto.dataFinal) {
      if (dto.dataInicial && dto.dataFinal && new Date(dto.dataInicial) > new Date(dto.dataFinal)) {
        throw new BadRequestException('dataInicial não pode ser posterior a dataFinal.');
      }
      where.dataOcorrencia = {};
      if (dto.dataInicial) where.dataOcorrencia.gte = new Date(dto.dataInicial);
      if (dto.dataFinal) where.dataOcorrencia.lte = new Date(dto.dataFinal);
    }

    // Ordenação (validada pelo DTO — valor sempre seguro aqui)
    const sortBy = dto.sortBy || 'criadoEm';
    const sortOrder = dto.sortOrder === 'asc' ? 'asc' : 'desc';
    const page = dto.page || 1;
    const pageSize = dto.pageSize || 20;

    const [items, total] = await this.prisma.$transaction([
      this.prisma.ocorrencia.findMany({
        where,
        orderBy: { [sortBy]: sortOrder },
        skip: (page - 1) * pageSize,
        take: pageSize,
        include: {
          usuario: { select: { id: true, nome: true, matricula: true, cargo: true } },
          municipio: { select: { id: true, nome: true } },
          delegacia: { select: { id: true, titulo: true } },
        },
      }),
      this.prisma.ocorrencia.count({ where }),
    ]);

    return { items: items.map(o => this.mapFromSearch(o)), page, pageSize, total, totalPages: Math.ceil(total / pageSize) };
  }

  async findOne(id: string, currentUser: any) {
    const o = await this.prisma.ocorrencia.findUnique({ where: { id }, include: { usuario: true, municipio: true, delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);
    return this.mapToResponse(o);
  }

  async update(id: string, dto: UpdateOcorrenciaDto, currentUser: any) {
    const o = await this.prisma.ocorrencia.findUnique({ where: { id }, include: { usuario: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);
    if (!isOcorrenciaEditavel(o.status)) throw new ConflictException('A ocorrência já foi finalizada.');
    const u = await this.prisma.ocorrencia.update({ where: { id }, data: { ...(dto.descricao !== undefined && { descricao: dto.descricao }), ...(dto.observacoes !== undefined && { observacoes: dto.observacoes }) }, include: { usuario: true, municipio: true, delegacia: true } });
    return this.mapToResponse(u);
  }

  async finalizar(id: string, dto: FinalizarOcorrenciaDto, currentUser: any) {
    const o = await this.prisma.ocorrencia.findUnique({ where: { id }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);
    if (!isOcorrenciaEditavel(o.status)) throw new ConflictException('A ocorrência já foi finalizada.');
    const statusAnterior = o.status;
    return this.prisma.$transaction(async (tx) => {
      const r = await tx.ocorrencia.updateMany({ where: { id, status: statusAnterior }, data: { status: 'CONCLUIDA', dataConclusao: new Date(), finalizadaPorId: currentUser.id, observacoesEncerramento: dto.observacoes || null } });
      if (r.count === 0) throw new ConflictException('A ocorrência já foi finalizada por outro usuário.');
      await tx.historicoStatusOcorrencia.create({ data: { tipo: 'FINALIZACAO', statusAnterior, statusNovo: 'CONCLUIDA', motivo: dto.observacoes || null, ocorrenciaId: id, alteradoPorId: currentUser.id } });
      return this.mapToResponse(await tx.ocorrencia.findUnique({ where: { id }, include: { usuario: true, municipio: true, delegacia: true } }));
    });
  }

  async reabrir(id: string, dto: ReabrirOcorrenciaDto, currentUser: any) {
    const o = await this.prisma.ocorrencia.findUnique({ where: { id }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);
    if (o.status !== 'CONCLUIDA') throw new ConflictException('Somente ocorrências concluídas podem ser reabertas.');
    return this.prisma.$transaction(async (tx) => {
      const r = await tx.ocorrencia.updateMany({ where: { id, status: 'CONCLUIDA' }, data: { status: 'EM_INVESTIGACAO' } });
      if (r.count === 0) throw new ConflictException('A ocorrência já foi reaberta por outro usuário.');
      await tx.historicoStatusOcorrencia.create({ data: { tipo: 'REABERTURA', statusAnterior: 'CONCLUIDA', statusNovo: 'EM_INVESTIGACAO', motivo: dto.justificativa, ocorrenciaId: id, alteradoPorId: currentUser.id } });
      return this.mapToResponse(await tx.ocorrencia.findUnique({ where: { id }, include: { usuario: true, municipio: true, delegacia: true } }));
    });
  }

  async arquivar(id: string, dto: ArquivarOcorrenciaDto, currentUser: any) {
    const o = await this.prisma.ocorrencia.findUnique({ where: { id }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);
    if (o.status !== 'CONCLUIDA') throw new ConflictException('Somente ocorrências concluídas podem ser arquivadas.');
    return this.prisma.$transaction(async (tx) => {
      const r = await tx.ocorrencia.updateMany({ where: { id, status: 'CONCLUIDA' }, data: { status: 'ARQUIVADA' } });
      if (r.count === 0) throw new ConflictException('A ocorrência já foi arquivada por outro usuário.');
      await tx.historicoStatusOcorrencia.create({ data: { tipo: 'ARQUIVAMENTO', statusAnterior: 'CONCLUIDA', statusNovo: 'ARQUIVADA', motivo: dto.motivo, ocorrenciaId: id, alteradoPorId: currentUser.id } });
      return this.mapToResponse(await tx.ocorrencia.findUnique({ where: { id }, include: { usuario: true, municipio: true, delegacia: true } }));
    });
  }

  async getPendencias(id: string, currentUser: any): Promise<PendenciasResponseDto> {
    const o = await this.prisma.ocorrencia.findUnique({ where: { id }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);

    const pendencias: PendenciaDto[] = [];

    // Status não finalizado
    if (o.status === 'ABERTA' || o.status === 'EM_INVESTIGACAO') {
      pendencias.push({ codigo: 'OCORRENCIA_NAO_FINALIZADA', titulo: 'Ocorrência não concluída', descricao: 'A ocorrência ainda não foi finalizada.', criticidade: 'ALTA', categoria: 'OCORRENCIA' });
    }

    // Contagens paralelas (1 query cada)
    const [tp, tv, to_, tvt, tf, ta] = await Promise.all([
      this.prisma.pessoaEnvolvida.count({ where: { ocorrenciaId: id } }),
      this.prisma.veiculoOcorrencia.count({ where: { ocorrenciaId: id } }),
      this.prisma.objetoOcorrencia.count({ where: { ocorrenciaId: id } }),
      this.prisma.vestigioOcorrencia.count({ where: { ocorrenciaId: id } }),
      this.prisma.fotografiaOcorrencia.count({ where: { ocorrenciaId: id } }),
      this.prisma.anexoOcorrencia.count({ where: { ocorrenciaId: id } }),
    ]);

    if (tp === 0) pendencias.push({ codigo: 'SEM_PESSOA', titulo: 'Nenhuma pessoa cadastrada', descricao: 'A ocorrência não possui pessoas envolvidas registradas.', criticidade: 'MEDIA', categoria: 'PESSOA' });
    if (tv === 0) pendencias.push({ codigo: 'SEM_VEICULO', titulo: 'Nenhum veículo cadastrado', descricao: 'A ocorrência não possui veículos vinculados.', criticidade: 'BAIXA', categoria: 'VEICULO' });
    if (to_ === 0) pendencias.push({ codigo: 'SEM_OBJETO', titulo: 'Nenhum objeto cadastrado', descricao: 'A ocorrência não possui objetos vinculados.', criticidade: 'BAIXA', categoria: 'OBJETO' });
    if (tvt === 0) pendencias.push({ codigo: 'SEM_VESTIGIO', titulo: 'Nenhum vestígio cadastrado', descricao: 'A ocorrência não possui vestígios registrados.', criticidade: 'MEDIA', categoria: 'VESTIGIO' });
    if (tf === 0) pendencias.push({ codigo: 'SEM_FOTOGRAFIA', titulo: 'Nenhuma fotografia cadastrada', descricao: 'A ocorrência ainda não possui fotografias registradas.', criticidade: 'MEDIA', categoria: 'FOTOGRAFIA' });
    if (ta === 0) pendencias.push({ codigo: 'SEM_ANEXO', titulo: 'Nenhum anexo cadastrado', descricao: 'A ocorrência não possui anexos registrados.', criticidade: 'BAIXA', categoria: 'ANEXO' });

    // Vestígio coletado sem custódia
    if (tvt > 0) {
      const semCustodia = await this.prisma.vestigioOcorrencia.count({ where: { ocorrenciaId: id, coletado: true, movimentacoesCustodia: { none: {} } } });
      if (semCustodia > 0) {
        pendencias.push({ codigo: 'VESTIGIO_SEM_CUSTODIA', titulo: 'Vestígio coletado sem custódia', descricao: `${semCustodia} vestígio(s) coletado(s) sem movimentação de custódia registrada.`, criticidade: 'MEDIA', categoria: 'CUSTODIA' });
      }
    }

    // Ordenação: ALTA → MEDIA → BAIXA, estável
    const ordem = { ALTA: 0, MEDIA: 1, BAIXA: 2 };
    pendencias.sort((a, b) => ordem[a.criticidade] - ordem[b.criticidade]);

    const resumo = {
      total: pendencias.length,
      alta: pendencias.filter(p => p.criticidade === 'ALTA').length,
      media: pendencias.filter(p => p.criticidade === 'MEDIA').length,
      baixa: pendencias.filter(p => p.criticidade === 'BAIXA').length,
    };

    return { ocorrenciaId: id, numeroBo: o.numeroBo, status: o.status, resumo, pendencias };
  }

  async getRelatorio(id: string, currentUser: any): Promise<RelatorioOcorrenciaDto> {
    const o = await this.prisma.ocorrencia.findUnique({
      where: { id },
      include: { delegacia: true },
    });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);

    const [
      ocorrencia,
      pessoas,
      veiculos,
      objetos,
      vestigios,
      fotografias,
      anexos,
      historicoStatus,
    ] = await Promise.all([
      this.prisma.ocorrencia.findUnique({
        where: { id },
        include: { usuario: { select: { id: true, nome: true, matricula: true, cargo: true } }, municipio: true, delegacia: true },
      }),
      this.prisma.pessoaEnvolvida.findMany({ where: { ocorrenciaId: id }, orderBy: { criadoEm: 'asc' } }),
      this.prisma.veiculoOcorrencia.findMany({ where: { ocorrenciaId: id }, orderBy: { criadoEm: 'asc' } }),
      this.prisma.objetoOcorrencia.findMany({ where: { ocorrenciaId: id }, orderBy: { criadoEm: 'asc' } }),
      this.prisma.vestigioOcorrencia.findMany({
        where: { ocorrenciaId: id },
        orderBy: { criadoEm: 'asc' },
        include: { movimentacoesCustodia: { orderBy: { movimentadoEm: 'asc' } } },
      }),
      this.prisma.fotografiaOcorrencia.findMany({ where: { ocorrenciaId: id }, orderBy: { criadoEm: 'asc' } }),
      this.prisma.anexoOcorrencia.findMany({ where: { ocorrenciaId: id }, orderBy: { criadoEm: 'asc' } }),
      this.prisma.historicoStatusOcorrencia.findMany({
        where: { ocorrenciaId: id },
        orderBy: { alteradoEm: 'asc' },
        include: { alteradoPor: { select: { id: true, nome: true, matricula: true, cargo: true } } },
      }),
    ]);

    if (!ocorrencia) throw new NotFoundException('Erro ao carregar dados da ocorrência.');

    return {
      ocorrencia: {
        id: ocorrencia.id, numeroBo: ocorrencia.numeroBo, status: ocorrencia.status,
        descricao: ocorrencia.descricao, observacoes: ocorrencia.observacoes,
        dataOcorrencia: ocorrencia.dataOcorrencia.toISOString(),
        dataConclusao: ocorrencia.dataConclusao?.toISOString() || null,
        criadoEm: ocorrencia.criadoEm.toISOString(),
        municipio: ocorrencia.municipio ? { id: ocorrencia.municipio.id, nome: ocorrencia.municipio.nome } : null,
        delegacia: ocorrencia.delegacia ? { id: ocorrencia.delegacia.id, nome: ocorrencia.delegacia.titulo ?? ocorrencia.delegacia.id } : null,
        usuario: ocorrencia.usuario ? { id: ocorrencia.usuario.id, nome: ocorrencia.usuario.nome, matricula: ocorrencia.usuario.matricula, cargo: ocorrencia.usuario.cargo } : null,
      },
      pessoas: pessoas.map(p => ({ id: p.id, nome: p.nome, identificada: p.identificada, nic: p.nic, cpf: p.cpf, tipoEnvolvimento: p.tipoEnvolvimento, sexo: p.sexo, dataNascimento: p.dataNascimento?.toISOString() || null, telefone: p.telefone, bairro: p.bairro, criadoEm: p.criadoEm.toISOString() })),
      veiculos: veiculos.map(v => ({ id: v.id, placa: v.placa, marca: v.marca, modelo: v.modelo, ano: v.ano, cor: v.cor, situacao: v.situacao, criadoEm: v.criadoEm.toISOString() })),
      objetos: objetos.map(obj => ({ id: obj.id, categoria: obj.categoria, descricao: obj.descricao, marca: obj.marca, modelo: obj.modelo, quantidade: obj.quantidade, situacao: obj.situacao, criadoEm: obj.criadoEm.toISOString() })),
      vestigios: vestigios.map(v => ({ id: v.id, categoria: v.categoria, descricao: v.descricao, coletado: v.coletado, situacao: v.situacao, numeroLacre: v.numeroLacre, criadoEm: v.criadoEm.toISOString(), custodia: v.movimentacoesCustodia.map(c => ({ id: c.id, tipoMovimentacao: c.tipoMovimentacao, origem: c.origem, destino: c.destino, entreguePor: c.entreguePor, recebidoPor: c.recebidoPor, movimentadoEm: c.movimentadoEm.toISOString() })) })),
      fotografias: fotografias.map(f => ({ id: f.id, legenda: f.legenda, mimeType: f.mimeType, tamanhoBytes: f.tamanhoBytes, criadoEm: f.criadoEm.toISOString() })),
      anexos: anexos.map(a => ({ id: a.id, descricao: a.descricao, mimeType: a.mimeType, tamanhoBytes: a.tamanhoBytes, criadoEm: a.criadoEm.toISOString() })),
      historicoStatus: historicoStatus.map(h => ({ id: h.id, tipo: h.tipo, statusAnterior: h.statusAnterior, statusNovo: h.statusNovo, motivo: h.motivo, alteradoEm: h.alteradoEm.toISOString(), alteradoPor: h.alteradoPor })),
      linhaDoTempo: await this.linhaTempoService.getTimeline(id, currentUser),
    };
  }

  async getHistoricoStatus(id: string, currentUser: any) {
    const o = await this.prisma.ocorrencia.findUnique({ where: { id }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);
    return this.prisma.historicoStatusOcorrencia.findMany({ where: { ocorrenciaId: id }, orderBy: { alteradoEm: 'asc' }, include: { alteradoPor: { select: { id: true, nome: true, matricula: true, cargo: true } } } });
  }

  private async _validarUnidade(o: any, currentUser: any) {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade.');
    const u = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!u?.delegacia || o.delegaciaId !== u.delegacia.id) throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
  }

  private _buildGlobalSearchOr(q: string): any[] {
    return [
      { numeroBo: { contains: q, mode: 'insensitive' } },
      { descricao: { contains: q, mode: 'insensitive' } },
      { pessoasEnvolvidas: { some: { nome: { contains: q, mode: 'insensitive' } } } },
      { pessoasEnvolvidas: { some: { cpf: { contains: q } } } },
      { veiculosOcorrencia: { some: { placa: { contains: q, mode: 'insensitive' } } } },
      { objetosOcorrencia: { some: { descricao: { contains: q, mode: 'insensitive' } } } },
      { vestigiosOcorrencia: { some: { descricao: { contains: q, mode: 'insensitive' } } } },
      { vestigiosOcorrencia: { some: { numeroLacre: { contains: q, mode: 'insensitive' } } } },
      { fotografiasOcorrencia: { some: { legenda: { contains: q, mode: 'insensitive' } } } },
      { anexosOcorrencia: { some: { descricao: { contains: q, mode: 'insensitive' } } } },
    ];
  }

  private mapToResponse(o: any): OcorrenciaResponseDto {
    return { id: o.id, numeroBo: o.numeroBo, status: o.status, descricao: o.descricao, observacoes: o.observacoes, dataOcorrencia: o.dataOcorrencia, dataConclusao: o.dataConclusao, criadoEm: o.criadoEm, usuarioId: o.usuarioId, municipioId: o.municipioId, delegaciaId: o.delegaciaId };
  }

  private mapFromSearch(o: any): any {
    return {
      id: o.id, numeroBo: o.numeroBo, status: o.status,
      descricao: o.descricao?.substring?.(0, 200) || o.descricao,
      dataOcorrencia: o.dataOcorrencia, dataConclusao: o.dataConclusao, criadoEm: o.criadoEm,
      usuario: o.usuario ? { id: o.usuario.id, nome: o.usuario.nome, matricula: o.usuario.matricula, cargo: o.usuario.cargo } : null,
      municipio: o.municipio ? { id: o.municipio.id, nome: o.municipio.nome } : null,
      delegacia: o.delegacia ? { id: o.delegacia.id, nome: o.delegacia.titulo } : null,
    };
  }
}