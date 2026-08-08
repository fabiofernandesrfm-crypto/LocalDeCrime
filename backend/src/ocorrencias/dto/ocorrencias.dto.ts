import { IsString, IsOptional, MinLength } from 'class-validator';
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