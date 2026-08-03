# DATABASE_ARCHITECTURE.md

## Arquitetura do Banco de Dados — Sistema de Registro de Atendimento em Local de Crime (PCPE)

> **Versão:** 2.1.0  
> **Data:** 01/08/2026  
> **Autor:** Arquiteto de Software — Equipe PCPE  
> **SGBD:** PostgreSQL 16 + PostGIS 3.4  
> **ORM:** Prisma ORM (prisma-client-js)  
> **Backend:** NestJS (TypeScript)

---

## 1. Objetivo da Arquitetura

Definir uma arquitetura de banco de dados relacional robusta, extensível e auditável para o Sistema de Registro de Atendimento em Local de Crime da Polícia Civil de Pernambuco (PCPE). A arquitetura deve:

- Suportar todos os módulos funcionais previstos (autenticação, ocorrências, cadeia de custódia, vestígios, mídias, equipes, auditoria, sincronização offline, etc.).
- Garantir integridade referencial e normalização adequada.
- Permitir rastreabilidade completa de todas as alterações (auditoria e linha do tempo).
- Ser compatível com operação offline-first no frontend Flutter (sincronização bidirecional).
- Utilizar exclusão lógica (soft delete) para preservar histórico e integridade de dados sensíveis forenses.
- Aproveitar PostGIS para consultas geoespaciais (localização de crimes, proximidade, mapas de calor).
- Ser projetada para crescimento incremental, permitindo adição de novos módulos sem reestruturação.

---

## 2. Lista Completa de Todas as Entidades

As entidades estão organizadas por domínio funcional.

### 2.1 Domínio: Autenticação e Gestão de Usuários

| #  | Entidade          | Tabela               | Descrição                                                |
|----|-------------------|----------------------|----------------------------------------------------------|
| 1  | Usuario           | `usuarios`           | Policiais e servidores com acesso ao sistema             |
| 2  | Perfil            | `perfis`             | Conjunto de permissões atribuíveis a usuários            |
| 3  | Permissao         | `permissoes`         | Permissão atômica (ex: `criar_atendimento`, `ver_relatorio`) |
| 4  | UsuarioPerfil     | `usuario_perfis`     | Tabela associativa N:N entre Usuario e Perfil            |
| 5  | PerfilPermissao   | `perfil_permissoes`  | Tabela associativa N:N entre Perfil e Permissao          |
| 6  | Sessao            | `sessoes`            | Sessões ativas (JWT refresh tokens, dispositivos)        |
| 7  | RefreshToken      | `refresh_tokens`     | Tokens de refresh para renovação de acesso               |

### 2.2 Domínio: Estrutura Organizacional

| #  | Entidade          | Tabela               | Descrição                                                |
|----|-------------------|----------------------|----------------------------------------------------------|
| 8  | Delegacia         | `delegacias`         | Delegacias da Polícia Civil (unidades territoriais)      |
| 9  | Instituto         | `institutos`         | IML, IC, IITB e outros institutos de perícia             |
| 10 | Departamento      | `departamentos`      | Departamentos internos (DHPP, DPM, etc.)                 |
| 11 | Municipio         | `municipios`         | Municípios de Pernambuco (para endereçamento)            |
| 12 | Unidade           | `unidades`           | Tabela polimórfica unificadora (Delegacia OU Instituto OU Departamento) |

### 2.3 Domínio: Ocorrências e Atendimentos

| #  | Entidade            | Tabela                 | Descrição                                                |
|----|---------------------|------------------------|----------------------------------------------------------|
| 13 | Ocorrencia          | `ocorrencias`          | Registro formal de uma ocorrência policial               |
| 14 | AtendimentoLocal    | `atendimentos_local`   | Atendimento pericial em local de crime (vinculado a uma ocorrência) |

### 2.4 Domínio: Equipes e Pessoal

| #  | Entidade              | Tabela                   | Descrição                                                |
|----|-----------------------|--------------------------|----------------------------------------------------------|
| 15 | Equipe                | `equipes`                | Equipe de atendimento (peritos, agentes, chefe)          |
| 16 | EquipeUsuario         | `equipe_usuarios`        | Membros de uma equipe (N:N) com função na equipe         |
| 17 | PessoaEnvolvida       | `pessoas_envolvidas`     | Pessoas relacionadas à ocorrência (vítima, testemunha, suspeito) |
| 18 | PolicialParticipante  | `policiais_participantes` | Policiais que participaram do atendimento (além da equipe) |

### 2.5 Domínio: Vestígios e Cadeia de Custódia

| #  | Entidade              | Tabela                   | Descrição                                                |
|----|-----------------------|--------------------------|----------------------------------------------------------|
| 19 | Vestigio              | `vestigios`              | Vestígio coletado no local de crime                      |
| 20 | CadeiaCustodia        | `cadeia_custodia`        | Registro da cadeia de custódia de cada vestígio          |
| 21 | TipoVestigio          | `tipos_vestigio`         | Classificação de vestígios (biológico, químico, balístico, etc.) |
| 22 | Acondicionamento      | `acondicionamentos`      | Registro de acondicionamento do vestígio (embalagem, lacre) |
| 23 | DestinoVestigio       | `destinos_vestigio`      | Destino do vestígio (instituto pericial, depósito judicial) |

### 2.6 Domínio: Objetos e Itens Apreendidos

| #  | Entidade          | Tabela               | Descrição                                                |
|----|-------------------|----------------------|----------------------------------------------------------|
| 24 | Objeto            | `objetos`            | Objeto apreendido no local (genérico)                    |
| 25 | Arma              | `armas`              | Arma de fogo ou branca apreendida                        |
| 26 | Municao           | `municoes`           | Munição apreendida (individual ou em lote)               |
| 27 | Droga             | `drogas`             | Entorpecente apreendido                                  |
| 28 | Veiculo           | `veiculos`           | Veículo relacionado à ocorrência                         |
| 29 | CategoriaObjeto   | `categorias_objeto`  | Categorias de objetos (ex: eletrônico, documento, joia)  |
| 30 | TipoArma          | `tipos_arma`         | Classificação de armas (revólver, pistola, faca, etc.)   |
| 31 | TipoMunicao       | `tipos_municao`      | Classificação de munições (calibre, tipo)                |
| 32 | TipoDroga         | `tipos_droga`        | Classificação de entorpecentes                           |

### 2.7 Domínio: Mídias (Fotografias, Vídeos, Áudios)

| #  | Entidade          | Tabela               | Descrição                                                |
|----|-------------------|----------------------|----------------------------------------------------------|
| 33 | Fotografia        | `fotografias`        | Fotografia registrada no atendimento                     |
| 34 | Video             | `videos`             | Vídeo registrado no atendimento                          |
| 35 | Audio             | `audios`             | Áudio registrado no atendimento                          |
| 36 | DocumentoAnexo    | `documentos_anexos`  | Documento digitalizado anexado ao atendimento            |
| 37 | MidiaTag          | `midia_tags`         | Tags para categorização de mídias                        |
| 38 | MidiaMidiaTag     | `midia_midia_tags`   | Tabela associativa N:N entre mídias e tags               |

### 2.8 Domínio: Assinaturas e Validação

| #  | Entidade          | Tabela               | Descrição                                                |
|----|-------------------|----------------------|----------------------------------------------------------|
| 39 | Assinatura        | `assinaturas`        | Assinatura digital de um registro (validação jurídica)   |
| 40 | TipoAssinatura    | `tipos_assinatura`   | Tipos de assinatura (biométrica, certificado digital, PIN) |

### 2.9 Domínio: Auditoria e Logs

| #  | Entidade          | Tabela                 | Descrição                                                |
|----|-------------------|------------------------|----------------------------------------------------------|
| 41 | Auditoria         | `auditorias`           | Registro de auditoria de todas as operações sensíveis    |
| 42 | LogSistema        | `logs_sistema`         | Logs técnicos do sistema (erros, warnings, info)         |
| 43 | HistoricoAlteracao| `historico_alteracoes` | Histórico de alterações em registros (versionamento)     |
| 44 | LinhaTempo        | `linhas_tempo`         | Eventos da linha do tempo de um atendimento              |

