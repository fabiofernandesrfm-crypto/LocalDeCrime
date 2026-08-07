import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma/prisma.service';

@Injectable()
export class AppService {
  constructor(private readonly prisma: PrismaService) {}

  getHello(): string {
    return 'Sistema de Registro de Atendimento em Local de Crime API';
  }

  async healthCheck(): Promise<{
    status: string;
    service: string;
    database: string;
  }> {
    let dbStatus = 'disconnected';
    try {
      await this.prisma.$queryRawUnsafe('SELECT 1');
      dbStatus = 'connected';
    } catch {
      dbStatus = 'disconnected';
    }

    const overall = dbStatus === 'connected' ? 'ok' : 'degraded';

    return {
      status: overall,
      service: 'local-de-crime-api',
      database: dbStatus,
    };
  }
}