import { IsString, IsOptional, MinLength, MaxLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateOcorrenciaDto {
  @ApiProperty({ example: 'Descricao da ocorrencia', description: 'Descricao/relato da ocorrencia' })
  @IsString()
  @MinLength(10)
  descricao: string;

  @ApiPropertyOptional({ example: 'Observacoes adicionais' })
  @IsOptional()
  @IsString()
  observacoes?: string;

  // municipioId, delegaciaId, usuarioId, unidadeId, status, numeroBo
  // sao determinados exclusivamente pelo backend via JWT.
}

export class ArquivarOcorrenciaDto {
  @ApiProperty({ example: 'Ocorrência concluída e pronta para arquivamento definitivo.' })
  @IsString()
  @MinLength(5)
  @MaxLength(5000)
  motivo: string;
}

export class ReabrirOcorrenciaDto {
  @ApiProperty({ example: 'Necessário complementar investigação após novas evidências.' })
  @IsString()
  @MinLength(5)
  @MaxLength(5000)
  justificativa: string;
}

export class FinalizarOcorrenciaDto {
  @ApiPropertyOptional({ example: 'Ocorrência encerrada após coleta de todos os vestígios.' })
  @IsOptional()
  @IsString()
  @MinLength(3)
  @MaxLength(5000)
  observacoes?: string;
}

export class UpdateOcorrenciaDto {
  @ApiPropertyOptional({ example: 'Nova descricao' })
  @IsOptional()
  @IsString()
  descricao?: string;

  @ApiPropertyOptional({ example: 'Novas observacoes' })
  @IsOptional()
  @IsString()
  observacoes?: string;
}

export class OcorrenciaResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  numeroBo: string;

  @ApiProperty()
  status: string;

  @ApiProperty()
  descricao: string;

  @ApiProperty()
  observacoes: string | null;

  @ApiProperty()
  dataOcorrencia: Date;

  @ApiProperty()
  dataConclusao: Date | null;

  @ApiProperty()
  criadoEm: Date;

  @ApiProperty()
  usuarioId: string;

  @ApiProperty()
  municipioId: string;

  @ApiProperty()
  delegaciaId: string;
}