### 2.10 Domínio: Configurações e Infraestrutura

| #  | Entidade              | Tabela                     | Descrição                                                |
|----|-----------------------|----------------------------|----------------------------------------------------------|
| 45 | Configuracao          | `configuracoes`            | Configurações do sistema (chave-valor)                   |
| 46 | SincronizacaoOffline  | `sincronizacao_offline`    | Registro de sincronização de dados offline               |
| 47 | FilaSincronizacao     | `fila_sincronizacao`       | Fila de operações pendentes de sincronização             |
| 48 | Dispositivo           | `dispositivos`             | Dispositivos móveis autorizados a operar offline         |
| 49 | BackupRegistro        | `backups_registro`         | Metadados de backups realizados                          |

### 2.11 Domínio: Tabelas Auxiliares (Enums/Lookup)

| #  | Entidade              | Tabela                     | Descrição                                                |
|----|-----------------------|----------------------------|----------------------------------------------------------|
| 50 | TipoLocal             | Enum PostgreSQL            | Tipos de local de crime (já existente)                   |
| 51 | StatusAtendimento     | Enum PostgreSQL            | Status do atendimento (já existente)                     |
| 52 | Role                  | Enum PostgreSQL            | Papéis de usuário (já existente)                         |
| 53 | StatusOcorrencia      | Enum PostgreSQL            | Status da ocorrência (aberta, em investigação, concluída)|
| 54 | TipoEnvolvimento      | Enum PostgreSQL            | Tipo de envolvimento (vítima, testemunha, suspeito, etc.)|
| 55 | StatusCadeia          | Enum PostgreSQL            | Status da cadeia de custódia                             |
| 56 | TipoEquipe            | Enum PostgreSQL            | Tipo de equipe (perícia, investigação, plantão)          |
| 57 | StatusEquipe          | Enum PostgreSQL            | Status da equipe (ativa, inativa, em deslocamento)       |
| 58 | StatusSincronizacao   | Enum PostgreSQL            | Status da sincronização (pendente, enviado, confirmado, conflito) |
| 59 | TipoMidia             | Enum PostgreSQL            | Tipo de mídia (foto, vídeo, áudio, documento)            |
| 60 | NivelLog              | Enum PostgreSQL            | Nível de log (debug, info, warning, error, critical)     |
| 61 | AcaoAuditoria         | Enum PostgreSQL            | Ação auditada (criar, atualizar, deletar, visualizar, exportar) |

---

## 3. Justificativa da Existência de Cada Entidade

### 3.1 Usuario
**Justificativa:** Entidade central do sistema. Todo acesso é autenticado e toda ação é atribuída a um usuário. O vínculo com matrícula funcional garante unicidade institucional.

### 3.2 Perfil e Permissao
**Justificativa:** Modelo RBAC (Role-Based Access Control). Separar perfis de permissões permite granularidade — um "Perito" pode ter permissões diferentes de outro "Perito" em contextos específicos. O modelo N:N via tabelas associativas garante flexibilidade máxima.

### 3.3 UsuarioPerfil e PerfilPermissao
**Justificativa:** Tabelas associativas necessárias para o relacionamento muitos-para-muitos. Sem elas, um usuário só poderia ter um perfil e um perfil só poderia ter uma permissão — restrição inaceitável para um sistema corporativo.

### 3.4 Sessao e RefreshToken
**Justificativa:** Gerenciamento seguro de sessões. Permite revogação de tokens, rastreamento de dispositivos conectados e conformidade com a LGPD (possibilidade de encerrar todas as sessões de um usuário). A separação entre sessão e refresh token segue o padrão OAuth 2.0.

### 3.5 Delegacia, Instituto, Departamento
**Justificativa:** A PCPE possui três tipos de unidades organizacionais distintas. Delegacias são territoriais (baseadas em circunscrições). Institutos são periciais (IML, IC, IITB). Departamentos são administrativos/especializados (DHPP, DPM, etc.). Modelá-las separadamente permite atributos específicos para cada tipo.

### 3.6 Municipio
**Justificativa:** Tabela de domínio para normalização de endereços. Referenciar municípios por ID evita inconsistências de digitação e permite validação. Essencial para relatórios estatísticos por região.

### 3.7 Unidade
**Justificativa:** Tabela polimórfica que unifica Delegacia, Instituto e Departamento para simplificar relacionamentos. Um usuário é lotado em uma Unidade, independentemente do tipo. Segue o padrão "supertype/subtype" de modelagem relacional, evitando foreign keys polimórficas complexas.

### 3.8 Ocorrencia
**Justificativa:** Uma ocorrência é o registro policial formal (equivalente ao BO — Boletim de Ocorrência). É uma entidade distinta do AtendimentoLocal porque uma ocorrência pode existir sem atendimento pericial, e um atendimento pericial sempre está vinculado a uma ocorrência. Separá-las segue o princípio da responsabilidade única.

### 3.9 AtendimentoLocal
**Justificativa:** Registro específico do atendimento pericial no local de crime. Sucede o modelo atual `Atendimento` (que será renomeado/evoluído). Contém dados geoespaciais, condições do local, e é o ponto de partida para toda a cadeia de custódia. Justifica-se como entidade separada porque é o core domain do sistema.

### 3.10 Equipe e EquipeUsuario
**Justificativa:** Um atendimento envolve uma equipe de policiais/peritos. A equipe é uma entidade própria porque pode ser pré-formada (equipe de plantão) e reutilizada em múltiplos atendimentos. A tabela associativa `EquipeUsuario` permite registrar qual função cada membro exerceu (chefe, perito, agente).

### 3.11 PessoaEnvolvida
**Justificativa:** Registra pessoas físicas relacionadas à ocorrência (vítimas, testemunhas, suspeitos, proprietários, etc.). Essencial para o aspecto jurídico-policial. Separa-se de Usuario porque são entidades completamente distintas — pessoas envolvidas não têm acesso ao sistema.

### 3.12 PolicialParticipante
**Justificativa:** Registra policiais que participaram do atendimento mas não pertencem à equipe formal (ex: policial militar que fez a segurança do local, delegado que compareceu). Complementa a equipe formal.

### 3.13 Vestigio
**Justificativa:** Entidade central da cadeia de custódia. Todo vestígio coletado no local de crime deve ser registrado individualmente com seu próprio ID de custódia, garantindo rastreabilidade forense. Esta é uma exigência legal do CPP (Código de Processo Penal).

### 3.14 CadeiaCustodia
**Justificativa:** Registra cada movimentação/evento na vida de um vestígio — coleta, acondicionamento, transporte, recebimento, análise, descarte. Cada registro é imutável (append-only) para garantir a integridade da cadeia de custódia, requisito legal incontornável.

### 3.15 TipoVestigio, Acondicionamento, DestinoVestigio
**Justificativa:** Tabelas de domínio para classificação padronizada. Seguem protocolos forenses nacionais e permitem consultas analíticas (ex: "quantos vestígios biológicos foram coletados este mês?").

### 3.16 Objeto, Arma, Municao, Droga, Veiculo
**Justificativa:** Itens específicos frequentemente encontrados em locais de crime. Embora pudessem ser modelados como subtipos de uma entidade genérica "ItemApreendido", a separação justifica-se porque cada tipo possui atributos radicalmente distintos (arma tem calibre e numeração; droga tem peso e tipo; veículo tem placa e chassi). A especialização evita tabelas com dezenas de colunas nullable (anti-pattern "tabela esparsa").

### 3.17 CategoriaObjeto, TipoArma, TipoMunicao, TipoDroga
**Justificativa:** Tabelas de domínio para padronização e consultas analíticas.

