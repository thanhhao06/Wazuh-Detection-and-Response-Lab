```powershell
<#
.SYNOPSIS
    Tự động sinh Sysmon Event ID 1 (Process Create) liên quan đến powershell.exe 
    để kiểm thử các rule 100100 và 100101 trên Wazuh SIEM.
.DESCRIPTION
    Script này mô phỏng 2 hành vi:
    1. Chạy PowerShell dạng rõ từ CMD (System Discovery).
    2. Chạy PowerShell dạng mã hóa Base64 từ CMD (Evasion Technique).
#>

function Get-UTC7Time {
    return (Get-Date).ToUniversalTime().AddHours(7).ToString('yyyy-MM-dd HH:mm:ss "UTC+7"')
}

Write-Host "[$(Get-UTC7Time)] [*] Bắt đầu chiến dịch giả lập PowerShell Execution..." -ForegroundColor Cyan

# -------------------------------------------------------------------------
# HÀNH VI 1: PowerShell thông thường (Kích hoạt Rule 100100 - Level 5)
# -------------------------------------------------------------------------
Write-Host "[$(Get-UTC7Time)] [-] Thực thi lệnh cơ bản (Get-Process)..." -ForegroundColor Yellow

# Gọi qua cmd.exe để khớp ParentImage trong báo cáo INC-002
$BasicArgs = '/c powershell.exe -NoProfile -Command "Get-Process | Select-Object -First 5"'
Start-Process -FilePath "cmd.exe" -ArgumentList $BasicArgs -WindowStyle Hidden -Wait


# -------------------------------------------------------------------------
# HÀNH VI 2: PowerShell mã hóa (Kích hoạt Rule 100101 - Level 10)
# -------------------------------------------------------------------------
Write-Host "[$(Get-UTC7Time)] [-] Thực thi lệnh mã hóa (EncodedCommand)..." -ForegroundColor Yellow

$Payload = 'Write-Output "SOC-LAB-ENCODED-TEST"'
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($Payload)
$EncodedPayload = [Convert]::ToBase64String($Bytes)

# Gọi qua cmd.exe với cờ -EncodedCommand
$EncodedArgs = "/c powershell.exe -NoProfile -EncodedCommand $EncodedPayload"
Start-Process -FilePath "cmd.exe" -ArgumentList $EncodedArgs -WindowStyle Hidden -Wait


Write-Host "[$(Get-UTC7Time)] [+] Hoàn tất! Vui lòng kiểm tra Wazuh Dashboard để đối chiếu Sysmon Event ID 1." -ForegroundColor Green
```
