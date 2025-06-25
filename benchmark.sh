#!/bin/bash

# --- Configuration ---
if [ -z "$1" ]; then
    echo "Usage: ./benchmark.sh <domain>"
    exit 1
fi

TARGET=$1
TIMESTAMP=$(date +%s)
RESULTS_DIR="benchmark_${TARGET}_${TIMESTAMP}"
mkdir -p "$RESULTS_DIR"

echo "[*] Starting benchmark for target: $TARGET"
echo "[*] Results will be saved in: $RESULTS_DIR"
echo "--------------------------------------------------"

# --- Step 1: Execution & Data Collection ---

echo "[+] Running gau..."
time (gau "$TARGET" > "$RESULTS_DIR/gau.raw")
echo "[+] Running waymore..."
time (waymore -d "$TARGET" -mode U > "$RESULTS_DIR/waymore.raw")
echo "[+] Running urx..."
time (urx -d "$TARGET" > "$RESULTS_DIR/urx.raw")

echo "--------------------------------------------------"
echo "[*] Tool execution complete. Normalizing results..."

# --- Step 2: Normalization ---
# Create sorted, unique lists for comparison. This is the most important step.
sort -u "$RESULTS_DIR/gau.raw" > "$RESULTS_DIR/gau.sorted"
sort -u "$RESULTS_DIR/waymore.raw" > "$RESULTS_DIR/waymore.sorted"
sort -u "$RESULTS_DIR/urx.raw" > "$RESULTS_DIR/urx.sorted"

# --- Step 3: Analysis ---
echo "[*] Analyzing results..."

# Metric 1: Total Volume
GAU_TOTAL=$(wc -l < "$RESULTS_DIR/gau.sorted")
WAYMORE_TOTAL=$(wc -l < "$RESULTS_DIR/waymore.sorted")
URX_TOTAL=$(wc -l < "$RESULTS_DIR/urx.sorted")

# Combine all results into a single master list
cat "$RESULTS_DIR/gau.sorted" "$RESULTS_DIR/waymore.sorted" "$RESULTS_DIR/urx.sorted" | sort -u > "$RESULTS_DIR/all_unique.sorted"
ALL_TOTAL=$(wc -l < "$RESULTS_DIR/all_unique.sorted")

# Metric 2 & 3: Unique Contributions and Overlap
# We use the 'comm' command which compares two SORTED files.
# comm -23 file1 file2 -> shows lines unique to file1
# comm -13 file1 file2 -> shows lines unique to file2
# comm -12 file1 file2 -> shows lines common to both

# Find URLs unique to GAU compared to the others
comm -23 "$RESULTS_DIR/gau.sorted" <(cat "$RESULTS_DIR/waymore.sorted" "$RESULTS_DIR/urx.sorted" | sort -u) > "$RESULTS_DIR/gau.unique"
GAU_UNIQUE=$(wc -l < "$RESULTS_DIR/gau.unique")

# Find URLs unique to WAYMORE compared to the others
comm -23 "$RESULTS_DIR/waymore.sorted" <(cat "$RESULTS_DIR/gau.sorted" "$RESULTS_DIR/urx.sorted" | sort -u) > "$RESULTS_DIR/waymore.unique"
WAYMORE_UNIQUE=$(wc -l < "$RESULTS_DIR/waymore.unique")

# Find URLs unique to URX compared to the others
comm -23 "$RESULTS_DIR/urx.sorted" <(cat "$RESULTS_DIR/gau.sorted" "$RESULTS_DIR/waymore.sorted" | sort -u) > "$RESULTS_DIR/urx.unique"
URX_UNIQUE=$(wc -l < "$RESULTS_DIR/urx.unique")

# Find URLs found by ALL THREE tools
comm -12 "$RESULTS_DIR/gau.sorted" <(comm -12 "$RESULTS_DIR/waymore.sorted" "$RESULTS_DIR/urx.sorted") > "$RESULTS_DIR/all_common.sorted"
ALL_COMMON=$(wc -l < "$RESULTS_DIR/all_common.sorted")

echo "--------------------------------------------------"
echo "[*] Benchmark Report for: $TARGET"
echo "--------------------------------------------------"
echo "Total Unique URLs Found (All Tools): $ALL_TOTAL"
echo "URLs Found by All Three Tools:       $ALL_COMMON"
echo ""
echo "--- Individual Tool Performance ---"
echo "Tool      | Total Found | Unique Contribution"
echo "----------|-------------|--------------------"
printf "gau       | %-11d | %d\n" "$GAU_TOTAL" "$GAU_UNIQUE"
printf "waymore   | %-11d | %d\n" "$WAYMORE_TOTAL" "$WAYMORE_UNIQUE"
printf "urx       | %-11d | %d\n" "$URX_TOTAL" "$URX_UNIQUE"
echo ""
echo "[*] Raw output files and unique lists are saved in the '$RESULTS_DIR' directory."
echo "[*] Benchmark complete."
