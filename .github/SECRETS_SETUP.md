# 🔑 GitHub Secrets Setup para CI/CD

Este documento explica como configurar os **secrets do GitHub** necessários para o workflow `supabase-seed-deploy.yml`.

## 📋 Secrets Necessários

Configure os seguintes secrets no repositório GitHub:

### Settings > Secrets and variables > Actions > New repository secret

| Secret Name | Valor | Fonte |
|---|---|---|
| `SUPABASE_ACCESS_TOKEN` | Token pessoal do Supabase | https://app.supabase.com/account/tokens |
| `SUPABASE_PROJECT_REF` | `chyhjtbgzwwdckhptnja` | URL Supabase ou Dashboard |
| `SUPABASE_DB_PASSWORD` | Senha do banco de dados | `.env.local` (BHrdf3Ei4ZH4tMZ0) |
| `SUPABASE_URL` | `https://chyhjtbgzwwdckhptnja.supabase.co` | Dashboard Supabase |
| `SUPABASE_SERVICE_ROLE_KEY` | Service Role Key (nunca compartilhe!) | Dashboard > Project Settings > API Keys |
| `FCM_SERVER_KEY` | Firebase Cloud Messaging Key | Firebase Console > Project Settings |

## ✅ Como Criar um Token de Acesso Supabase

1. Acesse: https://app.supabase.com/account/tokens
2. Clique em **New token**
3. Dê um nome descritivo (ex: `github-ci-cd`)
4. Copie o token e cole em GitHub Secrets como `SUPABASE_ACCESS_TOKEN`

## 🚀 Como Usar o Workflow

O workflow será acionado automaticamente quando você:
- Fazer push para a branch `main`
- Alterar arquivos em `supabase/seed/` ou `supabase/functions/`

Ou execute **manualmente**:
1. Vá para **Actions** no GitHub
2. Selecione **Supabase Seed & Deploy Functions**
3. Clique em **Run workflow**

## 🔒 Segurança

- ❌ **Nunca** compartilhe `SUPABASE_SERVICE_ROLE_KEY` ou `SUPABASE_DB_PASSWORD`
- ✅ Sempre use GitHub Secrets (não no código)
- ✅ Revogue tokens antigos regularmente
- ✅ Use tokens com escopo mínimo necessário

## 📝 Dados do Seu Projeto (para referência)

```
Project Ref: chyhjtbgzwwdckhptnja
Supabase URL: https://chyhjtbgzwwdckhptnja.supabase.co
Region: South America (São Paulo)
Database Password: [armazenado em .env.local]
```

## ❓ Troubleshooting

**Erro: "Access token invalid"**
- Verifique se o token está correto em GitHub Secrets
- Regenere o token em https://app.supabase.com/account/tokens

**Erro: "Project not found"**
- Verifique se `SUPABASE_PROJECT_REF` = `chyhjtbgzwwdckhptnja`
- Confirme que a conta tem acesso ao projeto

**Erro: "Column does not exist"**
- O seed SQL tem erro de schema
- Corrija no arquivo `supabase/seed/mock_data.sql` e faça push novamente

---

**Próximo passo:** Configure todos os secrets, depois faça um push para testar! ✨
