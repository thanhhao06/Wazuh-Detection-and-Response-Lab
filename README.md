# 🛡️ SOC & Detection Engineering Lab (Azaki)

## 📖 Giới thiệu (Overview)
Đây là kho tài liệu tổng hợp toàn bộ các nghiên cứu, kịch bản giả lập tấn công (Adversary Emulation) và báo cáo điều tra sự cố (Incident Response) trong hệ thống SOC Lab cá nhân. 

Lab được xây dựng với mục tiêu:
1. Nghiên cứu thực tế các kỹ thuật tấn công theo framework **MITRE ATT&CK**.
2. Thiết kế và tùy biến các quy tắc cảnh báo (Detection Engineering) trên nền tảng **Wazuh SIEM**.
3. Thực hành quy trình ứng phó sự cố chuẩn doanh nghiệp theo mô hình **PICERL** (Preparation, Identification, Containment, Eradication, Recovery, Lessons Learned).

## 🏗️ Kiến trúc Môi trường (Lab Architecture)
*   **SIEM / Trung tâm điều hành:** Wazuh Manager, Wazuh Indexer & Dashboard (Ubuntu Server).
*   **Endpoint mục tiêu (Victim):** Windows 10/11 Workstation (`AZAKI-PC`).
*   **Cảm biến thu thập (Sensors):** Wazuh Agent, Sysmon (System Monitor), và Windows Security Advanced Audit Policies.

## 📂 Cấu trúc Thư mục
Dự án được chia thành 3 cấu phần chính, liên kết chặt chẽ với nhau theo vòng đời của một sự kiện an ninh mạng:
*   `/Script/` **(Adversary Emulation):** Chứa các mã nguồn (PowerShell/Python) được tôi tự tay thiết kế để mô phỏng chính xác hành vi của mã độc hoặc kẻ tấn công. Đảm bảo sinh ra các log chân thực nhất mà không cần sử dụng mã độc thật (Tránh rủi ro hỏng hóc hệ thống).
*   `/DEC/` **(Detection Engineering):** Chứa các tài liệu phân tích kỹ thuật, giải thích logic xây dựng Rule XML trên Wazuh để bóc tách các trường dữ liệu (Event Parsing) và tóm gọn hành vi từ thư mục Script.
*   `/INC/` **(Incident Response):** Chứa các báo cáo điều tra sự cố chuyên sâu. Mỗi file là một quá trình truy vết (Forensic), phân tích dòng thời gian sự cố (Timeline) và đưa ra các quyết định ngăn chặn/khắc phục.

## 📋 Danh sách Kịch bản Điều tra (Use Cases)

| ID | Tên Kịch bản (Scenario) | Kỹ thuật MITRE ATT&CK | Nguồn Log Trọng tâm | Trạng thái |
| :--- | :--- | :--- | :--- | :--- |
| **Case 001** | Tấn công dò mật khẩu qua mạng (SMB Brute-force) | T1110.001 | Windows Event 4625 | 🟢 Hoàn thành |
| **Case 002** | Thực thi mã độc PowerShell & Mã hóa Base64 (Evasion) | T1059.001 | Sysmon Event 1 | 🟢 Hoàn thành |
| **Case 003** | Leo thang đặc quyền thông qua quản lý Local Account | T1078.003 | Windows Event 4720, 4732 | 🟢 Hoàn thành |
| **Case 004** | Giám sát tính toàn vẹn (FIM) & Vượt mặt cảnh báo | T1562.001 | Wazuh FIM / Sysmon | 🟢 Hoàn thành |
| **Case 005** | Kết nối mạng bất thường từ tiến trình LOLBin | T1071.001 | Sysmon Event 3 | 🟢 Hoàn thành |
| **Case 006** | Thiết lập Persistence qua Scheduled Task | T1053.005 | Windows Event 4698 | 🟢 Hoàn thành |

## 💡 Điểm nổi bật của Lab
*   **Phòng thủ chiều sâu (Defense-in-Depth):** Tận dụng sự kết hợp chéo giữa nhiều nguồn Log (Sysmon + Windows Security) để vượt qua các bộ lọc giảm nhiễu (Blindspots/Exclusions) của Endpoint. Điển hình như việc dùng Event 4698 để "tóm" `schtasks.exe` khi Sysmon Event 1 bị che khuất (Case 006).
*   **Phản ứng Tự động (Active Response):** Tích hợp tính năng tự động của SIEM để tạo các luồng cách ly lập tức (Drop IP/Block Port) ở tầng Windows Defender Firewall khi phát hiện Brute-force.
*   **Phân tích Forensic:** Kỹ thuật truy vết chuyên sâu dựa trên Correlation (Process GUID, Parent-Child Process, Logon Session) để dựng lại bối cảnh (Context) trước và sau khi mã độc thực thi.

---
*Tác giả: **Azaki** 
