import { IsString, IsOptional, MinLength, MaxLength, IsIn, IsInt, Min, Max, IsDateString } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class CreateOcorrenciaDto {
  @ApiProperty({ example: 'Descricao da ocorrencia', description: 'Descricao/relato da ocorrencia' })
  @IsString() @MinLength(10) descricao: string;
  @ApiPropertyOptional({ example: 'Observacoes adicionais' })
  @IsOptional() @IsString() observacoes?: string;
}

export class ArquivarOcorrenciaDto {
  @ApiProperty({ example: 'Ocorrência concluída e pronta para arquivamento definitivo.' })
  @IsString() @MinLength(5) @MaxLength(5000) motivo: string;
}

export class ReabrirOcorrenciaDto {
  @ApiProperty({ example: 'Necessário complementar investigação após novas evidências.' })
  @IsString() @MinLength(5) @MaxLength(5000) justificativa: string;
}

export class FinalizarOcorrenciaDto {
  @ApiPropertyOptional({ example: 'Ocorrência encerrada após coleta de todos os vestígios.' })
  @IsOptional() @IsString() @MinLength(3) @MaxLength(5000) observacoes?: string;
}

export class UpdateOcorrenciaDto {
  @ApiPropertyOptional({ example: 'Nova descricao' }) @IsOptional() @IsString() descricao?: string;
  @ApiPropertyOptional({ example: 'Novas observacoes' }) @IsOptional() @IsString() observacoes?: string;
}

// ── Consulta Avançada ────────────────────────────────────────
const VALID_STATUS = ['ABERTA', 'EM_INVESTIGACAO', 'CONCLUIDA', 'ARQUIVADA'] as const;
type StatusValido = typeof VALID_STATUS[number];

const VALID_SORT = ['criadoEm', 'dataOcorrencia', 'numeroBo', 'status'] as const;

export class SearchOcorrenciasDto {
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(1) @Type(() => Number) page?: number = 1;
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(1) @Max(100) @Type(() => Number) pageSize?: number = 20;

  @ApiPropertyOptional() @IsOptional() @IsString() numeroBo?: string;
  @ApiPropertyOptional({ enum: VALID_STATUS }) @IsOptional() @IsString() status?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() delegaciaId?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() municipioId?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() usuarioId?: string;
  @ApiPropertyOptional({ example: 'HML-2026' })
  @IsOptional() @IsString() q?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() descricao?: string;

  // ── Pesquisa Operacional Integrada ────────────────────────
  @ApiPropertyOptional({ example: 'João' })
  @IsOptional() @IsString() nomePessoa?: string;
  @ApiPropertyOptional({ example: '12345678900' })
  @IsOptional() @IsString() cpfPessoa?: string;
  @ApiPropertyOptional({ example: 'ABC1234' })
  @IsOptional() @IsString() placaVeiculo?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() objetoDescricao?: string;

  // ── Pesquisa Operacional Avançada ─────────────────────────
  @ApiPropertyOptional() @IsOptional() @IsString() descricaoVestigio?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() categoriaVestigio?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() numeroLacre?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() legendaFoto?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() descricaoAnexo?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() tipoMovimentacaoCustodia?: string;

  @ApiPropertyOptional({ example: '2026-08-01T00:00:00.000Z' })
  @IsOptional() @IsDateString() dataInicial?: string;
  @ApiPropertyOptional({ example: '2026-08-31T23:59:59.999Z' })
  @IsOptional() @IsDateString() dataFinal?: string;

  @ApiPropertyOptional({ enum: VALID_SORT })
  @IsOptional() @IsIn(VALID_SORT as unknown as string[]) sortBy?: string = 'criadoEm';
  @ApiPropertyOptional({ enum: ['asc', 'desc'] })
  @IsOptional() @IsString() sortOrder?: string = 'desc';
}

export class PaginatedOcorrenciasDto {
  @ApiProperty() items: OcorrenciaResponseDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
  @ApiProperty() totalPages: number;
}

export class OcorrenciaResponseDto {
  @ApiProperty() id: string;
  @ApiProperty() numeroBo: string;
  @ApiProperty() status: string;
  @ApiProperty() descricao: string;
  @ApiProperty() observacoes: string | null;
  @ApiProperty() dataOcorrencia: Date;
  @ApiProperty() dataConclusao: Date | null;
  @ApiProperty() criadoEm: Date;
  @ApiProperty() usuarioId: string;
  @ApiProperty() municipioId: string;
  @ApiProperty() delegaciaId: string;
}