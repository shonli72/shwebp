#!/usr/bin/env bash
#
# Copyright (C) 2025 Heiko Schnitzler
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# ------------------------------------------------------------------------------
# Script: shwebp
# Author: Heiko (kontakt@schnitzler-heiko.de)
# Version: 0.1.0
# Description: Converts images (JPG, PNG, TIFF, HEIC, HEIF) to WebP using cwebp
#              Supports recursion, dry-run, logging, quality control, silent mode,
#              force overwrite and optional source/target directory selection.
# ------------------------------------------------------------------------------
#

# Terminal color codes for formatted output
RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
CYAN='\033[0;96m'
ORANGE='\033[38;5;214m'
RESET='\033[0m'

DEFAULT_QUALITY=75                  # Default WebP compression quality
LOG_DIR="$HOME/.shscripts/shwebp"   # Directory for log files
TMP_DIR="/tmp/shwebp_heic"          # Temp dir for intermediate HEIC-JPG files
SCRIPT_NAME="shwebp"                # Script name for log output
VERSION="0.1.0"                     # Script version

# Print script version and exit
print_version() {
  echo "$SCRIPT_NAME version $VERSION"
  exit 0
}

# Display usage information and list all supported options
# Called when -h or --help is passed
print_help() {
  echo -e "${CYAN}######################################################################${RESET}"
  echo -e "${CYAN}### ${YELLOW}${SCRIPT_NAME}${RESET} – Convert images (JPG, PNG, TIF, TIFF, HEIC, HEIF) to WebP using cwebp"
  echo -e "${CYAN}######################################################################${RESET}"
  echo
  echo -e "${GREEN}Usage:${RESET} $SCRIPT_NAME [OPTIONS]"
  echo
  echo -e "${GREEN}Options:${RESET}"
  echo "  -R                   Process directories recursively"
  echo "  -q [1-100]           Quality level (default: $DEFAULT_QUALITY)"
  echo "  -l                   Create log file in ~/.shscripts/shwebp"
  echo "  --dry-run            Show what would be done without making changes"
  echo "  -f                   Force overwrite of existing .webp files"
  echo "  -s \"dir1,dir2\"     Source directories to process"
  echo "  -t \"target-dir\"    Target directory for all output"
  echo "  -S, --silent         Suppress all terminal output (only logs)"
  echo "  -h, --help           Show this help message"
  echo "  -v, --version        Show version"
  echo
  echo -e "${CYAN}######################################################################${RESET}"
  exit 0
}

# Generate a log filename based on timestamp and source directory
# Appends -dryrun if DRY_RUN is active
generate_log_filename() {
  local base="$(basename "$1")"
  [[ "$base" == "." ]] && base="$(basename "$(pwd)")"
  local timestamp
  timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
  local name="${timestamp}_${base}"
  if [[ "$2" == true ]]; then
    echo "$LOG_DIR/${name}-dryrun.log"
  else
    echo "$LOG_DIR/${name}.log"
  fi
}

# Initialize log file header with metadata like command, quality, flags, etc.
init_logfile_header() {
  mkdir -p "$LOG_DIR"
  {
    echo "# shwebp log – $(date)"
    echo "# Command: $SCRIPT_NAME $ORIGINAL_ARGS"
    echo "# Start directory: $(realpath "$1")"
    [[ -n "$TARGET_DIR" ]] && echo "# Target directory: $TARGET_DIR"
    echo "# Quality: $QUALITY"
    echo "# Recursive: $RECURSIVE"
    echo "# Dry-run: $DRY_RUN"
    echo
  } > "$LOG_FILE"
}

# Append message to log file if logging is enabled
log_message() {
  local msg="$1"
  [[ "$LOG_ENABLED" == true ]] && echo "$msg" >> "$LOG_FILE"
}

