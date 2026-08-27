```powershell
<#
.SYNOPSIS
    Tự động sinh Event ID 4720 và 4732 để kiểm thử khả năng giám sát tài khoản trên Wazuh SIEM.
.DESCRIPTION
    Script thực hiện 2 hành vi:
    1. Tạo một tài khoản cục bộ mới (Event 4720).
    2. Thêm tài khoản đó vào nhóm Administrators (Event 4732).
#>

function Get-UTC7Time {
    return (Get-Date).ToUniversalTime().AddHours(7).ToString('yyyy-MM-dd HH:mm:ss "UTC+7"')
}

$TargetUser = "soclab-test"
$TargetPassword = ConvertTo-SecureString "P@ssw0rd2026_Azaki!" -AsPlainText -Force
$TargetGroup = "Administrators"

Write-Host "[$(Get-UTC7Time)] [*] Bắt đầu chiến dịch giả lập T1136.001 & T1098.007..." -ForegroundColor Cyan

# Hành vi 1: Tạo tài khoản (Kích hoạt Rule 60109 - Event 4720)
Write-Host "[$(Get-UTC7Time)] [-] Đang tạo tài khoản cục bộ [$TargetUser]..." -ForegroundColor Yellow
try {
    New-LocalUser -Name $TargetUser -Password $TargetPassword -Description "Temporary Wazuh SOC Lab backdoor" -ErrorAction Stop
    Write-Host "[$(Get-UTC7Time)] [+] Đã tạo thành công tài khoản." -ForegroundColor Green
} catch {
    Write-Host "[$(Get-UTC7Time)] [!] Lỗi: Tài khoản có thể đã tồn tại. Đang tiếp tục..." -ForegroundColor Red
}

Start-Sleep -Seconds 3 # Tạo độ trễ nhỏ để log phân tách rõ ràng trên SIEM

# Hành vi 2: Thay đổi đặc quyền (Kích hoạt Rule 60144 - Event 4732)
Write-Host "[$(Get-UTC7Time)] [-] Đang chèn [$TargetUser] vào nhóm [$TargetGroup]..." -ForegroundColor Yellow
try {
    Add-LocalGroupMember -Group $TargetGroup -Member $TargetUser -ErrorAction Stop
    Write-Host "[$(Get-UTC7Time)] [+] Đã nâng quyền thành công." -ForegroundColor Green
} catch {
    Write-Host "[$(Get-UTC7Time)] [!] Lỗi: Không thể thêm vào nhóm. Có thể user đã ở trong nhóm." -ForegroundColor Red
}

Write-Host "[$(Get-UTC7Time)] [*] Hoàn tất! Vui lòng kiểm tra Wazuh Dashboard (Rule 60109 & 60144)." -ForegroundColor Cyan
```
