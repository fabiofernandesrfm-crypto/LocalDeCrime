import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreatePessoaEnvolvidaDto, UpdatePessoaEnvolvidaDto, PessoaEnvolvidaResponseDto } from './dto/pessoas.dto';
import { CreateTelefoneDto, UpdateTelefoneDto } from './dto/telefone-pessoa.dto';
import { CreateEnderecoDto, UpdateEnderecoDto } from './dto/endereco-pessoa.dto';

@Injectable()
export class PessoasService {
  constructor(private readonly prisma: PrismaService) {}

  // ── Pessoa ────────────────────────────────────────────────
  async createPessoa(ocorrenciaId: string, dto: CreatePessoaEnvolvidaDto, currentUser: any): Promise<PessoaEnvolvidaResponseDto> {
    const ok = await this.validarOcorrencia(ocorrenciaId, currentUser);
    const identificada = dto.identificada ?? true;
    if (identificada && (!dto.nome || dto.nome.trim().length < 3))
      throw new BadRequestException('Nome é obrigatório para pessoa identificada.');
    if (!identificada && dto.tipoEnvolvimento !== 'VITIMA')
      throw new BadRequestException('Apenas VÍTIMA pode ser não identificada.');

    const p = await this.prisma.pessoaEnvolvida.create({
      data: {
        nome: dto.nome ?? null, identificada, nic: dto.nic, tipoEnvolvimento: dto.tipoEnvolvimento,
        cpf: dto.cpf, rg: dto.rg, sexo: dto.sexo ?? 'NAO_INFORMADO',
        dataNascimento: dto.dataNascimento ? new Date(dto.dataNascimento) : null,
        telefone: dto.telefone, endereco: dto.endereco, bairro: dto.bairro, cep: dto.cep,
        depoimento: dto.depoimento, ocorrenciaId, municipioId: ok.municipioId,
      },
    });
    return this.mapPessoa(p);
  }

  async findAllPessoas(ocorrenciaId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    return (await this.prisma.pessoaEnvolvida.findMany({ where: { ocorrenciaId }, orderBy: { criadoEm: 'desc' } })).map(p => this.mapPessoa(p));
  }

  async findOnePessoa(ocorrenciaId: string, id: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const p = await this.prisma.pessoaEnvolvida.findFirst({ where: { id, ocorrenciaId } });
    if (!p) throw new NotFoundException('Pessoa não encontrada.');
    return this.mapPessoa(p);
  }

  async updatePessoa(ocorrenciaId: string, id: string, dto: UpdatePessoaEnvolvidaDto, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const exists = await this.prisma.pessoaEnvolvida.findFirst({ where: { id, ocorrenciaId } });
    if (!exists) throw new NotFoundException('Pessoa não encontrada.');
    const p = await this.prisma.pessoaEnvolvida.update({ where: { id }, data: {
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
    }});
    return this.mapPessoa(p);
  }

  // ── Telefones ─────────────────────────────────────────────
  async addTelefone(ocorrenciaId: string, pessoaId: string, dto: CreateTelefoneDto, currentUser: any) {
    await this._validarOcorrenciaEPessoa(ocorrenciaId, pessoaId, currentUser);
    return this.prisma.telefonePessoa.create({ data: { numero: dto.numero, tipo: dto.tipo, observacao: dto.observacao, pessoaId } });
  }

  async listTelefones(ocorrenciaId: string, pessoaId: string, currentUser: any) {
    await this._validarOcorrenciaEPessoa(ocorrenciaId, pessoaId, currentUser);
    return this.prisma.telefonePessoa.findMany({ where: { pessoaId }, orderBy: { criadoEm: 'asc' } });
  }

