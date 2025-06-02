#!/bin/bash

#apply to application.bak

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

JAR_PATHS=(
    "${SCRIPT_DIR}/../../jars/TA"
    "${SCRIPT_DIR}/../../jars/Issuer"
    "${SCRIPT_DIR}/../../jars/Verifier"
    "${SCRIPT_DIR}/../../jars/CA"
    "${SCRIPT_DIR}/../../jars/Wallet"
    "${SCRIPT_DIR}/../../jars/API"
    "${SCRIPT_DIR}/../../jars/Demo"
)

MY_IP=$1
SETUP_PATH="${SCRIPT_DIR}/../../jars"
ORCHE_CONFIG_FILE="${SCRIPT_DIR}/../../configs/application.yml"

get_service_port() {
    local service="$1"
    grep -A 3 "${service}:" "$ORCHE_CONFIG_FILE" | grep "port:" | sed 's/.*port:[[:space:]]*\([0-9]*\).*/\1/'
}

get_service_port_lss() {
    local service="$1"
    grep -A 3 "^[[:space:]]*${service}:" "$ORCHE_CONFIG_FILE" | grep "port:" | sed 's/.*port:[[:space:]]*\([0-9]*\).*/\1/'
}

for JAR_PATH in "${JAR_PATHS[@]}"; do
    APP_YML="${JAR_PATH}/application.yml"

    WALLET_PATH=""
    ZKP_WALLET_PATH=""
    case "$JAR_PATH" in
        *"/TA")
            WALLET_PATH="${SCRIPT_DIR}/../../jars/TA/tas.wallet"
            ;;
        *"/Issuer")
            WALLET_PATH="${SCRIPT_DIR}/../../jars/Issuer/issuer.wallet"
            ZKP_WALLET_PATH="${SCRIPT_DIR}/../../jars/Issuer/issuer.zkpwallet"
            ;;
        *"/Verifier")
            WALLET_PATH="${SCRIPT_DIR}/../../jars/Verifier/verifier.wallet"
            ;;
        *"/CA")
            WALLET_PATH="${SCRIPT_DIR}/../../jars/CA/cas.wallet"
            ;;
        *"/Wallet")
            WALLET_PATH="${SCRIPT_DIR}/../../jars/Wallet/wallet.wallet"
            ;;
        *"/API")
            WALLET_PATH="${SCRIPT_DIR}/../../jars/API/api.wallet"
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

        # spring.profiles.active: dev, lss
        awk '
        BEGIN { found=0; spring_found=0 }
        /^spring:/ { spring_found=1; in_spring=1 }
        in_spring && /^  profiles:/ { in_profiles=1 }
        in_profiles && /active:/ {
            found=1
            sub(/active: .*/, "active: dev, lss")
        }
        { print }
        END {
          if (!found) {
            if (!spring_found) print "spring:";
            print "  profiles:";
            print "    active: dev, lss";
          }
        }
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

        # tas.url: http://$MY_IP:port
	TAS_PORT=$(get_service_port "tas")
	awk -v my_ip="$MY_IP" -v port="$TAS_PORT" '
        BEGIN { found=0; tas_found=0 }
        /^tas:/ { tas_found=1; in_tas=1 }
	in_tas && /url:/ { found=1; sub(/url:.*/, "url: http://" my_ip ":" port) }
        { print }
        END {
          if (!found) {
            if (!tas_found) print "tas:";
	    print "  url: http://" my_ip ":" port;
          }
        }
        ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

        # lss.url: http://$MY_IP:port
  LEDGER_PORT=$(get_service_port "ledgerService")
  awk -v my_ip="$MY_IP" -v port="$LEDGER_PORT" '
      BEGIN { found=0; lss_found=0; in_lss=0 }
      /^loss:/ { lss_found=1; in_lss=1 }
      in_lss && /url:/ { found=1; sub(/url:.*/, "url: http://" my_ip ":" port) }
      { print }
      END {
          if (!found) {
              if (!lss_found) print "lss:";
              print "  url: http://" my_ip ":" port;
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

        # demo url
        if [[ "$JAR_PATH" == *"/Demo" ]]; then
            echo "Adding service URLs for Demo application"
            
            TAS_PORT=$(get_service_port "tas")
            ISSUER_PORT=$(get_service_port "issuer")
            VERIFIER_PORT=$(get_service_port "verifier")
            CAS_PORT=$(get_service_port "cas")
            
            # tas.url: http://$MY_IP:$TAS_PORT
            awk -v my_ip="$MY_IP" -v port="$TAS_PORT" '
            BEGIN { found=0; tas_found=0 }
            /^tas:/ { tas_found=1; in_tas=1 }
            in_tas && /url:/ { found=1; sub(/url:.*/, "url: http://" my_ip ":" port) }
            { print }
            END {
              if (!found) {
                if (!tas_found) print "tas:";
                print "  url: http://" my_ip ":" port;
              }
            }
            ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

            # issuer.url: http://$MY_IP:$ISSUER_PORT
            awk -v my_ip="$MY_IP" -v port="$ISSUER_PORT" '
            BEGIN { found=0; issuer_found=0 }
            /^issuer:/ { issuer_found=1; in_issuer=1 }
            in_issuer && /url:/ { found=1; sub(/url:.*/, "url: http://" my_ip ":" port) }
            { print }
            END {
              if (!found) {
                if (!issuer_found) print "issuer:";
                print "  url: http://" my_ip ":" port;
              }
            }
            ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

            # verifier.url: http://$MY_IP:$VERIFIER_PORT
            awk -v my_ip="$MY_IP" -v port="$VERIFIER_PORT" '
            BEGIN { found=0; verifier_found=0 }
            /^verifier:/ { verifier_found=1; in_verifier=1 }
            in_verifier && /url:/ { found=1; sub(/url:.*/, "url: http://" my_ip ":" port) }
            { print }
            END {
              if (!found) {
                if (!verifier_found) print "verifier:";
                print "  url: http://" my_ip ":" port;
              }
            }
            ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

            # cas.url: http://$MY_IP:$CAS_PORT
            awk -v my_ip="$MY_IP" -v port="$CAS_PORT" '
            BEGIN { found=0; cas_found=0 }
            /^cas:/ { cas_found=1; in_cas=1 }
            in_cas && /url:/ { found=1; sub(/url:.*/, "url: http://" my_ip ":" port) }
            { print }
            END {
              if (!found) {
                if (!cas_found) print "cas:";
                print "  url: http://" my_ip ":" port;
              }
            }
            ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"
        fi

    else
        echo "Skipping: $APP_YML (File not found)"
    fi
done
