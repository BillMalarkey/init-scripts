#!/bin/bash

# --- Configuration ---
if [ ! -f "live_urls.txt" ]; then
    echo "[!] Error: live_urls.txt not found. Please provide a list of live URLs."
    exit 1
fi

TARGET_DOMAIN=$(head -n 1 live_urls.txt | unfurl -u domains)
RESULTS_DIR="wordlist_${TARGET_DOMAIN}"
mkdir -p "$RESULTS_DIR"

echo "[*] Starting custom wordlist generation for: $TARGET_DOMAIN"
echo "[*] Intermediate files will be saved in: $RESULTS_DIR"
echo "--------------------------------------------------"

# --- Phase 1: Structural Analysis with unfurl ---
echo "[+] 1. Extracting words from URL structures with unfurl..."
cat live_urls.txt | unfurl -u keys > "$RESULTS_DIR/unfurl_keys.txt"
cat live_urls.txt | unfurl -u values > "$RESULTS_DIR/unfurl_values.txt"
cat live_urls.txt | unfurl -u paths | sed 's#/#\n#g' > "$RESULTS_DIR/unfurl_paths.txt" # Split paths

# --- Phase 2: JavaScript Analysis (getJS + xnLinkFinder) ---
echo "[+] 2. Finding and analyzing JavaScript files..."
# First, find all the JS files
getJS --input live_urls.txt --complete > "$RESULTS_DIR/js_files.txt"

# Then, analyze them with xnLinkFinder
xnLinkfinder -i "$RESULTS_DIR/js_files.txt" -o "$RESULTS_DIR/xn_output.txt" -ow

# --- Phase 3: Live Response Analysis (fff + gf) ---
echo "[+] 3. Analyzing live responses for hidden paths..."
# fff finds links in the source of live pages
httpx -l live_urls.txt -srb -srd "$RESULTS_DIR/httpx_output.txt -silent -threads 100"

# gf can find URL-like strings inside JS files
cat "$RESULTS_DIR/js_files.txt" | xargs -I % curl -s % | gf url > "$RESULTS_DIR/gf_urls.txt"
# Now, extract just the paths from the gf results
cat "$RESULTS_DIR/gf_urls.txt" | unfurl -u paths | sed 's#/#\n#g' > "$RESULTS_DIR/gf_paths.txt"

# --- Phase 4: Page Content Analysis (cewl) ---
echo "[+] 4. Crawling page content for words with cewl..."
# We only need to crawl one representative URL
cewl $(head -n 1 live_urls.txt) > "$RESULTS_DIR/cewl_words.txt"

# --- Phase 5: Combine, Normalize, and Create Master Wordlist ---
echo "[+] 5. Combining all sources and normalizing..."
cat "$RESULTS_DIR/unfurl_keys.txt" \
    "$RESULTS_DIR/unfurl_values.txt" \
    "$RESULTS_DIR/unfurl_paths.txt" \
    "$RESULTS_DIR/xn_output.txt" \
    "$RESULTS_DIR/httpx_output.txt" \
    "$RESULTS_DIR/gf_paths.txt" \
    "$RESULTS_DIR/cewl_words.txt" \
    > "$RESULTS_DIR/master_raw.txt"

# The final, crucial cleanup step
cat "$RESULTS_DIR/master_raw.txt" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-zA-Z0-9.\_-]//g' | \
    grep -vE "^\." | \
    sort -u | \
    grep -E "^[a-zA-Z]{3,}$" \
    > "custom_wordlist_${TARGET_DOMAIN}.txt"

echo "--------------------------------------------------"
echo "[*] Success! Custom wordlist created: custom_wordlist_${TARGET_DOMAIN}.txt"
echo "[*] Total unique words found: $(wc -l < "custom_wordlist_${TARGET_DOMAIN}.txt")"
