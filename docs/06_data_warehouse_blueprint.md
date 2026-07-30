# Data Warehouse Blueprint

**Projeto:** Wealth Management Analytics Dashboard

**Empresa:** On Time Analytics Services

**Versão:** 1.0

**Data:** Julho de 2026

---

# 1. Objetivo

Este documento descreve a arquitetura lógica do Data Warehouse desenvolvido para o projeto **Wealth Management Analytics Dashboard**.

O objetivo deste Data Warehouse é consolidar dados provenientes das operações de uma instituição financeira fictícia especializada em Gestão de Patrimônio (Wealth Management), permitindo análises estratégicas através de dashboards, consultas SQL e futuras aplicações analíticas.

Este documento servirá como referência para:

- Implementação do banco PostgreSQL
- Desenvolvimento do ETL
- Geração de dados sintéticos
- Construção do modelo no Power BI
- Evoluções futuras do projeto

---

# 2. Escopo

O projeto contempla a construção de um Data Warehouse modelado em esquema estrela (Star Schema), composto por tabelas dimensão e tabelas fato.

Nesta primeira versão serão contempladas análises relacionadas a:

- Clientes
- Assessores
- Produtos Financeiros
- Agências
- Perfil de Investidor
- Canais de Atendimento
- Patrimônio
- Movimentações Financeiras
- Receita
- Evolução Patrimonial

---

# 3. Modelo Dimensional

O modelo seguirá a arquitetura Star Schema.

## Tabelas Dimensão

- dim_calendar
- dim_customer
- dim_advisor
- dim_branch
- dim_region
- dim_product
- dim_channel
- dim_risk_profile

## Tabelas Fato

- fact_transactions
- fact_portfolio_positions
- fact_daily_balances
- fact_revenue
- fact_customer_growth

---

# 4. Dimensões

## 4.1 dim_calendar

Armazena todas as informações relacionadas ao calendário.

Principais informações:

- Datas
- Ano
- Trimestre
- Mês
- Semana
- Dia
- Nome do mês
- Dia da semana

---

## 4.2 dim_customer

Armazena os dados cadastrais dos clientes.

Principais informações:

- Identificação do cliente
- Dados demográficos
- Cidade
- Estado
- Segmento
- Patrimônio
- Data de ingresso
- Assessor responsável
- Agência
- Perfil de risco

---

## 4.3 dim_advisor

Contém informações sobre os assessores de investimentos.

Principais informações:

- Nome
- Agência
- Região
- Data de admissão
- Segmento atendido

---

## 4.4 dim_branch

Representa as agências da instituição financeira.

Principais informações:

- Nome da agência
- Código
- Cidade
- Estado
- Região

---

## 4.5 dim_region

Tabela responsável pela regionalização.

Principais informações:

- Região
- Estado
- Sigla

---

## 4.6 dim_product

Catálogo dos produtos financeiros.

Exemplos:

- Tesouro Direto
- CDB
- LCI
- LCA
- Debêntures
- Fundos de Investimento
- ETFs
- Ações
- BDRs
- Fundos Imobiliários
- Previdência Privada
- COE

---

## 4.7 dim_channel

Representa o canal utilizado pelo cliente.

Exemplos:

- Agência
- Aplicativo
- Internet Banking
- Mesa de Investimentos
- Assessor
- Plataforma Digital

---

## 4.8 dim_risk_profile

Representa o perfil de suitability do investidor.

Perfis contemplados:

- Conservador
- Moderado
- Arrojado
- Agressivo

---

# 5. Tabelas Fato

## fact_transactions

Armazena todas as movimentações financeiras realizadas pelos clientes.

Exemplos:

- Aplicações
- Resgates
- Compra de ativos
- Venda de ativos
- Transferências

Indicadores derivados:

- Volume Financeiro
- Quantidade de Operações
- Ticket Médio
- Receita por Operação

---

