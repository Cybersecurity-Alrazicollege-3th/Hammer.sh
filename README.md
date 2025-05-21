# Hammer.sh

# 🔨 Hammer DoS Script (Bash Version)

## ⚠️ Legal Disclaimer

> **This script is intended for educational and authorized security testing purposes only.**
> 
> Unauthorized use of this tool against systems you do not own or have explicit permission to test is illegal and unethical.
>
> The developer is not responsible for any misuse or damage caused by this script.

---

## 📝 About the Project

**Hammer DoS** is a simple Bash-based Denial-of-Service (DoS) testing script designed to simulate HTTP flooding against a target server. It sends repeated HTTP GET requests using both `nc` and `curl`, with randomized user-agents and multi-threaded background execution.

The tool includes support for **bot hammering** (sending requests through known bots) and allows full control over the number of concurrent threads and target port.

---

## 🚀 Features

- Multi-threaded request flooding using `nc` and `curl`.
- Randomized User-Agent strings to mimic different browsers.
- Bot hammering using online services (e.g., Facebook sharer, W3C validator).
- Configurable number of threads and target port.
- Simple and colorized terminal output.

---

## ⚙️ Usage

```bash
./hammer.sh -s <SERVER_IP> [-p <PORT>] [-t <THREADS>]
