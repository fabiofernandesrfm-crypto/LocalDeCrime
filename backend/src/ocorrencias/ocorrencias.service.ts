import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOcorrenciaDto, UpdateOcorrenciaDto, OcorrenciaResponseDto, FinalizarOcorrenciaDto, ReabrirOcorrenciaDto, ArquivarOcorrenciaDto } from './dto/ocorrencias.dto';
import { isOcorrenciaEditavel } from '../common/ocorrencia-helper';

@Injectable()
export class OcorrenciasService {
  constructor(private readonly prisma: PrismaService) {}

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

  async findAll(currentUser: any) {
    if (!currentUser.unidadeId) return [];
    const u = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!u?.delegacia) return [];
    return (await this.prisma.ocorrencia.findMany({ where: { delegaciaId: u.delegacia.id }, orderBy: { criadoEm: 'desc' }, take: 50, include: { usuario: true, municipio: true, delegacia: true } })).map(o => this.mapToResponse(o));
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

  // ── Finalização com histórico imutável ────────────────────
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
      const f = await tx.ocorrencia.findUnique({ where: { id }, include: { usuario: true, municipio: true, delegacia: true } });
      return this.mapToResponse(f);
    });
  }

  // ── Reabertura com histórico imutável ─────────────────────
  async reabrir(id: string, dto: ReabrirOcorrenciaDto, currentUser: any) {
    const o = await this.prisma.ocorrencia.findUnique({ where: { id }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);
    if (o.status !== 'CONCLUIDA') throw new ConflictException('Somente ocorrências concluídas podem ser reabertas.');

    return this.prisma.$transaction(async (tx) => {
      const r = await tx.ocorrencia.updateMany({ where: { id, status: 'CONCLUIDA' }, data: { status: 'EM_INVESTIGACAO' } });
      if (r.count === 0) throw new ConflictException('A ocorrência já foi reaberta por outro usuário.');
      await tx.historicoStatusOcorrencia.create({ data: { tipo: 'REABERTURA', statusAnterior: 'CONCLUIDA', statusNovo: 'EM_INVESTIGACAO', motivo: dto.justificativa, ocorrenciaId: id, alteradoPorId: currentUser.id } });
      const f = await tx.ocorrencia.findUnique({ where: { id }, include: { usuario: true, municipio: true, delegacia: true } });
      return this.mapToResponse(f);
    });
  }

  // ── Arquivamento com histórico imutável ───────────────────
  async arquivar(id: string, dto: ArquivarOcorrenciaDto, currentUser: any) {
    const o = await this.prisma.ocorrencia.findUnique({ where: { id }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);
    if (o.status !== 'CONCLUIDA') throw new ConflictException('Somente ocorrências concluídas podem ser arquivadas.');

    return this.prisma.$transaction(async (tx) => {
      const r = await tx.ocorrencia.updateMany({ where: { id, status: 'CONCLUIDA' }, data: { status: 'ARQUIVADA' } });
      if (r.count === 0) throw new ConflictException('A ocorrência já foi arquivada por outro usuário.');
      await tx.historicoStatusOcorrencia.create({ data: { tipo: 'ARQUIVAMENTO', statusAnterior: 'CONCLUIDA', statusNovo: 'ARQUIVADA', motivo: dto.motivo, ocorrenciaId: id, alteradoPorId: currentUser.id } });
      const f = await tx.ocorrencia.findUnique({ where: { id }, include: { usuario: true, municipio: true, delegacia: true } });
      return this.mapToResponse(f);
    });
  }

  // ── GET histórico de status ───────────────────────────────
  async getHistoricoStatus(id: string, currentUser: any) {
    const o = await this.prisma.ocorrencia.findUnique({ where: { id }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    await this._validarUnidade(o, currentUser);
    return this.prisma.historicoStatusOcorrencia.findMany({
      where: { ocorrenciaId: id },
      orderBy: { alteradoEm: 'asc' },
      include: { alteradoPor: { select: { id: true, nome: true, matricula: true, cargo: true } } },
    });
  }

  // ── Helpers ───────────────────────────────────────────────
  private async _validarUnidade(o: any, currentUser: any) {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade.');
    const u = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!u?.delegacia || o.delegaciaId !== u.delegacia.id) throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
  }

  private mapToResponse(o: any): OcorrenciaResponseDto {
    return { id: o.id, numeroBo: o.numeroBo, status: o.status, descricao: o.descricao, observacoes: o.observacoes, dataOcorrencia: o.dataOcorrencia, dataConclusao: o.dataConclusao, criadoEm: o.criadoEm, usuarioId: o.usuarioId, municipioId: o.municipioId, delegaciaId: o.delegaciaId };
  }
}