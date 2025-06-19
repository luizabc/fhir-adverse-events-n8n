# FHIR Adverse Events Workflow (n8n + Supabase)

Este projeto implementa um fluxo automatizado no [n8n](https://n8n.io) para resgatar eventos adversos clínicos da API pública FHIR (HAPI), extrair dados relevantes e armazená-los em uma tabela no Supabase.

## Objetivo

- Coletar dados de eventos adversos com base no padrão FHIR.
- A partir dos dados coletados, coletar os dados de pacientes.
- Unificar informações do paciente envolvidos.
- Persistir os dados normalizados em um banco PostgreSQL no Supabase.

---
##  Estrutura do Projeto

```
fhir-adverse-events-n8n/
├── workflows/
│   └── adverse-events-workflow.json     # Workflow exportado do n8n
├── docs/
│   └── architecture.png                 # Arquitetura do fluxo no n8n
├── supabase/
│   └── schema.sql                       # Script SQL do schema no Supabase
```
---

##Como Funciona 
1. O fluxo é inciado manualmnte ou via webhook.
2. Uma requisição HTTP consulta a API FHIR pública para buscar eventos adversos (`AdverseEvent`).
3. O workflow extrai os dados solicitados de cada evento.
4. Uma segunda requisição HTTP busca os dados demográficos relacionados ao `subjectReference`coletaqdo no `AdverseEvent`(`Patient`, `Practitioner`, `RelatedPerson`).
5. Os dados são combinados usando um `Merge Node` com SQL e enviados ao Supabase.
6. Uma resposta final retorna o status e os dados tratados.

---
Tecnologias Utilizadas

- **n8n** – Plataforma de automação low-code/no-code
- **FHIR (HAPI)** – API pública para testes com dados clínicos estruturados
- **Supabase (PostgreSQL)** – Banco de dados relacional na nuvem
- **SQL** – Comando `Merge` no n8n para união entre dados clínicos e demográficos
- **Webhook** – Disparo do fluxo e retorno do status de execução

---

## Configurando o Ambiente

1. Clonar o Repositório

```
git clone https://github.com/luizabc/fhir-adverse-events-n8n.git
cd fhir-adverse-events-n8n

```
2. Criar a Tabela no Supabase
Acesse o painel do Supabase

Vá até “SQL Editor”

Copie e cole o conteúdo de supabase/schema.sql e execute

### Modo de Uso
n8n Local (via CLI)
1. Instale o n8n globalmente:

```
npm install -g n8n 
```
2. Inicie o n8n:
```
n8n
```
3. Acesse a interface em http://localhost:5678
Importe o workflow: workflows/adverse-events-workflow.json

4. Configure as credenciais:
  HTTP Request: base URL https://hapi.fhir.org/baseR4
  Supabase: insira os dados de acesso ao seu banco

5. Dispare o webhook manualmente (use o Postman ou curl)
  Inclua o parâmetro _count no body da requisição para limitar os resultados.

### n8n Cloud (para usuários pagos)
1. Acesse sua conta em n8n Cloud
2. Vá em "Workflows" > "Import" e carregue o JSON exportado
3. Configure as mesmas credenciais (HTTP e Supabase)
4. Use a URL pública do webhook fornecida pelo n8n Cloud para testar o fluxo

### Exemplo de Saída Final
```
{
  "eventId": "245493",
  "eventText": "O/E - itchy rash",
  "date": "2017-01-29T12:34:56+00:00",
  "seriousness": "Mild",
  "severity": "moderate",
  "subjectReference": "Practitioner/245467",
  "birthDate": "1959-03-11",
  "gender": "male"
}
}
```

---
### Melhorias Futuras
- Adicionar autenticação para acesso ao webhook
- Armazenar os dados brutos em um bucket (S3/Supabase Storage)
- Criar visualização interativa 
- Modularizar os blocos do workflow para reuso em outros projetos FHIR

