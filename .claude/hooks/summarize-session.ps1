# Stop hook — logs session end event to .claude/logs/sessions.jsonl
# Event: Stop
#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# .claude/logs/ derived from this script's location (.claude/hooks/)
$logDir = Join-Path (Split-Path $PSScriptRoot -Parent) 'logs'

if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

$entry = @{
    timestamp  = (Get-Date -Format 'o')
    event      = "session_stop"
    session_id = $env:CLAUDE_SESSION_ID
} | ConvertTo-Json -Compress

Add-Content -Path "$logDir\sessions.jsonl" -Value $entry -Encoding UTF8
exit 0
