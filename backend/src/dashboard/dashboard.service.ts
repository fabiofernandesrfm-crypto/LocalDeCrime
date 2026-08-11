import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DashboardOcorrenciasQueryDto, DashboardOcorrenciasResponseDto } from './dto/dashboard.dto';

const STATUSES = ['ABERTA', 'EM_INVESTIGACAO', 'CONCLUIDA', 'ARQUIVADA'] as const;

@Injectable()
export class DashboardService {
  constructor(private readonly prisma: PrismaService) {}

  async getOcorrencias(dto: DashboardOcorrenciasQueryDto, currentUser: any): Promise<DashboardOcorrenciasResponseDto> {
    // Unidade do usuário
    if (!currentUser.unidadeId) return this._empty(dto);
    const unidade = await this.prisma.unidade.findUnique({ where: { id: currentUser.unidadeId }, include: { delegacia: true } });
    if (!unidade?.delegacia) return this._empty(dto);

    // Se delegaciaId informado e diferente da institucional → retorno vazio
    if (dto.delegaciaId && dto.delegaciaId !== unidade.delegacia.id) {
      return this._empty(dto);
    }

    // Where base com isolamento
    const baseWhere: any = { delegaciaId: unidade.delegacia.id };
    this._applyFilters(dto, baseWhere);

    // ── Agregações (todas em paralelo via $transaction) ──────
    const [statusCounts, municipioCounts, delegaciaCounts, resumoCounts] = await Promise.all([
      // porStatus
      this.prisma.ocorrencia.groupBy({ by: ['status'], where: baseWhere, _count: { id: true } }),
      // porMunicipio
      this.prisma.ocorrencia.groupBy({ by: ['municipioId'], where: baseWhere, _count: { id: true } }),
      // porDelegacia
      this.prisma.ocorrencia.groupBy({ by: ['delegaciaId'], where: baseWhere, _count: { id: true } }),
      // resumo (totais por status + count total)
      Promise.all(STATUSES.map(s => this.prisma.ocorrencia.count({ where: { ...baseWhere, status: s } }))),
    ]);

    // Resolver nomes (batch único)
    const [municipiosMap, delegaciasMap] = await Promise.all([
      this._loadMunicipios(municipioCounts.map(m => m.municipioId)),
      this._loadDelegacias(delegaciaCounts.map(d => d.delegaciaId)),
    ]);

    // porDia
    const diasRaw = await this.prisma.ocorrencia.groupBy({
      by: ['dataOcorrencia'],
      where: baseWhere,
      _count: { id: true },
    });

    const porDia = diasRaw
      .map(d => ({ data: d.dataOcorrencia.toISOString().substring(0, 10), total: d._count.id }))
      .reduce((acc: { data: string; total: number }[], curr) => {
        const existing = acc.find(a => a.data === curr.data);
        if (existing) { existing.total += curr.total; } else { acc.push(curr); }
        return acc;
      }, [])
      .sort((a, b) => a.data.localeCompare(b.data));

    return {
      filtros: {
        dataInicial: dto.dataInicial || null,
        dataFinal: dto.dataFinal || null,
        municipioId: dto.municipioId || null,
        delegaciaId: dto.delegaciaId || null,
      },
      resumo: {
        totalOcorrencias: resumoCounts.reduce((a, b) => a + b, 0),
        abertas: resumoCounts[0],
        emInvestigacao: resumoCounts[1],
        concluidas: resumoCounts[2],
        arquivadas: resumoCounts[3],
      },
      porStatus: statusCounts.map(s => ({ status: s.status, total: s._count.id })),
      porDia,
      porMunicipio: municipioCounts.map(m => ({ municipioId: m.municipioId, municipio: municipiosMap.get(m.municipioId) || m.municipioId, total: m._count.id })),
      porDelegacia: delegaciaCounts.map(d => ({ delegaciaId: d.delegaciaId, delegacia: delegaciasMap.get(d.delegaciaId) || d.delegaciaId, total: d._count.id })),
    };
  }

  // ── Helpers ───────────────────────────────────────────────
  private _applyFilters(dto: DashboardOcorrenciasQueryDto, where: any) {
    if (dto.dataInicial || dto.dataFinal) {
      if (dto.dataInicial && dto.dataFinal && new Date(dto.dataInicial) > new Date(dto.dataFinal)) {
        throw new BadRequestException('dataInicial não pode ser posterior a dataFinal.');
      }
      where.dataOcorrencia = {};
      if (dto.dataInicial) where.dataOcorrencia.gte = new Date(dto.dataInicial);
      if (dto.dataFinal) where.dataOcorrencia.lte = new Date(dto.dataFinal);
    }
    if (dto.municipioId) where.municipioId = dto.municipioId;
    // dto.delegaciaId NÃO sobrescreve a delegacia institucional (isolamento obrigatório)
  }

  private async _loadMunicipios(ids: string[]): Promise<Map<string, string>> {
    const unique = [...new Set(ids)];
    if (unique.length === 0) return new Map();
    const rows = await this.prisma.municipio.findMany({ where: { id: { in: unique } }, select: { id: true, nome: true } });
    return new Map(rows.map(r => [r.id, r.nome]));
  }

  private async _loadDelegacias(ids: string[]): Promise<Map<string, string>> {
    const unique = [...new Set(ids)];
    if (unique.length === 0) return new Map();
    const rows = await this.prisma.delegacia.findMany({ where: { id: { in: unique } }, select: { id: true, titulo: true } });
    return new Map(rows.map(r => [r.id, r.titulo ?? r.id]));
  }

  private _empty(dto: DashboardOcorrenciasQueryDto): DashboardOcorrenciasResponseDto {
    return {
      filtros: { dataInicial: dto.dataInicial || null, dataFinal: dto.dataFinal || null, municipioId: dto.municipioId || null, delegaciaId: dto.delegaciaId || null },
      resumo: { totalOcorrencias: 0, abertas: 0, emInvestigacao: 0, concluidas: 0, arquivadas: 0 },
      porStatus: [], porDia: [], porMunicipio: [], porDelegacia: [],
    };
  }
}