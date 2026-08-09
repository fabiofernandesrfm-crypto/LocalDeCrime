import { Injectable, NotFoundException, BadRequestException, PayloadTooLargeException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../upload/storage.service';
import { FotografiaBodyDto, UpdateFotografiaDto } from './dto/fotografias.dto';

const ALLOWED = ['image/jpeg', 'image/png', 'image/webp'];

interface FileInput { buffer: Buffer; originalname: string; mimetype: string; size: number }

@Injectable()
export class FotografiasService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
    private readonly config: ConfigService,
  ) {}

  async upload(ocorrenciaId: string, file: FileInput, dto: FotografiaBodyDto, currentUser: any) {
    if (!file) throw new BadRequestException('Arquivo de imagem é obrigatório.');
    const maxMb = +this.config.get<number>('MAX_IMAGE_UPLOAD_MB', 10);
    const maxBytes = maxMb * 1024 * 1024;
    if (file.size > maxBytes) throw new PayloadTooLargeException(`Arquivo excede o limite de ${maxMb} MB.`);
    if (!ALLOWED.includes(file.mimetype)) throw new BadRequestException('Tipo de arquivo não permitido. Use JPEG, PNG ou WebP.');

    await this.validarOcorrencia(ocorrenciaId, currentUser, true);
    await this._validarVinculos(ocorrenciaId, dto);

    let storageKey: string | undefined;
    try {
      const saved = await this.storage.save(file, 'fotos');
      storageKey = saved.storageKey;

      return await this.prisma.fotografiaOcorrencia.create({ data: {
        storageKey: saved.storageKey, arquivoOriginalNome: saved.originalName,
        mimeType: saved.mimeType, tamanhoBytes: saved.sizeBytes,
        legenda: dto.legenda, ordem: dto.ordem ?? 0,
        capturadoEm: dto.capturadoEm ? new Date(dto.capturadoEm) : null,
        gpsLat: dto.gpsLat, gpsLng: dto.gpsLng,
        pessoaId: dto.pessoaId, veiculoId: dto.veiculoId, objetoId: dto.objetoId, vestigioId: dto.vestigioId,
        ocorrenciaId, criadoPorId: currentUser.id,
      }});
    } catch (err) {
      if (storageKey) await this.storage.remove(storageKey).catch(() => {});
      throw err;
    }
  }

  async findAll(ocorrenciaId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    return this.prisma.fotografiaOcorrencia.findMany({ where: { ocorrenciaId }, orderBy: [{ ordem: 'asc' }, { criadoEm: 'asc' }] });
  }

  async findOne(ocorrenciaId: string, fotoId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const f = await this.prisma.fotografiaOcorrencia.findFirst({ where: { id: fotoId, ocorrenciaId } });
    if (!f) throw new NotFoundException('Fotografia não encontrada.');
    return f;
  }

  async update(ocorrenciaId: string, fotoId: string, dto: UpdateFotografiaDto, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser, true);
    const f = await this.prisma.fotografiaOcorrencia.findFirst({ where: { id: fotoId, ocorrenciaId } });
    if (!f) throw new NotFoundException('Fotografia não encontrada.');
    await this._validarVinculos(ocorrenciaId, dto);

    return this.prisma.fotografiaOcorrencia.update({ where: { id: fotoId }, data: {
      ...(dto.legenda !== undefined && { legenda: dto.legenda }),
      ...(dto.ordem !== undefined && { ordem: dto.ordem }),
      ...(dto.capturadoEm !== undefined && { capturadoEm: new Date(dto.capturadoEm) }),
      ...(dto.pessoaId !== undefined && { pessoaId: dto.pessoaId, veiculoId: null, objetoId: null, vestigioId: null }),
      ...(dto.veiculoId !== undefined && { veiculoId: dto.veiculoId, pessoaId: null, objetoId: null, vestigioId: null }),
      ...(dto.objetoId !== undefined && { objetoId: dto.objetoId, pessoaId: null, veiculoId: null, vestigioId: null }),
      ...(dto.vestigioId !== undefined && { vestigioId: dto.vestigioId, pessoaId: null, veiculoId: null, objetoId: null }),
    }});
  }

  private async _validarVinculos(ocorrenciaId: string, dto: any) {
    let cnt = 0;
    if (dto.pessoaId) { cnt++; const p = await this.prisma.pessoaEnvolvida.findFirst({ where: { id: dto.pessoaId, ocorrenciaId } }); if (!p) throw new BadRequestException('Pessoa não pertence a esta ocorrência.'); }
    if (dto.veiculoId) { cnt++; const v = await this.prisma.veiculoOcorrencia.findFirst({ where: { id: dto.veiculoId, ocorrenciaId } }); if (!v) throw new BadRequestException('Veículo não pertence a esta ocorrência.'); }
    if (dto.objetoId) { cnt++; const o = await this.prisma.objetoOcorrencia.findFirst({ where: { id: dto.objetoId, ocorrenciaId } }); if (!o) throw new BadRequestException('Objeto não pertence a esta ocorrência.'); }
    if (dto.vestigioId) { cnt++; const v = await this.prisma.vestigioOcorrencia.findFirst({ where: { id: dto.vestigioId, ocorrenciaId } }); if (!v) throw new BadRequestException('Vestígio não pertence a esta ocorrência.'); }
    if (cnt > 1) throw new BadRequestException('Apenas um vínculo específico é permitido por fotografia.');
  }

  private async validarOcorrencia(ocorrenciaId: string, currentUser: any, exigeAberta = false) {
    if (!currentUser.unidadeId) throw new BadRequestException('Usuário sem Unidade.');
    const o = await this.prisma.ocorrencia.findUnique({ where: { id: ocorrenciaId }, include: { delegacia: true } });
    if (!o) throw new NotFoundException('Ocorrência não encontrada.');
    const u = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!u?.delegacia || o.delegaciaId !== u.delegacia.id) throw new NotFoundException('Ocorrência não pertence à sua Unidade.');
    if (exigeAberta && o.status !== 'ABERTA') throw new BadRequestException('A ocorrência não está mais editável.');
  }
}