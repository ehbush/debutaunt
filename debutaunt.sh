#!/bin/bash

# DebUtAUnT - Enhanced Version
# Debian Update & APT Unified Terminal
# https://github.com/ehbush/debutaunt
# Created by Anthony C. Bush in 2021 for Personal / Home Use
# Enhanced with better error handling, logging, and features

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Script configuration
SCRIPT_NAME="debutaunt.sh"
SCRIPT_VERSION="2.0.0"
LOG_FILE="/tmp/debutaunt-$(date +%Y%m%d-%H%M%S).log"
TEMP_OUTPUT="/tmp/debutaunt-output.txt"
BACKUP_DIR="/var/backups/debutaunt"

# Color definitions with proper tput commands
readonly FBLACK=$(tput setaf 0 2>/dev/null || echo "")
readonly FRED=$(tput setaf 1 2>/dev/null || echo "")
readonly FGREEN=$(tput setaf 2 2>/dev/null || echo "")
readonly FYELLOW=$(tput setaf 3 2>/dev/null || echo "")
readonly FBLUE=$(tput setaf 4 2>/dev/null || echo "")
readonly FMAGENTA=$(tput setaf 5 2>/dev/null || echo "")
readonly FCYAN=$(tput setaf 6 2>/dev/null || echo "")
readonly FWHITE=$(tput setaf 7 2>/dev/null || echo "")
readonly RESET=$(tput sgr0 2>/dev/null || echo "")

# Background colors
readonly BBLACK=$(tput setab 0 2>/dev/null || echo "")
readonly BRED=$(tput setab 1 2>/dev/null || echo "")
readonly BGREEN=$(tput setab 2 2>/dev/null || echo "")
readonly BYELLOW=$(tput setab 3 2>/dev/null || echo "")
readonly BBLUE=$(tput setab 4 2>/dev/null || echo "")
readonly BMAGENTA=$(tput setab 5 2>/dev/null || echo "")
readonly BCYAN=$(tput setab 6 2>/dev/null || echo "")
readonly BWHITE=$(tput setab 7 2>/dev/null || echo "")

# Script information
readonly INTRO="
${BBLUE}${FWHITE} Welcome to DebUtAUnT v${SCRIPT_VERSION}! ${RESET}
${FCYAN}Debian Update & APT Unified Terminal${RESET}

${FYELLOW}Features:${RESET}
• System updates and upgrades
• Automatic dependency cleanup
• Error detection and reporting
• Comprehensive logging
• Backup creation before major changes

${FMAGENTA}https://github.com/ehbush/debutaunt${RESET}
"

readonly USAGE="
${FGREEN}Usage:${RESET} sudo bash ${SCRIPT_NAME} [OPTIONS]

${FYELLOW}Options:${RESET}
  -u, --skip-update      Skip apt-get update
  -g, --skip-upgrade     Skip apt-get upgrade
  -d, --skip-dist        Skip apt-get dist-upgrade
  -r, --skip-autoremove  Skip apt-get autoremove
  -c, --skip-autoclean   Skip apt-get autoclean
  -b, --create-backup    Create system backup before upgrades
  -l, --log-only         Only show log file location
  -v, --verbose          Verbose output
  -q, --quiet            Quiet mode (minimal output)
  -h, --help             Display this help message
  --version              Show version information

${FYELLOW}Examples:${RESET}
  sudo bash ${SCRIPT_NAME}              # Run all operations
  sudo bash ${SCRIPT_NAME} -u -g        # Skip update and upgrade
  sudo bash ${SCRIPT_NAME} -b -v        # Create backup with verbose output
  sudo bash ${SCRIPT_NAME} --quiet      # Quiet mode for automation

${FYELLOW}Note:${RESET} This script requires root privileges
"

# Global variables
SKIP_UPDATE=0
SKIP_UPGRADE=0
SKIP_DIST=0
SKIP_AUTOREMOVE=0
SKIP_AUTOCLEAN=0
CREATE_BACKUP=0
LOG_ONLY=0
VERBOSE=0
QUIET=0
ERROR_COUNT=0
WARNING_COUNT=0