# Convert a single image to WebP
# Handles special case for HEIC/HEIF using heif-convert
# Updates counters (converted/skipped/error), logs status, and respects silent mode
convert_image() {
  local file="$1"
  local ext="${file##*.}"
  local target_name="$(basename "${file%.*}.webp")"
  local target_file="${file%.*}.webp"
  local final_path="$target_file"
  [[ -n "$TARGET_DIR" ]] && final_path="$TARGET_DIR/$target_name"

  ((total_count++))

  if [[ -n "$TARGET_DIR" ]]; then
    mkdir -p "$TARGET_DIR"
    target_file="$TARGET_DIR/$filename"
  fi

  [[ "$SILENT_MODE" != true ]] && echo -e "${YELLOW}Converting: $file${RESET}"
  log_message "CONVERT: $file → $final_path"

  if [[ "$DRY_RUN" == true ]]; then
    [[ "$SILENT_MODE" != true ]] && echo -e "${ORANGE}Would convert to: $final_path${RESET}"
    return
  fi

  if [[ -f "$final_path" && "$FORCE_OVERWRITE" != true ]]; then
    [[ "$SILENT_MODE" != true ]] && echo -e "${RED}Skipped (target exists): $file${RESET}"
    log_message "SKIP: $file"
    ((skipped_count++))
    return
  fi

  if [[ "$ext" =~ ^[Hh][Ee][Ii][CcFf]?$ ]]; then
    tmp_jpg=$(mktemp --suffix=.jpg)
    if ! heif-convert "$file" "$tmp_jpg" > /dev/null 2>&1; then
      echo -e "${RED}Error during heif-convert: $file${RESET}"
      log_message "ERROR: $file (heif-convert failed)"
      ((error_count++))
      return
    fi
    if [[ "$SILENT_MODE" == true ]]; then
      cwebp -q "$QUALITY" "$tmp_jpg" -o "$final_path" > /dev/null 2>&1
    else
      cwebp -q "$QUALITY" "$tmp_jpg" -o "$final_path"
    fi
    if [[ $? -eq 0 ]]; then
      [[ "$SILENT_MODE" != true ]] && echo -e "${GREEN}Finished: $final_path${RESET}"
      ((converted_count++))
    else
      echo -e "${RED}Error converting: $file${RESET}"
      log_message "ERROR: $file (cwebp failed)"
      ((error_count++))
    fi
    rm -f "$tmp_jpg"
  else
    if [[ "$SILENT_MODE" == true ]]; then
      cwebp -q "$QUALITY" "$file" -o "$final_path" > /dev/null 2>&1
    else
      cwebp -q "$QUALITY" "$file" -o "$final_path"
    fi
    if [[ $? -eq 0 ]]; then
      [[ "$SILENT_MODE" != true ]] && echo -e "${GREEN}Finished: $final_path${RESET}"
      ((converted_count++))
    else
      echo -e "${RED}Error converting: $file${RESET}"
      log_message "ERROR: $file"
      ((error_count++))
    fi
  fi
}

# Process all supported image files in a directory
# Honors recursion settings and logs each directory header
process_directory() {
  local dir="$1"
  local recursive="$2"
  local depth_param=""
  [[ "$recursive" == true ]] && depth_param="-maxdepth 999" || depth_param="-maxdepth 1"

  mapfile -t images < <(find "$dir" $depth_param -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o \
    -iname "*.tif" -o -iname "*.tiff" -o -iname "*.heic" -o -iname "*.heif" \))

  local full_path
  full_path=$(realpath "$dir")
  local count="${#images[@]}"
  [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}######################################################################${RESET}"
  [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}### ${GREEN}Found:${RESET} $count image(s) in $full_path"
  log_message "--- Directory: $full_path ---"

  for file in "${images[@]}"; do
    convert_image "$file"
  done
}

