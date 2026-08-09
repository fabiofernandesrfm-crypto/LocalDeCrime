-- CreateTable
CREATE TABLE "anexos_ocorrencia" (
    "id" TEXT NOT NULL,
    "storage_key" TEXT NOT NULL,
    "arquivo_original_nome" TEXT NOT NULL,
    "mime_type" TEXT NOT NULL,
    "tamanho_bytes" INTEGER NOT NULL,
    "categoria" TEXT,
    "descricao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "criado_por_id" TEXT NOT NULL,
    "ocorrencia_id" TEXT NOT NULL,
    "pessoa_id" TEXT,
    "veiculo_id" TEXT,
    "objeto_id" TEXT,
    "vestigio_id" TEXT,

    CONSTRAINT "anexos_ocorrencia_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "anexos_ocorrencia_ocorrencia_id_idx" ON "anexos_ocorrencia"("ocorrencia_id");

-- CreateIndex
CREATE INDEX "anexos_ocorrencia_criado_por_id_idx" ON "anexos_ocorrencia"("criado_por_id");

-- AddForeignKey
ALTER TABLE "anexos_ocorrencia" ADD CONSTRAINT "anexos_ocorrencia_criado_por_id_fkey" FOREIGN KEY ("criado_por_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anexos_ocorrencia" ADD CONSTRAINT "anexos_ocorrencia_ocorrencia_id_fkey" FOREIGN KEY ("ocorrencia_id") REFERENCES "ocorrencias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anexos_ocorrencia" ADD CONSTRAINT "anexos_ocorrencia_pessoa_id_fkey" FOREIGN KEY ("pessoa_id") REFERENCES "pessoas_envolvidas"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anexos_ocorrencia" ADD CONSTRAINT "anexos_ocorrencia_veiculo_id_fkey" FOREIGN KEY ("veiculo_id") REFERENCES "veiculos_ocorrencia"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anexos_ocorrencia" ADD CONSTRAINT "anexos_ocorrencia_objeto_id_fkey" FOREIGN KEY ("objeto_id") REFERENCES "objetos_ocorrencia"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anexos_ocorrencia" ADD CONSTRAINT "anexos_ocorrencia_vestigio_id_fkey" FOREIGN KEY ("vestigio_id") REFERENCES "vestigios_ocorrencia"("id") ON DELETE SET NULL ON UPDATE CASCADE;
