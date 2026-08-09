-- CreateTable
CREATE TABLE "telefones_pessoa" (
    "id" TEXT NOT NULL,
    "numero" TEXT NOT NULL,
    "tipo" TEXT,
    "observacao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "pessoa_id" TEXT NOT NULL,

    CONSTRAINT "telefones_pessoa_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "enderecos_pessoa" (
    "id" TEXT NOT NULL,
    "logradouro" TEXT NOT NULL,
    "numero" TEXT,
    "complemento" TEXT,
    "bairro" TEXT,
    "cidade" TEXT,
    "estado" TEXT,
    "cep" TEXT,
    "tipo" TEXT,
    "observacao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "pessoa_id" TEXT NOT NULL,

    CONSTRAINT "enderecos_pessoa_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "telefones_pessoa_pessoa_id_idx" ON "telefones_pessoa"("pessoa_id");

-- CreateIndex
CREATE INDEX "enderecos_pessoa_pessoa_id_idx" ON "enderecos_pessoa"("pessoa_id");

-- AddForeignKey
ALTER TABLE "telefones_pessoa" ADD CONSTRAINT "telefones_pessoa_pessoa_id_fkey" FOREIGN KEY ("pessoa_id") REFERENCES "pessoas_envolvidas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "enderecos_pessoa" ADD CONSTRAINT "enderecos_pessoa_pessoa_id_fkey" FOREIGN KEY ("pessoa_id") REFERENCES "pessoas_envolvidas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
