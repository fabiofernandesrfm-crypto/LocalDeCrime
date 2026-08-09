import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateVestigioDto, UpdateVestigioDto } from './dto/vestigios.dto';

@Injectable()
export class VestigiosService {
  constructor(private readonly prisma: PrismaService) {}

  async create(ocorrenciaId: string, dto: CreateVestigioDto, currentUser: any) {
    await this.validar(ocorrenciaId, currentUser);
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
    await this.validar(ocorrenciaId, currentUser);
    return this.prisma.vestigioOcorrencia.findMany({ where: { ocorrenciaId }, orderBy: { criadoEm: 'asc' } });
  }

  async findOne(ocorrenciaId: string, vestigioId: string, currentUser: any) {
    await this.validar(ocorrenciaId, currentUser);
    const v = await this.prisma.vestigioOcorrencia.findFirst({ where: { id: vestigioId, ocorrenciaId } });
    if (!v) throw new NotFoundException('Vestígio não encontrado.');
    return v;
  }

  async update(ocorrenciaId: string, vestigioId: string, dto: UpdateVestigioDto, currentUser: any) {
    await this.validar(ocorrenciaId, currentUser);
    const v = await this.prisma.vestigioOcorrencia.findFirst({ where: { id: vestigioId, ocorrenciaId } });
    if (!v) throw new NotFoundException('Vestígio não encontrado.');
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
    }});
  }

  private validarMinimo(dto: CreateVestigioDto) {
    const tem = (dto.categoria && dto.categoria.trim().length > 0) || (dto.descricao && dto.descricao.trim().length >= 3);
    if (!tem) throw new BadRequestException('Informe ao menos categoria ou descrição.');
  }

  private async validar(ocorrenciaId: string, currentUser: any) {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade.');
    const o = await this.prisma.ocorrencia.findUnique({ where: { id: ocorrenciaId }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    const u = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!u?.delegacia || o.delegaciaId !== u.delegacia.id) throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
    if (o.status !== 'ABERTA') throw new BadRequestException('A ocorrência não está mais editável.');
  }
}