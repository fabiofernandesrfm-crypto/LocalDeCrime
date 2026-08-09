import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { randomUUID } from 'node:crypto';
import * as path from 'path';
import * as fs from 'fs/promises';
import { Readable } from 'stream';

@Injectable()
export class StorageService {
  private readonly baseDir: string;

  constructor(private readonly config: ConfigService) {
    this.baseDir = this.config.get<string>('STORAGE_PATH', './uploads');
  }

  async save(file: { buffer: Buffer; originalname: string; mimetype: string; size: number }, folder: string) {
    const ext = path.extname(file.originalname).toLowerCase();
    const validExts: Record<string, string> = { '.jpg': '.jpg', '.jpeg': '.jpeg', '.png': '.png', '.webp': '.webp' };
    const safeExt = validExts[ext] || '.jpg';
    const storageKey = `${folder}/${randomUUID()}${safeExt}`;
    const fullPath = this._resolve(storageKey);
    await fs.mkdir(path.dirname(fullPath), { recursive: true });
    await fs.writeFile(fullPath, file.buffer);
    return { storageKey, originalName: file.originalname, mimeType: file.mimetype, sizeBytes: file.size };
  }

  async remove(storageKey: string) {
    const fullPath = this._resolve(storageKey);
    try { await fs.unlink(fullPath); } catch {}
  }

  async read(storageKey: string, mimeType = 'image/jpeg'): Promise<{ readable: Readable; mime: string; size: number }> {
    const fullPath = this._resolve(storageKey);
    try {
      const stat = await fs.stat(fullPath);
      const fd = await fs.open(fullPath, 'r');
      const readable = fd.createReadStream();
      return { readable, mime: mimeType, size: stat.size };
    } catch {
      throw new Error('FILE_NOT_FOUND');
    }
  }

  getUrl(storageKey: string): string {
    const baseUrl = this.config.get<string>('STORAGE_BASE_URL', '/api/v1/files');
    return `${baseUrl}/${storageKey}`;
  }

  private _resolve(storageKey: string): string {
    if (!storageKey || storageKey.includes('\\') || storageKey.startsWith('/') || storageKey.includes('..')) {
      throw new Error('Storage Key inválida.');
    }
    const base = path.resolve(this.baseDir);
    const target = path.resolve(base, storageKey);
    const relative = path.relative(base, target);
    if (relative.startsWith('..') || path.isAbsolute(relative) || relative.includes('\\')) {
      throw new Error('Path traversal detectado.');
    }
    return target;
  }
}