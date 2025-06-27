#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 2.0.0"
    exit 1
fi

API_VERSION="$1"
TAG="V${API_VERSION}"

JAR_NAMES=(
    "did-api-server-${API_VERSION}.jar"
    "did-demo-server-${API_VERSION}.jar"
    "did-issuer-server-${API_VERSION}.jar"
    "did-ta-server-${API_VERSION}.jar"
    "did-ca-server-${API_VERSION}.jar"
    "did-verifier-server-${API_VERSION}.jar"
    "did-wallet-server-${API_VERSION}.jar"
    "did-ledger-service-server-${API_VERSION}.jar"
)

JAR_PATHS=("jars/API" "jars/Demo" "jars/Issuer" "jars/TA" "jars/CA" "jars/Verifier" "jars/Wallet" "jars/LSS")

GITHUB_REPOS=(
    "OmniOneID/did-api-server"
    "OmniOneID/did-demo-server"
    "OmniOneID/did-issuer-server"
    "OmniOneID/did-ta-server"
    "OmniOneID/did-ca-server"
    "OmniOneID/did-verifier-server"
    "OmniOneID/did-wallet-server"
    "OmniOneID/did-ledger-service-server"
)

fail_flag=0

already_exists_list=()
success_list=()
success_times=()
fail_list=()

download_jar() {
    local repo="$1"
    local jar_name="$2"
    local download_path="$3"
    local jar_file="$download_path/$jar_name"

    if [[ -f "$jar_file" ]]; then
        echo "$jar_file already exists. Skipping download."
        already_exists_list+=("$jar_file")
        return
    fi

    echo "Fetching release information for $jar_name from $repo, tag $TAG..."

    ASSET_URL=$(curl -s "https://api.github.com/repos/$repo/releases/tags/$TAG" | grep "browser_download_url" | grep "$jar_name" | cut -d '"' -f 4)

    if [[ -z "$ASSET_URL" ]]; then
        echo "Error: Failed to find $jar_name in GitHub release tag $TAG."
        fail_flag=1
        fail_list+=("$jar_name (missing in $repo)")
        return
    fi

    mkdir -p "$download_path"

    echo "Downloading $jar_name to $download_path..."
    start_time=$(date +%s)

    curl -L --output "$jar_file" "$ASSET_URL"
    curl_exit_code=$?

    end_time=$(date +%s)
    duration=$((end_time - start_time))

    if [[ $curl_exit_code -ne 0 ]]; then
        echo "Error: Failed to download $jar_name."
        fail_flag=1
        fail_list+=("$jar_name (download error)")
        return
    fi

    echo "Download complete: $jar_file (${duration}s)"
    success_list+=("$jar_file")
    success_times+=("$duration")
}

for i in "${!JAR_NAMES[@]}"; do
    download_jar "${GITHUB_REPOS[$i]}" "${JAR_NAMES[$i]}" "${JAR_PATHS[$i]}"
done

wait

echo ""
echo "======================================"
echo "JAR Download Summary"
echo "======================================"

if [[ ${#success_list[@]} -gt 0 ]]; then
    echo "Successfully downloaded:"
    for i in "${!success_list[@]}"; do
        echo "  - ${success_list[$i]} (${success_times[$i]} seconds)"
    done
    echo ""
fi

if [[ ${#already_exists_list[@]} -gt 0 ]]; then
    echo "Already exists (skipped):"
    for jar in "${already_exists_list[@]}"; do
        echo "  - $jar"
    done
    echo ""
fi

if [[ ${#fail_list[@]} -gt 0 ]]; then
    echo "Failed to download:"
    for jar in "${fail_list[@]}"; do
        echo "  - $jar"
    done
    echo ""
fi

if [[ $fail_flag -eq 1 ]]; then
    echo "Some JAR files failed to download. Exiting..."
    exit 1
fi

echo "All requested JAR files are ready."
