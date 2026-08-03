# SCHEMA_SUMMARY.md

## Resumo do Schema Prisma — Sistema PCPE

**Versão:** 2.1.0  
**Data:** 01/08/2026  
**Arquivo:** `backend/prisma/schema.prisma`  
**Status:** ✅ Validado (`npx prisma validate`) | ✅ Formatado (`npx prisma format`)

---

## 1. Lista de Models (49 tabelas)

| #   | Model                | Tabela                     | Domínio                          |
|-----|----------------------|----------------------------|----------------------------------|
| 1   | Usuario              | `usuarios`                 | Autenticação e Gestão de Usuários |
| 2   | Perfil               | `perfis`                   | Autenticação e Gestão de Usuários |
| 3   | Permissao            | `permissoes`               | Autenticação e Gestão de Usuários |
| 4   | UsuarioPerfil        | `usuario_perfis`           | Autenticação e Gestão de Usuários |
| 5   | PerfilPermissao      | `perfil_permissoes`        | Autenticação e Gestão de Usuários |
| 6   | Sessao               | `sessoes`                  | Autenticação e Gestão de Usuários |
| 7   | RefreshToken         | `refresh_tokens`           | Autenticação e Gestão de Usuários |
| 8   | Unidade              | `unidades`                 | Estrutura Organizacional         |
| 9   | Delegacia            | `delegacias`               | Estrutura Organizacional         |
| 10  | Instituto            | `institutos`               | Estrutura Organizacional         |
| 11  | Departamento         | `departamentos`            | Estrutura Organizacional         |
| 12  | Municipio            | `municipios`               | Estrutura Organizacional         |
| 13  | Ocorrencia           | `ocorrencias`              | Ocorrências e Atendimentos       |
| 14  | AtendimentoLocal     | `atendimentos_local`       | Ocorrências e Atendimentos       |
| 15  | Equipe               | `equipes`                  | Equipes e Pessoal                |
| 16  | EquipeUsuario        | `equipe_usuarios`          | Equipes e Pessoal                |
| 17  | PessoaEnvolvida      | `pessoas_envolvidas`       | Equipes e Pessoal                |
| 18  | PolicialParticipante | `policiais_participantes`  | Equipes e Pessoal                |
| 19  | TipoVestigio         | `tipos_vestigio`           | Vestígios e Cadeia de Custódia   |
| 20  | Acondicionamento     | `acondicionamentos`        | Vestígios e Cadeia de Custódia   |
| 21  | DestinoVestigio      | `destinos_vestigio`        | Vestígios e Cadeia de Custódia   |
| 22  | Vestigio             | `vestigios`                | Vestígios e Cadeia de Custódia   |
| 23  | CadeiaCustodia       | `cadeia_custodia`          | Vestígios e Cadeia de Custódia   |
| 24  | CategoriaObjetoModel | `categorias_objeto`        | Objetos e Itens Apreendidos      |
| 25  | Objeto               | `objetos`                  | Objetos e Itens Apreendidos      |
| 26  | TipoArmaModel        | `tipos_arma`               | Objetos e Itens Apreendidos      |
| 27  | Arma                 | `armas`                    | Objetos e Itens Apreendidos      |
| 28  | TipoMunicaoModel     | `tipos_municao`            | Objetos e Itens Apreendidos      |
| 29  | Municao              | `municoes`                 | Objetos e Itens Apreendidos      |
| 30  | TipoDrogaModel       | `tipos_droga`              | Objetos e Itens Apreendidos      |
| 31  | Droga                | `drogas`                   | Objetos e Itens Apreendidos      |
| 32  | Veiculo              | `veiculos`                 | Objetos e Itens Apreendidos      |
| 33  | MidiaTag             | `midia_tags`               | Mídias                           |
| 34  | MidiaMidiaTag        | `midia_midia_tags`         | Mídias                           |
| 35  | Fotografia           | `fotografias`              | Mídias                           |
| 36  | Video                | `videos`                   | Mídias                           |
| 37  | Audio                | `audios`                   | Mídias                           |
| 38  | DocumentoAnexo       | `documentos_anexos`        | Mídias                           |
| 39  | TipoAssinaturaModel  | `tipos_assinatura`         | Assinaturas e Validação          |
| 40  | Assinatura           | `assinaturas`              | Assinaturas e Validação          |
| 41  | Auditoria            | `auditorias`               | Auditoria e Logs                 |
| 42  | LogSistema           | `logs_sistema`             | Auditoria e Logs                 |
| 43  | HistoricoAlteracao   | `historico_alteracoes`     | Auditoria e Logs                 |
| 44  | LinhaTempo           | `linhas_tempo`             | Auditoria e Logs                 |
| 45  | Configuracao         | `configuracoes`            | Configurações e Infraestrutura   |
| 46  | Dispositivo          | `dispositivos`             | Configurações e Infraestrutura   |
| 47  | SincronizacaoOffline | `sincronizacao_offline`    | Configurações e Infraestrutura   |
| 48  | FilaSincronizacao    | `fila_sincronizacao`       | Configurações e Infraestrutura   |
| 49  | BackupRegistro       | `backups_registro`         | Configurações e Infraestrutura   |

