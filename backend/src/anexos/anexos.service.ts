import { Injectable, NotFoundException, BadRequestException, PayloadTooLargeException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../upload/storage.service';
import { AnexoBodyDto, UpdateAnexoDto } from './dto/anexos.dto';

const ALLOWED = ['application/pdf', 'image/jpeg', 'image/png', 'image/webp'];

interface FileInput { buffer: Buffer; originalname: string; mimetype: string; size: number }

@Injectable()
export class AnexosService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
    private readonly config: ConfigService,
  ) {}

  async upload(ocorrenciaId: string, file: FileInput, dto: AnexoBodyDto, currentUser: any) {
    if (!file) throw new BadRequestException('Arquivo é obrigatório.');
    const maxMb = +this.config.get<number>('MAX_ATTACHMENT_UPLOAD_MB', 20);
    const maxBytes = maxMb * 1024 * 1024;
    if (file.size > maxBytes) throw new PayloadTooLargeException(`Arquivo excede o limite de ${maxMb} MB.`);
    if (!ALLOWED.includes(file.mimetype)) throw new BadRequestException('Tipo de arquivo não permitido.');

    await this.validarOcorrencia(ocorrenciaId, currentUser, true);
    await this._validarVinculos(ocorrenciaId, dto);

    let storageKey: string | undefined;
    try {
      const saved = await this.storage.save(file, 'anexos');
      storageKey = saved.storageKey;

      return await this.prisma.anexoOcorrencia.create({ data: {
        storageKey: saved.storageKey, arquivoOriginalNome: saved.originalName,
        mimeType: saved.mimeType, tamanhoBytes: saved.sizeBytes,
        categoria: dto.categoria, descricao: dto.descricao,
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
    return this.prisma.anexoOcorrencia.findMany({ where: { ocorrenciaId }, orderBy: { criadoEm: 'asc' } });
  }

  async findOne(ocorrenciaId: string, anexoId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const a = await this.prisma.anexoOcorrencia.findFirst({ where: { id: anexoId, ocorrenciaId } });
    if (!a) throw new NotFoundException('Anexo não encontrado.');
    return a;
  }

  async serveFile(ocorrenciaId: string, anexoId: string, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser);
    const a = await this.prisma.anexoOcorrencia.findFirst({ where: { id: anexoId, ocorrenciaId } });
    if (!a) throw new NotFoundException('Anexo não encontrado.');
    try {
      const { readable, mime, size } = await this.storage.read(a.storageKey, a.mimeType);
      return { readable, mime, size };
    } catch {
      throw new NotFoundException('Arquivo não encontrado.');
    }
  }

  async update(ocorrenciaId: string, anexoId: string, dto: UpdateAnexoDto, currentUser: any) {
    await this.validarOcorrencia(ocorrenciaId, currentUser, true);
    const a = await this.prisma.anexoOcorrencia.findFirst({ where: { id: anexoId, ocorrenciaId } });
    if (!a) throw new NotFoundException('Anexo não encontrado.');
    await this._validarVinculos(ocorrenciaId, dto);

    return this.prisma.anexoOcorrencia.update({ where: { id: anexoId }, data: {
      ...(dto.categoria !== undefined && { categoria: dto.categoria }),
      ...(dto.descricao !== undefined && { descricao: dto.descricao }),
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
    if (cnt > 1) throw new BadRequestException('Apenas um vínculo específico é permitido por anexo.');
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