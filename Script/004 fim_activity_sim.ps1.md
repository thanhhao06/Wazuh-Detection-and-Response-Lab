```powershell
<#
.SYNOPSIS
    Tự động sinh các sự kiện File Integrity Monitoring (FIM) để kiểm thử Wazuh Syscheck.
.DESCRIPTION
    Script thực hiện:
    1. Tạo thư mục C:\SOC-Lab\Important (Nếu chưa có).
    2. Tạo file test.txt (Kích hoạt Rule 554).
    3. Thêm nội dung vào file (Kích hoạt Rule 550 & sinh syscheck.diff).
    4. Xóa file (Kích hoạt Rule 553).
#>

function Get-UTC7Time {
    return (Get-Date).ToUniversalTime().AddHours(7).ToString('yyyy-MM-dd HH:mm:ss "UTC+7"')
}

$MonitorDir = "C:\SOC-Lab\Important"
$TargetFile = "$MonitorDir\test.txt"

Write-Host "[$(Get-UTC7Time)] [*] Bắt đầu chiến dịch giả lập File Integrity Monitoring (FIM)..." -ForegroundColor Cyan

# Đảm bảo thư mục tồn tại
if (-not (Test-Path $MonitorDir)) {
    New-Item -ItemType Directory -Path $MonitorDir -Force | Out-Null
}

# Hành vi 1: Tạo file mới (Rule 554)
Write-Host "[$(Get-UTC7Time)] [-] [CREATE] Đang tạo file $TargetFile..." -ForegroundColor Yellow
Set-Content -Path $TargetFile -Value "SOC Lab Initial Content"
Start-Sleep -Seconds 5 # Đợi Wazuh Agent quét và gửi log

# Hành vi 2: Sửa file (Rule 550)
Write-Host "[$(Get-UTC7Time)] [-] [MODIFY] Đang sửa đổi nội dung file..." -ForegroundColor Yellow
Add-Content -Path $TargetFile -Value "Modified during Wazuh FIM test"
Start-Sleep -Seconds 5 # Đợi Wazuh tính toán Hash và Diff

# Hành vi 3: Xóa file (Rule 553)
Write-Host "[$(Get-UTC7Time)] [-] [DELETE] Đang xóa file..." -ForegroundColor Yellow
Remove-Item $TargetFile -Force

Write-Host "[$(Get-UTC7Time)] [*] Hoàn tất! Vui lòng kiểm tra Wazuh Dashboard (Rule 554, 550, 553)." -ForegroundColor Cyan
```