> **Nota:** A tabela `atendimentos` existente no schema original foi substituída por `atendimentos_local`. Ela NÃO foi alterada neste momento — apenas planejada. A migration existente permanece intacta.

---

## 2. Lista de Enums (25 enums)

| #   | Enum                     | Valores                                                                                      |
|-----|--------------------------|----------------------------------------------------------------------------------------------|
| 1   | Role                     | ADMIN, CHEFE_EQUIPE, PERITO, AGENTE                                                          |
| 2   | StatusAtendimento        | ABERTO, EM_ANDAMENTO, CONCLUIDO, CANCELADO                                                   |
| 3   | TipoLocal                | RESIDENCIA, VIA_PUBLICA, ESTABELECIMENTO_COMERCIAL, AREA_RURAL, VEICULO, OUTRO                |
| 4   | TipoUnidade              | DELEGACIA, INSTITUTO, DEPARTAMENTO                                                           |
| 5   | StatusOcorrencia         | ABERTA, EM_INVESTIGACAO, CONCLUIDA, ARQUIVADA                                                |
| 6   | TipoEnvolvimento         | VITIMA, TESTEMUNHA, SUSPEITO, PROPRIETARIO, RESPONSAVEL, OUTRO                                |
| 7   | StatusCadeia             | COLETADO, ACONDICIONADO, TRANSPORTADO, RECEBIDO, EM_ANALISE, ANALISADO, DESCARTADO, DEVOLVIDO |
| 8   | TipoEquipe               | PERICIA, INVESTIGACAO, PLANTAO, ESPECIAL                                                     |
| 9   | StatusEquipe             | ATIVA, INATIVA, EM_DESLOCAMENTO, EM_ATENDIMENTO                                              |
| 10  | StatusSincronizacao      | PENDENTE, ENVIADO, CONFIRMADO, CONFLITO, FALHA                                               |
| 11  | TipoMidia                | FOTO, VIDEO, AUDIO, DOCUMENTO                                                                |
| 12  | NivelLog                 | DEBUG, INFO, WARNING, ERROR, CRITICAL                                                        |
| 13  | AcaoAuditoria            | CRIAR, ATUALIZAR, DELETAR, VISUALIZAR, EXPORTAR, LOGIN, LOGOUT, FALHA_LOGIN                  |
| 14  | TipoAssinatura           | BIOMETRICA, CERTIFICADO_DIGITAL, PIN, SENHA                                                  |
| 15  | StatusSessao             | ATIVA, EXPIRADA, REVOGADA                                                                    |
| 16  | TipoAcondicionamento     | SACO_PLASTICO, ENVELOPE_PAPEL, CAIXA_PAPELAO, TUBO_ENSAIO, FRASCO_VIDRO, LACRE_METALICO      |
| 17  | CategoriaObjeto          | ELETRONICO, DOCUMENTO, JOIA, FERRAMENTA, VESTUARIO, OUTRO                                    |
| 18  | TipoArma                 | REVOLVER, PISTOLA, ESPINGARDA, FUZIL, FACA, FACAO, OUTRA_BRANCA, OUTRA_FOGO                  |
| 19  | TipoMunicao              | CALIBRE_22, CALIBRE_38, CALIBRE_380, CALIBRE_9MM, CALIBRE_12, CALIBRE_556, CALIBRE_762, OUTRO |
| 20  | TipoDroga                | MACONHA, COCAINA, CRACK, HEROINA, LSD, ECSTASY, METANFETAMINA, OUTRA                         |
| 21  | MetodoAutenticacao       | SENHA, BIOMETRIA, CERTIFICADO, SSO                                                           |
| 22  | Sexo                     | MASCULINO, FEMININO, NAO_INFORMADO                                                           |
| 23  | TipoPessoa               | FISICA, JURIDICA                                                                             |
| 24  | StatusProcessamentoMidia | PENDENTE, PROCESSANDO, CONCLUIDO, FALHA                                                      |
| 25  | FuncaoEquipe             | CHEFE, PERITO, AGENTE, FOTOGRAFO, MOTORISTA, AUXILIAR                                        |

