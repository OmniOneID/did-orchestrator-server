#!/bin/bash

PASSWORD="$1"
BASE_DIR="$(dirname "$(pwd)")/jars"

if [ -z "$PASSWORD" ]; then
    echo "Usage: sh create_all.sh <password>"
    exit 1
fi

for mode in CA Issuer TA Verifier Wallet; do
    MODE_DIR="$BASE_DIR/$mode"
    if [ ! -d "$MODE_DIR" ]; then
        echo "Creating directory: $MODE_DIR"
        mkdir -p "$MODE_DIR"
    fi
done

JAR_PATH="did-cli-tool-server-1.0.0.jar"
CAS_PATH="$BASE_DIR/CA"
ISSUER_PATH="$BASE_DIR/Issuer"
TAS_PATH="$BASE_DIR/TA"
VERIFIER_PATH="$BASE_DIR/Verifier"
WALLET_PATH="$BASE_DIR/Wallet"

echo "Creating wallets..."
echo "$PASSWORD" | java -jar "$JAR_PATH" walletManager createWallet -m "$CAS_PATH/cas" -p
echo "$PASSWORD" | java -jar "$JAR_PATH" walletManager createWallet -m "$ISSUER_PATH/issuer" -p
echo "$PASSWORD" | java -jar "$JAR_PATH" walletManager createWallet -m "$TAS_PATH/tas" -p
echo "$PASSWORD" | java -jar "$JAR_PATH" walletManager createWallet -m "$VERIFIER_PATH/verifier" -p
echo "$PASSWORD" | java -jar "$JAR_PATH" walletManager createWallet -m "$WALLET_PATH/wallet" -p

echo "Adding keys..."
for key in assert auth keyagree invoke; do
    echo "$PASSWORD" | java -jar "$JAR_PATH" walletManager addKey -m "$TAS_PATH/tas.wallet" -i "$key" -t 1 -p
done
for key in assert auth keyagree; do
    echo "$PASSWORD" | java -jar "$JAR_PATH" walletManager addKey -m "$CAS_PATH/cas.wallet" -i "$key" -t 1 -p
done
for key in assert auth keyagree; do
    echo "$PASSWORD" | java -jar "$JAR_PATH" walletManager addKey -m "$ISSUER_PATH/issuer.wallet" -i "$key" -t 1 -p
done
for key in assert auth keyagree; do
    echo "$PASSWORD" | java -jar "$JAR_PATH" walletManager addKey -m "$VERIFIER_PATH/verifier.wallet" -i "$key" -t 1 -p
done
for key in assert auth keyagree; do
    echo "$PASSWORD" | java -jar "$JAR_PATH" walletManager addKey -m "$WALLET_PATH/wallet.wallet" -i "$key" -t 1 -p
done

echo "Creating DIDs..."
echo "$PASSWORD" | java -jar "$JAR_PATH" did createDid -m "$TAS_PATH/tas.wallet" -f "$TAS_PATH/tas.did" -id did:omn:tas -ci did:omn:tas -mi assert -ai auth -ki keyagree -ii invoke -p
echo "$PASSWORD" | java -jar "$JAR_PATH" did createDid -m "$CAS_PATH/cas.wallet" -f "$CAS_PATH/cas.did" -id did:omn:cas -ci did:omn:tas -mi assert -ai auth -ki keyagree -p
echo "$PASSWORD" | java -jar "$JAR_PATH" did createDid -m "$ISSUER_PATH/issuer.wallet" -f "$ISSUER_PATH/issuer.did" -id did:omn:issuer -ci did:omn:tas -mi assert -ai auth -ki keyagree -p
echo "$PASSWORD" | java -jar "$JAR_PATH" did createDid -m "$VERIFIER_PATH/verifier.wallet" -f "$VERIFIER_PATH/verifier.did" -id did:omn:verifier -ci did:omn:tas -mi assert -ai auth -ki keyagree -p
echo "$PASSWORD" | java -jar "$JAR_PATH" did createDid -m "$WALLET_PATH/wallet.wallet" -f "$WALLET_PATH/wallet.did" -id did:omn:wallet -ci did:omn:tas -mi assert -ai auth -ki keyagree -p
