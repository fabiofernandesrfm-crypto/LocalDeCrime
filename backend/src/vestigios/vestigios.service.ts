import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateVestigioDto, UpdateVestigioDto, CreateMovimentacaoCustodiaDto } from './dto/vestigios.dto';
import { isOcorrenciaEditavel } from '../common/ocorrencia-helper';

@Injectable()
export class VestigiosService {
  constructor(private readonly prisma: PrismaService) {}

  // ── Vestígio ──────────────────────────────────────────────
  async create(ocorrenciaId: string, dto: CreateVestigioDto, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    this.validarMinimo(dto);
    return this.prisma.vestigioOcorrencia.create({ data: {
      categoria: dto.categoria, descricao: dto.descricao, caracteristicas: dto.caracteristicas,
      localizacaoDescricao: dto.localizacaoDescricao, gpsLat: dto.gpsLat, gpsLng: dto.gpsLng,
      coletado: dto.coletado ?? false, coletadoPor: dto.coletadoPor,
      situacao: dto.situacao, destinacao: dto.destinacao, observacoes: dto.observacoes,
      ocorrenciaId, criadoPorId: currentUser.id,
    }});
  }

  async findAll(ocorrenciaId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    return this.prisma.vestigioOcorrencia.findMany({ where: { ocorrenciaId }, orderBy: { criadoEm: 'asc' } });
  }

  async findOne(ocorrenciaId: string, vestigioId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const v = await this.prisma.vestigioOcorrencia.findFirst({ where: { id: vestigioId, ocorrenciaId } });
    if (!v) throw new NotFoundException('Vestígio não encontrado.');
    return v;
  }

  async update(ocorrenciaId: string, vestigioId: string, dto: UpdateVestigioDto, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser, true);
    const v = await this.prisma.vestigioOcorrencia.findFirst({ where: { id: vestigioId, ocorrenciaId } });
    if (!v) throw new NotFoundException('Vestígio não encontrado.');

    // Bloquear substituicao de lacre ja existente
    if (dto.numeroLacre !== undefined && v.numeroLacre && dto.numeroLacre !== v.numeroLacre) {
      throw new BadRequestException('Lacre já registrado. Substituição requer nova movimentação de custódia.');
    }

    const acondicionadoEm = (dto.acondicionado && !v.acondicionadoEm) ? new Date() : v.acondicionadoEm;
    const lacradoEm = (dto.numeroLacre && !v.lacradoEm) ? new Date() : v.lacradoEm;

    return this.prisma.vestigioOcorrencia.update({ where: { id: vestigioId }, data: {
      ...(dto.categoria !== undefined && { categoria: dto.categoria }),
      ...(dto.descricao !== undefined && { descricao: dto.descricao }),
      ...(dto.caracteristicas !== undefined && { caracteristicas: dto.caracteristicas }),
      ...(dto.localizacaoDescricao !== undefined && { localizacaoDescricao: dto.localizacaoDescricao }),
      ...(dto.gpsLat !== undefined && { gpsLat: dto.gpsLat }),
      ...(dto.gpsLng !== undefined && { gpsLng: dto.gpsLng }),
      ...(dto.coletado !== undefined && { coletado: dto.coletado }),
      ...(dto.coletadoPor !== undefined && { coletadoPor: dto.coletadoPor }),
      ...(dto.situacao !== undefined && { situacao: dto.situacao }),
      ...(dto.destinacao !== undefined && { destinacao: dto.destinacao }),
      ...(dto.observacoes !== undefined && { observacoes: dto.observacoes }),
      ...(dto.acondicionado !== undefined && { acondicionado: dto.acondicionado }),
      ...(dto.tipoAcondicionamento !== undefined && { tipoAcondicionamento: dto.tipoAcondicionamento }),
      ...(dto.descricaoAcondicionamento !== undefined && { descricaoAcondicionamento: dto.descricaoAcondicionamento }),
      ...(dto.acondicionadoPor !== undefined && { acondicionadoPor: dto.acondicionadoPor }),
      ...(dto.numeroLacre !== undefined && { numeroLacre: dto.numeroLacre }),
      ...(dto.tipoLacre !== undefined && { tipoLacre: dto.tipoLacre }),
      ...(dto.lacradoPor !== undefined && { lacradoPor: dto.lacradoPor }),
      ...(dto.acondicionado !== undefined && !v.acondicionadoEm ? { acondicionadoEm } : {}),
      ...(dto.numeroLacre !== undefined && !v.lacradoEm ? { lacradoEm } : {}),
    }});
  }

  // ── Custódia ──────────────────────────────────────────────
  async addMovimentacao(ocorrenciaId: string, vestigioId: string, dto: CreateMovimentacaoCustodiaDto, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser, false);
    const v = await this.prisma.vestigioOcorrencia.findFirst({ where: { id: vestigioId, ocorrenciaId } });
    if (!v) throw new NotFoundException('Vestígio não encontrado.');

    // Validar minimo
    if (!dto.origem && !dto.destino && !dto.entreguePor && !dto.recebidoPor && !dto.observacoes) {
      throw new BadRequestException('Informe ao menos origem, destino, responsável ou observação.');
    }

    return this.prisma.movimentacaoCustodiaVestigio.create({ data: {
      tipoMovimentacao: dto.tipoMovimentacao, origem: dto.origem, destino: dto.destino,
      entreguePor: dto.entreguePor, recebidoPor: dto.recebidoPor,
      documentoRecebedor: dto.documentoRecebedor, observacoes: dto.observacoes,
      movimentadoEm: dto.movimentadoEm ? new Date(dto.movimentadoEm) : new Date(),
      vestigioId, registradoPorId: currentUser.id,
    }});
  }

  async listHistorico(ocorrenciaId: string, vestigioId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser, false);
    const v = await this.prisma.vestigioOcorrencia.findFirst({ where: { id: vestigioId, ocorrenciaId } });
    if (!v) throw new NotFoundException('Vestígio não encontrado.');
    return this.prisma.movimentacaoCustodiaVestigio.findMany({
      where: { vestigioId },
      orderBy: [{ movimentadoEm: 'asc' }, { criadoEm: 'asc' }],
    });
  }

  // ── Helpers ───────────────────────────────────────────────
  private validarMinimo(dto: CreateVestigioDto) {
    if (!(dto.categoria && dto.categoria.trim().length > 0) && !(dto.descricao && dto.descricao.trim().length >= 3))
      throw new BadRequestException('Informe ao menos categoria ou descrição.');
  }

  private async validarOcorrencia(ocorrenciaId: string, currentUser: any, exigeAberta = false) {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade.');
    const o = await this.prisma.ocorrencia.findUnique({ where: { id: ocorrenciaId }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    const u = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!u?.delegacia || o.delegaciaId !== u.delegacia.id) throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
    if (exigeAberta && !isOcorrenciaEditavel(o.status)) throw new ConflictException('A ocorrência já foi finalizada.');
    if (!exigeAberta && o.status === 'ARQUIVADA') throw new ConflictException('A ocorrência está arquivada e não permite novas movimentações de custódia.');
  }
}