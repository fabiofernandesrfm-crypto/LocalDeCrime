import { Controller, Get, Post, Patch, Body, Param, Query, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { OcorrenciasService } from './ocorrencias.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { PermissionGuard } from '../auth/guards/permission.guard';
import { RequirePermission } from '../auth/decorators/require-permission.decorator';
import { Permissions } from '../auth/constants/permissions';
import { CurrentUser } from '../auth/current-user.decorator';
import { CreateOcorrenciaDto, UpdateOcorrenciaDto, FinalizarOcorrenciaDto, ReabrirOcorrenciaDto, ArquivarOcorrenciaDto, SearchOcorrenciasDto } from './dto/ocorrencias.dto';

@ApiTags('ocorrencias')
@UseGuards(JwtAuthGuard, PermissionGuard)
@Controller('ocorrencias')
export class OcorrenciasController {
  constructor(private readonly service: OcorrenciasService) {}

  @Post() @HttpCode(HttpStatus.CREATED) create(@Body() dto: CreateOcorrenciaDto, @CurrentUser() u: any) { return this.service.create(dto, u); }
  @Get() search(@Query() query: SearchOcorrenciasDto, @CurrentUser() u: any) { return this.service.search(query, u); }
  @Get(':id') findOne(@Param('id') id: string, @CurrentUser() u: any) { return this.service.findOne(id, u); }
  @Patch(':id') update(@Param('id') id: string, @Body() dto: UpdateOcorrenciaDto, @CurrentUser() u: any) { return this.service.update(id, dto, u); }

  @RequirePermission(Permissions.OCORRENCIA_FINALIZAR)
  @Post(':id/finalizar') @HttpCode(HttpStatus.OK) finalizar(@Param('id') id: string, @Body() dto: FinalizarOcorrenciaDto, @CurrentUser() u: any) { return this.service.finalizar(id, dto, u); }

  @RequirePermission(Permissions.OCORRENCIA_REABRIR)
  @Post(':id/reabrir') @HttpCode(HttpStatus.OK) reabrir(@Param('id') id: string, @Body() dto: ReabrirOcorrenciaDto, @CurrentUser() u: any) { return this.service.reabrir(id, dto, u); }

  @RequirePermission(Permissions.OCORRENCIA_ARQUIVAR)
  @Post(':id/arquivar') @HttpCode(HttpStatus.OK) arquivar(@Param('id') id: string, @Body() dto: ArquivarOcorrenciaDto, @CurrentUser() u: any) { return this.service.arquivar(id, dto, u); }
  @Get(':id/historico-status') getHistorico(@Param('id') id: string, @CurrentUser() u: any) { return this.service.getHistoricoStatus(id, u); }
}