---

## 3. Lista de Relacionamentos

### 3.1 Relacionamentos 1:1

| Entidade A   | Entidade B   | FK Unique                         | Descrição                                    |
|--------------|--------------|-----------------------------------|----------------------------------------------|
| Delegacia    | Unidade      | `delegacias.unidade_id` (unique)  | Toda delegacia tem exatamente uma unidade     |
| Instituto    | Unidade      | `institutos.unidade_id` (unique)  | Todo instituto tem exatamente uma unidade     |
| Departamento | Unidade      | `departamentos.unidade_id` (unique) | Todo departamento tem exatamente uma unidade |

### 3.2 Relacionamentos 1:N (principais)

| Entidade A (1)      | Entidade B (N)          | FK em B                     |
|----------------------|-------------------------|-----------------------------|
| Unidade              | Usuario                 | `usuarios.unidade_id`       |
| Unidade              | Equipe                  | `equipes.unidade_id`        |
| Municipio            | Unidade                 | `unidades.municipio_id`     |
| Municipio            | Ocorrencia              | `ocorrencias.municipio_id`  |
| Municipio            | PessoaEnvolvida         | `pessoas_envolvidas.municipio_id` |
| Delegacia            | Ocorrencia              | `ocorrencias.delegacia_id`  |
| Usuario              | Ocorrencia              | `ocorrencias.usuario_id`    |
| Ocorrencia           | AtendimentoLocal        | `atendimentos_local.ocorrencia_id` |
| Usuario              | AtendimentoLocal        | `atendimentos_local.usuario_id` |
| Equipe               | AtendimentoLocal        | `atendimentos_local.equipe_id` |
| AtendimentoLocal     | Vestigio                | `vestigios.atendimento_local_id` |
| AtendimentoLocal     | Objeto                  | `objetos.atendimento_local_id` |
| AtendimentoLocal     | Arma                    | `armas.atendimento_local_id` |
| AtendimentoLocal     | Municao                 | `municoes.atendimento_local_id` |
| AtendimentoLocal     | Droga                   | `drogas.atendimento_local_id` |
| AtendimentoLocal     | Veiculo                 | `veiculos.atendimento_local_id` |
| AtendimentoLocal     | Fotografia              | `fotografias.atendimento_local_id` |
| AtendimentoLocal     | Video                   | `videos.atendimento_local_id` |
| AtendimentoLocal     | Audio                   | `audios.atendimento_local_id` |
| AtendimentoLocal     | DocumentoAnexo          | `documentos_anexos.atendimento_local_id` |
| AtendimentoLocal     | PolicialParticipante    | `policiais_participantes.atendimento_local_id` |
| AtendimentoLocal     | Assinatura              | `assinaturas.atendimento_local_id` |
| AtendimentoLocal     | LinhaTempo              | `linhas_tempo.atendimento_local_id` |
| AtendimentoLocal     | HistoricoAlteracao      | `historico_alteracoes.atendimento_local_id` |
| Ocorrencia           | PessoaEnvolvida         | `pessoas_envolvidas.ocorrencia_id` |
| Ocorrencia           | LinhaTempo              | `linhas_tempo.ocorrencia_id` |
| Usuario              | Sessao                  | `sessoes.usuario_id`        |
| Sessao               | RefreshToken            | `refresh_tokens.sessao_id`  |
| Usuario              | Auditoria               | `auditorias.usuario_id`     |
| Usuario              | HistoricoAlteracao      | `historico_alteracoes.usuario_id` |
| Usuario              | LinhaTempo              | `linhas_tempo.usuario_id`   |
| Usuario              | Fotografia              | `fotografias.usuario_id`    |
| Usuario              | Video                   | `videos.usuario_id`         |
| Usuario              | Audio                   | `audios.usuario_id`         |
| Usuario              | DocumentoAnexo          | `documentos_anexos.usuario_id` |
| Usuario              | Assinatura              | `assinaturas.usuario_id`    |
| Usuario              | Dispositivo             | `dispositivos.usuario_id`   |
| Usuario              | FilaSincronizacao       | `fila_sincronizacao.usuario_id` |
| Usuario              | CadeiaCustodia          | `cadeia_custodia.usuario_id` |
| Usuario              | BackupRegistro          | `backups_registro.usuario_id` |
| TipoVestigio         | Vestigio                | `vestigios.tipo_vestigio_id` |
| Acondicionamento     | Vestigio                | `vestigios.acondicionamento_id` |
| Vestigio             | CadeiaCustodia          | `cadeia_custodia.vestigio_id` |
| Vestigio             | Fotografia              | `fotografias.vestigio_id`   |
| DestinoVestigio      | CadeiaCustodia          | `cadeia_custodia.destino_vestigio_id` |
| CategoriaObjetoModel | Objeto                  | `objetos.categoria_objeto_id` |
| TipoArmaModel        | Arma                    | `armas.tipo_arma_id`        |
| TipoMunicaoModel     | Municao                 | `municoes.tipo_municao_id`  |
| TipoDrogaModel       | Droga                   | `drogas.tipo_droga_id`      |
| TipoAssinaturaModel  | Assinatura              | `assinaturas.tipo_assinatura_id` |
| Dispositivo          | SincronizacaoOffline    | `sincronizacao_offline.dispositivo_id` |
| SincronizacaoOffline | FilaSincronizacao       | `fila_sincronizacao.sincronizacao_offline_id` |
| Dispositivo          | Auditoria               | `auditorias.dispositivo_id` |