### 3.18 Fotografia, Video, Audio, DocumentoAnexo
**Justificativa:** Mídias são evidências fundamentais em investigações criminais. Separam-se em entidades distintas porque cada tipo tem metadados específicos (resolução, duração, codec) e requisitos de armazenamento diferentes (fotos podem ter miniaturas; vídeos podem ter transcrição; documentos podem ter OCR).

### 3.19 MidiaTag e MidiaMidiaTag
**Justificativa:** Permitem categorização flexível de mídias sem alterar o schema. Tags como "corpo", "arma", "entrada", "saída" facilitam busca e organização.

### 3.20 Assinatura e TipoAssinatura
**Justificativa:** Assinaturas digitais garantem a validade jurídica dos registros. A entidade registra quem assinou, o quê, quando e com qual método. Essencial para cadeia de custódia digital e conformidade com o processo eletrônico.

### 3.21 Auditoria
**Justificativa:** Registro obrigatório para sistemas governamentais. Captura quem fez o quê, quando, de qual IP e com qual resultado. Requisito de compliance e transparência.

### 3.22 LogSistema
**Justificativa:** Diferente da auditoria (que é negocial), logs do sistema capturam eventos técnicos (erros de conexão, timeouts, exceções). Essencial para diagnóstico e monitoramento.

### 3.23 HistoricoAlteracao
**Justificativa:** Versionamento completo de registros. Permite visualizar o estado anterior de qualquer entidade, quem alterou e quando. Diferente da auditoria (que registra a ação), o histórico registra o dado antes e depois (snapshot).

### 3.24 LinhaTempo
**Justificativa:** Visão cronológica dos eventos de um atendimento. Agrega eventos de diferentes entidades (chegada da equipe, coleta de vestígios, fotos, saída) em uma timeline unificada para facilitar a reconstrução do atendimento.

### 3.25 Configuracao
**Justificativa:** Parâmetros do sistema que podem ser alterados sem deploy (horários de plantão, prazos, endpoints, etc.). Modelo chave-valor com tipagem.

### 3.26 SincronizacaoOffline, FilaSincronizacao, Dispositivo
**Justificativa:** Suporte ao modo offline-first. Dispositivos móveis podem operar sem conexão; as alterações são enfileiradas e sincronizadas quando a conexão é restabelecida. Essencial para trabalho de campo em áreas rurais/remotas.

### 3.27 BackupRegistro
**Justificativa:** Metadados de backups para conformidade com políticas de retenção e recuperação de desastres.

---

## 4. Relacionamentos Entre Todas as Entidades

### 4.1 Diagrama Textual Hierárquico

```
Usuário
├── Sessao (1:N)
│   └── RefreshToken (1:N)
├── UsuarioPerfil (1:N) → Perfil (N:1)
│   └── PerfilPermissao (1:N) → Permissao (N:1)
├── Unidade (N:1) [lotação]
├── AtendimentoLocal (1:N) [responsável]
├── EquipeUsuario (1:N) → Equipe (N:1)
├── Assinatura (1:N)
├── Auditoria (1:N)
├── HistoricoAlteracao (1:N)
└── LinhaTempo (1:N)

Perfil
├── UsuarioPerfil (1:N) → Usuario (N:1)
└── PerfilPermissao (1:N) → Permissao (N:1)

Permissao
└── PerfilPermissao (1:N) → Perfil (N:1)

Unidade
├── Delegacia (1:1) [opcional]
├── Instituto (1:1) [opcional]
├── Departamento (1:1) [opcional]
├── Usuario (1:N)
└── Municipio (N:1)

Delegacia
└── Unidade (1:1)

Instituto
└── Unidade (1:1)

Departamento
└── Unidade (1:1)

Municipio
└── Unidade (1:N)

Ocorrencia
├── AtendimentoLocal (1:N)
├── PessoaEnvolvida (1:N)
├── Municipio (N:1)
├── Delegacia (N:1)
├── Usuario (N:1) [registrador]
└── LinhaTempo (1:N)

AtendimentoLocal
├── Ocorrencia (N:1)
├── Equipe (N:1)
├── Usuario (N:1) [responsável]
├── Vestigio (1:N)
├── Objeto (1:N)
├── Arma (1:N)
├── Municao (1:N)
├── Droga (1:N)
├── Veiculo (1:N)
├── Fotografia (1:N)
├── Video (1:N)
├── Audio (1:N)
├── DocumentoAnexo (1:N)
├── PolicialParticipante (1:N)
├── Assinatura (1:N)
├── LinhaTempo (1:N)
└── HistoricoAlteracao (1:N)

Equipe
├── AtendimentoLocal (1:N)
├── EquipeUsuario (1:N) → Usuario (N:1)
└── Unidade (N:1)

EquipeUsuario
├── Equipe (N:1)
└── Usuario (N:1)

PessoaEnvolvida
├── Ocorrencia (N:1)
└── Municipio (N:1)

PolicialParticipante
├── AtendimentoLocal (N:1)
└── Usuario (N:1) [opcional, se for usuário do sistema]

Vestigio
├── AtendimentoLocal (N:1)
├── TipoVestigio (N:1)
├── CadeiaCustodia (1:N)
├── Acondicionamento (N:1)
└── Fotografia (1:N) [fotos específicas do vestígio]

CadeiaCustodia
├── Vestigio (N:1)
├── Usuario (N:1) [responsável pela movimentação]
├── DestinoVestigio (N:1)
└── Assinatura (1:N)

Objeto
├── AtendimentoLocal (N:1)
├── CategoriaObjeto (N:1)
└── Fotografia (1:N)

Arma
├── AtendimentoLocal (N:1)
├── TipoArma (N:1)
└── Fotografia (1:N)

Municao
├── AtendimentoLocal (N:1)
├── TipoMunicao (N:1)
└── Fotografia (1:N)

Droga
├── AtendimentoLocal (N:1)
├── TipoDroga (N:1)
└── Fotografia (1:N)

Veiculo
├── AtendimentoLocal (N:1)
└── Fotografia (1:N)

Fotografia
├── AtendimentoLocal (N:1)
├── Vestigio (N:1) [opcional]
├── Objeto (N:1) [opcional]
├── Arma (N:1) [opcional]
├── Municao (N:1) [opcional]
├── Droga (N:1) [opcional]
├── Veiculo (N:1) [opcional]
├── Usuario (N:1) [autor]
└── MidiaMidiaTag (1:N) → MidiaTag (N:1)

Video
├── AtendimentoLocal (N:1)
├── Usuario (N:1) [autor]
└── MidiaMidiaTag (1:N) → MidiaTag (N:1)

Audio
├── AtendimentoLocal (N:1)
├── Usuario (N:1) [autor]
└── MidiaMidiaTag (1:N) → MidiaTag (N:1)

DocumentoAnexo
├── AtendimentoLocal (N:1)
├── Usuario (N:1) [autor]
└── MidiaMidiaTag (1:N) → MidiaTag (N:1)

Assinatura
├── Usuario (N:1) [signatário]
├── TipoAssinatura (N:1)
├── AtendimentoLocal (N:1) [opcional]
├── CadeiaCustodia (N:1) [opcional]
└── DocumentoAnexo (N:1) [opcional]

Auditoria
├── Usuario (N:1)
└── Dispositivo (N:1) [opcional]

LinhaTempo
├── Ocorrencia (N:1)
├── AtendimentoLocal (N:1) [opcional]
└── Usuario (N:1)

HistoricoAlteracao
├── Usuario (N:1)
└── AtendimentoLocal (N:1) [opcional]

SincronizacaoOffline
├── Dispositivo (N:1)
└── FilaSincronizacao (1:N)

FilaSincronizacao
├── SincronizacaoOffline (N:1)
└── Usuario (N:1)

Dispositivo
├── Usuario (N:1)
└── SincronizacaoOffline (1:N)

Configuracao
└── (entidade autônoma, sem FKs externas)

BackupRegistro
└── Usuario (N:1) [executor]

LogSistema
└── Usuario (N:1) [opcional]
```

