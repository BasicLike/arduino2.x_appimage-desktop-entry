#!/bin/bash
set -e
set -o pipefail

APPIMAGE_PATH="$1"

if [ -z "$APPIMAGE_PATH" ]; then
    echo "Usage: $0 /path/to/appimage [--remove]"
    exit 1
fi

if [ ! -f "$APPIMAGE_PATH" ]; then
    echo "File not found: $APPIMAGE_PATH"
    exit 1
fi

if [[ "$APPIMAGE_PATH" =~ [[:space:]] || "$APPIMAGE_PATH" =~ [^[:ascii:]] ]]; then
    echo "Warning: Path contains spaces or non-ASCII characters which may cause issues."
fi

TEMP_SQUASHFS_PATH=$(mktemp -d) || { echo "Failed to create temp directory"; exit 1; }
trap 'rm -rf "$TEMP_SQUASHFS_PATH"' EXIT

APPIMAGE_FULLPATH=$(readlink -e "$APPIMAGE_PATH")
APPIMAGE_FILENAME=$(basename "$APPIMAGE_PATH")
APP_NAME="${APPIMAGE_FILENAME%.*}"
DESKTOP_ENTRY_PATH="${HOME}/.local/share/applications/$APP_NAME.desktop"
ICON_FOLDER="${HOME}/.local/share/icons"
mkdir -p "$ICON_FOLDER"

if [ "$2" == "--remove" ]; then
    rm -f "$DESKTOP_ENTRY_PATH"
    find "$ICON_FOLDER" -maxdepth 1 -type f -name "$APP_NAME.*" -delete
    echo "Removed $APP_NAME from applications and icons."
    exit 0
fi

pushd "$TEMP_SQUASHFS_PATH" > /dev/null
"$APPIMAGE_FULLPATH" --appimage-extract > /dev/null
cd squashfs-root/

echo "Choose icon number:"
mapfile -t FILENAMES < <(find -L . -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.svg' \))
if [ "${#FILENAMES[@]}" -eq 0 ]; then
    echo "No icon files (*.png or *.svg) found in AppImage."
    exit 1
fi

i=1
for filename in "${FILENAMES[@]}"; do
    printf " %d) %s\n" "$i" "$filename"
    i=$((i + 1))
done

while true; do
    read -rp "Icon number [1]: " SELECTED_INDEX
    SELECTED_INDEX=${SELECTED_INDEX:-1}
    if [[ "$SELECTED_INDEX" =~ ^[0-9]+$ ]] && [ "$SELECTED_INDEX" -ge 1 ] && [ "$SELECTED_INDEX" -le "${#FILENAMES[@]}" ]; then
        break
    else
        echo "Invalid input. Please enter a number between 1 and ${#FILENAMES[@]}."
    fi
done

ICON_SRC="${FILENAMES[$((SELECTED_INDEX - 1))]}"
ICON_EXT="${ICON_SRC##*.}"
ICON_DST="${ICON_FOLDER}/${APP_NAME}.${ICON_EXT}"
cp "$ICON_SRC" "$ICON_DST"

cat > "$DESKTOP_ENTRY_PATH" <<EOT
[Desktop Entry]
Name=$APP_NAME
StartupWMClass=
Exec=env ELECTRON_DISABLE_SANDBOX=1 "$APPIMAGE_FULLPATH"
Icon=$ICON_DST
Type=Application
Terminal=false
EOT

popd > /dev/null

echo "Created desktop entry at: $DESKTOP_ENTRY_PATH"
