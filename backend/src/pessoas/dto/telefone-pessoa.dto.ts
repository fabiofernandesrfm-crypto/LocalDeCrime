import { IsString, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateTelefoneDto {
  @ApiProperty({ example: '(81) 99999-0001' })
  @IsString()
  numero: string;

  @ApiProperty({ example: 'CELULAR', required: false })
  @IsOptional() @IsString()
  tipo?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  observacao?: string;
}

export class UpdateTelefoneDto {
  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  numero?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  tipo?: string;

  @ApiProperty({ required: false })
  @IsOptional() @IsString()
  observacao?: string;
}