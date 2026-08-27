#!/usr/bin/env python3
# File: simulations/smb_bruteforce_sim.py

import subprocess
import time
from datetime import datetime, timezone, timedelta

def get_utc7_time():
    utc_now = datetime.now(timezone.utc)
    utc7 = timezone(timedelta(hours=7))
    return utc_now.astimezone(utc7).strftime('%Y-%m-%d %H:%M:%S %Z')

# Configuration - Thay đổi IP target thành IP của AZAKI-PC
TARGET_IP = "192.168.1.10" 
USERNAME = "soclab-test"
PASSWORDS = ["123456", "password", "admin123", "soclab2026", "P@ssw0rd!"]

def simulate_brute_force():
    print(f"[{get_utc7_time()}] [*] Initiating SMB Brute-Force Simulation targeting {TARGET_IP}...")
    
    # Lặp 10 lần qua 5 mật khẩu để tạo ra 50 Event 4625 dạng Burst
    for i in range(10):
        for pwd in PASSWORDS:
            # Gửi yêu cầu SMB authentication sai mật khẩu
            cmd = f"smbclient -L //{TARGET_IP} -U {USERNAME}%{pwd} -c 'quit' > /dev/null 2>&1"
            subprocess.run(cmd, shell=True)
            time.sleep(0.1) # Độ trễ siêu nhỏ để tạo log burst

    print(f"[{get_utc7_time()}] [+] Simulation complete. Check Wazuh Dashboard for Event 4625 and Rule 60122 alerts.")

if __name__ == "__main__":
    simulate_brute_force()