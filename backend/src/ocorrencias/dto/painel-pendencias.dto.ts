import { IsOptional, IsString, IsIn, IsInt, Min, Max, IsDateString } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

const VALID_CRITICIDADES = ['ALTA', 'MEDIA', 'BAIXA'] as const;
const VALID_STATUS = ['ABERTA', 'EM_INVESTIGACAO', 'CONCLUIDA', 'ARQUIVADA'] as const;
const VALID_CODIGOS = [
  'OCORRENCIA_NAO_FINALIZADA', 'SEM_PESSOA', 'SEM_VEICULO', 'SEM_OBJETO',
  'SEM_VESTIGIO', 'SEM_FOTOGRAFIA', 'SEM_ANEXO', 'VESTIGIO_SEM_CUSTODIA',
] as const;

export class PainelPendenciasQueryDto {
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(1) @Type(() => Number) page?: number = 1;
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(1) @Max(100) @Type(() => Number) pageSize?: number = 20;
  @ApiPropertyOptional({ enum: VALID_CRITICIDADES }) @IsOptional() @IsIn(VALID_CRITICIDADES as unknown as string[]) criticidade?: string;
  @ApiPropertyOptional({ enum: VALID_STATUS }) @IsOptional() @IsIn(VALID_STATUS as unknown as string[]) status?: string;
  @ApiPropertyOptional({ enum: VALID_CODIGOS }) @IsOptional() @IsIn(VALID_CODIGOS as unknown as string[]) codigoPendencia?: string;
  @ApiPropertyOptional() @IsOptional() @IsDateString() dataInicial?: string;
  @ApiPropertyOptional() @IsOptional() @IsDateString() dataFinal?: string;
}

export class PainelPendenciasItemDto {
  ocorrenciaId: string;
  numeroBo: string;
  status: string;
  dataOcorrencia: string;
  resumo: { total: number; alta: number; media: number; baixa: number };
  pendencias: { codigo: string; criticidade: string; categoria: string; titulo: string }[];
}

export class PainelPendenciasResponseDto {
  items: PainelPendenciasItemDto[];
  page: number;
  pageSize: number;
  total: number;
  totalPages: number;
}