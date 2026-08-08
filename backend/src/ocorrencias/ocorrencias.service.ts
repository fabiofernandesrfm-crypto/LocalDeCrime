import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOcorrenciaDto, UpdateOcorrenciaDto, OcorrenciaResponseDto } from './dto/ocorrencias.dto';

@Injectable()
export class OcorrenciasService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateOcorrenciaDto, currentUser: any): Promise<OcorrenciaResponseDto> {
    if (!currentUser.unidadeId) {
      throw new BadRequestException('Usuário sem Unidade vinculada.');
    }

    const unidade = await this.prisma.unidade.findUnique({
      where: { id: currentUser.unidadeId },
      include: { delegacia: true, municipio: true },
    });

    if (!unidade) throw new BadRequestException('Unidade do usuário não encontrada.');
    if (!unidade.municipioId) throw new BadRequestException('Unidade não possui vínculo com Município.');
    if (!unidade.delegacia) throw new BadRequestException('Unidade não possui Delegacia vinculada.');

    const municipioId = unidade.municipioId;
    const delegaciaId = unidade.delegacia.id;

    // Gera numeroBo de homologacao (ano-sequencia) com retry em caso de colisao
    let numeroBo = '';
    for (let tentativa = 0; tentativa < 5; tentativa++) {
      const ano = new Date().getFullYear();
      const protoSufix = Math.random().toString(36).substring(2, 10).toUpperCase();
      numeroBo = `HML-${ano}-${protoSufix}`;
      const existente = await this.prisma.ocorrencia.findUnique({ where: { numeroBo } });
      if (!existente) break;
      if (tentativa === 4) throw new BadRequestException('Não foi possível gerar identificador. Tente novamente.');
    }

    const ocorrencia = await this.prisma.ocorrencia.create({
      data: {
        numeroBo,
        descricao: dto.descricao,
        observacoes: dto.observacoes,
        municipioId,
        delegaciaId,
        usuarioId: currentUser.id,
        status: 'ABERTA',
      },
      include: { usuario: true, municipio: true, delegacia: true },
    });

    return this.mapToResponse(ocorrencia);
  }

  // findAll / findOne / update permanecem como antes
  async findAll(currentUser: any): Promise<OcorrenciaResponseDto[]> {
    if (!currentUser.unidadeId) return [];

    const unidade = await this.prisma.unidade.findUnique({
      where: { id: currentUser.unidadeId },
      include: { delegacia: true },
    });

    if (!unidade?.delegacia) return [];

    const ocorrencias = await this.prisma.ocorrencia.findMany({
      where: { delegaciaId: unidade.delegacia.id },
      orderBy: { criadoEm: 'desc' },
      take: 50,
      include: { usuario: true, municipio: true, delegacia: true },
    });

    return ocorrencias.map((o) => this.mapToResponse(o));
  }

  async findOne(id: string, currentUser: any): Promise<OcorrenciaResponseDto> {
    const ocorrencia = await this.prisma.ocorrencia.findUnique({
      where: { id },
      include: { usuario: true, municipio: true, delegacia: true },
    });

    if (!ocorrencia) throw new NotFoundException('Ocorrência não encontrada.');

    if (currentUser.unidadeId) {
      const unidade = await this.prisma.unidade.findUnique({
        where: { id: currentUser.unidadeId },
        include: { delegacia: true },
      });
      if (unidade?.delegacia && ocorrencia.delegaciaId !== unidade.delegacia.id) {
        throw new NotFoundException('Ocorrência não encontrada.');
      }
    }

    return this.mapToResponse(ocorrencia);
  }

  async update(id: string, dto: UpdateOcorrenciaDto, currentUser: any): Promise<OcorrenciaResponseDto> {
    const ocorrencia = await this.prisma.ocorrencia.findUnique({
      where: { id },
      include: { usuario: true },
    });

    if (!ocorrencia) throw new NotFoundException('Ocorrência não encontrada.');

    if (ocorrencia.status !== 'ABERTA') {
      throw new BadRequestException('Somente rascunhos podem ser editados.');
    }

    if (currentUser.unidadeId) {
      const unidade = await this.prisma.unidade.findUnique({
        where: { id: currentUser.unidadeId },
        include: { delegacia: true },
      });
      if (unidade?.delegacia && ocorrencia.delegaciaId !== unidade.delegacia.id) {
        throw new NotFoundException('Ocorrência não encontrada.');
      }
    }

    const updated = await this.prisma.ocorrencia.update({
      where: { id },
      data: {
        ...(dto.descricao !== undefined && { descricao: dto.descricao }),
        ...(dto.observacoes !== undefined && { observacoes: dto.observacoes }),
      },
      include: { usuario: true, municipio: true, delegacia: true },
    });

    return this.mapToResponse(updated);
  }

  private mapToResponse(o: any): OcorrenciaResponseDto {
    return {
      id: o.id,
      numeroBo: o.numeroBo,
      status: o.status,
      descricao: o.descricao,
      observacoes: o.observacoes,
      dataOcorrencia: o.dataOcorrencia,
      dataConclusao: o.dataConclusao,
      criadoEm: o.criadoEm,
      usuarioId: o.usuarioId,
      municipioId: o.municipioId,
      delegaciaId: o.delegaciaId,
    };
  }
}