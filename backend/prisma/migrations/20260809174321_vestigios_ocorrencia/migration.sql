-- CreateTable
CREATE TABLE "vestigios_ocorrencia" (
    "id" TEXT NOT NULL,
    "categoria" TEXT,
    "descricao" TEXT,
    "caracteristicas" TEXT,
    "localizacao_descricao" TEXT,
    "gps_lat" DOUBLE PRECISION,
    "gps_lng" DOUBLE PRECISION,
    "coletado" BOOLEAN NOT NULL DEFAULT false,
    "coletado_por" TEXT,
    "situacao" TEXT,
    "destinacao" TEXT,
    "observacoes" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "criado_por_id" TEXT NOT NULL,
    "ocorrencia_id" TEXT NOT NULL,

    CONSTRAINT "vestigios_ocorrencia_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "vestigios_ocorrencia_ocorrencia_id_idx" ON "vestigios_ocorrencia"("ocorrencia_id");

-- CreateIndex
CREATE INDEX "vestigios_ocorrencia_criado_por_id_idx" ON "vestigios_ocorrencia"("criado_por_id");

-- AddForeignKey
ALTER TABLE "vestigios_ocorrencia" ADD CONSTRAINT "vestigios_ocorrencia_criado_por_id_fkey" FOREIGN KEY ("criado_por_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vestigios_ocorrencia" ADD CONSTRAINT "vestigios_ocorrencia_ocorrencia_id_fkey" FOREIGN KEY ("ocorrencia_id") REFERENCES "ocorrencias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