### 3.3 Relacionamentos N:N (com tabela associativa)

| Entidade A   | Entidade B      | Tabela Associativa    | Chave Composta         |
|--------------|-----------------|-----------------------|------------------------|
| Usuario      | Perfil          | `usuario_perfis`      | `[usuario_id, perfil_id]` |
| Perfil       | Permissao       | `perfil_permissoes`   | `[perfil_id, permissao_id]` |
| Usuario      | Equipe          | `equipe_usuarios`     | `[equipe_id, usuario_id]` |
| Fotografia   | MidiaTag        | `midia_midia_tags`    | (FK polimórfica)       |
| Video        | MidiaTag        | `midia_midia_tags`    | (FK polimórfica)       |
| Audio        | MidiaTag        | `midia_midia_tags`    | (FK polimórfica)       |
| DocumentoAnexo | MidiaTag      | `midia_midia_tags`    | (FK polimórfica)       |

### 3.4 Relacionamentos Opcionais (FK polimórfica)

| Entidade       | FKs Opcionais                                                                 |
|----------------|-------------------------------------------------------------------------------|
| Fotografia     | `vestigio_id`, `objeto_id`, `arma_id`, `municao_id`, `droga_id`, `veiculo_id` |
| MidiaMidiaTag  | `fotografia_id`, `video_id`, `audio_id`, `documento_anexo_id`                 |
| Assinatura     | `atendimento_local_id`, `cadeia_custodia_id`, `documento_anexo_id`            |

