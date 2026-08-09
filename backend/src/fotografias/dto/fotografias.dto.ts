import { IsString, IsOptional, IsInt, IsNumber, IsDateString, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class FotografiaBodyDto {
  @ApiPropertyOptional() @IsOptional() @IsString() legenda?: string;
  @ApiPropertyOptional({ default: 0 }) @IsOptional() @Type(() => Number) @IsInt() ordem?: number;
  @ApiPropertyOptional() @IsOptional() @IsDateString() capturadoEm?: string;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() @Min(-90) @Max(90) gpsLat?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() @Min(-180) @Max(180) gpsLng?: number;
  @ApiPropertyOptional({ description: 'Vincular a pessoa (opcional, exclusivo)' }) @IsOptional() @IsString() pessoaId?: string;
  @ApiPropertyOptional({ description: 'Vincular a veiculo (opcional, exclusivo)' }) @IsOptional() @IsString() veiculoId?: string;
  @ApiPropertyOptional({ description: 'Vincular a objeto (opcional, exclusivo)' }) @IsOptional() @IsString() objetoId?: string;
  @ApiPropertyOptional({ description: 'Vincular a vestigio (opcional, exclusivo)' }) @IsOptional() @IsString() vestigioId?: string;
}

export class UpdateFotografiaDto {
  @ApiPropertyOptional() @IsOptional() @IsString() legenda?: string;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsInt() ordem?: number;
  @ApiPropertyOptional() @IsOptional() @IsDateString() capturadoEm?: string;
  @ApiPropertyOptional({ description: 'Vincular a pessoa (opcional, exclusivo)' }) @IsOptional() @IsString() pessoaId?: string;
  @ApiPropertyOptional({ description: 'Vincular a veiculo (opcional, exclusivo)' }) @IsOptional() @IsString() veiculoId?: string;
  @ApiPropertyOptional({ description: 'Vincular a objeto (opcional, exclusivo)' }) @IsOptional() @IsString() objetoId?: string;
  @ApiPropertyOptional({ description: 'Vincular a vestigio (opcional, exclusivo)' }) @IsOptional() @IsString() vestigioId?: string;
}