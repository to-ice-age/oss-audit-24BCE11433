#!/bin/bash
# ============================================================
# Script 3: Disk and Permission Auditor
# Author: [Your Name] | Reg No: [Your Registration Number]
# Course: Open Source Software | OSS NGMC Capstone Project
# Software Choice: Python
# Description: Loops through important system directories
#              and reports disk usage, ownership, and
#              permissions. Also checks Python-specific dirs.
# ============================================================

# --- Define the list of system directories to audit ---
# Using an array to store multiple directory paths
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/lib" "/var")

# --- Python-specific directories to check separately ---
PYTHON_DIRS=(
    "/usr/lib/python3"
    "/usr/local/lib"
    "/usr/bin/python3"
    "$HOME/.local/lib"
)

echo "========================================================"
echo "      DISK AND PERMISSION AUDITOR                      "
echo "========================================================"
echo ""
echo "  Date   : $(date '+%Y-%m-%d %H:%M:%S')"
echo "  Host   : $(hostname)"
echo "  User   : $(whoami)"
echo ""

# ============================================================
# SECTION 1: Standard System Directory Audit
# Loop through system dirs with a for loop
# ============================================================
echo "--------------------------------------------------------"
echo "  SECTION 1: System Directory Audit"
echo "--------------------------------------------------------"
printf "  %-20s %-25s %-10s\n" "Directory" "Permissions (type/owner/group)" "Size"
printf "  %-20s %-25s %-10s\n" "---------" "------------------------------" "----"
echo ""

for DIR in "${DIRS[@]}"; do
    # Check if the directory actually exists before trying to access it
    if [ -d "$DIR" ]; then
        # Use ls -ld to get permissions, extract fields with awk
        # Field 1 = permissions string, Field 3 = owner, Field 4 = group
        PERMS=$(ls -ld "$DIR" 2>/dev/null | awk '{print $1, $3, $4}')

        # Use du -sh to get human-readable size, cut extracts first field
        # 2>/dev/null suppresses permission-denied errors
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        # Print formatted output with printf for alignment
        printf "  %-20s %-25s %-10s\n" "$DIR" "$PERMS" "${SIZE:-N/A}"
    else
        # Directory does not exist on this system
        printf "  %-20s %s\n" "$DIR" "[does not exist on this system]"
    fi
done

echo ""

# ============================================================
# SECTION 2: Python-Specific Directory Audit
# Check Python's config files, library dirs, and binary
# ============================================================
echo "--------------------------------------------------------"
echo "  SECTION 2: Python Installation Audit"
echo "--------------------------------------------------------"
echo ""

# Attempt to find Python's exact installation path dynamically
PYTHON_BIN=$(command -v python3 2>/dev/null)

if [ -n "$PYTHON_BIN" ]; then
    echo "  Python binary found at: $PYTHON_BIN"

    # Get the real path in case it is a symlink
    REAL_PATH=$(readlink -f "$PYTHON_BIN" 2>/dev/null)
    echo "  Resolves to           : $REAL_PATH"

    # Get permissions of the Python binary
    BIN_PERMS=$(ls -l "$PYTHON_BIN" 2>/dev/null | awk '{print $1, $3, $4}')
    echo "  Binary permissions    : $BIN_PERMS"
    echo ""
else
    echo "  Python3 binary not found in PATH."
    echo ""
fi

# Loop through Python-specific directories
for PYDIR in "${PYTHON_DIRS[@]}"; do
    # Use wildcard expansion to catch versioned dirs like /usr/lib/python3.10
    # The ls glob handles finding the right versioned subdirectory
    MATCHED=$(ls -d "${PYDIR}"* 2>/dev/null | head -1)

    if [ -n "$MATCHED" ] && [ -e "$MATCHED" ]; then
        # Get permissions using ls -ld
        PERMS=$(ls -ld "$MATCHED" 2>/dev/null | awk '{print $1, $3, $4}')
        SIZE=$(du -sh "$MATCHED" 2>/dev/null | cut -f1)
        echo "  Path       : $MATCHED"
        echo "  Permissions: $PERMS"
        echo "  Size       : ${SIZE:-N/A}"
        echo ""
    else
        echo "  Path       : $PYDIR* [not found]"
        echo ""
    fi
done

# ============================================================
# SECTION 3: Permission Flag Explanation
# Educational section explaining what the permission bits mean
# ============================================================
echo "--------------------------------------------------------"
echo "  SECTION 3: Permission Notation Reference"
echo "--------------------------------------------------------"
echo ""
echo "  Format: [type][owner][group][others]"
echo "  Example: drwxr-xr-x  root root"
echo ""
echo "  d = directory, - = regular file, l = symbolic link"
echo "  r = read (4), w = write (2), x = execute (1)"
echo ""
echo "  Why this matters for Python:"
echo "  The Python binary (/usr/bin/python3) is owned by root"
echo "  and executable by all users (rwxr-xr-x). User packages"
echo "  in ~/.local are writable only by the owning user."
echo "  Running Python as root is a security risk — avoid it."
echo ""
echo "========================================================"
echo "  Audit complete."
echo "========================================================"
echo ""