---

## 5. Cardinalidade

### 5.1 Relacionamentos 1:1

| Entidade A     | Entidade B     | Descrição                                      |
|----------------|----------------|------------------------------------------------|
| Delegacia      | Unidade        | Toda delegacia tem exatamente uma unidade      |
| Instituto      | Unidade        | Todo instituto tem exatamente uma unidade      |
| Departamento   | Unidade        | Todo departamento tem exatamente uma unidade   |

### 5.2 Relacionamentos 1:N

| Entidade A (1)       | Entidade B (N)        | Descrição                                  |
|-----------------------|-----------------------|--------------------------------------------|
| Usuario               | Sessao                | Um usuário pode ter várias sessões         |
| Sessao                | RefreshToken          | Uma sessão pode gerar vários refresh tokens|
| Usuario               | Auditoria             | Um usuário gera vários registros de auditoria |
| Usuario               | HistoricoAlteracao    | Um usuário faz várias alterações           |
| Usuario               | LinhaTempo            | Um usuário registra vários eventos         |
| Usuario               | AtendimentoLocal      | Um usuário pode ser responsável por vários atendimentos |
| Usuario               | Assinatura            | Um usuário pode ter várias assinaturas     |
| Usuario               | Fotografia            | Um usuário pode tirar várias fotos         |
| Usuario               | Video                 | Um usuário pode gravar vários vídeos       |
| Usuario               | Audio                 | Um usuário pode gravar vários áudios       |
| Usuario               | DocumentoAnexo        | Um usuário pode anexar vários documentos   |
| Usuario               | Dispositivo           | Um usuário pode ter vários dispositivos    |
| Usuario               | FilaSincronizacao     | Um usuário pode ter várias operações pendentes |
| Usuario               | Ocorrencia            | Um usuário pode registrar várias ocorrências |
| Unidade               | Usuario               | Uma unidade pode ter vários usuários lotados |
| Unidade               | Equipe                | Uma unidade pode ter várias equipes        |
| Municipio             | Unidade               | Um município pode ter várias unidades      |
| Municipio             | Ocorrencia            | Um município pode ter várias ocorrências   |
| Municipio             | PessoaEnvolvida       | Um município pode ter várias pessoas       |
| Ocorrencia            | AtendimentoLocal      | Uma ocorrência pode ter vários atendimentos |
| Ocorrencia            | PessoaEnvolvida       | Uma ocorrência pode ter várias pessoas envolvidas |
| Ocorrencia            | LinhaTempo            | Uma ocorrência tem vários eventos de timeline |
| Delegacia             | Ocorrencia            | Uma delegacia registra várias ocorrências  |
| AtendimentoLocal      | Vestigio              | Um atendimento pode ter vários vestígios   |
| AtendimentoLocal      | Objeto                | Um atendimento pode ter vários objetos     |
| AtendimentoLocal      | Arma                  | Um atendimento pode ter várias armas       |
| AtendimentoLocal      | Municao               | Um atendimento pode ter várias munições    |
| AtendimentoLocal      | Droga                 | Um atendimento pode ter várias drogas      |
| AtendimentoLocal      | Veiculo               | Um atendimento pode ter vários veículos    |
| AtendimentoLocal      | Fotografia            | Um atendimento pode ter várias fotos       |
| AtendimentoLocal      | Video                 | Um atendimento pode ter vários vídeos      |
| AtendimentoLocal      | Audio                 | Um atendimento pode ter vários áudios      |
| AtendimentoLocal      | DocumentoAnexo        | Um atendimento pode ter vários documentos  |
| AtendimentoLocal      | PolicialParticipante  | Um atendimento pode ter vários policiais   |
| AtendimentoLocal      | Assinatura            | Um atendimento pode ter várias assinaturas |
| AtendimentoLocal      | LinhaTempo            | Um atendimento tem vários eventos de timeline |
| AtendimentoLocal      | HistoricoAlteracao    | Um atendimento tem várias versões históricas |
| Equipe                | AtendimentoLocal      | Uma equipe pode atender vários locais      |
| Equipe                | EquipeUsuario         | Uma equipe tem vários membros              |
| Vestigio              | CadeiaCustodia        | Um vestígio tem vários registros de custódia |
| Vestigio              | Fotografia            | Um vestígio pode ter várias fotos específicas |
| TipoVestigio          | Vestigio              | Um tipo classifica vários vestígios        |
| Acondicionamento      | Vestigio              | Um tipo de acondicionamento usado em vários vestígios |
| DestinoVestigio       | CadeiaCustodia        | Um destino aparece em vários registros     |
| CategoriaObjeto       | Objeto                | Uma categoria classifica vários objetos    |
| TipoArma              | Arma                  | Um tipo classifica várias armas            |
| TipoMunicao           | Municao               | Um tipo classifica várias munições         |
| TipoDroga             | Droga                 | Um tipo classifica várias drogas           |
| TipoAssinatura        | Assinatura            | Um tipo é usado em várias assinaturas      |
| Dispositivo           | SincronizacaoOffline  | Um dispositivo tem várias sincronizações   |
| SincronizacaoOffline  | FilaSincronizacao     | Uma sincronização tem várias operações     |

### 5.3 Relacionamentos N:N (com tabela associativa)

| Entidade A     | Entidade B     | Tabela Associativa   | Descrição                              |
|----------------|----------------|----------------------|----------------------------------------|
| Usuario        | Perfil         | UsuarioPerfil        | Um usuário pode ter vários perfis      |
| Perfil         | Permissao      | PerfilPermissao      | Um perfil pode ter várias permissões   |
| Usuario        | Equipe         | EquipeUsuario        | Um usuário pode participar de várias equipes |
| Fotografia     | MidiaTag       | MidiaMidiaTag        | Uma foto pode ter várias tags          |
| Video          | MidiaTag       | MidiaMidiaTag        | Um vídeo pode ter várias tags          |
| Audio          | MidiaTag       | MidiaMidiaTag        | Um áudio pode ter várias tags          |
| DocumentoAnexo | MidiaTag       | MidiaMidiaTag        | Um documento pode ter várias tags      |

---

## 6. Estratégia de Normalização

### 6.1 Forma Normal Adotada

O banco será projetado na **3ª Forma Normal (3FN)** como regra geral, com desnormalizações pontuais e justificadas para otimização de leitura.

### 6.2 Princípios

1. **Atomicidade (1FN):** Todos os atributos são atômicos. Não há colunas multivaloradas. Tags e categorias usam tabelas associativas, não arrays.
2. **Dependência funcional total (2FN):** Toda coluna não-chave depende da chave primária inteira. Tabelas associativas têm chaves compostas que garantem isso.
3. **Ausência de dependência transitiva (3FN):** Colunas não-chave dependem apenas da PK, não de outras colunas não-chave. Ex: Em `AtendimentoLocal`, o nome da cidade não é armazenado — apenas a FK para `Municipio`.

### 6.3 Desnormalizações Planejadas

| Local                          | Desnormalização                                  | Justificativa                                               |
|--------------------------------|--------------------------------------------------|-------------------------------------------------------------|
| `atendimentos_local`           | `numero_registro` (autoincrement) mantido como campo redundante de exibição | Facilita busca e legibilidade humana (ex: "ALC-2026-0001") |
| `auditorias`                   | `nome_entidade` e `valor_resumo` armazenados como snapshot | Evita joins complexos em consultas de auditoria (dados históricos não mudam) |
| `historicos_alteracao`         | `dados_antes` e `dados_depois` como JSONB        | Flexibilidade para versionar qualquer estrutura sem schema rígido |
| `logs_sistema`                 | `contexto` como JSONB                            | Dados de contexto variam por tipo de log                    |
| `configuracoes`                | `valor` como JSONB                               | Permite valores de tipos diferentes (string, número, objeto) |

### 6.4 Uso de JSONB

