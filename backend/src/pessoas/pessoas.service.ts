import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreatePessoaEnvolvidaDto, UpdatePessoaEnvolvidaDto, PessoaEnvolvidaResponseDto } from './dto/pessoas.dto';

@Injectable()
export class PessoasService {
  constructor(private readonly prisma: PrismaService) {}

  async create(ocorrenciaId: string, dto: CreatePessoaEnvolvidaDto, currentUser: any): Promise<PessoaEnvolvidaResponseDto> {
    const ok = await this.validarOcorrencia(ocorrenciaId, currentUser);

    const identificada = dto.identificada ?? true;

    // Validacao condicional de nome: obrigatorio se identificada=true ou tipo != VITIMA
    if (identificada && (!dto.nome || dto.nome.trim().length < 3)) {
      throw new BadRequestException('Nome é obrigatório para pessoa identificada (mínimo 3 caracteres).');
    }
    if (!identificada && dto.tipoEnvolvimento !== 'VITIMA') {
      throw new BadRequestException('Apenas VÍTIMA pode ser marcada como não identificada.');
    }

    const pessoa = await this.prisma.pessoaEnvolvida.create({
      data: {
        nome: dto.nome ?? null,
        identificada,
        nic: dto.nic,
        tipoEnvolvimento: dto.tipoEnvolvimento,
        cpf: dto.cpf,
        rg: dto.rg,
        sexo: dto.sexo ?? 'NAO_INFORMADO',
        dataNascimento: dto.dataNascimento ? new Date(dto.dataNascimento) : null,
        telefone: dto.telefone,
        endereco: dto.endereco,
        bairro: dto.bairro,
        cep: dto.cep,
        depoimento: dto.depoimento,
        ocorrenciaId,
        municipioId: ok.municipioId,
      },
    });

    return this.mapToResponse(pessoa);
  }

  async findAll(ocorrenciaId: string, currentUser: any): Promise<PessoaEnvolvidaResponseDto[]> {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const pessoas = await this.prisma.pessoaEnvolvida.findMany({
      where: { ocorrenciaId },
      orderBy: { criadoEm: 'desc' },
    });
    return pessoas.map((p) => this.mapToResponse(p));
  }

  async findOne(ocorrenciaId: string, id: string, currentUser: any): Promise<PessoaEnvolvidaResponseDto> {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const pessoa = await this.prisma.pessoaEnvolvida.findFirst({ where: { id, ocorrenciaId } });
    if (!pessoa) throw new NotFoundException('Pessoa não encontrada nesta ocorrência.');
    return this.mapToResponse(pessoa);
  }

  async update(ocorrenciaId: string, id: string, dto: UpdatePessoaEnvolvidaDto, currentUser: any): Promise<PessoaEnvolvidaResponseDto> {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const pessoa = await this.prisma.pessoaEnvolvida.findFirst({ where: { id, ocorrenciaId } });
    if (!pessoa) throw new NotFoundException('Pessoa não encontrada nesta ocorrência.');

    const updated = await this.prisma.pessoaEnvolvida.update({
      where: { id },
      data: {
        ...(dto.nome !== undefined && { nome: dto.nome }),
        ...(dto.identificada !== undefined && { identificada: dto.identificada }),
        ...(dto.nic !== undefined && { nic: dto.nic }),
        ...(dto.cpf !== undefined && { cpf: dto.cpf }),
        ...(dto.rg !== undefined && { rg: dto.rg }),
        ...(dto.sexo !== undefined && { sexo: dto.sexo }),
        ...(dto.dataNascimento !== undefined && { dataNascimento: dto.dataNascimento ? new Date(dto.dataNascimento) : undefined }),
        ...(dto.telefone !== undefined && { telefone: dto.telefone }),
        ...(dto.endereco !== undefined && { endereco: dto.endereco }),
        ...(dto.bairro !== undefined && { bairro: dto.bairro }),
        ...(dto.cep !== undefined && { cep: dto.cep }),
        ...(dto.depoimento !== undefined && { depoimento: dto.depoimento }),
      },
    });

    return this.mapToResponse(updated);
  }

  private async validarOcorrencia(ocorrenciaId: string, currentUser: any) {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade.');
    const ocorrencia = await this.prisma.ocorrencia.findUnique({
      where: { id: ocorrenciaId },
      include: { delegacia: true },
    });
    if (!ocorrencia) throw new NotFoundException('Ocorrência não encontrada.');
    const unidade = await this.prisma.unidade.findUnique({
      where: { id: currentUser.unidadeId },
      include: { delegacia: true },
    });
    if (!unidade?.delegacia || ocorrencia.delegaciaId !== unidade.delegacia.id) {
      throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
    }
    if (ocorrencia.status !== 'ABERTA') {
      throw new BadRequestException('A ocorrência não está mais editável.');
    }
    return ocorrencia;
  }

  private mapToResponse(p: any): PessoaEnvolvidaResponseDto {
    return {
      id: p.id,
      nome: p.nome,
      identificada: p.identificada,
      nic: p.nic,
      tipoEnvolvimento: p.tipoEnvolvimento,
      cpf: p.cpf,
      rg: p.rg,
      sexo: p.sexo,
      dataNascimento: p.dataNascimento,
      telefone: p.telefone,
      endereco: p.endereco,
      bairro: p.bairro,
      cep: p.cep,
      depoimento: p.depoimento,
      ocorrenciaId: p.ocorrenciaId,
      criadoEm: p.criadoEm,
    };
  }
}