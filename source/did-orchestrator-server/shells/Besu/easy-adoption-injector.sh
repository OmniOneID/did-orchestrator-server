#!/bin/bash

#apply to application.bak
JAR_PATHS=(
    "${PWD}/../../jars/TA"
    "${PWD}/../../jars/Issuer"
    "${PWD}/../../jars/Verifier"
    "${PWD}/../../jars/CA"
    "${PWD}/../../jars/Wallet"
    "${PWD}/../../jars/API"
    "${PWD}/../../jars/Demo"
)

MY_IP=$(ifconfig | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | head -n 1)
BLOCKCHAIN_PATH="${PWD}/blockchain.properties"
SETUP_PATH="${PWD}/../../jars"

for JAR_PATH in "${JAR_PATHS[@]}"; do
    APP_YML="${JAR_PATH}/application.yml"

    WALLET_PATH=""
    ZKP_WALLET_PATH=""
    case "$JAR_PATH" in
        *"/TA") 
            WALLET_PATH="${PWD}/../../jars/TA/tas.wallet"
            ;;
        *"/Issuer") 
            WALLET_PATH="${PWD}/../../jars/Issuer/issuer.wallet"
            ZKP_WALLET_PATH="${PWD}/../../jars/Issuer/issuer.zkpwallet"
            ;;
        *"/Verifier") 
            WALLET_PATH="${PWD}/../../jars/Verifier/verifier.wallet"
            ;;
        *"/CA") 
            WALLET_PATH="${PWD}/../../jars/CA/cas.wallet"
            ;;
        *"/Wallet") 
            WALLET_PATH="${PWD}/../../jars/Wallet/wallet.wallet"
            ;;
        *"/API") 
            WALLET_PATH="${PWD}/../../jars/API/api.wallet"
            ;;
    esac

    mkdir -p "${JAR_PATH}"

    if [ -f "$APP_YML" ]; then
        rm "$APP_YML"
    fi

    if [ ! -f "$APP_YML" ]; then
        touch "$APP_YML"
    fi

    if [ -f "$APP_YML" ]; then
        echo "Updating: $APP_YML"

        # spring.profiles.active: dev
        awk '
        BEGIN { found=0; spring_found=0 }
        /^spring:/ { spring_found=1; in_spring=1 }
        in_spring && /^  profiles:/ { in_profiles=1 }
        in_profiles && /active:/ { found=1; sub(/active: .*/, "active: dev") }
        { print }
        END { 
          if (!found) {
            if (!spring_found) print "spring:";
            print "  profiles:";
            print "    active: dev";
          }
        }
        ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

        # blockchain.file-path: ${PWD}/blockchain.properties
        awk -v bcpath="$BLOCKCHAIN_PATH" '
        BEGIN { found=0 }
        /^blockchain:/ { in_blockchain=1 }
        in_blockchain && /file-path:/ { found=1; sub(/file-path:.*/, "file-path: " bcpath) }
        { print }
        END { if (!found) print "blockchain:\n  file-path: " bcpath }
        ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

        # setup.base-url: http://$MY_IP and setup.path: ${SETUP_PATH}
        awk -v setup_base_url="http://$MY_IP" -v setup_path="$SETUP_PATH" '
        BEGIN { found_base_url=0; found_path=0 }
        /^setup:/ { in_setup=1 }
        in_setup && /base-url:/ { found_base_url=1; sub(/base-url:.*/, "base-url: " setup_base_url) }
        in_setup && /path:/ { found_path=1; sub(/path:.*/, "path: " setup_path) }
        { print }
        END {
            if (!found_base_url) print "setup:\n  base-url: " setup_base_url
            if (!found_path) print "  path: " setup_path
        }
        ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

        # tas.url: http://$MY_IP:8090
        awk -v my_ip="$MY_IP" '
        BEGIN { found=0; tas_found=0 }
        /^tas:/ { tas_found=1; in_tas=1 }
        in_tas && /url:/ { found=1; sub(/url:.*/, "url: http://" my_ip ":8090") }
        { print }
        END { 
          if (!found) {
            if (!tas_found) print "tas:";
            print "  url: http://" my_ip ":8090";
          }
        }
        ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

        # wallet.file-path
        if [ ! -z "$WALLET_PATH" ]; then
            echo $WALLET_PATH
            awk -v wallet_path="$WALLET_PATH" '
            BEGIN { found=0; wallet_found=0 }
            /^wallet:/ { wallet_found=1; in_wallet=1 }
            in_wallet && /file-path:/ { found=1; sub(/file-path:.*/, "file-path: " wallet_path) }
            { print }
            END { 
              if (!found) {
                if (!wallet_found) print "wallet:";
                print "  file-path: " wallet_path;
              }
            }
            ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"
        fi

        # zkp-wallet.file-path
        if [ ! -z "$ZKP_WALLET_PATH" ] && [[ "$JAR_PATH" == *"/Issuer" ]]; then
            echo $ZKP_WALLET_PATH
            awk -v wallet_path="$ZKP_WALLET_PATH" '
            BEGIN { found=0; zkp_wallet_found=0 }
            /^zkp-wallet:/ { zkp_wallet_found=1; in_zkp_wallet=1 }
            in_zkp_wallet && /file-path:/ { found=1; sub(/file-path:.*/, "file-path: " wallet_path) }
            { print }
            END { 
            if (!found) {
                if (!zkp_wallet_found) print "zkp-wallet:";
                print "  file-path: " wallet_path;
            }
            }
            ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"
        fi

    else
        echo "Skipping: $APP_YML (File not found)"
    fi
done