JSONB será usado exclusivamente para:
- Dados cuja estrutura varia (configurações, contexto de log)
- Snapshots históricos que não precisam ser consultados relationalmente
- **NUNCA** para dados que precisam de constraints, FKs, ou consultas frequentes com WHERE em campos internos

### 6.5 Padrão Supertype/Subtype (Unidade)

A entidade `Unidade` segue o padrão supertype/subtype:
- `unidades` contém atributos comuns (nome, endereco, municipio_id, tipo)
- `delegacias`, `institutos`, `departamentos` contêm atributos específicos
- Relacionamento 1:1 com FK bidirecional
- A coluna `tipo` na tabela `unidades` é um discriminador (Delegacia | Instituto | Departamento)

---

## 7. Estratégia de Auditoria

### 7.1 Tabela de Auditoria

Tabela única `auditorias` registra todas as operações sensíveis do sistema:

| Campo             | Tipo      | Descrição                                         |
|-------------------|-----------|---------------------------------------------------|
| id                | UUID      | PK                                                |
| usuario_id        | UUID (FK) | Usuário que executou a ação                       |
| acao              | Enum      | Ação (criar, atualizar, deletar, visualizar, exportar, login, logout) |
| entidade          | String    | Nome da entidade afetada (ex: "AtendimentoLocal")  |
| entidade_id       | UUID      | ID do registro afetado                            |
| valor_anterior    | JSONB     | Snapshot do estado anterior (opcional)            |
| valor_novo        | JSONB     | Snapshot do estado novo (opcional)                |
| ip_origem         | String    | Endereço IP do cliente                            |
| user_agent        | String    | User agent do cliente                             |
| dispositivo_id    | UUID (FK) | Dispositivo utilizado (opcional)                  |
| data_hora         | Timestamp | Momento exato da ação                             |

### 7.2 O Que é Auditado

- **Autenticação:** Login, logout, tentativas de login falhas, troca de senha
- **CRUD sensível:** Criação/edição/exclusão de atendimentos, vestígios, cadeia de custódia
- **Permissões:** Alterações de perfis e permissões de usuários
- **Dados pessoais:** Acesso a dados de pessoas envolvidas (LGPD)
- **Exportações:** Geração de relatórios, exportação de dados

### 7.3 O Que NÃO é Auditado

- Consultas de leitura em tabelas não sensíveis
- Operações de sincronização técnica (metadados)
- Logs de sistema (já possuem tabela própria)

### 7.4 Implementação

- **Middleware/Interceptor no NestJS:** Captura automaticamente ações em endpoints anotados com `@Auditavel()`
- **Append-only:** Registros de auditoria nunca são alterados ou excluídos
- **Retenção:** 5 anos (conforme legislação), com partição por ano para performance

---

## 8. Estratégia de Sincronização Offline

### 8.1 Arquitetura Offline-First

O sistema mobile (Flutter) deve operar offline em áreas sem conectividade. A estratégia adotada é **Offline-First com sincronização bidirecional baseada em CRDT-like timestamps**.

### 8.2 Tabelas de Suporte

#### `dispositivos`
Registra dispositivos móveis autorizados. Cada dispositivo tem um `device_id` único e está vinculado a um usuário.

#### `sincronizacao_offline`
Registra cada operação de sincronização (pull ou push) com:
- dispositivo_id
- data_inicio, data_fim
- status (em_andamento, concluido, falha)
- registros_enviados, registros_recebidos
- conflitos_detectados

#### `fila_sincronizacao`
Fila de operações pendentes de envio ao servidor:
- usuario_id
- entidade, entidade_id
- acao (criar, atualizar, deletar)
- dados (JSONB com o payload completo)
- data_operacao (timestamp original da operação no dispositivo)
- status (pendente, enviado, confirmado, conflito)
- tentativas, ultima_tentativa

### 8.3 Estratégia de Conflitos

- **Last Write Wins (LWW):** Baseado no timestamp `atualizado_em` — a operação mais recente prevalece
- **Conflitos detectados** são registrados em `fila_sincronizacao` com status "conflito" para revisão manual
- **Dados críticos** (cadeia de custódia) usam append-only — nunca há conflito, apenas concatenação

### 8.4 Fluxo de Sincronização

1. **Pull (Server → Device):** Dispositivo solicita alterações desde `ultima_sincronizacao`. Servidor retorna delta.
2. **Push (Device → Server):** Dispositivo envia fila de operações pendentes. Servidor aplica em ordem.
3. **Resolução de Conflitos:** Se detectado conflito, servidor aplica LWW e notifica dispositivo.
4. **Confirmação:** Servidor confirma cada item da fila com status "confirmado" ou "conflito".

### 8.5 Dados Disponíveis Offline

- Catálogos (municípios, tipos, categorias): **Full sync** no primeiro login, depois delta
- Registros do usuário: Apenas atendimentos do usuário e sua equipe
- Mídias: Metadados sincronizados; arquivos binários em fila separada com prioridade baixa

---

## 9. Estratégia de Versionamento

### 9.1 Histórico de Alterações

Tabela `historicos_alteracao` mantém versionamento completo de registros críticos:

| Campo             | Tipo      | Descrição                                         |
|-------------------|-----------|---------------------------------------------------|
| id                | UUID      | PK                                                |
| entidade          | String    | Nome da entidade (ex: "AtendimentoLocal")          |
| entidade_id       | UUID      | ID do registro                                    |
| usuario_id        | UUID (FK) | Usuário que fez a alteração                       |
| dados_antes       | JSONB     | Snapshot completo antes da alteração              |
| dados_depois      | JSONB     | Snapshot completo depois da alteração             |
| versao            | Int       | Número sequencial da versão                       |
| motivo            | String    | Justificativa da alteração (opcional)             |
| data_hora         | Timestamp | Momento da alteração                              |

### 9.2 Entidades Versionadas

- AtendimentoLocal (todas as alterações)
- Vestigio (todas as alterações)
- CadeiaCustodia (já é naturalmente append-only, mas cada registro é versionado se editado)
- Ocorrencia
- PessoaEnvolvida

### 9.3 Política de Retenção

- Versões mantidas indefinidamente para registros de atendimento (valor jurídico)
- Versões de dados cadastrais (usuários, perfis): 2 anos
- Snapshots armazenados como JSONB para flexibilidade de schema

---

## 10. Estratégia de Índices

### 10.1 Índices Primários (automáticos)

- Todas as PKs (UUID) geram índices B-tree automaticamente
- Todas as colunas `@unique` no Prisma geram índices únicos

### 10.2 Índices Secundários Projetados

