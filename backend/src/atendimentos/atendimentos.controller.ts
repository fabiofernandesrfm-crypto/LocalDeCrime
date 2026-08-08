import { Controller, Get, Post, Patch, Body, Param, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { AtendimentosService } from './atendimentos.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { CreateAtendimentoDto, UpdateAtendimentoDto, AtendimentoResponseDto } from './dto/atendimentos.dto';

@ApiTags('atendimentos')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('atendimentos')
export class AtendimentosController {
  constructor(private readonly atendimentosService: AtendimentosService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Registrar nova ocorrência / atendimento' })
  @ApiResponse({ status: 201, description: 'Atendimento criado (RASCUNHO).', type: AtendimentoResponseDto })
  async create(
    @Body() dto: CreateAtendimentoDto,
    @CurrentUser() currentUser: any,
  ): Promise<AtendimentoResponseDto> {
    return this.atendimentosService.create(dto, currentUser);
  }

  @Get()
  @ApiOperation({ summary: 'Listar atendimentos da Unidade do usuário' })
  @ApiResponse({ status: 200, description: 'Lista de atendimentos.', type: [AtendimentoResponseDto] })
  async findAll(
    @CurrentUser() currentUser: any,
  ): Promise<AtendimentoResponseDto[]> {
    return this.atendimentosService.findAll(currentUser);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Buscar atendimento por ID (isolado por Unidade)' })
  @ApiResponse({ status: 200, description: 'Atendimento encontrado.', type: AtendimentoResponseDto })
  async findOne(
    @Param('id') id: string,
    @CurrentUser() currentUser: any,
  ): Promise<AtendimentoResponseDto> {
    return this.atendimentosService.findOne(id, currentUser);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Atualizar atendimento (somente rascunhos da Unidade)' })
  @ApiResponse({ status: 200, description: 'Atendimento atualizado.', type: AtendimentoResponseDto })
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateAtendimentoDto,
    @CurrentUser() currentUser: any,
  ): Promise<AtendimentoResponseDto> {
    return this.atendimentosService.update(id, dto, currentUser);
  }
}