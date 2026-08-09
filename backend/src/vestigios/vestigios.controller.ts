import { Controller, Get, Post, Patch, Body, Param, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { VestigiosService } from './vestigios.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { CreateVestigioDto, UpdateVestigioDto } from './dto/vestigios.dto';

@ApiTags('vestigios')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('ocorrencias/:ocorrenciaId/vestigios')
export class VestigiosController {
  constructor(private readonly service: VestigiosService) {}
  @Post() @HttpCode(HttpStatus.CREATED)
  create(@Param('ocorrenciaId') oid: string, @Body() dto: CreateVestigioDto, @CurrentUser() u: any) { return this.service.create(oid, dto, u); }
  @Get()
  findAll(@Param('ocorrenciaId') oid: string, @CurrentUser() u: any) { return this.service.findAll(oid, u); }
  @Get(':vid')
  findOne(@Param('ocorrenciaId') oid: string, @Param('vid') vid: string, @CurrentUser() u: any) { return this.service.findOne(oid, vid, u); }
  @Patch(':vid')
  update(@Param('ocorrenciaId') oid: string, @Param('vid') vid: string, @Body() dto: UpdateVestigioDto, @CurrentUser() u: any) { return this.service.update(oid, vid, dto, u); }
}