#!/bin/bash
# ============================================================
# Script 2: FOSS Package Inspector
# Author: [Your Name] | Reg No: [Your Registration Number]
# Course: Open Source Software | OSS NGMC Capstone Project
# Software Choice: Python
# Description: Checks whether selected FOSS packages are
#              installed, displays their version and license,
#              and prints a philosophy note about each using
#              a case statement.
# Usage: ./script2_package_inspector.sh
# ============================================================

# --- List of FOSS packages to inspect ---
PACKAGES=("python3" "git" "vim" "curl" "gcc")

echo "========================================================"
echo "         FOSS PACKAGE INSPECTOR                        "
echo "========================================================"
echo ""

# ============================================================
# Function: inspect_package
# ============================================================
inspect_package() {

    local PACKAGE=$1

    echo "--------------------------------------------------------"
    echo "  Package: $PACKAGE"
    echo "--------------------------------------------------------"

    # ============================================================
    # Detect Operating System
    # ============================================================
    OS_TYPE=$(uname)

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        # macOS System

        if command -v "$PACKAGE" &>/dev/null; then
            echo "  Status  : INSTALLED (macOS)"

            case "$PACKAGE" in
                python3)
                    echo "  Version : $(python3 --version 2>&1)"
                    ;;
                git)
                    echo "  Version : $(git --version)"
                    ;;
                vim)
                    echo "  Version : $(vim --version | head -n 1)"
                    ;;
                curl)
                    echo "  Version : $(curl --version | head -n 1)"
                    ;;
                gcc)
                    echo "  Version : $(gcc --version | head -n 1)"
                    ;;
            esac

            # Check if Homebrew exists
            if command -v brew &>/dev/null; then
                BREW_INFO=$(brew list --versions "$PACKAGE" 2>/dev/null)
                if [[ ! -z "$BREW_INFO" ]]; then
                    echo "  Manager : Homebrew"
                fi
            fi

        else
            echo "  Status  : NOT INSTALLED"
            echo "  Tip     : Install with 'brew install $PACKAGE'"
        fi

    else
        # ========================================================
        # Linux System
        # ========================================================

        if command -v rpm &>/dev/null && rpm -q "$PACKAGE" &>/dev/null; then

            echo "  Status  : INSTALLED (via RPM)"

            rpm -qi "$PACKAGE" 2>/dev/null | grep -E "^(Version|License|Summary)" | \
            while IFS= read -r line; do
                echo "  $line"
            done

        elif command -v dpkg &>/dev/null && dpkg -l "$PACKAGE" 2>/dev/null | grep -q "^ii"; then

            echo "  Status  : INSTALLED (via dpkg/apt)"

            dpkg -l "$PACKAGE" 2>/dev/null | grep "^ii" | \
            awk '{printf "  Version : %s\n", $3}'

        elif command -v "$PACKAGE" &>/dev/null; then

            echo "  Status  : INSTALLED"
            echo "  Version : $($PACKAGE --version 2>&1 | head -n 1)"

        else

            echo "  Status  : NOT INSTALLED"
            echo "  Tip     : Install with 'sudo apt install $PACKAGE'"
        fi
    fi

    echo ""

    # ============================================================
    # Case Statement: FOSS Philosophy
    # ============================================================
    case "$PACKAGE" in

        python3|python)
            echo "  Philosophy: Python proves that readability and freedom"
            echo "              reinforce each other in open source."
            echo "  License   : Python Software Foundation License (PSF v2)"
            ;;

        git)
            echo "  Philosophy: Git emerged from the need for a free version"
            echo "              control system — open source solves problems."
            echo "  License   : GNU General Public License v2 (GPL v2)"
            ;;

        vim)
            echo "  Philosophy: Vim is charityware — freedom combined with"
            echo "              social responsibility."
            echo "  License   : Vim License (GPL compatible)"
            ;;

        curl)
            echo "  Philosophy: curl quietly powers the internet through"
            echo "              open collaboration."
            echo "  License   : MIT/curl License"
            ;;

        gcc)
            echo "  Philosophy: GCC builds the open world — compilers enable"
            echo "              freedom in software creation."
            echo "  License   : GNU General Public License v3 (GPL v3)"
            ;;

        *)
            echo "  Philosophy: Open source thrives because developers share."
            echo "  License   : See documentation."
            ;;
    esac

    echo ""
}

# ============================================================
# Main Loop
# ============================================================
for PKG in "${PACKAGES[@]}"; do
    inspect_package "$PKG"
done

echo "========================================================"
echo "  Inspection complete. All tools above are open source."
echo "========================================================"
echo ""
