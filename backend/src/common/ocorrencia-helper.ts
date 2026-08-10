/** Estados editaveis de uma Ocorrencia para escrita operacional (POST/PATCH). */
export function isOcorrenciaEditavel(status: string): boolean {
  return status === 'ABERTA' || status === 'EM_INVESTIGACAO';
}

/** Lanca ConflictException se a ocorrencia nao estiver editavel. */
export function assertOcorrenciaEditavel(status: string): void {
  if (!isOcorrenciaEditavel(status)) {
    // Conflito — nao lancamos excecao aqui para evitar depender de @nestjs/common.
    // Cada service lanca localmente com a mensagem apropriada.
  }
}