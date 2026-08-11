// ── Relatório Operacional Consolidado ───────────────────────

export class RelatorioOcorrenciaDto {
  ocorrencia: OcorrenciaRelatorioDto;
  pessoas: PessoaRelatorioDto[];
  veiculos: VeiculoRelatorioDto[];
  objetos: ObjetoRelatorioDto[];
  vestigios: VestigioRelatorioDto[];
  fotografias: FotografiaRelatorioDto[];
  anexos: AnexoRelatorioDto[];
  historicoStatus: HistoricoStatusRelatorioDto[];
  linhaDoTempo: LinhaTempoRelatorioDto[];
}

export class OcorrenciaRelatorioDto {
  id: string;
  numeroBo: string;
  status: string;
  descricao: string;
  observacoes: string | null;
  dataOcorrencia: string;
  dataConclusao: string | null;
  criadoEm: string;
  municipio: { id: string; nome: string } | null;
  delegacia: { id: string; nome: string } | null;
  usuario: { id: string; nome: string; matricula: string; cargo: string | null } | null;
}

export class PessoaRelatorioDto {
  id: string; nome: string | null; identificada: boolean; nic: string | null; cpf: string | null;
  tipoEnvolvimento: string; sexo: string | null; dataNascimento: string | null;
  telefone: string | null; bairro: string | null; criadoEm: string;
}

export class VeiculoRelatorioDto {
  id: string; placa: string | null; marca: string | null; modelo: string | null;
  ano: string | null; cor: string | null; situacao: string | null; criadoEm: string;
}

export class ObjetoRelatorioDto {
  id: string; categoria: string | null; descricao: string | null; marca: string | null;
  modelo: string | null; quantidade: number; situacao: string | null; criadoEm: string;
}

export class VestigioRelatorioDto {
  id: string; categoria: string | null; descricao: string | null;
  coletado: boolean; situacao: string | null; numeroLacre: string | null;
  criadoEm: string;
  custodia: CustodiaRelatorioDto[];
}

export class CustodiaRelatorioDto {
  id: string; tipoMovimentacao: string; origem: string | null; destino: string | null;
  entreguePor: string | null; recebidoPor: string | null; movimentadoEm: string;
}

export class FotografiaRelatorioDto {
  id: string; legenda: string | null; mimeType: string; tamanhoBytes: number;
  criadoEm: string;
}

export class AnexoRelatorioDto {
  id: string; descricao: string | null; mimeType: string; tamanhoBytes: number;
  criadoEm: string;
}

export class HistoricoStatusRelatorioDto {
  id: string; tipo: string; statusAnterior: string; statusNovo: string;
  motivo: string | null; alteradoEm: string;
  alteradoPor: { id: string; nome: string; matricula: string; cargo: string | null } | null;
}

export class LinhaTempoRelatorioDto {
  id: string; tipo: string; titulo: string; descricao: string | null; dataHora: string;
  usuario: { id: string; nome: string; matricula: string; cargo: string | null } | null;
}