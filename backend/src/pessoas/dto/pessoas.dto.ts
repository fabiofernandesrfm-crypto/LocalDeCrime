import { IsString, IsOptional, IsEnum, IsBoolean, MinLength, ValidateIf } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Sexo, TipoEnvolvimento } from '@prisma/client';

export class CreatePessoaEnvolvidaDto {
  @ApiProperty({ enum: TipoEnvolvimento, example: 'VITIMA' })
  @IsEnum(TipoEnvolvimento)
  tipoEnvolvimento: TipoEnvolvimento;

  @ApiPropertyOptional({ default: true })
  @IsOptional()
  @IsBoolean()
  identificada?: boolean;

  // nome: obrigatório quando identificada=true OU tipo != VITIMA
  @ApiPropertyOptional({ example: 'João da Silva' })
  @ValidateIf((o: CreatePessoaEnvolvidaDto) => o.identificada !== false || o.tipoEnvolvimento !== 'VITIMA')
  @IsString()
  @MinLength(3)
  nome?: string;

  @ApiPropertyOptional({ example: '1234567', description: 'NIC — Número de Identificação Criminal' })
  @IsOptional()
  @IsString()
  nic?: string;

  @ApiPropertyOptional({ example: '123.456.789-00' })
  @IsOptional()
  @IsString()
  cpf?: string;

  @ApiPropertyOptional({ example: '12.345.678-9' })
  @IsOptional()
  @IsString()
  rg?: string;

  @ApiPropertyOptional({ enum: Sexo, example: 'MASCULINO' })
  @IsOptional()
  @IsEnum(Sexo)
  sexo?: Sexo;

  @ApiPropertyOptional({ example: '1990-03-15' })
  @IsOptional()
  @IsString()
  dataNascimento?: string;

  @ApiPropertyOptional({ example: '(81) 99999-0000' })
  @IsOptional()
  @IsString()
  telefone?: string;

  @ApiPropertyOptional({ example: 'Rua Exemplo, 100' })
  @IsOptional()
  @IsString()
  endereco?: string;

  @ApiPropertyOptional({ example: 'Centro' })
  @IsOptional()
  @IsString()
  bairro?: string;

  @ApiPropertyOptional({ example: '50000-000' })
  @IsOptional()
  @IsString()
  cep?: string;

  @ApiPropertyOptional({ example: 'Depoimento da pessoa...' })
  @IsOptional()
  @IsString()
  depoimento?: string;
}

export class UpdatePessoaEnvolvidaDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MinLength(3)
  nome?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  identificada?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  nic?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  cpf?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  rg?: string;

  @ApiPropertyOptional({ enum: Sexo })
  @IsOptional()
  @IsEnum(Sexo)
  sexo?: Sexo;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  dataNascimento?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  telefone?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  endereco?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  bairro?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  cep?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  depoimento?: string;
}

export class PessoaEnvolvidaResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  nome: string | null;

  @ApiProperty()
  identificada: boolean;

  @ApiProperty()
  nic: string | null;

  @ApiProperty()
  tipoEnvolvimento: string;

  @ApiProperty()
  cpf: string | null;

  @ApiProperty()
  rg: string | null;

  @ApiProperty()
  sexo: string;

  @ApiProperty()
  dataNascimento: Date | null;

  @ApiProperty()
  telefone: string | null;

  @ApiProperty()
  endereco: string | null;

  @ApiProperty()
  bairro: string | null;

  @ApiProperty()
  cep: string | null;

  @ApiProperty()
  depoimento: string | null;

  @ApiProperty()
  ocorrenciaId: string;

  @ApiProperty()
  criadoEm: Date;
}