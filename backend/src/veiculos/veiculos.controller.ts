import { Controller, Get, Post, Patch, Body, Param, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { VeiculosService } from './veiculos.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { CreateVeiculoDto, UpdateVeiculoDto } from './dto/veiculos.dto';

@ApiTags('veiculos')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('ocorrencias/:ocorrenciaId/veiculos')
export class VeiculosController {
  constructor(private readonly service: VeiculosService) {}

  @Post() @HttpCode(HttpStatus.CREATED)
  create(@Param('ocorrenciaId') oid: string, @Body() dto: CreateVeiculoDto, @CurrentUser() u: any) { return this.service.create(oid, dto, u); }

  @Get()
  findAll(@Param('ocorrenciaId') oid: string, @CurrentUser() u: any) { return this.service.findAll(oid, u); }

  @Get(':veiculoId')
  findOne(@Param('ocorrenciaId') oid: string, @Param('veiculoId') vid: string, @CurrentUser() u: any) { return this.service.findOne(oid, vid, u); }

  @Patch(':veiculoId')
  update(@Param('ocorrenciaId') oid: string, @Param('veiculoId') vid: string, @Body() dto: UpdateVeiculoDto, @CurrentUser() u: any) { return this.service.update(oid, vid, dto, u); }
}