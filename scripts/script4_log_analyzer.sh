#!/bin/bash
# ============================================================
# Script 4: Log File Analyzer
# Author: [Your Name] | Reg No: [Your Registration Number]
# Course: Open Source Software | OSS NGMC Capstone Project
# Software Choice: Python
# Description: Reads a log file line by line, counts keyword
#              occurrences, shows summary and last 5 matches.
#              Includes retry logic if the file is empty.
# Usage: ./script4_log_analyzer.sh <logfile> [keyword]
#        ./script4_log_analyzer.sh /var/log/syslog error
#        ./script4_log_analyzer.sh /var/log/auth.log warning
# ============================================================

# --- Read command-line arguments ---
# $1 = log file path (required), $2 = keyword (optional, default: error)
LOGFILE=$1
KEYWORD=${2:-"error"}    # Default keyword is 'error' if not provided

# --- Counters for tracking matches ---
COUNT=0          # Total count of matching lines
MAX_RETRIES=3    # Maximum number of retry attempts for empty files
RETRY=0          # Current retry attempt counter

# ============================================================
# SECTION 1: Input Validation
# Check that a log file argument was provided and that it exists
# ============================================================

# Check if no argument was provided at all
if [ -z "$LOGFILE" ]; then
    echo "========================================================"
    echo "  ERROR: No log file specified."
    echo "  Usage: $0 <logfile> [keyword]"
    echo "  Example: $0 /var/log/syslog error"
    echo "========================================================"
    exit 1    # Exit with error code 1
fi

# Check if the provided path points to an actual file
if [ ! -f "$LOGFILE" ]; then
    echo "========================================================"
    echo "  ERROR: File '$LOGFILE' not found or is not a regular file."
    echo "  Check the path and try again."
    echo "========================================================"
    exit 1    # Exit with error code 1
fi

echo "========================================================"
echo "         LOG FILE ANALYZER                             "
echo "========================================================"
echo ""
echo "  Log file : $LOGFILE"
echo "  Keyword  : '$KEYWORD' (case-insensitive)"
echo "  Started  : $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# ============================================================
# SECTION 2: Empty File Retry Logic (do-while style)
# Bash does not have a native do-while; simulate with while+break
# Retries up to MAX_RETRIES times if the file is empty
# ============================================================

while true; do
    # Check if file is empty using the -s flag (true if file has size > 0)
    if [ ! -s "$LOGFILE" ]; then
        RETRY=$((RETRY + 1))    # Increment retry counter

        # If we have not yet hit the max retries, wait and try again
        if [ "$RETRY" -le "$MAX_RETRIES" ]; then
            echo "  WARNING: '$LOGFILE' appears to be empty."
            echo "  Waiting 2 seconds before retry $RETRY of $MAX_RETRIES..."
            sleep 2    # Wait 2 seconds before checking again
        else
            # Max retries reached — report and exit
            echo "  ERROR: File is still empty after $MAX_RETRIES retries."
            echo "  Exiting. Check if the log file is being written to."
            exit 1
        fi
    else
        # File has content — break out of the retry loop
        break
    fi
done

echo "  File size: $(du -sh "$LOGFILE" | cut -f1)"
echo "  Lines    : $(wc -l < "$LOGFILE")"
echo ""
echo "--------------------------------------------------------"
echo "  Scanning for '$KEYWORD'..."
echo "--------------------------------------------------------"
echo ""

# ============================================================
# SECTION 3: Main Scan — while read loop
# Read the file line by line; check each line for the keyword
# -r flag prevents backslash escaping in line contents
# IFS= preserves leading/trailing whitespace in each line
# ============================================================

# Temporary file to store matching lines for later display
TMPFILE=$(mktemp)    # Create a secure temporary file

while IFS= read -r LINE; do
    # Use grep -iq for case-insensitive (-i) quiet (-q) search
    # If the keyword is found in this line, increment counter
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))          # Increment match counter
        echo "$LINE" >> "$TMPFILE"    # Save matching line to temp file
    fi
done < "$LOGFILE"    # Redirect file contents into the while loop

# ============================================================
# SECTION 4: Summary Output
# ============================================================

echo "  Scan complete."
echo ""
echo "========================================================"
echo "  SUMMARY"
echo "========================================================"
echo "  Keyword '$KEYWORD' found: $COUNT time(s) in $LOGFILE"
echo ""

# Show percentage of lines that matched (if file has lines)
TOTAL_LINES=$(wc -l < "$LOGFILE")
if [ "$TOTAL_LINES" -gt 0 ]; then
    # Use awk for floating point arithmetic (bash only does integers)
    PERCENT=$(awk "BEGIN {printf \"%.1f\", ($COUNT / $TOTAL_LINES) * 100}")
    echo "  Match rate: $PERCENT% of $TOTAL_LINES total lines"
fi

echo ""

# ============================================================
# SECTION 5: Show last 5 matching lines
# Use tail to get last 5 lines from the temp file of matches
# ============================================================

if [ "$COUNT" -gt 0 ]; then
    echo "--------------------------------------------------------"
    echo "  LAST 5 MATCHING LINES:"
    echo "--------------------------------------------------------"
    tail -5 "$TMPFILE" | while IFS= read -r MATCH_LINE; do
        # Print each of the last 5 matches with a visual prefix
        echo "  >> $MATCH_LINE"
    done
    echo ""
else
    echo "  No lines containing '$KEYWORD' were found."
    echo "  Try a different keyword or check the file content."
    echo ""
fi

# --- Clean up: remove temporary file ---
rm -f "$TMPFILE"    # -f flag suppresses error if file doesn't exist

echo "========================================================"
echo "  Analysis complete. Log file reviewed with open tools. "
echo "========================================================"
echo ""
