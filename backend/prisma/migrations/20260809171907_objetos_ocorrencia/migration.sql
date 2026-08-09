-- CreateTable
CREATE TABLE "objetos_ocorrencia" (
    "id" TEXT NOT NULL,
    "categoria" TEXT,
    "descricao" TEXT,
    "marca" TEXT,
    "modelo" TEXT,
    "numero_serie" TEXT,
    "quantidade" INTEGER NOT NULL DEFAULT 1,
    "caracteristicas" TEXT,
    "situacao" TEXT,
    "destinacao" TEXT,
    "coletado_por" TEXT,
    "destinatario" TEXT,
    "doc_destinatario" TEXT,
    "vinculo_dest" TEXT,
    "gps_lat" DOUBLE PRECISION,
    "gps_lng" DOUBLE PRECISION,
    "observacoes" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "criado_por_id" TEXT NOT NULL,
    "ocorrencia_id" TEXT NOT NULL,
    "pessoa_id" TEXT,

    CONSTRAINT "objetos_ocorrencia_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "objetos_ocorrencia_ocorrencia_id_idx" ON "objetos_ocorrencia"("ocorrencia_id");

-- CreateIndex
CREATE INDEX "objetos_ocorrencia_criado_por_id_idx" ON "objetos_ocorrencia"("criado_por_id");

-- CreateIndex
CREATE INDEX "objetos_ocorrencia_pessoa_id_idx" ON "objetos_ocorrencia"("pessoa_id");

-- AddForeignKey
ALTER TABLE "objetos_ocorrencia" ADD CONSTRAINT "objetos_ocorrencia_criado_por_id_fkey" FOREIGN KEY ("criado_por_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "objetos_ocorrencia" ADD CONSTRAINT "objetos_ocorrencia_ocorrencia_id_fkey" FOREIGN KEY ("ocorrencia_id") REFERENCES "ocorrencias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "objetos_ocorrencia" ADD CONSTRAINT "objetos_ocorrencia_pessoa_id_fkey" FOREIGN KEY ("pessoa_id") REFERENCES "pessoas_envolvidas"("id") ON DELETE SET NULL ON UPDATE CASCADE;
