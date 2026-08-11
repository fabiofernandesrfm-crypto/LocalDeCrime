/** Catálogo central de códigos de permissão RBAC. */
export const Permissions = {
  OCORRENCIA_FINALIZAR: 'OCORRENCIA_FINALIZAR',
  OCORRENCIA_REABRIR: 'OCORRENCIA_REABRIR',
  OCORRENCIA_ARQUIVAR: 'OCORRENCIA_ARQUIVAR',
} as const;

export type PermissionCode = (typeof Permissions)[keyof typeof Permissions];