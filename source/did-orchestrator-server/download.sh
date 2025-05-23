#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 2.0.0"
    exit 1
fi

API_VERSION="$1"
TAG="V${API_VERSION}"
GITHUB_REPO="DevOmniOneID/did-orchestrator-server"

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

JAR_PATHS=("jars/API" "jars/Demo" "jars/Issuer" "jars/TA" "jars/CA" "jars/Verifier" "jars/Wallet" "jars/LS")

fail_flag=0

download_jar() {
    local jar_name="$1"
    local download_path="$2"
    local jar_file="$download_path/$jar_name"

    if [[ -f "$jar_file" ]]; then
        echo "$jar_file already exists. Skipping download."
        return
    fi

    echo "Fetching release information for $jar_name from tag $TAG..."

    ASSET_URL=$(curl -s "https://api.github.com/repos/$GITHUB_REPO/releases/tags/$TAG" | grep "browser_download_url" | grep "$jar_name" | cut -d '"' -f 4)

    if [[ -z "$ASSET_URL" ]]; then
        echo "Error: Failed to find $jar_name in GitHub release tag $TAG."
        fail_flag=1
        return
    fi

    mkdir -p "$download_path"

    echo "Downloading $jar_name to $download_path..."
    curl -L --output "$jar_file" "$ASSET_URL"

    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to download $jar_name."
        fail_flag=1
        return
    fi

    echo "Download complete: $jar_file"
}

for i in "${!JAR_NAMES[@]}"; do
    download_jar "${JAR_NAMES[$i]}" "${JAR_PATHS[$i]}"
done

wait

if [[ $fail_flag -eq 1 ]]; then
    echo "Some JAR files failed to download. Exiting..."
    exit 1
fi

echo "All JAR files are ready."
