import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateVeiculoDto, UpdateVeiculoDto } from './dto/veiculos.dto';
import { isOcorrenciaEditavel } from '../common/ocorrencia-helper';

@Injectable()
export class VeiculosService {
  constructor(private readonly prisma: PrismaService) {}

  async create(ocorrenciaId: string, dto: CreateVeiculoDto, currentUser: any) {
    await this.validar(ocorrenciaId, currentUser);
    this.validarMinimoIdentificacao(dto);

    const placa = dto.placa?.toUpperCase().replace(/[^A-Z0-9]/g, '') || null;
    return this.prisma.veiculoOcorrencia.create({ data: {
      placa, marca: dto.marca, modelo: dto.modelo, ano: dto.ano, cor: dto.cor,
      situacao: dto.situacao, destinacao: dto.destinacao,
      responsavel: dto.responsavel, destinatario: dto.destinatario,
      docDestinatario: dto.docDestinatario, vinculo: dto.vinculo,
      gpsLat: dto.gpsLat, gpsLng: dto.gpsLng,
      observacoes: dto.observacoes,
      ocorrenciaId, criadoPorId: currentUser.id,
    }});
  }

  async findAll(ocorrenciaId: string, currentUser: any) {
    await this.validar(ocorrenciaId, currentUser);
    return this.prisma.veiculoOcorrencia.findMany({ where: { ocorrenciaId }, orderBy: { criadoEm: 'asc' } });
  }

  async findOne(ocorrenciaId: string, veiculoId: string, currentUser: any) {
    await this.validar(ocorrenciaId, currentUser);
    const v = await this.prisma.veiculoOcorrencia.findFirst({ where: { id: veiculoId, ocorrenciaId } });
    if (!v) throw new NotFoundException('Veículo não encontrado.');
    return v;
  }

  async update(ocorrenciaId: string, veiculoId: string, dto: UpdateVeiculoDto, currentUser: any) {
    await this.validar(ocorrenciaId, currentUser);
    const v = await this.prisma.veiculoOcorrencia.findFirst({ where: { id: veiculoId, ocorrenciaId } });
    if (!v) throw new NotFoundException('Veículo não encontrado.');
    return this.prisma.veiculoOcorrencia.update({ where: { id: veiculoId }, data: {
      ...(dto.placa !== undefined && { placa: dto.placa?.toUpperCase().replace(/[^A-Z0-9]/g, '') || null }),
      ...(dto.marca !== undefined && { marca: dto.marca }),
      ...(dto.modelo !== undefined && { modelo: dto.modelo }),
      ...(dto.ano !== undefined && { ano: dto.ano }),
      ...(dto.cor !== undefined && { cor: dto.cor }),
      ...(dto.situacao !== undefined && { situacao: dto.situacao }),
      ...(dto.destinacao !== undefined && { destinacao: dto.destinacao }),
      ...(dto.responsavel !== undefined && { responsavel: dto.responsavel }),
      ...(dto.destinatario !== undefined && { destinatario: dto.destinatario }),
      ...(dto.docDestinatario !== undefined && { docDestinatario: dto.docDestinatario }),
      ...(dto.vinculo !== undefined && { vinculo: dto.vinculo }),
      ...(dto.gpsLat !== undefined && { gpsLat: dto.gpsLat }),
      ...(dto.gpsLng !== undefined && { gpsLng: dto.gpsLng }),
      ...(dto.observacoes !== undefined && { observacoes: dto.observacoes }),
    }});
  }

  private validarMinimoIdentificacao(dto: CreateVeiculoDto) {
    const temPlaca = dto.placa && dto.placa.trim().length > 0;
    const temMarcaOuModelo = (dto.marca && dto.marca.trim().length > 0) || (dto.modelo && dto.modelo.trim().length > 0);
    const temObservacao = dto.observacoes && dto.observacoes.trim().length >= 3;
    if (!temPlaca && !temMarcaOuModelo && !temObservacao) {
      throw new BadRequestException('Informe ao menos placa, marca/modelo ou uma observação descritiva para identificar o veículo.');
    }
  }

  private async validar(ocorrenciaId: string, currentUser: any) {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade.');
    const o = await this.prisma.ocorrencia.findUnique({ where: { id: ocorrenciaId }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    const u = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!u?.delegacia || o.delegaciaId !== u.delegacia.id) throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
    if (!isOcorrenciaEditavel(o.status)) throw new ConflictException('A ocorrência já foi finalizada.');
  }
}