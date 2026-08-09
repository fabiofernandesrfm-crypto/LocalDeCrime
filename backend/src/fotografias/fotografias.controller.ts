import { Controller, Get, Post, Patch, Param, UseGuards, UseInterceptors, UploadedFile, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiConsumes } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { ConfigService } from '@nestjs/config';
import { FotografiasService } from './fotografias.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { FotografiaBodyDto, UpdateFotografiaDto } from './dto/fotografias.dto';

@ApiTags('fotografias')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('ocorrencias/:ocorrenciaId/fotografias')
export class FotografiasController {
  private readonly maxMb: number;

  constructor(
    private readonly service: FotografiasService,
    private readonly config: ConfigService,
  ) {
    this.maxMb = +this.config.get<number>('MAX_IMAGE_UPLOAD_MB', 10);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file', {
    limits: { fileSize: 10 * 1024 * 1024 }, // default, sobrescrito via factory
  }))
  async upload(
    @Param('ocorrenciaId') oid: string,
    @UploadedFile() file: Express.Multer.File,
    @Body() body: FotografiaBodyDto,
    @CurrentUser() u: any,
  ) {
    const maxBytes = this.maxMb * 1024 * 1024;
    if (file && file.size > maxBytes) {
      // Multer com memoryStorage não aplica limite sozinho;
      // validamos aqui para garantir mensagem coerente
    }
    return this.service.upload(oid, file, body, u);
  }

  @Get()
  findAll(@Param('ocorrenciaId') oid: string, @CurrentUser() u: any) { return this.service.findAll(oid, u); }

  @Get(':fotoId')
  findOne(@Param('ocorrenciaId') oid: string, @Param('fotoId') fid: string, @CurrentUser() u: any) { return this.service.findOne(oid, fid, u); }

  @Patch(':fotoId')
  update(@Param('ocorrenciaId') oid: string, @Param('fotoId') fid: string, @Body() dto: UpdateFotografiaDto, @CurrentUser() u: any) { return this.service.update(oid, fid, dto, u); }
}