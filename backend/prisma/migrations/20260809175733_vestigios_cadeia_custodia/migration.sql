-- AlterTable
ALTER TABLE "vestigios_ocorrencia" ADD COLUMN     "acondicionado" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "acondicionado_em" TIMESTAMP(3),
ADD COLUMN     "acondicionado_por" TEXT,
ADD COLUMN     "descricao_acondicionamento" TEXT,
ADD COLUMN     "lacrado_em" TIMESTAMP(3),
ADD COLUMN     "lacrado_por" TEXT,
ADD COLUMN     "numero_lacre" TEXT,
ADD COLUMN     "tipo_acondicionamento" TEXT,
ADD COLUMN     "tipo_lacre" TEXT;

-- CreateTable
CREATE TABLE "movimentacoes_custodia_vestigio" (
    "id" TEXT NOT NULL,
    "tipo_movimentacao" TEXT NOT NULL,
    "origem" TEXT,
    "destino" TEXT,
    "entregue_por" TEXT,
    "recebido_por" TEXT,
    "documento_recebedor" TEXT,
    "observacoes" TEXT,
    "movimentado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "vestigio_id" TEXT NOT NULL,
    "registrado_por_id" TEXT NOT NULL,

    CONSTRAINT "movimentacoes_custodia_vestigio_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "movimentacoes_custodia_vestigio_vestigio_id_idx" ON "movimentacoes_custodia_vestigio"("vestigio_id");

-- CreateIndex
CREATE INDEX "movimentacoes_custodia_vestigio_registrado_por_id_idx" ON "movimentacoes_custodia_vestigio"("registrado_por_id");

-- CreateIndex
CREATE INDEX "movimentacoes_custodia_vestigio_movimentado_em_idx" ON "movimentacoes_custodia_vestigio"("movimentado_em");

-- AddForeignKey
ALTER TABLE "movimentacoes_custodia_vestigio" ADD CONSTRAINT "movimentacoes_custodia_vestigio_vestigio_id_fkey" FOREIGN KEY ("vestigio_id") REFERENCES "vestigios_ocorrencia"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "movimentacoes_custodia_vestigio" ADD CONSTRAINT "movimentacoes_custodia_vestigio_registrado_por_id_fkey" FOREIGN KEY ("registrado_por_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
