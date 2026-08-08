import { Controller, Get, Post, Patch, Body, Param, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { PessoasService } from './pessoas.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { CreatePessoaEnvolvidaDto, UpdatePessoaEnvolvidaDto, PessoaEnvolvidaResponseDto } from './dto/pessoas.dto';

@ApiTags('pessoas')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('ocorrencias/:ocorrenciaId/pessoas')
export class PessoasController {
  constructor(private readonly pessoasService: PessoasService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Adicionar pessoa a uma ocorrencia' })
  @ApiResponse({ status: 201, description: 'Pessoa criada.', type: PessoaEnvolvidaResponseDto })
  async create(
    @Param('ocorrenciaId') ocorrenciaId: string,
    @Body() dto: CreatePessoaEnvolvidaDto,
    @CurrentUser() currentUser: any,
  ): Promise<PessoaEnvolvidaResponseDto> {
    return this.pessoasService.create(ocorrenciaId, dto, currentUser);
  }

  @Get()
  @ApiOperation({ summary: 'Listar pessoas da ocorrencia' })
  @ApiResponse({ status: 200, description: 'Lista de pessoas.', type: [PessoaEnvolvidaResponseDto] })
  async findAll(
    @Param('ocorrenciaId') ocorrenciaId: string,
    @CurrentUser() currentUser: any,
  ): Promise<PessoaEnvolvidaResponseDto[]> {
    return this.pessoasService.findAll(ocorrenciaId, currentUser);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Buscar pessoa por ID' })
  @ApiResponse({ status: 200, description: 'Pessoa encontrada.', type: PessoaEnvolvidaResponseDto })
  async findOne(
    @Param('ocorrenciaId') ocorrenciaId: string,
    @Param('id') id: string,
    @CurrentUser() currentUser: any,
  ): Promise<PessoaEnvolvidaResponseDto> {
    return this.pessoasService.findOne(ocorrenciaId, id, currentUser);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Atualizar pessoa da ocorrencia' })
  @ApiResponse({ status: 200, description: 'Pessoa atualizada.', type: PessoaEnvolvidaResponseDto })
  async update(
    @Param('ocorrenciaId') ocorrenciaId: string,
    @Param('id') id: string,
    @Body() dto: UpdatePessoaEnvolvidaDto,
    @CurrentUser() currentUser: any,
  ): Promise<PessoaEnvolvidaResponseDto> {
    return this.pessoasService.update(ocorrenciaId, id, dto, currentUser);
  }
}