  async updateTelefone(ocorrenciaId: string, pessoaId: string, telefoneId: string, dto: UpdateTelefoneDto, currentUser: any) {
    await this._validarOcorrenciaEPessoa(ocorrenciaId, pessoaId, currentUser);
    const t = await this.prisma.telefonePessoa.findFirst({ where: { id: telefoneId, pessoaId } });
    if (!t) throw new NotFoundException('Telefone não encontrado.');
    return this.prisma.telefonePessoa.update({ where: { id: telefoneId }, data: {
      ...(dto.numero !== undefined && { numero: dto.numero }),
      ...(dto.tipo !== undefined && { tipo: dto.tipo }),
      ...(dto.observacao !== undefined && { observacao: dto.observacao }),
    }});
  }

  // ── Endereços ─────────────────────────────────────────────
  async addEndereco(ocorrenciaId: string, pessoaId: string, dto: CreateEnderecoDto, currentUser: any) {
    await this._validarOcorrenciaEPessoa(ocorrenciaId, pessoaId, currentUser);
    return this.prisma.enderecoPessoa.create({ data: { logradouro: dto.logradouro, bairro: dto.bairro, cidade: dto.cidade, estado: dto.estado, cep: dto.cep, numero: dto.numero, complemento: dto.complemento, tipo: dto.tipo, observacao: dto.observacao, pessoaId } });
  }

  async listEnderecos(ocorrenciaId: string, pessoaId: string, currentUser: any) {
    await this._validarOcorrenciaEPessoa(ocorrenciaId, pessoaId, currentUser);
    return this.prisma.enderecoPessoa.findMany({ where: { pessoaId }, orderBy: { criadoEm: 'asc' } });
  }

  async updateEndereco(ocorrenciaId: string, pessoaId: string, enderecoId: string, dto: UpdateEnderecoDto, currentUser: any) {
    await this._validarOcorrenciaEPessoa(ocorrenciaId, pessoaId, currentUser);
    const e = await this.prisma.enderecoPessoa.findFirst({ where: { id: enderecoId, pessoaId } });
    if (!e) throw new NotFoundException('Endereço não encontrado.');
    return this.prisma.enderecoPessoa.update({ where: { id: enderecoId }, data: {
      ...(dto.logradouro !== undefined && { logradouro: dto.logradouro }),
      ...(dto.bairro !== undefined && { bairro: dto.bairro }),
      ...(dto.cidade !== undefined && { cidade: dto.cidade }),
      ...(dto.estado !== undefined && { estado: dto.estado }),
      ...(dto.cep !== undefined && { cep: dto.cep }),
      ...(dto.numero !== undefined && { numero: dto.numero }),
      ...(dto.complemento !== undefined && { complemento: dto.complemento }),
      ...(dto.tipo !== undefined && { tipo: dto.tipo }),
      ...(dto.observacao !== undefined && { observacao: dto.observacao }),
    }});
  }

  // ── Helpers ───────────────────────────────────────────────
  private async validarOcorrencia(ocorrenciaId: string, currentUser: any) {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade.');
    const o = await this.prisma.ocorrencia.findUnique({ where: { id: ocorrenciaId }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    const u = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!u?.delegacia || o.delegaciaId !== u.delegacia.id) throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
    if (o.status !== 'ABERTA') throw new BadRequestException('A ocorrência não está mais editável.');
    return o;
  }

  private async _validarOcorrenciaEPessoa(ocorrenciaId: string, pessoaId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const p = await this.prisma.pessoaEnvolvida.findFirst({ where: { id: pessoaId, ocorrenciaId } });
    if (!p) throw new NotFoundException('Pessoa não encontrada nesta ocorrência.');
    return p;
  }

  private mapPessoa(p: any): PessoaEnvolvidaResponseDto {
    return {
      id: p.id, nome: p.nome, identificada: p.identificada, nic: p.nic, tipoEnvolvimento: p.tipoEnvolvimento,
      cpf: p.cpf, rg: p.rg, sexo: p.sexo, dataNascimento: p.dataNascimento,
      telefone: p.telefone, endereco: p.endereco, bairro: p.bairro, cep: p.cep,
      depoimento: p.depoimento, ocorrenciaId: p.ocorrenciaId, criadoEm: p.criadoEm,
    };
  }
}