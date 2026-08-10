import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAtendimentoDto, UpdateAtendimentoDto, AtendimentoResponseDto } from './dto/atendimentos.dto';
import { isOcorrenciaEditavel } from '../common/ocorrencia-helper';

@Injectable()
export class AtendimentosService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateAtendimentoDto, currentUser: any): Promise<AtendimentoResponseDto> {
    if (!currentUser.unidadeId) {
      throw new BadRequestException('Usuário não possui Unidade vinculada.');
    }

    // 1. Buscar Ocorrencia pai e validar que pertence a mesma Unidade
    const ocorrencia = await this.prisma.ocorrencia.findUnique({
      where: { id: dto.ocorrenciaId },
      include: { delegacia: true },
    });

    if (!ocorrencia) {
      throw new NotFoundException('Ocorrência não encontrada.');
    }

    // Validar que a Ocorrencia pertence a mesma Unidade (via Delegacia)
    const unidade = await this.prisma.unidade.findUnique({
      where: { id: currentUser.unidadeId },
      include: { delegacia: true },
    });

    if (!unidade?.delegacia || ocorrencia.delegaciaId !== unidade.delegacia.id) {
      throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
    }

    const atendimento = await this.prisma.atendimentoLocal.create({
      data: {
        tipoLocal: dto.tipoLocal,
        endereco: dto.endereco,
        bairro: dto.bairro,
        cidade: dto.cidade,
        descricao: dto.descricao,
        numero: dto.numero,
        complemento: dto.complemento,
        estado: dto.estado ?? 'PE',
        cep: dto.cep,
        latitude: dto.latitude,
        longitude: dto.longitude,
        observacoes: dto.observacoes,
        ocorrenciaId: dto.ocorrenciaId,
        usuarioId: currentUser.id,
        status: 'ABERTO',
      },
      include: { usuario: true },
    });

    return this.mapToResponse(atendimento);
  }

  async findAll(currentUser: any): Promise<AtendimentoResponseDto[]> {
    if (!currentUser.unidadeId) return [];

    const unidade = await this.prisma.unidade.findUnique({
      where: { id: currentUser.unidadeId },
      include: { delegacia: true },
    });

    if (!unidade?.delegacia) return [];

    // Filtrar atendimentos cuja Ocorrencia pertence a mesma Delegacia
    const atendimentos = await this.prisma.atendimentoLocal.findMany({
      where: {
        ocorrencia: { delegaciaId: unidade.delegacia.id },
      },
      orderBy: { criadoEm: 'desc' },
      take: 50,
      include: { usuario: true },
    });

    return atendimentos.map((a) => this.mapToResponse(a));
  }

  async findOne(id: string, currentUser: any): Promise<AtendimentoResponseDto> {
    const atendimento = await this.prisma.atendimentoLocal.findUnique({
      where: { id },
      include: { usuario: true, ocorrencia: { include: { delegacia: true } } },
    });

    if (!atendimento) {
      throw new NotFoundException('Atendimento não encontrado.');
    }

    // Isolamento: Atendimento → Ocorrencia → Delegacia → Unidade do usuario
    if (currentUser.unidadeId) {
      const unidade = await this.prisma.unidade.findUnique({
        where: { id: currentUser.unidadeId },
        include: { delegacia: true },
      });
      if (unidade?.delegacia && atendimento.ocorrencia?.delegaciaId !== unidade.delegacia.id) {
        throw new NotFoundException('Atendimento não pertence à sua Unidade.');
      }
    }

    return this.mapToResponse(atendimento);
  }

  async update(id: string, dto: UpdateAtendimentoDto, currentUser: any): Promise<AtendimentoResponseDto> {
    const atendimento = await this.prisma.atendimentoLocal.findUnique({
      where: { id },
      include: { usuario: true, ocorrencia: { include: { delegacia: true } } },
    });

    if (!atendimento) throw new NotFoundException('Atendimento não encontrado.');

    // Isolamento por Unidade
    if (currentUser.unidadeId) {
      const unidade = await this.prisma.unidade.findUnique({
        where: { id: currentUser.unidadeId },
        include: { delegacia: true },
      });
      if (unidade?.delegacia && atendimento.ocorrencia?.delegaciaId !== unidade.delegacia.id) {
        throw new NotFoundException('Atendimento não pertence à sua Unidade.');
      }
    }

    // Somente rascunhos sao editaveis
    if (atendimento.status !== 'ABERTO') {
      throw new BadRequestException('Somente atendimentos em Rascunho (ABERTO) podem ser editados.');
    }

    // Ocorrencia pai tambem deve estar editavel
    if (atendimento.ocorrencia?.status && !isOcorrenciaEditavel(atendimento.ocorrencia.status)) {
      throw new ConflictException('A Ocorrência vinculada já foi finalizada.');
    }

    const updated = await this.prisma.atendimentoLocal.update({
      where: { id },
      data: {
        ...(dto.status !== undefined && { status: dto.status }),
        ...(dto.observacoes !== undefined && { observacoes: dto.observacoes }),
      },
      include: { usuario: true },
    });

    return this.mapToResponse(updated);
  }

  private mapToResponse(a: any): AtendimentoResponseDto {
    return {
      id: a.id,
      numeroRegistro: a.numeroRegistro,
      status: a.status,
      tipoLocal: a.tipoLocal,
      endereco: a.endereco,
      numero: a.numero,
      complemento: a.complemento,
      bairro: a.bairro,
      cidade: a.cidade,
      estado: a.estado,
      cep: a.cep,
      latitude: a.latitude,
      longitude: a.longitude,
      descricao: a.descricao,
      observacoes: a.observacoes,
      dataOcorrencia: a.dataOcorrencia,
      dataConclusao: a.dataConclusao,
      criadoEm: a.criadoEm,
      usuarioId: a.usuarioId,
    };
  }
}