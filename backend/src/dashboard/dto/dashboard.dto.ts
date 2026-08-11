import { IsOptional, IsString, IsDateString } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class DashboardOcorrenciasQueryDto {
  @ApiPropertyOptional({ example: '2026-08-01T00:00:00.000Z' })
  @IsOptional() @IsDateString() dataInicial?: string;
  @ApiPropertyOptional({ example: '2026-08-31T23:59:59.999Z' })
  @IsOptional() @IsDateString() dataFinal?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() municipioId?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() delegaciaId?: string;
}

export class DashboardOcorrenciasResponseDto {
  filtros: {
    dataInicial: string | null;
    dataFinal: string | null;
    municipioId: string | null;
    delegaciaId: string | null;
  };
  resumo: {
    totalOcorrencias: number;
    abertas: number;
    emInvestigacao: number;
    concluidas: number;
    arquivadas: number;
  };
  porStatus: { status: string; total: number }[];
  porDia: { data: string; total: number }[];
  porMunicipio: { municipioId: string; municipio: string; total: number }[];
  porDelegacia: { delegaciaId: string; delegacia: string; total: number }[];
}