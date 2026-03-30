#!/bin/bash
# ============================================================
# Script 1: System Identity Report
# Author: [Your Name] | Reg No: [Your Registration Number]
# Course: Open Source Software | OSS NGMC Capstone Project
# Software Choice: Python
# Description: Displays a welcome screen with system info,
#              environment details, and OSS license information.
# ============================================================

# --- Student Details (fill before submission) ---
STUDENT_NAME="[Kavya Chaudhary]"
REG_NUMBER="[24BCE11433]"
SOFTWARE_CHOICE="Python"

# --- Collect system information using command substitution ---
KERNEL=$(uname -r)                        # Linux kernel version
ARCH=$(uname -m)                          # System architecture (x86_64, arm64, etc.)
USER_NAME=$(whoami)                        # Currently logged-in username
HOME_DIR=$HOME                             # Home directory of current user
HOSTNAME=$(hostname)                       # System hostname
UPTIME=$(uptime)                        # Human-readable uptime (e.g. "up 2 hours, 3 minutes")
CURRENT_DATE=$(date '+%A, %d %B %Y')      # Full date (e.g. Monday, 01 January 2025)
CURRENT_TIME=$(date '+%H:%M:%S')          # 24-hour time

# --- Get Linux distribution name (works on most distros) ---
if [ -f /etc/os-release ]; then
    # Source the os-release file to get distro variables
    . /etc/os-release
    DISTRO_NAME="$NAME $VERSION"
elif command -v lsb_release &>/dev/null; then
    # Fallback: use lsb_release command if available
    DISTRO_NAME=$(lsb_release -d | cut -f2)
else
    # Final fallback if neither method works
    DISTRO_NAME="Unknown Linux Distribution"
fi

# --- Check Python version if installed ---
if command -v python3 &>/dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)   # Get Python version string
else
    PYTHON_VERSION="Python3 not found"
fi

# --- Determine the OS license ---
# The Linux kernel is licensed under GPL v2, which covers the OS layer
OS_LICENSE="GNU General Public License version 2 (GPL v2)"

# ============================================================
# Display the system identity report (formatted output)
# ============================================================

echo "========================================================"
echo "         OPEN SOURCE AUDIT — SYSTEM IDENTITY REPORT    "
echo "========================================================"
echo ""

# Student section
echo "  Student  : $STUDENT_NAME"
echo "  Reg No   : $REG_NUMBER"
echo "  Software : $SOFTWARE_CHOICE"
echo ""
echo "--------------------------------------------------------"
echo "  SYSTEM INFORMATION"
echo "--------------------------------------------------------"

# System info section
echo "  Hostname       : $HOSTNAME"
echo "  Distribution   : $DISTRO_NAME"
echo "  Kernel Version : $KERNEL"
echo "  Architecture   : $ARCH"
echo ""
echo "--------------------------------------------------------"
echo "  USER & ENVIRONMENT"
echo "--------------------------------------------------------"

# User and environment info
echo "  Logged-in User : $USER_NAME"
echo "  Home Directory : $HOME_DIR"
echo "  Shell          : $SHELL"
echo ""
echo "--------------------------------------------------------"
echo "  TIME & UPTIME"
echo "--------------------------------------------------------"

# Time section
echo "  Current Date   : $CURRENT_DATE"
echo "  Current Time   : $CURRENT_TIME"
echo "  System Uptime  : $UPTIME"
echo ""
echo "--------------------------------------------------------"
echo "  PYTHON ENVIRONMENT"
echo "--------------------------------------------------------"

# Python-specific info
echo "  Python Version : $PYTHON_VERSION"

# Check if pip is available too
if command -v pip3 &>/dev/null; then
    PIP_VERSION=$(pip3 --version | awk '{print $1, $2}')
    echo "  pip Version    : $PIP_VERSION"
fi

# Show where Python is installed
PYTHON_PATH=$(command -v python3 2>/dev/null || echo "Not found")
echo "  Python Binary  : $PYTHON_PATH"
echo ""
echo "--------------------------------------------------------"
echo "  OPEN SOURCE LICENSE"
echo "--------------------------------------------------------"

# License information
echo "  This system runs Linux, covered under:"
echo "  $OS_LICENSE"
echo ""
echo "  Python itself is covered under:"
echo "  Python Software Foundation License (PSF License v2)"
echo "  A permissive, OSI-approved, FSF-approved free license."
echo ""
echo "========================================================"
echo "  All software on this system stands on open foundations."
echo "========================================================"
echo ""
