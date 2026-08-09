import { Controller, Get, Param, Res, UseGuards, NotFoundException } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import type { Response } from 'express';
import { StorageService } from './storage.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { PrismaService } from '../prisma/prisma.service';

/// Esta rota serve arquivo apenas por fotoId e NUNCA por storageKey direto.
/// Usada internamente (ex: frontend monta URL a partir do fotoId).
/// O storageKey nunca é exposto na URL.

@ApiTags('files')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('')
export class FilesController {
  constructor(private readonly storage: StorageService, private readonly prisma: PrismaService) {}

  @Get('ocorrencias/:ocorrenciaId/fotografias/:fotoId/arquivo')
  async serve(
    @Param('ocorrenciaId') oid: string,
    @Param('fotoId') fotoId: string,
    @CurrentUser() u: any,
    @Res() res: Response,
  ) {
    const foto = await this.prisma.fotografiaOcorrencia.findFirst({
      where: { id: fotoId, ocorrenciaId: oid },
      include: { ocorrencia: { include: { delegacia: true } } },
    });
    if (!foto) throw new NotFoundException('Fotografia não encontrada.');

    if (u.unidadeId) {
      const unidade = await this.prisma.unidade.findUnique({
        where: { id: u.unidadeId },
        include: { delegacia: true },
      });
      if (!unidade?.delegacia || foto.ocorrencia?.delegaciaId !== unidade.delegacia.id) {
        throw new NotFoundException('Fotografia não pertence à sua Unidade.');
      }
    }

    try {
      const { readable, mime, size } = await this.storage.read(foto.storageKey, foto.mimeType);
      res.set({ 'Content-Type': mime, 'Content-Length': size, 'Cache-Control': 'private, max-age=3600' });
      readable.pipe(res);
    } catch {
      throw new NotFoundException('Arquivo não encontrado.');
    }
  }
}