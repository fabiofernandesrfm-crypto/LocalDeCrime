import { Controller, Get, Post, Patch, Body, Param, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { ObjetosService } from './objetos.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { CreateObjetoDto, UpdateObjetoDto } from './dto/objetos.dto';

@ApiTags('objetos')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('ocorrencias/:ocorrenciaId/objetos')
export class ObjetosController {
  constructor(private readonly service: ObjetosService) {}

  @Post() @HttpCode(HttpStatus.CREATED)
  create(@Param('ocorrenciaId') oid: string, @Body() dto: CreateObjetoDto, @CurrentUser() u: any) { return this.service.create(oid, dto, u); }

  @Get()
  findAll(@Param('ocorrenciaId') oid: string, @CurrentUser() u: any) { return this.service.findAll(oid, u); }

  @Get(':objetoId')
  findOne(@Param('ocorrenciaId') oid: string, @Param('objetoId') oid2: string, @CurrentUser() u: any) { return this.service.findOne(oid, oid2, u); }

  @Patch(':objetoId')
  update(@Param('ocorrenciaId') oid: string, @Param('objetoId') oid2: string, @Body() dto: UpdateObjetoDto, @CurrentUser() u: any) { return this.service.update(oid, oid2, dto, u); }
}