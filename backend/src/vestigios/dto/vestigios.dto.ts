import { IsString, IsOptional, IsBoolean, IsNumber, Min, Max } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class CreateVestigioDto {
  @ApiPropertyOptional({ example: 'Biológico' }) @IsOptional() @IsString() categoria?: string;
  @ApiPropertyOptional({ example: 'Mancha de sangue no chão' }) @IsOptional() @IsString() descricao?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() caracteristicas?: string;
  @ApiPropertyOptional({ example: 'Próximo ao corpo da vítima' }) @IsOptional() @IsString() localizacaoDescricao?: string;
  @ApiPropertyOptional({ example: -8.04762 }) @IsOptional() @IsNumber() @Min(-90) @Max(90) gpsLat?: number;
  @ApiPropertyOptional({ example: -34.87703 }) @IsOptional() @IsNumber() @Min(-180) @Max(180) gpsLng?: number;
  @ApiPropertyOptional({ default: false }) @IsOptional() @IsBoolean() coletado?: boolean;
  @ApiPropertyOptional({ description: 'Responsável físico pela coleta' }) @IsOptional() @IsString() coletadoPor?: string;
  @ApiPropertyOptional({ example: 'Localizado' }) @IsOptional() @IsString() situacao?: string;
  @ApiPropertyOptional({ example: 'Encaminhado para perícia' }) @IsOptional() @IsString() destinacao?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() observacoes?: string;
}

export class UpdateVestigioDto {
  @ApiPropertyOptional() @IsOptional() @IsString() categoria?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() descricao?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() caracteristicas?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() localizacaoDescricao?: string;
  @ApiPropertyOptional() @IsOptional() @IsNumber() @Min(-90) @Max(90) gpsLat?: number;
  @ApiPropertyOptional() @IsOptional() @IsNumber() @Min(-180) @Max(180) gpsLng?: number;
  @ApiPropertyOptional() @IsOptional() @IsBoolean() coletado?: boolean;
  @ApiPropertyOptional() @IsOptional() @IsString() coletadoPor?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() situacao?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() destinacao?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() observacoes?: string;
}