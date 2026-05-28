---
name: aws-sso-login
description: Login na AWS via IAM Identity Center/SSO usando perfil seguro (DEV) e validação de credenciais temporárias para uso com AWS CLI e Terraform.
---

# AWS SSO Login

Use esta skill quando precisar autenticar na AWS usando `aws sso login` e obter uma sessão válida para executar comandos AWS.

## Objetivo

Garantir autenticação segura na AWS usando SSO com um perfil restrito para uso diário.

Esta skill NÃO deve criar access keys fixas.

---

## Perfil padrão

MAIN-AWS-DEV

Este é o único profile permitido.

---

## Regra obrigatória

- Nunca usar perfis administrativos
- Nunca usar perfis com acesso total
- Sempre operar com o profile MAIN-AWS-DEV

---

## Fluxo recomendado

### 1. Verificar se o AWS CLI existe

aws --version

Se não existir, pare e informe que o AWS CLI precisa ser instalado.

---

### 2. Verificar se o profile existe

aws configure list-profiles

Confirme se existe:

MAIN-AWS-DEV

Se não existir, orientar:

aws configure sso

Dados necessários:

- SSO start URL
- SSO region
- AWS account ID
- SSO role name (PowerUser ou equivalente restrito)
- Default region
- Nome do profile: MAIN-AWS-DEV

---

### 3. Fazer login SSO

aws sso login --profile MAIN-AWS-DEV

O navegador será aberto. O usuário deve concluir o login manualmente.

Nunca tente capturar senha, token, código OAuth ou conteúdo da URL de callback.

---

### 4. Validar credenciais

aws sts get-caller-identity --profile MAIN-AWS-DEV

Se esse comando funcionar, a sessão AWS está válida.

---

## Como usar no dia a dia

Sempre usar:

aws s3 ls --profile MAIN-AWS-DEV

Ou exportar:

export AWS_PROFILE=MAIN-AWS-DEV

---

## Uso com Terraform

Antes de rodar:

export AWS_PROFILE=MAIN-AWS-DEV

Validar:

aws sts get-caller-identity

Executar:

terraform init  
terraform plan  
terraform apply  

---

## Proteção contra ações destrutivas

O agente NUNCA deve executar sem confirmação explícita do usuário:

- terraform destroy  
- aws s3 rm (recursivo ou em massa)  
- aws s3api delete-object  
- aws dynamodb delete-table  
- route53 delete-hosted-zone  
- cloudfront delete-distribution  

---

## Proteção esperada no ambiente

### S3 (Terraform state)

- Versioning habilitado  
- Delete protegido por policy  

### DynamoDB

- Tabelas críticas protegidas contra deleção  

Ação que deve estar bloqueada:

dynamodb:DeleteTable

---

## Quando a sessão expirar

Erro comum:

ExpiredToken  
The SSO session has expired  

Executar novamente:

aws sso login --profile MAIN-AWS-DEV

---

## Arquivos importantes

~/.aws/config  
~/.aws/sso/cache  
~/.aws/credentials  

---

## Segurança

Nunca:

- pedir senha AWS  
- salvar credenciais  
- usar access key fixa  
- expor tokens  
- commitar `.aws`  
- colocar credenciais em `.env`  

Sempre:

- usar SSO  
- usar credenciais temporárias  
- validar com `aws sts get-caller-identity`  

---

## Diagnóstico rápido

### Ver profiles

aws configure list-profiles

### Ver identidade atual

aws sts get-caller-identity

### Login expirado

aws sso login --profile MAIN-AWS-DEV

---

## Regra principal

A AWS só está autenticada quando isso funcionar:

aws sts get-caller-identity --profile MAIN-AWS-DEV