---

## 4. Lista de Índices

### 4.1 Índices Únicos (UNIQUE)

| Tabela                 | Coluna(s)                    |
|------------------------|------------------------------|
| `usuarios`             | `matricula`                  |
| `usuarios`             | `email`                      |
| `perfis`               | `nome`                       |
| `permissoes`           | `codigo`                     |
| `sessoes`              | `token`                      |
| `refresh_tokens`       | `token`                      |
| `delegacias`           | `unidade_id`                 |
| `institutos`           | `unidade_id`                 |
| `departamentos`        | `unidade_id`                 |
| `municipios`           | `codigo_ibge`                |
| `ocorrencias`          | `numero_bo`                  |
| `atendimentos_local`   | `numero_registro`            |
| `tipos_vestigio`       | `nome`                       |
| `vestigios`            | `numero_custodia`            |
| `destinos_vestigio`    | `nome`                       |
| `categorias_objeto`    | `nome`                       |
| `tipos_arma`           | `nome`                       |
| `tipos_municao`        | `nome`                       |
| `tipos_droga`          | `nome`                       |
| `midia_tags`           | `nome`                       |
| `tipos_assinatura`     | `nome`                       |
| `configuracoes`        | `chave`                      |
| `dispositivos`         | `device_id`                  |

### 4.2 Índices Compostos (COMPOSITE)

| Tabela                 | Colunas                      |
|------------------------|------------------------------|
| `auditorias`           | `[entidade, entidade_id]`    |
| `historico_alteracoes` | `[entidade, entidade_id]`    |
| `fila_sincronizacao`   | `[usuario_id, status]`       |

### 4.3 Índices Simples (B-tree)

