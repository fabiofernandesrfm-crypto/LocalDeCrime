-- CreateEnum
CREATE TYPE "TipoHistoricoStatus" AS ENUM ('FINALIZACAO', 'REABERTURA');

-- CreateTable
CREATE TABLE "historico_status_ocorrencia" (
    "id" TEXT NOT NULL,
    "tipo" "TipoHistoricoStatus" NOT NULL,
    "status_anterior" "StatusOcorrencia" NOT NULL,
    "status_novo" "StatusOcorrencia" NOT NULL,
    "motivo" TEXT,
    "alterado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ocorrencia_id" TEXT NOT NULL,
    "alterado_por_id" TEXT NOT NULL,

    CONSTRAINT "historico_status_ocorrencia_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "historico_status_ocorrencia_ocorrencia_id_idx" ON "historico_status_ocorrencia"("ocorrencia_id");

-- CreateIndex
CREATE INDEX "historico_status_ocorrencia_alterado_por_id_idx" ON "historico_status_ocorrencia"("alterado_por_id");

-- CreateIndex
CREATE INDEX "historico_status_ocorrencia_alterado_em_idx" ON "historico_status_ocorrencia"("alterado_em");

-- AddForeignKey
ALTER TABLE "historico_status_ocorrencia" ADD CONSTRAINT "historico_status_ocorrencia_ocorrencia_id_fkey" FOREIGN KEY ("ocorrencia_id") REFERENCES "ocorrencias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "historico_status_ocorrencia" ADD CONSTRAINT "historico_status_ocorrencia_alterado_por_id_fkey" FOREIGN KEY ("alterado_por_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
