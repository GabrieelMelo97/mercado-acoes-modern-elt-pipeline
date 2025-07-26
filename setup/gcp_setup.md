# Configuração do Google Cloud Platform

## Conta GCP

- Crie uma [Conta GCP](https://console.cloud.google.com/freetrial/) se você não tiver uma.
- Crie um [projeto GCP](https://console.cloud.google.com/projectcreate?inv=1&invt=Ab0mdg) e anote o ID do seu projeto.

## GCP SDK

- Instale o [gcloud CLI](https://cloud.google.com/sdk/docs/install) localmente.

- Inicialize o gcloud CLI:

```
gcloud init
```

- Siga as instruções para autenticar com sua conta Google e configurar seu projeto.

## Configurar Credenciais

- Criar uma Conta de Serviço:
  - Vá para Console GCP > IAM e Admin > Contas de Serviço
  - Selecione `+ CRIAR CONTA DE SERVIÇO`
  - Digite um nome e descrição
  - Atribua a função `Visualizador`
  - Adicione as seguintes funções adicionais: `Administrador do Storage`, `Administrador de Objetos do Storage` e `Administrador do BigQuery`

- Selecione a conta de serviço > Chaves > Adicionar Chave > Criar nova chave.
- Escolha `JSON` e clique em `Criar`. O arquivo de chave será baixado para sua máquina.

> [!WARNING]
> Não compartilhe este arquivo de chave publicamente.

- Renomeie o arquivo de chave .json para `google_credentials.json`.
- Defina a variável de ambiente `GOOGLE_APPLICATION_CREDENTIALS` para apontar para suas chaves GCP baixadas:

**Windows**

```
set GOOGLE_APPLICATION_CREDENTIALS="C:\caminho\para\seu\google_credentials.json"
```

**macOS e Linux**

```
export GOOGLE_APPLICATION_CREDENTIALS="/caminho/para/seu/google_credentials.json"
```

- Verifique a autenticação e credenciais padrão:

```
gcloud auth application-default login
```

- Certifique-se de que as seguintes APIs de serviço estão habilitadas:
  - [API IAM](https://console.cloud.google.com/apis/library/iam.googleapis.com?inv=1&invt=Ab0m7A)
  - [Cloud Storage](https://console.cloud.google.com/apis/api/storage-component.googleapis.com/credentials?inv=1&invt=Ab0yZw)
  - [BigQuery](https://console.cloud.google.com/apis/api/bigquery.googleapis.com/metrics?hl=en&inv=1&invt=Ab0ybw)
  - [Cloud Composer](https://console.cloud.google.com/apis/library/composer.googleapis.com?hl=en&inv=1&invt=Ab09MQ)
  - [Dataproc](https://console.cloud.google.com/dataproc/overview?referrer=search&hl=en&inv=1&invt=Ab1kmA)
