import {
  IsString,
  IsOptional,
  IsEnum,
  IsNumber,
  MinLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum TipoLocal {
  RESIDENCIA = 'RESIDENCIA',
  VIA_PUBLICA = 'VIA_PUBLICA',
  ESTABELECIMENTO_COMERCIAL = 'ESTABELECIMENTO_COMERCIAL',
  AREA_RURAL = 'AREA_RURAL',
  VEICULO = 'VEICULO',
  OUTRO = 'OUTRO',
}

export enum StatusAtendimento {
  ABERTO = 'ABERTO',
  EM_ANDAMENTO = 'EM_ANDAMENTO',
  CONCLUIDO = 'CONCLUIDO',
  CANCELADO = 'CANCELADO',
}

export class CreateAtendimentoDto {
  @ApiProperty({ example: 'uuid-da-ocorrencia' })
  @IsString()
  ocorrenciaId: string;

  @ApiProperty({ enum: TipoLocal })
  @IsEnum(TipoLocal)
  tipoLocal: TipoLocal;

  @ApiProperty({ example: 'Rua das Flores' })
  @IsString()
  @MinLength(3)
  endereco: string;

  @ApiPropertyOptional({ example: '123' })
  @IsOptional()
  @IsString()
  numero?: string;

  @ApiPropertyOptional({ example: 'Apto 101' })
  @IsOptional()
  @IsString()
  complemento?: string;

  @ApiProperty({ example: 'Centro' })
  @IsString()
  bairro: string;

  @ApiProperty({ example: 'Recife' })
  @IsString()
  cidade: string;

  @ApiPropertyOptional({ example: 'PE' })
  @IsOptional()
  @IsString()
  estado?: string;

  @ApiPropertyOptional({ example: '50000-000' })
  @IsOptional()
  @IsString()
  cep?: string;

  @ApiPropertyOptional({ example: -8.047562 })
  @IsOptional()
  @IsNumber()
  latitude?: number;

  @ApiPropertyOptional({ example: -34.877096 })
  @IsOptional()
  @IsNumber()
  longitude?: number;

  @ApiProperty({ example: 'Arrombamento de residência...' })
  @IsString()
  @MinLength(10)
  descricao: string;

  @ApiPropertyOptional({ example: 'Porta dos fundos arrombada...' })
  @IsOptional()
  @IsString()
  observacoes?: string;
}

export class UpdateAtendimentoDto {
  @ApiPropertyOptional({ enum: StatusAtendimento })
  @IsOptional()
  @IsEnum(StatusAtendimento)
  status?: StatusAtendimento;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  observacoes?: string;
}

export class AtendimentoResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  numeroRegistro: number;

  @ApiProperty()
  status: string;

  @ApiProperty()
  tipoLocal: string;

  @ApiProperty()
  endereco: string;

  @ApiProperty()
  numero: string | null;

  @ApiProperty()
  complemento: string | null;

  @ApiProperty()
  bairro: string;

  @ApiProperty()
  cidade: string;

  @ApiProperty()
  estado: string;

  @ApiProperty()
  cep: string | null;

  @ApiProperty()
  latitude: number | null;

  @ApiProperty()
  longitude: number | null;

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
}