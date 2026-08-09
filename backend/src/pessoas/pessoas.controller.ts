import { Controller, Get, Post, Patch, Body, Param, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { PessoasService } from './pessoas.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { CreatePessoaEnvolvidaDto, UpdatePessoaEnvolvidaDto, PessoaEnvolvidaResponseDto } from './dto/pessoas.dto';
import { CreateTelefoneDto, UpdateTelefoneDto } from './dto/telefone-pessoa.dto';
import { CreateEnderecoDto, UpdateEnderecoDto } from './dto/endereco-pessoa.dto';

@ApiTags('pessoas')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('ocorrencias/:ocorrenciaId/pessoas')
export class PessoasController {
  constructor(private readonly service: PessoasService) {}

  // ── Pessoa ────────────────────────────────────────────────
  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Param('ocorrenciaId') oid: string, @Body() dto: CreatePessoaEnvolvidaDto, @CurrentUser() u: any) { return this.service.createPessoa(oid, dto, u); }

  @Get()
  findAll(@Param('ocorrenciaId') oid: string, @CurrentUser() u: any) { return this.service.findAllPessoas(oid, u); }

  @Get(':id')
  findOne(@Param('ocorrenciaId') oid: string, @Param('id') id: string, @CurrentUser() u: any) { return this.service.findOnePessoa(oid, id, u); }

  @Patch(':id')
  update(@Param('ocorrenciaId') oid: string, @Param('id') id: string, @Body() dto: UpdatePessoaEnvolvidaDto, @CurrentUser() u: any) { return this.service.updatePessoa(oid, id, dto, u); }

  // ── Telefones ─────────────────────────────────────────────
  @Post(':pessoaId/telefones')
  @HttpCode(HttpStatus.CREATED)
  addTel(@Param('ocorrenciaId') oid: string, @Param('pessoaId') pid: string, @Body() dto: CreateTelefoneDto, @CurrentUser() u: any) { return this.service.addTelefone(oid, pid, dto, u); }

  @Get(':pessoaId/telefones')
  listTel(@Param('ocorrenciaId') oid: string, @Param('pessoaId') pid: string, @CurrentUser() u: any) { return this.service.listTelefones(oid, pid, u); }

  @Patch(':pessoaId/telefones/:telefoneId')
  updTel(@Param('ocorrenciaId') oid: string, @Param('pessoaId') pid: string, @Param('telefoneId') tid: string, @Body() dto: UpdateTelefoneDto, @CurrentUser() u: any) { return this.service.updateTelefone(oid, pid, tid, dto, u); }

  // ── Endereços ─────────────────────────────────────────────
  @Post(':pessoaId/enderecos')
  @HttpCode(HttpStatus.CREATED)
  addEnd(@Param('ocorrenciaId') oid: string, @Param('pessoaId') pid: string, @Body() dto: CreateEnderecoDto, @CurrentUser() u: any) { return this.service.addEndereco(oid, pid, dto, u); }

  @Get(':pessoaId/enderecos')
  listEnd(@Param('ocorrenciaId') oid: string, @Param('pessoaId') pid: string, @CurrentUser() u: any) { return this.service.listEnderecos(oid, pid, u); }

  @Patch(':pessoaId/enderecos/:enderecoId')
  updEnd(@Param('ocorrenciaId') oid: string, @Param('pessoaId') pid: string, @Param('enderecoId') eid: string, @Body() dto: UpdateEnderecoDto, @CurrentUser() u: any) { return this.service.updateEndereco(oid, pid, eid, dto, u); }
}