| Tabela                  | Coluna(s)              |
|-------------------------|------------------------|
| `usuarios`              | `unidade_id`           |
| `usuarios`              | `ativo`                |
| `usuarios`              | `deletado_em`          |
| `perfis`                | `deletado_em`          |
| `permissoes`            | `modulo`               |
| `permissoes`            | `deletado_em`          |
| `sessoes`               | `usuario_id`           |
| `sessoes`               | `status`               |
| `refresh_tokens`        | `sessao_id`            |
| `refresh_tokens`        | `revogado`             |
| `unidades`              | `municipio_id`         |
| `unidades`              | `tipo`                 |
| `unidades`              | `deletado_em`          |
| `delegacias`            | `deletado_em`          |
| `institutos`            | `deletado_em`          |
| `departamentos`         | `deletado_em`          |
| `municipios`            | `nome`                 |
| `municipios`            | `uf`                   |
| `ocorrencias`           | `numero_bo`            |
| `ocorrencias`           | `municipio_id`         |
| `ocorrencias`           | `delegacia_id`         |
| `ocorrencias`           | `usuario_id`           |
| `ocorrencias`           | `status`               |
| `ocorrencias`           | `data_ocorrencia`      |
| `ocorrencias`           | `deletado_em`          |
| `atendimentos_local`    | `numero_registro`      |
| `atendimentos_local`    | `ocorrencia_id`        |
| `atendimentos_local`    | `equipe_id`            |
| `atendimentos_local`    | `usuario_id`           |
| `atendimentos_local`    | `status`               |
| `atendimentos_local`    | `data_ocorrencia`      |
| `atendimentos_local`    | `deletado_em`          |
| `equipes`               | `unidade_id`           |
| `equipes`               | `tipo`                 |
| `equipes`               | `status`               |
| `equipes`               | `deletado_em`          |
| `equipe_usuarios`       | `usuario_id`           |
| `pessoas_envolvidas`    | `ocorrencia_id`        |
| `pessoas_envolvidas`    | `cpf`                  |
| `pessoas_envolvidas`    | `municipio_id`         |
| `pessoas_envolvidas`    | `tipo_envolvimento`    |
| `pessoas_envolvidas`    | `deletado_em`          |
| `policiais_participantes` | `atendimento_local_id` |
| `policiais_participantes` | `usuario_id`           |
| `tipos_vestigio`        | `deletado_em`          |
| `vestigios`             | `atendimento_local_id` |
| `vestigios`             | `tipo_vestigio_id`     |
| `vestigios`             | `acondicionamento_id`  |
| `vestigios`             | `numero_custodia`      |
| `vestigios`             | `deletado_em`          |
| `cadeia_custodia`       | `vestigio_id`          |
| `cadeia_custodia`       | `usuario_id`           |
| `cadeia_custodia`       | `data_hora`            |
| `cadeia_custodia`       | `status`               |
| `categorias_objeto`     | `deletado_em`          |
| `objetos`               | `atendimento_local_id` |
| `objetos`               | `categoria_objeto_id`  |
| `objetos`               | `deletado_em`          |
| `tipos_arma`            | `deletado_em`          |
| `armas`                 | `atendimento_local_id` |
| `armas`                 | `tipo_arma_id`         |
| `armas`                 | `numero_serie`         |
| `armas`                 | `deletado_em`          |
| `tipos_municao`         | `deletado_em`          |
| `municoes`              | `atendimento_local_id` |
| `municoes`              | `tipo_municao_id`      |
| `municoes`              | `deletado_em`          |
| `tipos_droga`           | `deletado_em`          |
| `drogas`                | `atendimento_local_id` |
| `drogas`                | `tipo_droga_id`        |
| `drogas`                | `deletado_em`          |
| `veiculos`              | `atendimento_local_id` |
| `veiculos`              | `placa`                |
| `veiculos`              | `chassi`               |
| `veiculos`              | `deletado_em`          |
| `midia_tags`            | `deletado_em`          |
| `midia_midia_tags`      | `midia_tag_id`         |
| `midia_midia_tags`      | `fotografia_id`        |
| `midia_midia_tags`      | `video_id`             |
| `midia_midia_tags`      | `audio_id`             |
| `midia_midia_tags`      | `documento_anexo_id`   |
| `fotografias`           | `atendimento_local_id` |
| `fotografias`           | `usuario_id`           |
| `fotografias`           | `vestigio_id`          |
| `fotografias`           | `objeto_id`            |
| `fotografias`           | `arma_id`              |
| `fotografias`           | `municao_id`           |
| `fotografias`           | `droga_id`             |
| `fotografias`           | `veiculo_id`           |
| `fotografias`           | `deletado_em`          |
| `videos`                | `atendimento_local_id` |
| `videos`                | `usuario_id`           |
| `videos`                | `deletado_em`          |
| `audios`                | `atendimento_local_id` |
| `audios`                | `usuario_id`           |
| `audios`                | `deletado_em`          |
| `documentos_anexos`     | `atendimento_local_id` |
| `documentos_anexos`     | `usuario_id`           |
| `documentos_anexos`     | `deletado_em`          |
| `assinaturas`           | `usuario_id`           |
| `assinaturas`           | `tipo_assinatura_id`   |
| `assinaturas`           | `atendimento_local_id` |
| `assinaturas`           | `cadeia_custodia_id`   |
| `assinaturas`           | `documento_anexo_id`   |
| `assinaturas`           | `data_hora`            |
| `auditorias`            | `usuario_id`           |
| `auditorias`            | `acao`                 |
| `auditorias`            | `data_hora`            |
| `auditorias`            | `dispositivo_id`       |
| `logs_sistema`          | `nivel`                |
| `logs_sistema`          | `data_hora`            |
| `logs_sistema`          | `usuario_id`           |
| `historico_alteracoes`  | `usuario_id`           |
| `historico_alteracoes`  | `data_hora`            |
| `historico_alteracoes`  | `atendimento_local_id` |
| `linhas_tempo`          | `ocorrencia_id`        |
| `linhas_tempo`          | `atendimento_local_id` |
| `linhas_tempo`          | `usuario_id`           |
| `linhas_tempo`          | `data_hora`            |
| `dispositivos`          | `usuario_id`           |
| `dispositivos`          | `device_id`            |
| `dispositivos`          | `ativo`                |
| `sincronizacao_offline` | `dispositivo_id`       |
| `sincronizacao_offline` | `status`               |
| `sincronizacao_offline` | `data_inicio`          |
| `fila_sincronizacao`    | `status`               |
| `fila_sincronizacao`    | `sincronizacao_offline_id` |
| `backups_registro`      | `usuario_id`           |
| `backups_registro`      | `data_inicio`          |
| `backups_registro`      | `status`               |

