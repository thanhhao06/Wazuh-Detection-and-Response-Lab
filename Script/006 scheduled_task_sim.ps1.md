```powershell
<#
.SYNOPSIS
    Sinh log gia lap khoi tao Scheduled Task trai phep de kiem thu Wazuh Rule (T1053.005).
#>

function Get-UTC7Time {
    return (Get-Date).ToUniversalTime().AddHours(7).ToString('yyyy-MM-dd HH:mm:ss "UTC+7"')
}

Write-Host "[$(Get-UTC7Time)] [*] Khoi tao qua trinh kiem thu Detection Rule (Scheduled Task Persistence)..." -ForegroundColor Cyan

$PayloadPath = "C:\Users\Hao\Downloads\reverse_shell.exe"
$TaskName = "WindowsUpdate_Backup"

# Xoa file cu de ep Sysmon ghi nhan log 'File Created' (Event 11)
if (Test-Path $PayloadPath) { 
    Remove-Item -Path $PayloadPath -Force 
}

Write-Host "[$(Get-UTC7Time)] [-] Dang tao tep tin gia mao (dummy file) tai $PayloadPath..." -ForegroundColor Yellow

# Su dung New-Item de dam bao kich hoat Rule 92203 tren Wazuh
$DummyText = "This is a benign dummy payload used for SOC simulation. Not a real malware."
New-Item -Path $PayloadPath -ItemType File -Value $DummyText -Force | Out-Null

Write-Host "[$(Get-UTC7Time)] [-] Thuc thi schtasks.exe de tao Scheduled Task '$TaskName'..." -ForegroundColor Yellow

$ExecuteArgs = "/create /tn `"$TaskName`" /tr `"$PayloadPath`" /sc minute /mo 5 /F"
Start-Process -FilePath "schtasks.exe" -ArgumentList $ExecuteArgs -Wait -NoNewWindow

Write-Host "[$(Get-UTC7Time)] [+] Hoan tat! Vui long kiem tra Wazuh Dashboard cho Event 4698 (Scheduled Task Created)." -ForegroundColor Green
```
