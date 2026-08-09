import { IsString, IsOptional } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class AnexoBodyDto {
  @ApiPropertyOptional({ example: 'Ofício' })
  @IsOptional() @IsString()
  categoria?: string;

  @ApiPropertyOptional({ example: 'Ofício solicitando perícia complementar' })
  @IsOptional() @IsString()
  descricao?: string;

  @ApiPropertyOptional({ description: 'Vincular a pessoa (opcional, exclusivo)' })
  @IsOptional() @IsString()
  pessoaId?: string;

  @ApiPropertyOptional({ description: 'Vincular a veiculo (opcional, exclusivo)' })
  @IsOptional() @IsString()
  veiculoId?: string;

  @ApiPropertyOptional({ description: 'Vincular a objeto (opcional, exclusivo)' })
  @IsOptional() @IsString()
  objetoId?: string;

  @ApiPropertyOptional({ description: 'Vincular a vestigio (opcional, exclusivo)' })
  @IsOptional() @IsString()
  vestigioId?: string;
}

export class UpdateAnexoDto {
  @ApiPropertyOptional() @IsOptional() @IsString() categoria?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() descricao?: string;
  @ApiPropertyOptional({ description: 'Vincular a pessoa (opcional, exclusivo)' }) @IsOptional() @IsString() pessoaId?: string;
  @ApiPropertyOptional({ description: 'Vincular a veiculo (opcional, exclusivo)' }) @IsOptional() @IsString() veiculoId?: string;
  @ApiPropertyOptional({ description: 'Vincular a objeto (opcional, exclusivo)' }) @IsOptional() @IsString() objetoId?: string;
  @ApiPropertyOptional({ description: 'Vincular a vestigio (opcional, exclusivo)' }) @IsOptional() @IsString() vestigioId?: string;
}