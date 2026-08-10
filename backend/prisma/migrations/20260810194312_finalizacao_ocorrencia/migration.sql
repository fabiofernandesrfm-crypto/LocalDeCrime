-- AlterTable
ALTER TABLE "ocorrencias" ADD COLUMN     "finalizada_por_id" TEXT,
ADD COLUMN     "observacoes_encerramento" TEXT;

-- AddForeignKey
ALTER TABLE "ocorrencias" ADD CONSTRAINT "ocorrencias_finalizada_por_id_fkey" FOREIGN KEY ("finalizada_por_id") REFERENCES "usuarios"("id") ON DELETE SET NULL ON UPDATE CASCADE;
