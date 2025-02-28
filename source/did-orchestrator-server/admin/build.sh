ROOT_DIR=$(pwd)

FRONTEND_DIR="$ROOT_DIR"

BACKEND_STATIC_DIR="$(dirname "$ROOT_DIR")/src/main/resources/static"

if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
  echo "node_modules folder does not exist. Running npm install..."
  cd "$FRONTEND_DIR" && npm install
fi

echo "Building..."
npm run build

if [ ! -d "$BACKEND_STATIC_DIR" ]; then
  mkdir -p "$BACKEND_STATIC_DIR"
fi

echo "Deleting files in the existing static folder..."
rm -rf "$BACKEND_STATIC_DIR"/*

echo "Copying built files to the static folder..."
cp -r "$FRONTEND_DIR/build/"* "$BACKEND_STATIC_DIR/"

echo "Build and deployment completed!"