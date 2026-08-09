-- CreateTable
CREATE TABLE "fotografias_ocorrencia" (
    "id" TEXT NOT NULL,
    "storage_key" TEXT NOT NULL,
    "arquivo_original_nome" TEXT NOT NULL,
    "mime_type" TEXT NOT NULL,
    "tamanho_bytes" INTEGER NOT NULL,
    "legenda" TEXT,
    "ordem" INTEGER NOT NULL DEFAULT 0,
    "capturado_em" TIMESTAMP(3),
    "gps_lat" DOUBLE PRECISION,
    "gps_lng" DOUBLE PRECISION,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "criado_por_id" TEXT NOT NULL,
    "ocorrencia_id" TEXT NOT NULL,
    "pessoa_id" TEXT,
    "veiculo_id" TEXT,
    "objeto_id" TEXT,
    "vestigio_id" TEXT,

    CONSTRAINT "fotografias_ocorrencia_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "fotografias_ocorrencia_ocorrencia_id_idx" ON "fotografias_ocorrencia"("ocorrencia_id");

-- CreateIndex
CREATE INDEX "fotografias_ocorrencia_criado_por_id_idx" ON "fotografias_ocorrencia"("criado_por_id");

-- CreateIndex
CREATE INDEX "fotografias_ocorrencia_pessoa_id_idx" ON "fotografias_ocorrencia"("pessoa_id");

-- CreateIndex
CREATE INDEX "fotografias_ocorrencia_veiculo_id_idx" ON "fotografias_ocorrencia"("veiculo_id");

-- CreateIndex
CREATE INDEX "fotografias_ocorrencia_objeto_id_idx" ON "fotografias_ocorrencia"("objeto_id");

-- CreateIndex
CREATE INDEX "fotografias_ocorrencia_vestigio_id_idx" ON "fotografias_ocorrencia"("vestigio_id");

-- AddForeignKey
ALTER TABLE "fotografias_ocorrencia" ADD CONSTRAINT "fotografias_ocorrencia_criado_por_id_fkey" FOREIGN KEY ("criado_por_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias_ocorrencia" ADD CONSTRAINT "fotografias_ocorrencia_ocorrencia_id_fkey" FOREIGN KEY ("ocorrencia_id") REFERENCES "ocorrencias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias_ocorrencia" ADD CONSTRAINT "fotografias_ocorrencia_pessoa_id_fkey" FOREIGN KEY ("pessoa_id") REFERENCES "pessoas_envolvidas"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias_ocorrencia" ADD CONSTRAINT "fotografias_ocorrencia_veiculo_id_fkey" FOREIGN KEY ("veiculo_id") REFERENCES "veiculos_ocorrencia"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias_ocorrencia" ADD CONSTRAINT "fotografias_ocorrencia_objeto_id_fkey" FOREIGN KEY ("objeto_id") REFERENCES "objetos_ocorrencia"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias_ocorrencia" ADD CONSTRAINT "fotografias_ocorrencia_vestigio_id_fkey" FOREIGN KEY ("vestigio_id") REFERENCES "vestigios_ocorrencia"("id") ON DELETE SET NULL ON UPDATE CASCADE;