---

## 5. Lista de Constraints

### 5.1 Primary Keys

- Todas as 49 tabelas utilizam `id` como PK do tipo UUID (`String @id @default(uuid())`).
- 3 tabelas associativas usam chave composta com `@@id`:
  - `usuario_perfis`: `[usuario_id, perfil_id]`
  - `perfil_permissoes`: `[perfil_id, permissao_id]`
  - `equipe_usuarios`: `[equipe_id, usuario_id]`

### 5.2 Unique Constraints

- 23 colunas com `@unique` (listadas na seção 4.1).

### 5.3 Foreign Keys com Cascade Rules

| Tabela              | FK                   | OnDelete    |
|---------------------|----------------------|-------------|
| `usuario_perfis`    | `usuario_id`         | Cascade     |
| `usuario_perfis`    | `perfil_id`          | Cascade     |
| `perfil_permissoes` | `perfil_id`          | Cascade     |
| `perfil_permissoes` | `permissao_id`       | Cascade     |
| `sessoes`           | `usuario_id`         | Cascade     |
| `refresh_tokens`    | `sessao_id`          | Cascade     |
| `delegacias`        | `unidade_id`         | Cascade     |
| `institutos`        | `unidade_id`         | Cascade     |
| `departamentos`     | `unidade_id`         | Cascade     |
| `equipe_usuarios`   | `equipe_id`          | Cascade     |
| `equipe_usuarios`   | `usuario_id`         | **Restrict** |
| `midia_midia_tags`  | `midia_tag_id`       | Cascade     |
| `midia_midia_tags`  | `fotografia_id`      | Cascade     |
| `midia_midia_tags`  | `video_id`           | Cascade     |
| `midia_midia_tags`  | `audio_id`           | Cascade     |
| `midia_midia_tags`  | `documento_anexo_id` | Cascade     |

> **Nota:** `equipe_usuarios.usuario_id` usa `onDelete: Restrict` para evitar exclusão acidental de usuários que participaram de equipes. Demais FKs de domínio usam o padrão `Restrict` implícito (sem cascade).

### 5.4 Soft Delete

- 41 tabelas incluem `deletadoEm DateTime?` para exclusão lógica.
- 8 tabelas **não** possuem soft delete (append-only ou efêmeras):
  - `sessoes`, `refresh_tokens` — excluídos ao expirar/revogar
  - `auditorias` — append-only (exclusão apenas por política de retenção/partição)
  - `historico_alteracoes` — versionamento permanente
  - `logs_sistema` — rotacionado por tempo
  - `fila_sincronizacao` — dados técnicos efêmeros
  - `sincronizacao_offline` — dados técnicos efêmeros
  - `acondicionamentos` — entidade de escrita única
  - `destinos_vestigio` — entidade de catálogo simples

---

## 6. Totais

| Métrica                    | Quantidade |
|----------------------------|------------|
| **Total de models/tabelas** | 49         |
| **Total de enums**          | 25         |
| **Total de índices únicos** | 23         |
| **Total de índices simples**| ~120       |
| **Total de índices compostos** | 3          |
| **Total de relacionamentos** | ~75        |
| **Total de chaves estrangeiras** | ~70       |

---

> **Fim do Documento.**  
> Schema validado com `npx prisma validate` ✅  
> Schema formatado com `npx prisma format` ✅  
> Nenhuma migration foi executada.