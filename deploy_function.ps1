# Deploy script para Supabase Edge Function
# Uso: .\deploy_function.ps1

param(
    [string]$ProjectId = "chyhjtbgzwwdckhptnja",
    [string]$Token = "sbp_2002da0e408e891f641b6ffbbb5316148b42a905",
    [string]$FunctionName = "new_order_notification"
)

Write-Host "🚀 Supabase Edge Function Deploy Script"
Write-Host "==========================================="
Write-Host "Project ID: $ProjectId"
Write-Host "Function: $FunctionName"
Write-Host ""

# Ler o código da função
$functionPath = "./supabase/functions/$FunctionName/index.ts"
if (-not (Test-Path $functionPath)) {
    Write-Host "Arquivo nao encontrado: $functionPath"
    exit 1
}

$functionCode = Get-Content -Path $functionPath -Raw
Write-Host "OK Código lido: $($functionCode.Length) bytes"
Write-Host ""

# Fazer upload via Supabase Management API
$url = "https://api.supabase.com/v1/projects/$ProjectId/functions/$FunctionName/deploy"

$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}

$body = @{
    slug = $FunctionName
} | ConvertTo-Json -Depth 10

Write-Host "Enviando requisicao de deploy..."
Write-Host "POST $url"
Write-Host ""

try {
    $response = Invoke-WebRequest -Uri $url `
        -Method POST `
        -Headers $headers `
        -Body $body `
        -UseBasicParsing `
        -TimeoutSec 30

Write-Host "OK Deploy bem-sucedido!"
    Write-Host "Status: $($response.StatusCode)"
    Write-Host ""
    Write-Host "Response:"
    Write-Host $response.Content
} catch {
    $statusCode = $_.Exception.Response.StatusCode.Value__
    $message = $_.Exception.Message
    
    Write-Host "Erro no deploy!"
    Write-Host "Status Code: $statusCode"
    Write-Host "Message: $message"
    Write-Host ""
    
    if ($_.Exception.Response) {
        try {
            $stream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($stream)
            $responseBody = $reader.ReadToEnd()
            Write-Host "Response Body:"
            Write-Host $responseBody
            $reader.Close()
        } catch {
            Write-Host "Não foi possível ler o corpo da resposta"
        }
    }
    exit 1
}

Write-Host ""
Write-Host "OK: Script finalizado com sucesso!"