# Logging functions
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case "$level" in
        "INFO")  echo -e "${FGREEN}[INFO]${RESET} $message" ;;
        "WARN")  echo -e "${FYELLOW}[WARN]${RESET} $message" ;;
        "ERROR") echo -e "${FRED}[ERROR]${RESET} $message" ;;
        "DEBUG") [[ $VERBOSE -eq 1 ]] && echo -e "${FCYAN}[DEBUG]${RESET} $message" ;;
    esac
    
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Error handling
error_exit() {
    log "ERROR" "$1"
    cleanup
    exit 1
}

# Cleanup function
cleanup() {
    [[ -f "$TEMP_OUTPUT" ]] && rm -f "$TEMP_OUTPUT"
    log "INFO" "Cleanup completed"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "${BRED}${FWHITE}
    Uh-Oh! Looks like someone doesn't have sudo permissions...
    Better luck next time!${RESET}
    "
        exit 1
    fi
}

# Check if running on Debian/Ubuntu
check_distro() {
    if [[ ! -f /etc/debian_version ]]; then
        error_exit "This script is designed for Debian-based distributions only"
    fi
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -u|--skip-update)
                SKIP_UPDATE=1
                shift
                ;;
            -g|--skip-upgrade)
                SKIP_UPGRADE=1
                shift
                ;;
            -d|--skip-dist)
                SKIP_DIST=1
                shift
                ;;
            -r|--skip-autoremove)
                SKIP_AUTOREMOVE=1
                shift
                ;;
            -c|--skip-autoclean)
                SKIP_AUTOCLEAN=1
                shift
                ;;
            -b|--create-backup)
                CREATE_BACKUP=1
                shift
                ;;
            -l|--log-only)
                LOG_ONLY=1
                shift
                ;;
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -q|--quiet)
                QUIET=1
                shift
                ;;
            -h|--help)
                echo -e "$USAGE"
                exit 0
                ;;
            --version)
                echo "DebUtAUnT v${SCRIPT_VERSION}"
                exit 0
                ;;
            *)
                error_exit "Unknown option: $1"
                ;;
        esac
    done
}

# Create system backup
create_backup() {
    log "INFO" "Creating system backup..."
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    # Create package list backup
    local backup_file="$BACKUP_DIR/package-list-$(date +%Y%m%d-%H%M%S).txt"
    dpkg --get-selections > "$backup_file" 2>/dev/null || log "WARN" "Failed to create package list backup"
    
    # Create sources list backup
    local sources_backup="$BACKUP_DIR/sources-$(date +%Y%m%d-%H%M%S).tar.gz"
    tar -czf "$sources_backup" /etc/apt/sources.list.d/ /etc/apt/sources.list 2>/dev/null || log "WARN" "Failed to create sources backup"
    
    log "INFO" "Backup created: $backup_file, $sources_backup"
}

# Execute apt command with error handling
execute_apt() {
    local operation="$1"
    local command="$2"
    local description="$3"
    
    log "INFO" "Executing: $description"
    
    if [[ $QUIET -eq 0 ]]; then
        echo -e "
${FGREEN}#############################
#     $description   #
#############################${RESET}
"
    fi
    
    # Execute command and capture output
    if eval "$command" 2>&1 | tee -a "$TEMP_OUTPUT"; then
        log "INFO" "$description completed successfully"
        return 0
    else
        log "ERROR" "$description failed"
        ERROR_COUNT=$((ERROR_COUNT + 1))
        return 1
    fi
}

