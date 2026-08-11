export class PendenciaDto {
  codigo: string;
  titulo: string;
  descricao: string;
  criticidade: 'ALTA' | 'MEDIA' | 'BAIXA';
  categoria: string;
}

export class PendenciasResponseDto {
  ocorrenciaId: string;
  numeroBo: string;
  status: string;
  resumo: { total: number; alta: number; media: number; baixa: number };
  pendencias: PendenciaDto[];
}