| Tabela                   | Coluna(s)                    | Tipo     | Justificativa                                        |
|--------------------------|------------------------------|----------|------------------------------------------------------|
| `usuarios`               | `matricula`                  | UNIQUE   | Login e busca por matrícula (já existente)           |
| `usuarios`               | `email`                      | UNIQUE   | Login e recuperação de senha (já existente)          |
| `usuarios`               | `unidade_id`                 | B-tree   | Listar usuários por unidade                          |
| `usuarios`               | `ativo`                      | B-tree   | Filtrar usuários ativos/inativos                     |
| `atendimentos_local`     | `numero_registro`            | UNIQUE   | Busca por número de registro (já existente similar)  |
| `atendimentos_local`     | `ocorrencia_id`              | B-tree   | Listar atendimentos de uma ocorrência                |
| `atendimentos_local`     | `equipe_id`                  | B-tree   | Listar atendimentos de uma equipe                    |
| `atendimentos_local`     | `usuario_id`                 | B-tree   | Listar atendimentos de um usuário                    |
| `atendimentos_local`     | `status`                     | B-tree   | Filtrar por status                                   |
| `atendimentos_local`     | `data_ocorrencia`            | B-tree   | Ordenação e filtro por data                          |
| `atendimentos_local`     | `coordenadas`                | GIST     | Índice geoespacial para consultas de proximidade     |
| `ocorrencias`            | `delegacia_id`               | B-tree   | Listar ocorrências por delegacia                     |
| `ocorrencias`            | `municipio_id`               | B-tree   | Listar ocorrências por município                     |
| `ocorrencias`            | `data_ocorrencia`            | B-tree   | Ordenação e filtro por data                          |
| `vestigios`              | `atendimento_local_id`       | B-tree   | Listar vestígios de um atendimento                   |
| `vestigios`              | `tipo_vestigio_id`           | B-tree   | Filtrar por tipo de vestígio                         |
| `cadeia_custodia`        | `vestigio_id`                | B-tree   | Listar eventos de um vestígio (ordem cronológica)    |
| `cadeia_custodia`        | `usuario_id`                 | B-tree   | Listar movimentações por usuário                     |
| `cadeia_custodia`        | `data_hora`                  | B-tree   | Ordenação cronológica                                |
| `objetos` / `armas` / etc| `atendimento_local_id`       | B-tree   | Listar itens de um atendimento                       |
| `fotografias`            | `atendimento_local_id`       | B-tree   | Listar fotos de um atendimento                       |
| `fotografias`            | `vestigio_id`                | B-tree   | Listar fotos de um vestígio                          |
| `auditorias`             | `usuario_id`                 | B-tree   | Auditar ações de um usuário                          |
| `auditorias`             | `entidade` + `entidade_id`   | B-tree   | Auditar ações sobre um registro específico           |
| `auditorias`             | `data_hora`                  | B-tree   | Ordenação e particionamento por data                 |
| `auditorias`             | `acao`                       | B-tree   | Filtrar por tipo de ação                             |
| `historicos_alteracao`   | `entidade` + `entidade_id`   | B-tree   | Listar versões de um registro                        |
| `historicos_alteracao`   | `data_hora`                  | B-tree   | Ordenação cronológica                                |
| `linhas_tempo`           | `atendimento_local_id`       | B-tree   | Listar eventos de um atendimento                     |
| `linhas_tempo`           | `ocorrencia_id`              | B-tree   | Listar eventos de uma ocorrência                     |
| `linhas_tempo`           | `data_hora`                  | B-tree   | Ordenação cronológica                                |
| `sessoes`                | `usuario_id`                 | B-tree   | Listar sessões de um usuário                         |
| `sessoes`                | `token`                      | UNIQUE   | Validação de token                                   |
| `refresh_tokens`         | `token`                      | UNIQUE   | Validação de refresh token                           |
| `fila_sincronizacao`     | `usuario_id` + `status`      | B-tree   | Listar pendências de um usuário                      |
| `fila_sincronizacao`     | `status`                     | B-tree   | Filtrar por status                                   |
| `equipe_usuarios`        | `equipe_id`                  | B-tree   | Listar membros de uma equipe                         |
| `equipe_usuarios`        | `usuario_id`                 | B-tree   | Listar equipes de um usuário                         |
| `pessoas_envolvidas`     | `ocorrencia_id`              | B-tree   | Listar pessoas de uma ocorrência                     |
| `pessoas_envolvidas`     | `cpf`                        | B-tree   | Buscar pessoa por CPF                                |
| `assinaturas`            | `atendimento_local_id`       | B-tree   | Listar assinaturas de um atendimento                 |
| `assinaturas`            | `usuario_id`                 | B-tree   | Listar assinaturas de um usuário                     |
| `logs_sistema`           | `nivel`                      | B-tree   | Filtrar por nível de severidade                      |
| `logs_sistema`           | `data_hora`                  | B-tree   | Ordenação e particionamento                          |

### 10.3 Índices Geoespaciais

Aproveitando o PostGIS (imagem `postgis/postgis:16-3.4`):
- Coluna `coordenadas` do tipo `GEOMETRY(Point, 4326)` na tabela `atendimentos_local`
- Índice GIST para consultas de proximidade, mapas de calor e análise espacial
- Consultas típicas: "atendimentos em um raio de 5km", "atendimentos por bairro via polígono"

### 10.4 Índices Parciais

- `usuarios` WHERE `ativo = true`: Para consultas que só precisam de usuários ativos
- `fila_sincronizacao` WHERE `status = 'pendente'`: Para processamento de fila
- `auditorias` WHERE `data_hora >= CURRENT_DATE - INTERVAL '90 days'`: Para consultas recentes

---

## 11. Estratégia de Segurança

### 11.1 Segurança em Nível de Banco de Dados

#### Criptografia
- **Senhas:** Hash com bcrypt (12 rounds) — nunca armazenadas em plain text
- **Dados sensíveis em repouso:** PostgreSQL TDE (Transparent Data Encryption) se disponível na infraestrutura, ou criptografia em nível de filesystem
- **Conexões:** TLS 1.3 para todas as conexões com o banco

#### Autenticação no Banco
- Aplicação usa usuário de banco com privilégios mínimos (sem DROP, CREATE, superuser)
- Roles separadas para: aplicação (CRUD), migração (DDL), auditoria (read-only em auditorias)
- ` Row-Level Security (RLS)` opcional para isolamento multi-inquilino futuro

### 11.2 Segurança em Nível de Aplicação

#### Autenticação
- JWT com access token (15 min) + refresh token (7 dias)
- Refresh tokens armazenados com hash (SHA-256) no banco
- Sessões rastreáveis e revogáveis individualmente

#### Autorização (RBAC)
- Permissões atômicas verificadas via Guards no NestJS
- Cache de permissões no Redis para reduzir consultas ao banco
- Verificação em 3 níveis: módulo (feature), ação (CRUD), escopo (próprio/unidade/todos)

#### Proteção contra Injeção
- Prisma ORM com consultas parametrizadas (proteção nativa contra SQL injection)
- Validação de entrada via DTOs com class-validator
- Rate limiting nos endpoints de autenticação

### 11.3 Conformidade LGPD

- **Finalidade:** Dados pessoais coletados apenas para finalidade policial legítima
- **Minimização:** Apenas dados estritamente necessários são armazenados
- **Anonimização:** `auditorias` não armazenam dados pessoais de cidadãos em JSONB sem necessidade
- **Direito ao acesso:** Endpoints específicos para exportação de dados pessoais mediante solicitação
- **Exclusão:** Soft delete permite "exclusão" sem perda de integridade referencial; exclusão real sob demanda judicial com cascade controlado

### 11.4 Segurança Física e Backup

- Backups criptografados (AES-256)
- Armazenamento off-site com retenção mínima de 30 dias
- Testes de restauração trimestrais

---

## 12. Estratégia de Exclusão Lógica (Soft Delete)

### 12.1 Tabelas com Soft Delete

A coluna `deletado_em` (timestamp nullable) será adicionada às seguintes tabelas:

| Tabela                  | Justificativa                                                     |
|-------------------------|-------------------------------------------------------------------|
| `usuarios`              | Preservar histórico de ações do usuário; conformidade LGPD        |
| `perfis`                | Evitar orfanização de `usuario_perfis`                            |
| `permissoes`            | Evitar orfanização de `perfil_permissoes`                         |
| `unidades`              | Histórico de lotação; integridade referencial                     |
| `delegacias`            | Vinculada a unidade — mesma política                              |
| `institutos`            | Vinculada a unidade — mesma política                              |
| `departamentos`         | Vinculada a unidade — mesma política                              |
| `equipes`               | Histórico de equipes em atendimentos passados                     |
| `atendimentos_local`    | **NUNCA excluído** — valor jurídico permanente (apenas soft delete administrativo) |
| `ocorrencias`           | **NUNCA excluído** — registro policial permanente                 |
| `vestigios`             | **NUNCA excluído** — cadeia de custódia                           |
| `pessoas_envolvidas`    | Soft delete para conformidade LGPD                                |
| `objetos` / `armas` / etc | Soft delete — preservar numeração e rastreabilidade             |
| `fotografias` / `videos` / `audios` | Soft delete — preservar metadados; arquivo pode ser excluído |
| `documentos_anexos`     | Soft delete — preservar metadados                                 |
| `categorias_objeto`     | Evitar orfanização                                                |
| `tipos_*`               | Evitar orfanização                                                |
| `midia_tags`            | Soft delete para limpeza organizacional                           |