## fact_portfolio_positions

Representa a posição consolidada da carteira dos clientes.

Indicadores derivados:

- Patrimônio
- Alocação
- Distribuição por Produto
- Distribuição por Classe de Ativo

---

## fact_daily_balances

Responsável pelo histórico diário do patrimônio.

Indicadores derivados:

- Evolução Patrimonial
- Rentabilidade
- Crescimento do Patrimônio

---

## fact_revenue

Responsável pela receita gerada pela instituição.

Indicadores derivados:

- Receita por Cliente
- Receita por Assessor
- Receita por Agência
- Receita por Produto

---

## fact_customer_growth

Responsável pelo acompanhamento da evolução da base de clientes.

Indicadores derivados:

- Clientes Ativos
- Novos Clientes
- Cancelamentos
- Crescimento da Base

---

# 6. Regras de Negócio

O modelo seguirá as seguintes premissas:

- Cada cliente possui apenas um assessor principal.
- Cada cliente pertence a apenas uma agência.
- Cada cliente possui apenas um perfil de risco vigente.
- Um assessor pode atender diversos clientes.
- Um produto pode estar presente em diversas carteiras.
- Todas as movimentações possuirão uma data válida.
- Toda movimentação deverá estar vinculada a um cliente e a um produto.
- O patrimônio diário será armazenado historicamente.

---

# 7. Convenções de Modelagem

Para manter a padronização do projeto serão adotadas as seguintes convenções:

## Prefixos

Dimensões

dim_

Tabelas fato

fact_

Views

vw_

Procedures

sp_

Functions

fn_

---

## Chaves

Primary Key

*_key

Business Key

*_id

---

## Datas

Todas as datas utilizarão o padrão ISO (YYYY-MM-DD).

---

## Valores Financeiros

Todos os valores monetários serão armazenados utilizando o tipo NUMERIC.

---

## Nomenclatura

Todas as tabelas, colunas e objetos do banco utilizarão:

- letras minúsculas
- underscore (_)
- nomes em inglês

---

# 8. Relacionamentos

O Data Warehouse seguirá o modelo Star Schema.

Todas as tabelas fato estarão relacionadas às dimensões através de chaves substitutas (Surrogate Keys).

As dimensões serão compartilhadas entre as tabelas fato, permitindo reutilização e consistência das análises.

---

# 9. Fluxo dos Dados

O fluxo de dados seguirá as seguintes etapas:

1. Geração de Dados Sintéticos
2. Armazenamento dos arquivos CSV
3. Processo ETL em Python
4. Carga no PostgreSQL
5. Criação das Views Analíticas
6. Conexão do Power BI
7. Construção dos Dashboards

---

# 10. Volume Inicial de Dados

Para esta versão do projeto serão gerados aproximadamente:

| Entidade | Volume Estimado |
|----------|----------------:|
| Clientes | 50.000 |
| Assessores | 300 |
| Agências | 120 |
| Produtos Financeiros | 12 |
| Transações | 2.000.000 |
| Carteiras | 250.000 |
| Histórico Diário | 18.000.000 |

Os volumes foram definidos para simular um ambiente corporativo de Wealth Management e permitir análises com desempenho e complexidade semelhantes aos encontrados em aplicações reais.

---

# 11. Tecnologias Utilizadas

Banco de Dados

- PostgreSQL

Linguagem

- Python

Análise

- SQL

Visualização

- Power BI

Versionamento

- Git
- GitHub

---

# 12. Próximas Etapas

Após a aprovação deste Blueprint serão desenvolvidos os seguintes componentes:

1. Criação do Schema PostgreSQL
2. Implementação das Tabelas Dimensão
3. Implementação das Tabelas Fato
4. Desenvolvimento do Gerador de Dados Sintéticos
5. Desenvolvimento do Processo ETL
6. Construção das Views Analíticas
7. Desenvolvimento dos Dashboards em Power BI