// Evento da linha do tempo agregada (read-only, derivada dos models existentes)
export interface TimelineEventDto {
  id: string;
  tipo: string;
  categoria: string;
  titulo: string;
  descricao: string | null;
  dataHora: string; // ISO 8601
  entidadeId: string | null;
  entidadeTipo: string;
  usuario: { id: string; nome: string; matricula: string; cargo: string | null } | null;
  metadata: Record<string, unknown> | null;
}