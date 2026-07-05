# PostToolUse hook — logs tool usage to .claude/logs/tokens.jsonl
# Event: PostToolUse Write|Edit
# Input: JSON from stdin { tool_name, tool_input, tool_response }
#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# .claude/logs/ derived from this script's location (.claude/hooks/)
$logDir = Join-Path (Split-Path $PSScriptRoot -Parent) 'logs'

$input_json = $input | Out-String
try { $payload = $input_json | ConvertFrom-Json } catch { exit 0 }

if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

$entry = @{
    timestamp   = (Get-Date -Format 'o')
    tool_name   = $payload.tool_name
    file_path   = $payload.tool_input.file_path
    session_id  = $env:CLAUDE_SESSION_ID
} | ConvertTo-Json -Compress

Add-Content -Path "$logDir\tokens.jsonl" -Value $entry -Encoding UTF8
exit 0
