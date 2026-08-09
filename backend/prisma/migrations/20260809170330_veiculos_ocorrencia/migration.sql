-- CreateTable
CREATE TABLE "veiculos_ocorrencia" (
    "id" TEXT NOT NULL,
    "placa" TEXT,
    "marca" TEXT,
    "modelo" TEXT,
    "ano" TEXT,
    "cor" TEXT,
    "situacao" TEXT,
    "destinacao" TEXT,
    "responsavel" TEXT,
    "destinatario" TEXT,
    "doc_destinatario" TEXT,
    "vinculo" TEXT,
    "gps_lat" DOUBLE PRECISION,
    "gps_lng" DOUBLE PRECISION,
    "observacoes" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "criado_por_id" TEXT NOT NULL,
    "ocorrencia_id" TEXT NOT NULL,

    CONSTRAINT "veiculos_ocorrencia_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "veiculos_ocorrencia_ocorrencia_id_idx" ON "veiculos_ocorrencia"("ocorrencia_id");

-- CreateIndex
CREATE INDEX "veiculos_ocorrencia_placa_idx" ON "veiculos_ocorrencia"("placa");

-- CreateIndex
CREATE INDEX "veiculos_ocorrencia_criado_por_id_idx" ON "veiculos_ocorrencia"("criado_por_id");

-- AddForeignKey
ALTER TABLE "veiculos_ocorrencia" ADD CONSTRAINT "veiculos_ocorrencia_criado_por_id_fkey" FOREIGN KEY ("criado_por_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "veiculos_ocorrencia" ADD CONSTRAINT "veiculos_ocorrencia_ocorrencia_id_fkey" FOREIGN KEY ("ocorrencia_id") REFERENCES "ocorrencias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