# Analyze output for issues
analyze_output() {
    log "INFO" "Analyzing output for potential issues..."
    
    if [[ ! -f "$TEMP_OUTPUT" ]]; then
        log "WARN" "No output file found to analyze"
        return
    fi
    
    # Count and display warnings
    local warnings=$(grep -i "warning" "$TEMP_OUTPUT" | wc -l)
    WARNING_COUNT=$warnings
    
    # Display important messages
    echo -e "
${FGREEN}#####################################################
#   Alert, Alert! Reading output of the updates & upgrades, to identify any potential issues...   #
#####################################################${RESET}
"
    
    # Show warnings
    if [[ $warnings -gt 0 ]]; then
        echo -e "${FYELLOW}Warnings found: $warnings${RESET}"
        grep -i "warning" "$TEMP_OUTPUT" | tail -5
    fi
    
    # Show errors
    local errors=$(grep -i "error" "$TEMP_OUTPUT" | wc -l)
    if [[ $errors -gt 0 ]]; then
        echo -e "${FRED}Errors found: $errors${RESET}"
        grep -i "error" "$TEMP_OUTPUT" | tail -5
    fi
    
    # Show reboot recommendations
    if grep -qi "reboot\|restart" "$TEMP_OUTPUT"; then
        echo -e "${FMAGENTA}System restart may be required${RESET}"
        grep -i "reboot\|restart" "$TEMP_OUTPUT" | head -3
    fi
    
    # Show security updates
    if grep -qi "security" "$TEMP_OUTPUT"; then
        echo -e "${FGREEN}Security updates were applied${RESET}"
    fi
    
    # Show the original fun cleanup message
    echo -e "
${FGREEN}#############################
#    Cheerio Mate! It's now time to clean up the temp files we created...uno momento, por favor!    #
#############################${RESET}
"
}

# Main execution function
main() {
    # Initialize
    [[ $QUIET -eq 0 ]] && echo -e "$INTRO"
    
    # Check prerequisites
    check_root
    check_distro
    
    # Create backup if requested
    [[ $CREATE_BACKUP -eq 1 ]] && create_backup
    
    # Show log file location
    log "INFO" "Log file: $LOG_FILE"
    [[ $LOG_ONLY -eq 1 ]] && exit 0
    
    # Initialize output file
    > "$TEMP_OUTPUT"
    
    # Execute operations
    [[ $SKIP_UPDATE -eq 0 ]] && execute_apt "update" "apt-get update" "Executing APT Update"
    [[ $SKIP_UPGRADE -eq 0 ]] && execute_apt "upgrade" "apt-get upgrade -y" "Execute APT Upgrade"
    [[ $SKIP_DIST -eq 0 ]] && execute_apt "dist-upgrade" "apt-get dist-upgrade -y" "Executing Dist-Upgrade"
    [[ $SKIP_AUTOCLEAN -eq 0 ]] && execute_apt "autoclean" "apt-get autoclean" "Executing APT Autoclean"
    [[ $SKIP_AUTOREMOVE -eq 0 ]] && execute_apt "autoremove" "apt-get autoremove -y" "Executing APT Autoremove"
    
    # Add the original completion message for dist-upgrade
    if [[ $SKIP_DIST -eq 0 ]]; then
        echo -e "
${FGREEN}#############################
#   Dist Upgrade Complete   #
#############################${RESET}
"
    fi
    
    # Add the original completion message for autoremove
    if [[ $SKIP_AUTOREMOVE -eq 0 ]]; then
        echo -e "
${FGREEN}#############################
#     Great Success! APT Autoremove has completed!     #
#############################${RESET}
"
    fi
    
    # Check if we have any output to analyze
    if [[ -f "$TEMP_OUTPUT" ]]; then
        # Analyze results
        analyze_output
        
        # Clean up temp file
        rm "$TEMP_OUTPUT"
        
        # Summary
        echo -e "\n${BGREEN}${FWHITE} === Summary === ${RESET}"
        echo -e "Errors: ${FRED}$ERROR_COUNT${RESET}"
        echo -e "Warnings: ${FYELLOW}$WARNING_COUNT${RESET}"
        echo -e "Log file: ${FCYAN}$LOG_FILE${RESET}"
        
        if [[ $ERROR_COUNT -eq 0 ]]; then
            log "INFO" "All operations completed successfully"
            echo -e "
${FGREEN}#############################
#     Everything looks good from my side. Best of luck in your travels!    #
#############################${RESET}
"
        else
            log "WARN" "Some operations had errors"
            echo -e "${FYELLOW}⚠ System update completed with some errors${RESET}"
        fi
    else
        # Original fun message when no operations were performed
        echo -e "
${FGREEN}#########################################################
# Why you ain't choose any options tho? You tryna start beef? Nvm, you ain't even worth it...Exiting. #
#########################################################${RESET}
"
    fi
    
    # Cleanup
    cleanup
}

# Trap to ensure cleanup on exit
trap cleanup EXIT

# Parse arguments and run main function
parse_args "$@"
main
