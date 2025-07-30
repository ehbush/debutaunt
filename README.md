# DebUtAUnT 🚀

**Cross-Distribution Update & Package Manager Unified Terminal**

[![Version](https://img.shields.io/badge/version-3.1.3-blue.svg)](https://github.com/ehbush/debutaunt)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-red.svg)](https://github.com/ehbush/debutaunt)

> *"Why you ain't choose any options tho? You tryna start beef? Nvm, you ain't even worth it...Exiting."* 🤣

## What is DebUtAUnT? 

DebUtAUnT is a **personality-packed** bash script that makes system updates and upgrades across multiple Linux distributions quick, easy, and entertaining. Created by Anthony C. Bush in 2021 for personal/home use, it's evolved into a comprehensive cross-distribution package management tool with a unique character all its own.

### The Story Behind It 🏠

Originally designed for a massive home lab containing:
- ~10 Raspberry Pi devices
- ~10 Virtual Machines  
- ~4 Mini-PCs running different Debian flavors
- ~3 remote Linux servers
- And growing constantly!

The creator found themselves spending way too much time performing repetitive updates and upgrades. While other solutions existed, they wanted something **personal**, **fun**, and **tailored to their specific needs**.

## ✨ Features That Make It Special

### 🎯 **Cross-Distribution Support**
Works seamlessly across the three major Linux distribution families:

| Distribution Family | Package Manager | Detection |
|-------------------|----------------|-----------|
| **Debian-based** | `apt-get` | `/etc/debian_version` |
| **Red Hat-based** | `dnf` / `yum` | `/etc/redhat-release` |
| **Arch-based** | `pacman` | `/etc/arch-release` |

### 🎮 **Interactive Mode**
Run without options and get a beautiful interactive menu with **multi-operation support**:
```
=== DebUtAUnT Interactive Menu ===
What would you like to do today?
System: Debian-based with apt-get

1) Update package lists (apt-get update/check-update)
2) Upgrade packages (apt-get upgrade/update)  
3) Distribution upgrade (apt-get dist-upgrade/upgrade)
4) Clean up packages (apt-get autoremove)
5) Clean package cache (apt-get autoclean/clean)
6) Create system backup before upgrades
7) Run everything (recommended)
8) Custom selection
9) Show help
0) Exit

# After completing operations, you can perform more without restarting!
Would you like to perform more operations? (y/n): y
Alright, let's do more!
```

### 🛡️ **Safety & Backup Features**
- **Automatic backup creation** before major system changes
- **Comprehensive logging** with timestamped files
- **Error detection and reporting** with detailed analysis
- **Graceful error handling** with proper cleanup

### 🎨 **Your Personal Touch**
The script maintains its creator's unique personality with quirky messages like:
- *"Uh-Oh! Looks like someone doesn't have sudo permissions... Better luck next time!"*
- *"Cheerio Mate! It's now time to clean up the temp files we created...uno momento, por favor!"*
- *"Why you ain't choose any options tho? You tryna start beef? Nvm, you ain't even worth it...Exiting."*
- *"Everything looks good from my side. Best of luck in your travels!"*

## 🚀 Quick Start

### Basic Usage
```bash
# Interactive mode (recommended for first-time users)
sudo bash debutaunt.sh

# Auto mode (run everything automatically)
sudo bash debutaunt.sh --auto

# Command-line options (for automation)
sudo bash debutaunt.sh -u -g -b -v
```

### Installation
```bash
# Clone the repository
git clone https://github.com/ehbush/debutaunt.git
cd debutaunt

# Make executable
chmod +x debutaunt.sh

# Run it!
sudo bash debutaunt.sh
```

## 📋 Command Line Options

| Option | Description |
|--------|-------------|
| `-u, --skip-update` | Skip package list update |
| `-g, --skip-upgrade` | Skip package upgrade |
| `-d, --skip-dist` | Skip distribution upgrade |
| `-r, --skip-autoremove` | Skip package cleanup |
| `-c, --skip-autoclean` | Skip cache cleanup |
| `-b, --create-backup` | Create system backup before upgrades |
| `-l, --log-only` | Only show log file location |
| `-v, --verbose` | Verbose output |
| `-q, --quiet` | Quiet mode (minimal output) |
| `-a, --auto` | Run all operations automatically |
| `-h, --help` | Display help message |
| `--version` | Show version information |

## 🎯 Usage Examples

### Interactive Mode
```bash
# Start the interactive menu
sudo bash debutaunt.sh

# Multi-operation workflow example:
# 1. Choose "Update package lists"
# 2. After completion, choose "y" to continue
# 3. Choose "Upgrade packages" 
# 4. After completion, choose "y" to continue
# 5. Choose "Clean up packages"
# 6. Choose "n" to exit
# 
# All operations in one session without restarting!
```

### Automation Examples
```bash
# Run everything automatically
sudo bash debutaunt.sh --auto

# Skip update and upgrade, create backup
sudo bash debutaunt.sh -u -g -b

# Quiet mode for cron jobs
sudo bash debutaunt.sh --auto --quiet

# Verbose mode with backup
sudo bash debutaunt.sh -b -v
```

### Distribution-Specific Examples
```bash
# On Ubuntu/Debian
sudo bash debutaunt.sh --auto

# On CentOS/RHEL  
sudo bash debutaunt.sh --auto

# On Arch Linux
sudo bash debutaunt.sh --auto
```

## 🔧 Package Manager Commands

### Debian-based (apt-get)
- **Update**: `apt-get update`
- **Upgrade**: `apt-get upgrade -y`
- **Dist-upgrade**: `apt-get dist-upgrade -y`
- **Autoclean**: `apt-get autoclean`
- **Autoremove**: `apt-get autoremove -y`

### Red Hat-based (dnf/yum)
- **Update**: `dnf check-update` / `yum check-update`
- **Upgrade**: `dnf upgrade -y` / `yum update -y`
- **Dist-upgrade**: `dnf upgrade -y` / `yum update -y`
- **Autoclean**: `dnf clean all` / `yum clean all`
- **Autoremove**: `dnf autoremove -y` / `yum autoremove -y`

### Arch-based (pacman)
- **Update**: `pacman -Sy`
- **Upgrade**: `pacman -Syu --noconfirm`
- **Dist-upgrade**: `pacman -Syu --noconfirm`
- **Autoclean**: `pacman -Sc --noconfirm`
- **Autoremove**: `pacman -Rns $(pacman -Qtdq) --noconfirm`

## 📊 Output Analysis

The script provides comprehensive analysis of update results:

```
=== Analysis Results ===
Warnings found: 2
Errors found: 0
System restart may be required

=== Summary ===
Distribution: Debian-based
Package Manager: apt-get
Errors: 0
Warnings: 2
Log file: /tmp/debutaunt-20241201-143022.log
```

## 🛡️ Backup System

Creates intelligent backups based on your distribution:

### Debian-based
- Package list: `dpkg --get-selections`
- Sources backup: `/etc/apt/sources.list*`

### Red Hat-based  
- Package list: `rpm -qa`
- Repository backup: `/etc/yum.repos.d/`

### Arch-based
- Package list: `pacman -Qe` (explicitly installed)
- Config backup: `/etc/pacman.conf`

## 📝 Logging

Comprehensive logging with different levels:
- **INFO**: General information
- **WARN**: Warnings and non-critical issues
- **ERROR**: Critical errors
- **DEBUG**: Detailed debugging (verbose mode)

Log files are timestamped: `/tmp/debutaunt-YYYYMMDD-HHMMSS.log`

## 🎨 The Personality

What makes DebUtAUnT special isn't just its functionality—it's the **personality**! The script maintains its creator's unique sense of humor and style:

### Fun Error Messages
- Permission denied? *"Uh-Oh! Looks like someone doesn't have sudo permissions... Better luck next time!"*
- No operations selected? *"Why you ain't choose any options tho? You tryna start beef? Nvm, you ain't even worth it...Exiting."*

### Completion Messages  
- *"Cheerio Mate! It's now time to clean up the temp files we created...uno momento, por favor!"*
- *"Everything looks good from my side. Best of luck in your travels!"*
- *"Great Success! [Package Manager] Autoremove has completed!"*

### ASCII Art Headers
Beautiful, colorful section headers that make the output both informative and visually appealing.

## 🔧 Technical Details

### Requirements
- **Root privileges** (sudo access)
- **Bash shell**
- **Linux distribution** (Debian, Red Hat, or Arch based)

### File Locations
- **Script**: `debutaunt.sh`
- **Logs**: `/tmp/debutaunt-*.log`
- **Backups**: `/var/backups/debutaunt/`
- **Temp files**: `/tmp/debutaunt-output.txt`

### Exit Codes
- **0**: Success
- **1**: Permission error or unsupported distribution
- **2**: Help displayed

## 🤝 Contributing

This project welcomes contributions! Whether it's:
- Bug fixes
- Feature additions
- Documentation improvements
- Distribution support
- Or just sharing your experience

Feel free to:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Anthony C. Bush** - Original creator and maintainer
- **The Linux community** - For inspiration and feedback
- **All contributors** - For helping make this tool better

## 🌟 Why Choose DebUtAUnT?

1. **Cross-Distribution**: Works on Debian, Red Hat, and Arch based systems
2. **Interactive**: User-friendly menu system with multi-operation support
3. **Safe**: Comprehensive backup and error handling
4. **Fun**: Maintains personality while being professional
5. **Flexible**: Both interactive and command-line modes
6. **Comprehensive**: Detailed logging and analysis
7. **Automation-Ready**: Perfect for scripts and cron jobs
8. **Session Persistent**: Perform multiple operations without restarting

---

*"Best of luck in your travels!"* 🚀

---

**Created with ❤️ by Anthony C. Bush for the Linux community**
 
