import { Controller, Get, Post, Patch, Param, Res, UseGuards, UseInterceptors, UploadedFile, Body, HttpCode, HttpStatus, NotFoundException } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiConsumes } from '@nestjs/swagger';
import type { Response } from 'express';
import { FileInterceptor } from '@nestjs/platform-express';
import { AnexosService } from './anexos.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { AnexoBodyDto, UpdateAnexoDto } from './dto/anexos.dto';

@ApiTags('anexos')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('ocorrencias/:ocorrenciaId/anexos')
export class AnexosController {
  constructor(private readonly service: AnexosService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file'))
  async upload(
    @Param('ocorrenciaId') oid: string,
    @UploadedFile() file: Express.Multer.File,
    @Body() body: AnexoBodyDto,
    @CurrentUser() u: any,
  ) {
    return this.service.upload(oid, file, body, u);
  }

  @Get()
  findAll(@Param('ocorrenciaId') oid: string, @CurrentUser() u: any) { return this.service.findAll(oid, u); }

  @Get(':anexoId')
  findOne(@Param('ocorrenciaId') oid: string, @Param('anexoId') aid: string, @CurrentUser() u: any) { return this.service.findOne(oid, aid, u); }

  @Get(':anexoId/arquivo')
  async serveFile(
    @Param('ocorrenciaId') oid: string,
    @Param('anexoId') aid: string,
    @CurrentUser() u: any,
    @Res() res: Response,
  ) {
    const { readable, mime, size } = await this.service.serveFile(oid, aid, u);
    res.set({ 'Content-Type': mime, 'Content-Length': size, 'Cache-Control': 'private, max-age=3600' });
    readable.pipe(res);
  }

  @Patch(':anexoId')
  update(@Param('ocorrenciaId') oid: string, @Param('anexoId') aid: string, @Body() dto: UpdateAnexoDto, @CurrentUser() u: any) { return this.service.update(oid, aid, dto, u); }
}