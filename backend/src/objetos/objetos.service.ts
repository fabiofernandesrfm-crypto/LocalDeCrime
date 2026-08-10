import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateObjetoDto, UpdateObjetoDto } from './dto/objetos.dto';
import { isOcorrenciaEditavel } from '../common/ocorrencia-helper';

@Injectable()
export class ObjetosService {
  constructor(private readonly prisma: PrismaService) {}

  async create(ocorrenciaId: string, dto: CreateObjetoDto, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    this.validarMinimo(dto);

    // validar pessoaId se informado
    if (dto.pessoaId) {
      await this.validarPessoa(ocorrenciaId, dto.pessoaId);
    }

    return this.prisma.objetoOcorrencia.create({ data: {
      categoria: dto.categoria, descricao: dto.descricao, marca: dto.marca,
      modelo: dto.modelo, numeroSerie: dto.numeroSerie,
      quantidade: dto.quantidade ?? 1, caracteristicas: dto.caracteristicas,
      situacao: dto.situacao, destinacao: dto.destinacao,
      coletadoPor: dto.coletadoPor, destinatario: dto.destinatario,
      docDestinatario: dto.docDestinatario, vinculoDest: dto.vinculoDest,
      gpsLat: dto.gpsLat, gpsLng: dto.gpsLng,
      observacoes: dto.observacoes,
      ocorrenciaId, criadoPorId: currentUser.id,
      pessoaId: dto.pessoaId ?? null,
    }});
  }

  async findAll(ocorrenciaId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    return this.prisma.objetoOcorrencia.findMany({ where: { ocorrenciaId }, orderBy: { criadoEm: 'asc' } });
  }

  async findOne(ocorrenciaId: string, objetoId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const obj = await this.prisma.objetoOcorrencia.findFirst({ where: { id: objetoId, ocorrenciaId } });
    if (!obj) throw new NotFoundException('Objeto não encontrado.');
    return obj;
  }

  async update(ocorrenciaId: string, objetoId: string, dto: UpdateObjetoDto, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const obj = await this.prisma.objetoOcorrencia.findFirst({ where: { id: objetoId, ocorrenciaId } });
    if (!obj) throw new NotFoundException('Objeto não encontrado.');

    if (dto.pessoaId !== undefined && dto.pessoaId !== null) {
      await this.validarPessoa(ocorrenciaId, dto.pessoaId);
    }

    return this.prisma.objetoOcorrencia.update({ where: { id: objetoId }, data: {
      ...(dto.categoria !== undefined && { categoria: dto.categoria }),
      ...(dto.descricao !== undefined && { descricao: dto.descricao }),
      ...(dto.marca !== undefined && { marca: dto.marca }),
      ...(dto.modelo !== undefined && { modelo: dto.modelo }),
      ...(dto.numeroSerie !== undefined && { numeroSerie: dto.numeroSerie }),
      ...(dto.quantidade !== undefined && { quantidade: dto.quantidade }),
      ...(dto.caracteristicas !== undefined && { caracteristicas: dto.caracteristicas }),
      ...(dto.situacao !== undefined && { situacao: dto.situacao }),
      ...(dto.destinacao !== undefined && { destinacao: dto.destinacao }),
      ...(dto.coletadoPor !== undefined && { coletadoPor: dto.coletadoPor }),
      ...(dto.destinatario !== undefined && { destinatario: dto.destinatario }),
      ...(dto.docDestinatario !== undefined && { docDestinatario: dto.docDestinatario }),
      ...(dto.vinculoDest !== undefined && { vinculoDest: dto.vinculoDest }),
      ...(dto.gpsLat !== undefined && { gpsLat: dto.gpsLat }),
      ...(dto.gpsLng !== undefined && { gpsLng: dto.gpsLng }),
      ...(dto.observacoes !== undefined && { observacoes: dto.observacoes }),
      ...(dto.pessoaId !== undefined && { pessoaId: dto.pessoaId }),
    }});
  }

  private validarMinimo(dto: CreateObjetoDto) {
    const temCategoria = dto.categoria && dto.categoria.trim().length > 0;
    const temDescricao = dto.descricao && dto.descricao.trim().length >= 3;
    const temMarcaOuModelo = (dto.marca && dto.marca.trim().length > 0) || (dto.modelo && dto.modelo.trim().length > 0);
    if (!temCategoria && !temDescricao && !temMarcaOuModelo) {
      throw new BadRequestException('Informe ao menos categoria, descrição ou marca/modelo para identificar o objeto.');
    }
  }

  private async validarPessoa(ocorrenciaId: string, pessoaId: string) {
    const p = await this.prisma.pessoaEnvolvida.findFirst({ where: { id: pessoaId, ocorrenciaId } });
    if (!p) throw new BadRequestException('Pessoa informada não pertence a esta ocorrência.');
  }

  private async validarOcorrencia(ocorrenciaId: string, currentUser: any) {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade.');
    const o = await this.prisma.ocorrencia.findUnique({ where: { id: ocorrenciaId }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    const u = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!u?.delegacia || o.delegaciaId !== u.delegacia.id) throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
    if (!isOcorrenciaEditavel(o.status)) throw new ConflictException('A ocorrência já foi finalizada.');
  }
}