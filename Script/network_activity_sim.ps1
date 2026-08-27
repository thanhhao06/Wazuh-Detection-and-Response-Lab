```powershell
<#
.SYNOPSIS
    Tự động sinh Sysmon Event ID 1 (Process Create) và Sysmon Event ID 3 (Network Connection).
.DESCRIPTION
    Script gọi công cụ curl.exe để mô phỏng một kết nối mạng ra bên ngoài,
    giúp kiểm thử khả năng tương quan dữ liệu mạng-tiến trình của Wazuh SIEM.
#>

function Get-UTC7Time {
    return (Get-Date).ToUniversalTime().AddHours(7).ToString('yyyy-MM-dd HH:mm:ss "UTC+7"')
}

$TargetDomain = "https://example.com"
$TargetPort = 443

Write-Host "[$(Get-UTC7Time)] [*] Bắt đầu giả lập chuỗi Tương quan Tiến trình - Mạng (Process-to-Network)..." -ForegroundColor Cyan

# Hành vi: Gọi curl.exe qua cmd.exe để tạo Process Tree và Network Connection
Write-Host "[$(Get-UTC7Time)] [-] Thực thi lệnh curl.exe kết nối tới $TargetDomain qua cổng $TargetPort..." -ForegroundColor Yellow

$CommandArgs = "/c curl.exe $TargetDomain"
Start-Process -FilePath "cmd.exe" -ArgumentList $CommandArgs -WindowStyle Hidden -Wait

Write-Host "[$(Get-UTC7Time)] [+] Hoàn tất chuỗi kết nối." -ForegroundColor Green
Write-Host "[$(Get-UTC7Time)] [*] Vui lòng kiểm tra Wazuh Dashboard với filter: data.win.system.eventID:3 AND data.win.eventdata.image:*curl.exe" -ForegroundColor Cyan
```

