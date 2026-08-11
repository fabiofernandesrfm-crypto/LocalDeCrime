import { IsOptional, IsIn, IsInt, Min, Max, IsDateString } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

const VALID_PRIORIDADES = ['CRITICA', 'ALTA', 'MEDIA', 'BAIXA'] as const;
const VALID_CODIGOS = [
  'OCORRENCIA_NAO_FINALIZADA', 'SEM_PESSOA', 'SEM_VEICULO', 'SEM_OBJETO',
  'SEM_VESTIGIO', 'SEM_FOTOGRAFIA', 'SEM_ANEXO', 'VESTIGIO_SEM_CUSTODIA',
] as const;

export class FilaOperacionalQueryDto {
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(1) @Type(() => Number) page?: number = 1;
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(1) @Max(100) @Type(() => Number) pageSize?: number = 20;
  @ApiPropertyOptional({ enum: VALID_PRIORIDADES }) @IsOptional() @IsIn(VALID_PRIORIDADES as unknown as string[]) prioridade?: string;
  @ApiPropertyOptional({ enum: VALID_CODIGOS }) @IsOptional() @IsIn(VALID_CODIGOS as unknown as string[]) codigoPendencia?: string;
  @ApiPropertyOptional() @IsOptional() @IsDateString() dataInicial?: string;
  @ApiPropertyOptional() @IsOptional() @IsDateString() dataFinal?: string;
}

export class FilaOperacionalItemDto {
  ocorrenciaId: string;
  numeroBo: string;
  dataOcorrencia: string;
  idadeHoras: number;
  prioridade: string;
  motivos: string[];
  resumoPendencias: { total: number; alta: number; media: number; baixa: number };
}

export class FilaOperacionalResponseDto {
  items: FilaOperacionalItemDto[];
  page: number;
  pageSize: number;
  total: number;
  totalPages: number;
}