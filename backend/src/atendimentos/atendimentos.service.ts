import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAtendimentoDto, UpdateAtendimentoDto, AtendimentoResponseDto } from './dto/atendimentos.dto';

@Injectable()
export class AtendimentosService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateAtendimentoDto, currentUser: any): Promise<AtendimentoResponseDto> {
    if (!currentUser.unidadeId) {
      throw new BadRequestException('Usuário não possui Unidade vinculada. Não é possível criar ocorrência.');
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
    if (!currentUser.unidadeId) {
      return [];
    }

    const atendimentos = await this.prisma.atendimentoLocal.findMany({
      where: {
        usuario: { unidadeId: currentUser.unidadeId },
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
      include: { usuario: true },
    });

    if (!atendimento) {
      throw new NotFoundException('Atendimento não encontrado.');
    }

    // Isolamento por Unidade
    if (currentUser.unidadeId && atendimento.usuario?.unidadeId !== currentUser.unidadeId) {
      throw new NotFoundException('Atendimento não encontrado.');
    }

    return this.mapToResponse(atendimento);
  }

  async update(id: string, dto: UpdateAtendimentoDto, currentUser: any): Promise<AtendimentoResponseDto> {
    const atendimento = await this.prisma.atendimentoLocal.findUnique({
      where: { id },
      include: { usuario: true },
    });

    if (!atendimento) {
      throw new NotFoundException('Atendimento não encontrado.');
    }

    // Isolamento por Unidade
    if (currentUser.unidadeId && atendimento.usuario?.unidadeId !== currentUser.unidadeId) {
      throw new NotFoundException('Atendimento não encontrado.');
    }

    // Somente rascunhos são editáveis
    if (atendimento.status !== 'ABERTO') {
      throw new BadRequestException('Somente atendimentos em Rascunho (ABERTO) podem ser editados.');
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