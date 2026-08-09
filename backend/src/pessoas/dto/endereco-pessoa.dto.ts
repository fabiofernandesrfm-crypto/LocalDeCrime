import { IsString, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateEnderecoDto {
  @ApiProperty({ example: 'Rua Exemplo, 100' })
  @IsString()
  logradouro: string;

  @ApiProperty({ example: 'Centro', required: false })
  @IsOptional() @IsString()
  bairro?: string;

  @ApiProperty({ example: 'Recife', required: false })
  @IsOptional() @IsString()
  cidade?: string;

  @ApiProperty({ example: 'PE', required: false })
  @IsOptional() @IsString()
  estado?: string;

  @ApiProperty({ example: '50000-000', required: false })
  @IsOptional() @IsString()
  cep?: string;

  @ApiProperty({ example: '123', required: false })
  @IsOptional() @IsString()
  numero?: string;

  @ApiProperty({ example: 'Apto 101', required: false })
  @IsOptional() @IsString()
  complemento?: string;

  @ApiProperty({ example: 'RESIDENCIAL', required: false })
  @IsOptional() @IsString()
  tipo?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  observacao?: string;
}

export class UpdateEnderecoDto {
  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  logradouro?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  bairro?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  cidade?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  estado?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  cep?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  numero?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  complemento?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  tipo?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  observacao?: string;
}