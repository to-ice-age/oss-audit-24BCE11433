#!/bin/bash
# ============================================================
# Script 5: Open Source Manifesto Generator
# Author: [Your Name] | Reg No: [Your Registration Number]
# Course: Open Source Software | OSS NGMC Capstone Project
# Software Choice: Python
# Description: Interactively asks the user 3 questions and
#              generates a personalised open-source philosophy
#              statement, saving it to a .txt file.
# Usage: ./script5_manifesto_generator.sh
# ============================================================

# ============================================================
# ALIAS DEMONSTRATION
# Aliases are shorthand names for longer commands.
# In a script, alias must be enabled explicitly (not default).
# We define aliases here as a concept demonstration.
# ============================================================
shopt -s expand_aliases   # Enable alias expansion in this script

# Define an alias: 'say' is a short alias for 'echo'
alias say="echo"
# Define an alias: 'savetext' is an alias for appending to a file
# (aliases with arguments use functions in practice — shown below)

# Helper function to append text to the output file
# This demonstrates the alias/function concept for reusable output
savetext() {
    echo "$1" >> "$OUTPUT_FILE"
}

# ============================================================
# Setup: date and output filename
# ============================================================

DATE=$(date '+%d %B %Y')                   # Human-readable date
TIME=$(date '+%H:%M:%S')                   # Current time
OUTPUT_FILE="manifesto_$(whoami).txt"      # Filename personalised to current user

# ============================================================
# Display welcome banner
# ============================================================

say ""
say "========================================================"
say "     OPEN SOURCE MANIFESTO GENERATOR                   "
say "     Python Capstone | OSS NGMC Course                 "
say "========================================================"
say ""
say "  This script will generate a personalised open-source"
say "  philosophy statement based on your answers."
say "  Your manifesto will be saved to: $OUTPUT_FILE"
say ""
say "--------------------------------------------------------"
say "  Answer three questions honestly."
say "--------------------------------------------------------"
say ""

# ============================================================
# SECTION 1: Read user input interactively
# The 'read' command waits for keyboard input
# -p flag shows a prompt; result stored in named variable
# ============================================================

# Question 1: An open-source tool they use
read -p "  1. Name one open-source tool you use every day: " TOOL

# Validate that the user actually typed something
while [ -z "$TOOL" ]; do
    say "     Please enter a tool name (cannot be blank)."
    read -p "  1. Name one open-source tool you use every day: " TOOL
done

say ""

# Question 2: What freedom means to them (single word)
read -p "  2. In one word, what does 'freedom' mean to you? " FREEDOM

# Validate single-word input
while [ -z "$FREEDOM" ]; do
    say "     Please enter a word (cannot be blank)."
    read -p "  2. In one word, what does 'freedom' mean to you? " FREEDOM
done

# Extract first word only in case user typed multiple words
FREEDOM=$(echo "$FREEDOM" | awk '{print $1}')

say ""

# Question 3: Something they would build and share
read -p "  3. Name one thing you would build and share freely: " BUILD

# Validate that the user typed something
while [ -z "$BUILD" ]; do
    say "     Please enter something (cannot be blank)."
    read -p "  3. Name one thing you would build and share freely: " BUILD
done

say ""

# ============================================================
# SECTION 2: String Concatenation and Manifesto Generation
# Build a multi-line personalised philosophy statement
# using the three collected variables and string operations
# ============================================================

# Capitalise first letter of TOOL using parameter expansion
TOOL_CAP="$(echo "${TOOL:0:1}" | tr '[:lower:]' '[:upper:]')${TOOL:1}"
# Capitalise FREEDOM
FREEDOM_CAP="$(echo "${FREEDOM:0:1}" | tr '[:lower:]' '[:upper:]')${FREEDOM:1}"
# Capitalise BUILD
BUILD_CAP="$(echo "${BUILD:0:1}" | tr '[:lower:]' '[:upper:]')${BUILD:1}"

# Concatenate the author name (current user) with a title
AUTHOR_LINE="— $(whoami), $(hostname)"

# ============================================================
# SECTION 3: Write manifesto to file using > and >>
# First line uses > (overwrite/create), rest use >> (append)
# ============================================================

# Create/overwrite the file with the header
echo "OPEN SOURCE MANIFESTO" > "$OUTPUT_FILE"

# Append remaining content using savetext() function
savetext "Generated on $DATE at $TIME"
savetext "Author: $(whoami) | System: $(hostname)"
savetext "========================================================"
savetext ""
savetext "I believe in the tools that shaped me."
savetext ""
savetext "Every day I rely on $TOOL_CAP — a tool I did not build"
savetext "and did not pay for, yet one that works faithfully for me"
savetext "because someone, somewhere, chose to share it freely."
savetext "That act of sharing is not weakness. It is the foundation"
savetext "of everything I can build."
savetext ""
savetext "To me, freedom means $FREEDOM_CAP."
savetext ""
savetext "In software, freedom is not an abstraction. It is the right"
savetext "to read the code that runs on my machine, to understand it,"
savetext "to fix it when it is broken, and to pass it on better than"
savetext "I found it. When software is free, I am free."
savetext ""
savetext "One day I will build $BUILD_CAP."
savetext ""
savetext "When I do, I will release it openly. Not because I am"
savetext "required to, but because I understand — in a way I did not"
savetext "before studying open source — that the most durable things"
savetext "we make are the ones we give away."
savetext ""
savetext "I stand on the shoulders of programmers I will never meet."
savetext "The least I can do is hold the next person up."
savetext ""
savetext "========================================================"
savetext "$AUTHOR_LINE"
savetext "OSS NGMC Capstone Project | Chosen Software: Python"
savetext "========================================================"

# ============================================================
# SECTION 4: Display result
# ============================================================

say "--------------------------------------------------------"
say "  Manifesto generated successfully!"
say "  Saved to: $OUTPUT_FILE"
say "--------------------------------------------------------"
say ""

# Display the saved manifesto using cat
cat "$OUTPUT_FILE"

say ""
say "========================================================"
say "  Your manifesto has been written. Share it freely."
say "========================================================"
say ""
