import { Controller, Get, Post, Patch, Body, Param, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { OcorrenciasService } from './ocorrencias.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { CreateOcorrenciaDto, UpdateOcorrenciaDto, OcorrenciaResponseDto } from './dto/ocorrencias.dto';

@ApiTags('ocorrencias')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('ocorrencias')
export class OcorrenciasController {
  constructor(private readonly ocorrenciasService: OcorrenciasService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Criar nova ocorrencia (RASCUNHO)' })
  @ApiResponse({ status: 201, description: 'Ocorrencia criada.', type: OcorrenciaResponseDto })
  async create(
    @Body() dto: CreateOcorrenciaDto,
    @CurrentUser() currentUser: any,
  ): Promise<OcorrenciaResponseDto> {
    return this.ocorrenciasService.create(dto, currentUser);
  }

  @Get()
  @ApiOperation({ summary: 'Listar ocorrencias da Unidade' })
  @ApiResponse({ status: 200, description: 'Lista de ocorrencias.', type: [OcorrenciaResponseDto] })
  async findAll(
    @CurrentUser() currentUser: any,
  ): Promise<OcorrenciaResponseDto[]> {
    return this.ocorrenciasService.findAll(currentUser);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Buscar ocorrencia por ID' })
  @ApiResponse({ status: 200, description: 'Ocorrencia encontrada.', type: OcorrenciaResponseDto })
  async findOne(
    @Param('id') id: string,
    @CurrentUser() currentUser: any,
  ): Promise<OcorrenciaResponseDto> {
    return this.ocorrenciasService.findOne(id, currentUser);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Atualizar ocorrencia (rascunho)' })
  @ApiResponse({ status: 200, description: 'Ocorrencia atualizada.', type: OcorrenciaResponseDto })
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateOcorrenciaDto,
    @CurrentUser() currentUser: any,
  ): Promise<OcorrenciaResponseDto> {
    return this.ocorrenciasService.update(id, dto, currentUser);
  }
}