### 12.2 Tabelas SEM Soft Delete

| Tabela                  | Justificativa                                                     |
|-------------------------|-------------------------------------------------------------------|
| `auditorias`            | Append-only; exclusão apenas por política de retenção (partição)  |
| `historicos_alteracao`  | Append-only; versionamento permanente                             |
| `logs_sistema`          | Append-only; rotacionado por tempo                                |
| `sessoes`               | Exclusão real ao expirar/revogar                                  |
| `refresh_tokens`        | Exclusão real ao expirar/revogar                                  |
| `fila_sincronizacao`    | Exclusão real após confirmação (dados técnicos efêmeros)         |
| `sincronizacao_offline` | Exclusão real após retenção (dados técnicos)                     |

### 12.3 Implementação

- Todas as queries incluem `WHERE deletado_em IS NULL` por padrão
- Prisma Client middleware para filtrar automaticamente registros não deletados
- Método explícito `includeDeleted()` para bypass quando necessário (admin/auditoria)
- Índice parcial em `deletado_em` WHERE `deletado_em IS NULL` para performance

---

## 13. Estratégia de Backups

### 13.1 Política de Backup

| Tipo               | Frequência         | Retenção      | Local                          |
|--------------------|--------------------|---------------|--------------------------------|
| Backup completo    | Diário (00:00)     | 30 dias       | Off-site + cloud               |
| Backup incremental | A cada 6 horas     | 7 dias        | Storage rápido (restauração)   |
| WAL Archiving      | Contínuo           | 7 dias        | Point-in-time recovery         |
| Snapshot (cloud)   | Diário             | 90 dias       | Cloud provider                 |

### 13.2 Ferramentas

- `pg_dump` para backups lógicos (compatibilidade entre versões)
- `pg_basebackup` + WAL archiving para PITR (Point-in-Time Recovery)
- `pgBackRest` como alternativa enterprise-grade
- Scripts de verificação automática de integridade do backup

### 13.3 Procedimentos

- **Teste de restauração:** Trimestral, em ambiente isolado
- **RPO (Recovery Point Objective):** Máximo 1 hora (com WAL archiving contínuo)
- **RTO (Recovery Time Objective):** Máximo 4 horas
- **Retenção legal:** Backups de dados de ocorrências mantidos por 20 anos (valor jurídico)

### 13.4 Criptografia

- Backups criptografados com AES-256 antes do armazenamento
- Chaves gerenciadas via HashiCorp Vault ou AWS KMS (dependendo da infraestrutura)

---

## 14. Estratégia de Crescimento Futuro

### 14.1 Particionamento

| Tabela                  | Estratégia de Partição     | Gatilho                    |
|-------------------------|----------------------------|----------------------------|
| `auditorias`            | RANGE por `data_hora` (mensal) | > 10 milhões de registros |
| `logs_sistema`          | RANGE por `data_hora` (mensal) | > 10 milhões de registros |
| `historicos_alteracao`  | RANGE por `data_hora` (anual)  | > 5 milhões de registros  |
| `fila_sincronizacao`    | RANGE por `data_operacao` (diário) | > 1 milhão de registros |

### 14.2 Escalabilidade Horizontal

- **Leitura:** Read replicas para consultas analíticas e relatórios (não crítico para MVP)
- **Cache:** Redis para sessões, permissões e dados de catálogo
- **Filas:** BullMQ (Redis-based) para processamento assíncrono (exportação, sincronização de mídias)

### 14.3 Expansão de Schema

- **Módulos futuros previstos:**
  - Módulo de Inteligência Policial (análise criminal, padrões, mapas de calor avançados)
  - Módulo de Gestão de Provas (integração com sistema judiciário)
  - Módulo de Comunicação (notificações push, alertas entre unidades)
  - Módulo de Relatórios Estatísticos (dashboards avançados)
- **Estratégia:** Cada novo módulo adiciona tabelas independentes com FKs para entidades core (AtendimentoLocal, Ocorrencia)
- **Migrações:** Sempre aditivas e não-destrutivas (expand-contract pattern)

### 14.4 Versionamento de API

- Schema versioning via coluna `schema_version` em `configuracoes`
- Migrações sempre backward-compatible (fase de expansão antes da contração)
- Frontend verifica versão compatível no login

### 14.5 Multi-Tenancy Futura

- Arquitetura atual é single-tenant (PCPE)
- Preparação para multi-inquilino via coluna `tenant_id` opcional em tabelas core
- Se necessário no futuro (ex: integração com outras polícias estaduais), RLS por `tenant_id`

---

## 15. Sugestões de Melhorias Arquiteturais

### 15.1 Sugestões Imediatas (MVP)

1. **Renomear `Atendimento` para `AtendimentoLocal`:** O termo "atendimento" é genérico e pode conflitar com outros contextos. "AtendimentoLocal" descreve precisamente o propósito.

2. **Substituir campos de endereço por FK para Municipio:** Atualmente `cidade` e `estado` são strings soltas. Referenciar a tabela `municipios` garante integridade e permite dashboards geográficos.

3. **Adicionar tabela `Ocorrencia` antes de `AtendimentoLocal`:** Separar o BO (ocorrência) do atendimento pericial segue o fluxo real: primeiro registra-se a ocorrência, depois despacha-se o atendimento.

4. **Substituir `Role` por modelo RBAC completo:** O enum atual (ADMIN, CHEFE_EQUIPE, PERITO, AGENTE) é rígido. Perfis + Permissões oferecem granularidade necessária para um sistema corporativo.

5. **Migrar `latitude`/`longitude` (Float) para coluna GEOMETRY do PostGIS:** A imagem Docker já é `postgis/postgis:16-3.4`, mas o schema atual usa floats simples. Usar tipo GEOMETRY nativo habilita índices GIST espaciais e funções PostGIS (ST_DWithin, ST_Contains, etc.).

### 15.2 Sugestões de Curto Prazo (Pós-MVP)

6. **Implementar tabela `unidades` como supertype:** Evita FKs polimórficas e simplifica relacionamentos com usuários e equipes.

7. **Adicionar versionamento (historico_alteracoes):** Essencial para integridade de dados forenses. Permite auditoria completa de quem alterou o quê e quando.

8. **Implementar soft delete em todas as tabelas de domínio:** Protege integridade referencial e atende requisitos legais.

9. **Criar índices parciais para colunas `deletado_em`:** Melhora performance das consultas padrão (que sempre filtram `deletado_em IS NULL`).

### 15.3 Sugestões de Longo Prazo

10. **Particionamento de tabelas de auditoria e logs:** Essencial para performance quando o volume de dados crescer.

11. **Materialized Views para dashboards:** Consultas analíticas (estatísticas de criminalidade, tempo médio de atendimento) podem usar views materializadas refrescadas periodicamente.

12. **Event Sourcing para Cadeia de Custódia:** A cadeia de custódia se beneficia de event sourcing completo (cada evento é um fato imutável), em vez de CRUD tradicional.

13. **Full-Text Search:** Implementar busca textual em descrições de ocorrências e atendimentos usando `tsvector` do PostgreSQL.

14. **Coluna `tenant_id` para multi-tenancy:** Preparar schema para possível expansão para outras unidades da federação ou integração com sistemas federais (SINESP, Infoseg).

### 15.4 Observações Técnicas

- **Prisma + PostGIS:** Prisma não tem suporte nativo a tipos GEOMETRY. Será necessário usar `Unsupported("GEOMETRY(Point, 4326)")` no schema e raw queries para operações espaciais, ou criar as colunas geoespaciais via migration SQL personalizada.
- **JSONB no Prisma:** Tipo `Json` do Prisma mapeia para JSONB no PostgreSQL. Adequado para snapshots de auditoria e configurações.
- **Migrações existentes:** A migration `20260730154350_init` deve ser preservada. Novas tabelas serão adicionadas via migrations incrementais.