# ------------------------------------------------------------------------------
# main()
# Parses command-line arguments, sets global flags and variables,
# processes directories and converts images accordingly.
#
# Exit codes:
# 0 = Success (images converted, no errors)
# 1 = Invalid argument(s)
# 2 = No images converted (but no errors)
# 3 = Conversion errors occurred
# ------------------------------------------------------------------------------
main() {
  
  ORIGINAL_ARGS="$@"

  # Initialize default options and counters
  RECURSIVE=false
  DRY_RUN=false
  LOG_ENABLED=false
  QUALITY="$DEFAULT_QUALITY"
  TARGET_DIR=""
  DIRS=()
  converted_count=0
  total_count=0
  skipped_count=0
  error_count=0
  MULTI_SOURCE=false
  FORCE_OVERWRITE=false
  SILENT_MODE=false

  # Parse command-line arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -R) RECURSIVE=true ;;
      -q)
        shift
        QUALITY="$1"
        if ! [[ "$QUALITY" =~ ^[0-9]+$ ]] || ((QUALITY < 1 || QUALITY > 100)); then
          echo -e "${RED}Error:${RESET} Invalid quality: '$QUALITY'. Must be a number between 1 and 100."
          exit 1
        fi
        ;;
      -l) LOG_ENABLED=true ;;
      --dry-run) DRY_RUN=true ;;
      -f) FORCE_OVERWRITE=true ;;
      -s)
        shift
        MULTI_SOURCE=true
        IFS=',' read -ra INPUT_DIRS <<< "$1"
        for sdir in "${INPUT_DIRS[@]}"; do
          eval expanded_dir="$sdir"
          DIRS+=("$(realpath -m "$expanded_dir")")
        done
        ;;
      -t)
        shift
        eval TARGET_DIR="$1"
        TARGET_DIR=$(realpath -m "$TARGET_DIR")
        ;;
      -S|--silent) SILENT_MODE=true ;;
      -h|--help) print_help ;;
      -v|--version) print_version ;;
      -*)
        echo -e "${RED}Unknown option: $1${RESET}"
        exit 1
        ;;
      *) DIRS+=("$1") ;;
    esac
    shift
  done

  # Use current directory if no source directory was specified
  [[ ${#DIRS[@]} -eq 0 ]] && DIRS+=(".")

  # Enable implicit logging if silent or dry-run is active
  if [[ "$SILENT_MODE" == true && "$LOG_ENABLED" == false ]]; then
    LOG_ENABLED=true
    IMPLICIT_LOG=true
  fi

  if [[ "$DRY_RUN" == true && "$LOG_ENABLED" == false ]]; then
    LOG_ENABLED=true
    IMPLICIT_LOG=true
  fi

  # Prepare log file and write initial metadata if logging is enabled
  if [[ "$LOG_ENABLED" == true ]]; then
    if [[ "$MULTI_SOURCE" == true ]]; then
      LOG_FILE=$(generate_log_filename "multi" "$DRY_RUN")
      init_logfile_header "multi"
    else
      LOG_FILE=$(generate_log_filename "${DIRS[0]}" "$DRY_RUN")
      init_logfile_header "${DIRS[0]}"
    fi
  fi

  # Process each source directory
  # Skip if directory is invalid
  for dir in "${DIRS[@]}"; do
    [[ ! -d "$dir" ]] && echo -e "${RED}Invalid directory: $dir${RESET}" && continue
    process_directory "$dir" "$RECURSIVE"
  done

  # Show log file location (if not silent and not implicit)
  if [[ "$LOG_ENABLED" == true ]]; then
    {
      echo
      echo "# Finished at: $(date)"
      echo "# Summary:"
      echo "# Found:     $total_count"
      echo "# Converted: $converted_count"
      echo "# Skipped:   $skipped_count"
      echo "# Errors:    $error_count"
    } >> "$LOG_FILE"
  fi

  if [[ "$LOG_ENABLED" == true && "$IMPLICIT_LOG" != true ]]; then
    [[ "$SILENT_MODE" != true ]] && echo
    [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}Log file saved at:${RESET} $LOG_FILE"
  fi

  if [[ "$IMPLICIT_LOG" == true ]]; then
    [[ "$SILENT_MODE" != true ]] && echo
    [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}Log file saved at:${RESET} $LOG_FILE"
  fi

  # Show used target directory (if not silent)
  if [[ -n "$TARGET_DIR" ]]; then
    [[ "$SILENT_MODE" != true ]] && echo
    [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}Target directory used:${RESET} $TARGET_DIR"
  fi

  # Show final summary in terminal (unless silent)
  [[ "$SILENT_MODE" != true ]] && echo
  [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}Conversion summary:${RESET}"
  [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}  Found:     ${RESET}$total_count"
  [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}  Converted: ${RESET}$converted_count"
  [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}  Skipped:   ${RESET}$skipped_count"
  [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}  Errors:    ${RESET}$error_count"

  [[ "$SILENT_MODE" != true ]] && echo
  [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}### ${GREEN}Done.${RESET} Converted $converted_count image(s)."
  [[ "$SILENT_MODE" != true ]] && echo -e "${CYAN}######################################################################${RESET}"

  # Exit with appropriate code based on success/failure; more about, see above
  if (( error_count > 0 )); then
    exit 3
  elif (( converted_count == 0 )); then
    exit 2
  else
    exit 0
  fi
}

main "$@"
