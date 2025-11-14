name: Setup GitHub Actions Secrets

## Para usar este workflow, configure os seguintes secrets no GitHub:
## (Settings → Secrets and variables → Actions → New repository secret)

# Secrets necessários:
# - SUPABASE_PROJECT_REF: chyhjtbgzwwdckhptnja
# - SUPABASE_ACCESS_TOKEN: seu-personal-access-token (criado em Supabase Dashboard)
# - SUPABASE_DB_PASSWORD: sua-senha-do-banco
# - SUPABASE_URL: https://chyhjtbgzwwdckhptnja.supabase.co
# - SUPABASE_SERVICE_ROLE_KEY: sua-service-role-key
# - FCM_SERVER_KEY: sua-chave-do-firebase

## Como obter cada secret:

### 1. SUPABASE_PROJECT_REF
# Supabase Dashboard → Project Settings → General
# Procure por "Reference ID" ou use: chyhjtbgzwwdckhptnja

### 2. SUPABASE_ACCESS_TOKEN
# Supabase Dashboard → Account Settings → Access Tokens → Generate
# Ou: https://app.supabase.com/account/tokens

### 3. SUPABASE_DB_PASSWORD
# Supabase Dashboard → Project Settings → Database
# Procure por "Connection string" ou clique em "Reset password"

### 4. SUPABASE_URL
# Supabase Dashboard → Project Settings → API
# Copy: Project URL (ex: https://chyhjtbgzwwdckhptnja.supabase.co)

### 5. SUPABASE_SERVICE_ROLE_KEY
# Supabase Dashboard → Project Settings → API
# Copy: service_role (chave com acesso total)

### 6. FCM_SERVER_KEY
# Firebase Console → Project Settings → Service Accounts
# Copy: Server Key (para Firebase Cloud Messaging)

## Após configurar os secrets, o workflow rodará automaticamente ao fazer push em main
## ou você pode dispará-lo manualmente em: GitHub → Actions → Supabase Seed & Deploy Functions → Run workflow