---

## Apêndice A: Diagrama Textual Completo

```
Usuário
├── Sessao (1:N)
│   └── RefreshToken (1:N)
├── UsuarioPerfil (N:N) → Perfil
│   └── PerfilPermissao (N:N) → Permissao
├── Unidade (N:1) [lotação]
│   ├── Delegacia (1:1)
│   ├── Instituto (1:1)
│   └── Departamento (1:1)
├── AtendimentoLocal (1:N)
├── Ocorrencia (1:N)
├── EquipeUsuario (N:N) → Equipe
├── Assinatura (1:N)
├── Auditoria (1:N)
├── HistoricoAlteracao (1:N)
├── LinhaTempo (1:N)
├── Dispositivo (1:N)
│   └── SincronizacaoOffline (1:N)
│       └── FilaSincronizacao (1:N)
└── Fotografia / Video / Audio / DocumentoAnexo (1:N)

Perfil
├── UsuarioPerfil (N:N) → Usuario
└── PerfilPermissao (N:N) → Permissao

Permissao
└── PerfilPermissao (N:N) → Perfil

Unidade
├── Delegacia | Instituto | Departamento (1:1)
├── Usuario (1:N)
├── Equipe (1:N)
└── Municipio (N:1)

Ocorrencia
├── AtendimentoLocal (1:N)
├── PessoaEnvolvida (1:N)
├── Municipio (N:1)
├── Delegacia (N:1)
├── Usuario (N:1)
└── LinhaTempo (1:N)

AtendimentoLocal
├── Ocorrencia (N:1)
├── Equipe (N:1)
├── Usuario (N:1) [responsável]
├── Vestigio (1:N)
│   ├── TipoVestigio (N:1)
│   ├── CadeiaCustodia (1:N)
│   │   ├── Usuario (N:1) [responsável]
│   │   ├── DestinoVestigio (N:1)
│   │   └── Assinatura (1:N)
│   ├── Acondicionamento (N:1)
│   └── Fotografia (1:N)
├── Objeto (1:N)
│   ├── CategoriaObjeto (N:1)
│   └── Fotografia (1:N)
├── Arma (1:N)
│   ├── TipoArma (N:1)
│   └── Fotografia (1:N)
├── Municao (1:N)
│   ├── TipoMunicao (N:1)
│   └── Fotografia (1:N)
├── Droga (1:N)
│   ├── TipoDroga (N:1)
│   └── Fotografia (1:N)
├── Veiculo (1:N)
│   └── Fotografia (1:N)
├── Fotografia (1:N)
│   ├── Usuario (N:1) [autor]
│   └── MidiaMidiaTag (N:N) → MidiaTag
├── Video (1:N)
│   ├── Usuario (N:1) [autor]
│   └── MidiaMidiaTag (N:N) → MidiaTag
├── Audio (1:N)
│   ├── Usuario (N:1) [autor]
│   └── MidiaMidiaTag (N:N) → MidiaTag
├── DocumentoAnexo (1:N)
│   ├── Usuario (N:1) [autor]
│   └── MidiaMidiaTag (N:N) → MidiaTag
├── PolicialParticipante (1:N)
├── Assinatura (1:N)
├── LinhaTempo (1:N)
└── HistoricoAlteracao (1:N)

Equipe
├── AtendimentoLocal (1:N)
├── EquipeUsuario (N:N) → Usuario
└── Unidade (N:1)

PessoaEnvolvida
├── Ocorrencia (N:1)
└── Municipio (N:1)

Assinatura
├── Usuario (N:1)
├── TipoAssinatura (N:1)
├── AtendimentoLocal (N:1) [opcional]
├── CadeiaCustodia (N:1) [opcional]
└── DocumentoAnexo (N:1) [opcional]

Auditoria
├── Usuario (N:1)
└── Dispositivo (N:1) [opcional]

LinhaTempo
├── Ocorrencia (N:1)
├── AtendimentoLocal (N:1) [opcional]
└── Usuario (N:1)

HistoricoAlteracao
├── Usuario (N:1)
└── AtendimentoLocal (N:1) [opcional]

MidiaTag
└── MidiaMidiaTag (N:N) → Fotografia | Video | Audio | DocumentoAnexo

Configuracao (autônoma)
BackupRegistro (autônomo, referencia Usuario)
LogSistema (autônomo, referencia Usuario opcional)
```

---

## Apêndice B: Resumo de Enums Necessários

| Enum                    | Valores                                                                 |
|-------------------------|-------------------------------------------------------------------------|
| Role (existente)        | ADMIN, CHEFE_EQUIPE, PERITO, AGENTE                                     |
| StatusAtendimento (existente) | ABERTO, EM_ANDAMENTO, CONCLUIDO, CANCELADO                         |
| TipoLocal (existente)   | RESIDENCIA, VIA_PUBLICA, ESTABELECIMENTO_COMERCIAL, AREA_RURAL, VEICULO, OUTRO |
| TipoUnidade             | DELEGACIA, INSTITUTO, DEPARTAMENTO                                      |
| StatusOcorrencia        | ABERTA, EM_INVESTIGACAO, CONCLUIDA, ARQUIVADA                           |
| TipoEnvolvimento        | VITIMA, TESTEMUNHA, SUSPEITO, PROPRIETARIO, RESPONSAVEL, OUTRO          |
| StatusCadeia            | COLETADO, ACONDICIONADO, TRANSPORTADO, RECEBIDO, EM_ANALISE, ANALISADO, DESCARTADO, DEVOLVIDO |
| TipoEquipe              | PERICIA, INVESTIGACAO, PLANTAO, ESPECIAL                                 |
| StatusEquipe            | ATIVA, INATIVA, EM_DESLOCAMENTO, EM_ATENDIMENTO                         |
| StatusSincronizacao     | PENDENTE, ENVIADO, CONFIRMADO, CONFLITO, FALHA                          |
| TipoMidia               | FOTO, VIDEO, AUDIO, DOCUMENTO                                           |
| NivelLog                | DEBUG, INFO, WARNING, ERROR, CRITICAL                                   |
| AcaoAuditoria           | CRIAR, ATUALIZAR, DELETAR, VISUALIZAR, EXPORTAR, LOGIN, LOGOUT, FALHA_LOGIN |
| TipoAssinatura          | BIOMETRICA, CERTIFICADO_DIGITAL, PIN, SENHA                             |
| StatusSessao            | ATIVA, EXPIRADA, REVOGADA                                               |
| TipoAcondicionamento    | SACO_PLASTICO, ENVELOPE_PAPEL, CAIXA_PAPELAO, TUBO_ENSAIO, FRASCO_VIDRO, LACRE_METALICO |
| CategoriaObjeto         | ELETRONICO, DOCUMENTO, JOIA, FERRAMENTA, VESTUARIO, OUTRO               |
| TipoArma                | REVOLVER, PISTOLA, ESPINGARDA, FUZIL, FACA, FACAO, OUTRA_BRANCA, OUTRA_FOGO |
| TipoMunicao             | CALIBRE_22, CALIBRE_38, CALIBRE_380, CALIBRE_9MM, CALIBRE_12, CALIBRE_556, CALIBRE_762, OUTRO |
| TipoDroga               | MACONHA, COCAINA, CRACK, HEROINA, LSD, ECSTASY, METANFETAMINA, OUTRA   |
| MetodoAutenticacao      | SENHA, BIOMETRIA, CERTIFICADO, SSO                                     |

---

> **Fim do Documento.**  
> Este planejamento serve como referência arquitetural completa para implementação do schema Prisma e migrations.  
> **Próxima etapa:** Implementação do `schema.prisma` com base neste documento.