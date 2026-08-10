import { Controller, Get, Post, Patch, Body, Param, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { OcorrenciasService } from './ocorrencias.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { CreateOcorrenciaDto, UpdateOcorrenciaDto, FinalizarOcorrenciaDto, ReabrirOcorrenciaDto, ArquivarOcorrenciaDto } from './dto/ocorrencias.dto';

@ApiTags('ocorrencias')
@UseGuards(JwtAuthGuard)
@Controller('ocorrencias')
export class OcorrenciasController {
  constructor(private readonly service: OcorrenciasService) {}

  @Post() @HttpCode(HttpStatus.CREATED) create(@Body() dto: CreateOcorrenciaDto, @CurrentUser() u: any) { return this.service.create(dto, u); }
  @Get() findAll(@CurrentUser() u: any) { return this.service.findAll(u); }
  @Get(':id') findOne(@Param('id') id: string, @CurrentUser() u: any) { return this.service.findOne(id, u); }
  @Patch(':id') update(@Param('id') id: string, @Body() dto: UpdateOcorrenciaDto, @CurrentUser() u: any) { return this.service.update(id, dto, u); }

  @Post(':id/finalizar') @HttpCode(HttpStatus.OK) finalizar(@Param('id') id: string, @Body() dto: FinalizarOcorrenciaDto, @CurrentUser() u: any) { return this.service.finalizar(id, dto, u); }
  @Post(':id/reabrir') @HttpCode(HttpStatus.OK) reabrir(@Param('id') id: string, @Body() dto: ReabrirOcorrenciaDto, @CurrentUser() u: any) { return this.service.reabrir(id, dto, u); }
  @Post(':id/arquivar') @HttpCode(HttpStatus.OK) arquivar(@Param('id') id: string, @Body() dto: ArquivarOcorrenciaDto, @CurrentUser() u: any) { return this.service.arquivar(id, dto, u); }
  @Get(':id/historico-status') getHistorico(@Param('id') id: string, @CurrentUser() u: any) { return this.service.getHistoricoStatus(id, u); }
}