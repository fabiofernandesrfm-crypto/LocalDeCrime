import {
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  CreateAtendimentoDto,
  UpdateAtendimentoDto,
  AtendimentoResponseDto,
} from './dto/atendimentos.dto';

@Injectable()
export class AtendimentosService {
  constructor(private readonly prisma: PrismaService) {}

  async create(
    dto: CreateAtendimentoDto,
    usuarioId: string,
  ): Promise<AtendimentoResponseDto> {
    const atendimento = await this.prisma.atendimentoLocal.create({
      data: {
        ...dto,
        usuarioId,
      },
      include: {
        usuario: true,
      },
    });

    return this.mapToResponse(atendimento);
  }

  async findAll(page = 1, limit = 20): Promise<AtendimentoResponseDto[]> {
    const atendimentos = await this.prisma.atendimentoLocal.findMany({
      skip: (page - 1) * limit,
      take: limit,
      orderBy: { criadoEm: 'desc' },
      include: {
        usuario: true,
      },
    });

    return atendimentos.map((a) => this.mapToResponse(a));
  }

  async findOne(id: string): Promise<AtendimentoResponseDto> {
    const atendimento = await this.prisma.atendimentoLocal.findUnique({
      where: { id },
      include: {
        usuario: true,
      },
    });

    if (!atendimento) {
      throw new NotFoundException('Atendimento não encontrado.');
    }

    return this.mapToResponse(atendimento);
  }

  async update(
    id: string,
    dto: UpdateAtendimentoDto,
  ): Promise<AtendimentoResponseDto> {
    await this.findOne(id);

    const atendimento = await this.prisma.atendimentoLocal.update({
      where: { id },
      data: dto,
      include: {
        usuario: true,
      },
    });

    return this.mapToResponse(atendimento);
  }

  async remove(id: string): Promise<void> {
    await this.findOne(id);

    await this.prisma.atendimentoLocal.delete({
      where: { id },
    });
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