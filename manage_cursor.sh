#!/bin/bash

# Check Ubuntu version and exit if 24.04
UBUNTU_VERSION=$(lsb_release -rs 2>/dev/null)
if [ "$UBUNTU_VERSION" = "24.04" ]; then
    echo "-------------------------------------"
    echo "==============================="
    echo "❌ This script is for Ubuntu 22.04 only."
    echo "==============================="    
    echo "You are running Ubuntu 24.04."
    echo "This script is for Ubuntu 22.04 only."
    echo "Please use the installer for Ubuntu 24.04:"
    echo "https://github.com/hieutt192/Cursor-ubuntu/tree/Cursor-ubuntu24.04"
    echo "-------------------------------------"
    exit 1
fi

# --- Global Variables ---
# Change the install directory to a user home directory to avoid sudo in some steps
# Or keep /opt/Cursor if you want to install system-wide
CURSOR_INSTALL_DIR="/opt/Cursor"
APPIMAGE_FILENAME="cursor.AppImage" # Standardized filename
ICON_FILENAME_ON_DISK="cursor-icon.png" # Standardized local icon name

APPIMAGE_PATH="${CURSOR_INSTALL_DIR}/${APPIMAGE_FILENAME}"
ICON_PATH="${CURSOR_INSTALL_DIR}/${ICON_FILENAME_ON_DISK}"
DESKTOP_ENTRY_PATH="/usr/share/applications/cursor.desktop"

# --- Utility Functions ---
print_error() {
    echo "==============================="
    echo "❌ $1"
    echo "==============================="
}

print_success() {
    echo "==============================="
    echo "✅ $1"
    echo "==============================="
}

print_info() {
    echo "==============================="
    echo "ℹ️ $1"
    echo "==============================="
}

# --- Dependency Management ---
install_dependencies() {
    local deps=("curl" "jq" "wget" "figlet")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "📦 $dep is not installed. Installing..."
            sudo apt-get update
            sudo apt-get install -y "$dep"
        fi
    done
    
    # Check libfuse2 separately as it uses dpkg
    if ! dpkg -s libfuse2 &> /dev/null; then
        echo "📦 libfuse2 is not installed. Installing..."
        sudo apt-get update
        sudo apt-get install -y libfuse2
    fi
}

# --- Download Latest Cursor AppImage Function ---
download_latest_cursor_appimage() {
    API_URL="https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"
    USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    DOWNLOAD_PATH="/tmp/latest-cursor.AppImage"
    FINAL_URL=$(curl -sL -A "$USER_AGENT" "$API_URL" | jq -r '.url // .downloadUrl')

    if [ -z "$FINAL_URL" ] || [ "$FINAL_URL" = "null" ]; then
        print_error "Could not get the final AppImage URL from Cursor API."
        return 1
    fi

    echo "⬇️ Downloading latest Cursor AppImage from: $FINAL_URL"
    wget -q -O "$DOWNLOAD_PATH" "$FINAL_URL"

    if [ $? -eq 0 ] && [ -s "$DOWNLOAD_PATH" ]; then
        echo "✅ Downloaded latest Cursor AppImage successfully!"
        echo "$DOWNLOAD_PATH"
        return 0
    else
        print_error "Failed to download the AppImage."
        return 1
    fi
}

# --- Download Functions ---
get_appimage_path() {
    local operation="$1"  # "install" or "update"
    local action_text=""
    
    if [ "$operation" = "update" ]; then
        action_text="new Cursor AppImage"
    else
        action_text="Cursor AppImage"
    fi
    
    echo "How do you want to provide the $action_text?" >&2
    echo "📥 1. Automatically download the latest version (recommended)" >&2
    echo "📁 2. Specify local file path manually" >&2
    echo "------------------------" >&2
    read -rp "Choose 1 or 2: " appimage_option >&2

    local cursor_download_path=""
    
    if [ "$appimage_option" = "1" ]; then
        echo "⏳ Downloading the latest Cursor AppImage, please wait..." >&2
        cursor_download_path=$(download_latest_cursor_appimage 2>/dev/null | tail -n 1)
        if [ $? -ne 0 ] || [ ! -f "$cursor_download_path" ]; then
            print_error "Auto-download failed!" >&2
            echo "🤔 Would you like to specify the local file path manually instead? (y/n)" >&2
            read -r retry_option >&2
            if [[ "$retry_option" =~ ^[Yy]$ ]]; then
                if [ "$operation" = "update" ]; then
                    read -rp "📂 Enter new Cursor AppImage download path in your laptop/PC: " cursor_download_path >&2
                else
                    read -rp "📂 Enter Cursor AppImage download path in your laptop/PC: " cursor_download_path >&2
                fi
            else
                echo "❌ Exiting." >&2
                exit 1
            fi
        fi
    else
        if [ "$operation" = "update" ]; then
            read -rp "📂 Enter new Cursor AppImage download path in your laptop/PC: " cursor_download_path >&2
        else
            read -rp "📂 Enter Cursor AppImage download path in your laptop/PC: " cursor_download_path >&2
        fi
    fi
    
    # Return only the path
    echo "$cursor_download_path"
}

# --- AppImage Processing ---
process_appimage() {
    local source_path="$1"
    local operation="$2"  # "install" or "update"
    
    if [ "$operation" = "update" ]; then
        echo "🗑️ Removing old Cursor AppImage at $APPIMAGE_PATH..."
        sudo rm -f "$APPIMAGE_PATH"
        if [ $? -ne 0 ]; then
            print_error "Failed to remove old AppImage. Please check permissions."
            exit 1
        fi
        echo "✅ Old AppImage removed successfully."
    fi

    echo "📦 Move Cursor AppImage to $APPIMAGE_PATH..."
    sudo mv "$source_path" "$APPIMAGE_PATH"
    if [ $? -ne 0 ]; then
        print_error "Failed to move AppImage. Please check the URL and permissions."
        exit 1
    fi
    echo "✅ Cursor AppImage moved successfully."

    echo "🔧 Setting proper permissions..."
    # Set directory permissions (755 = rwxr-xr-x)
    sudo chmod -R 755 "$CURSOR_INSTALL_DIR"
    # Ensure AppImage is executable
    sudo chmod +x "$APPIMAGE_PATH"
    if [ $? -ne 0 ]; then
        print_error "Failed to set permissions. Please check system configuration."
        exit 1
    fi
    echo "✅ Permissions set successfully."
}

# --- Installation Function ---
installCursor() {
    if ! [ -f "$APPIMAGE_PATH" ]; then
        figlet -f slant "Install Cursor"
        echo "💿 Installing Cursor AI IDE on Ubuntu..."
        
        install_dependencies
        
        local cursor_download_path=$(get_appimage_path "install")
        
        read -rp "🎨 Enter icon filename from GitHub (e.g., cursor-icon.png): " icon_name_from_github
        local icon_download_url="https://raw.githubusercontent.com/hieutt192/Cursor-ubuntu/main/images/$icon_name_from_github"

        echo "📁 Creating installation directory ${CURSOR_INSTALL_DIR}..."
        sudo mkdir -p "$CURSOR_INSTALL_DIR"
        if [ $? -ne 0 ]; then
            print_error "Failed to create installation directory. Please check permissions."
            exit 1
        fi
        echo "✅ Installation directory ${CURSOR_INSTALL_DIR} created successfully."

        process_appimage "$cursor_download_path" "install"

        echo "🎨 Downloading Cursor icon to $ICON_PATH..."
        sudo curl -L "$icon_download_url" -o "$ICON_PATH"

        echo "🖥️ Creating .desktop entry for Cursor..."
        sudo tee "$DESKTOP_ENTRY_PATH" >/dev/null <<EOL
[Desktop Entry]
Name=Cursor AI IDE
Exec=$APPIMAGE_PATH
Icon=$ICON_PATH
Type=Application
Categories=Development;
MimeType=x-scheme-handler/cursor;
EOL

        # Set standard permissions for .desktop file (644 = rw-r--r--)
        echo "🔧 Setting desktop entry permissions..."
        sudo chmod 644 "$DESKTOP_ENTRY_PATH"
        if [ $? -ne 0 ]; then
            print_error "Failed to set desktop entry permissions."
            exit 1
        fi
        echo "✅ Desktop entry created with proper permissions."

        print_success "Cursor AI IDE installation complete. You can find it in your application menu."
    else
        print_info "Cursor AI IDE seems to be already installed at $APPIMAGE_PATH. If you want to update, please choose the update option."
        exec "$0"
    fi
}

# --- Update Function ---
updateCursor() {
    if [ -f "$APPIMAGE_PATH" ]; then
        figlet -f slant "Update Cursor"
        echo "🆙 Updating Cursor AI IDE..."
        
        install_dependencies
        
        local cursor_download_path=$(get_appimage_path "update")
        
        process_appimage "$cursor_download_path" "update"

        print_success "Cursor AI IDE update complete. Please restart Cursor if it was running."
    else
        print_error "Cursor AI IDE is not installed. Please run the installer first."
        exec "$0"
    fi
}

# --- Main Menu ---
install_dependencies

figlet -f slant "Cursor AI IDE"
echo "For Ubuntu 22.04"
echo "-------------------------------------------------"
echo "  /\\_/\\"
echo " ( o.o )"
echo "  > ^ <"
echo "------------------------"
echo "💿 1. Install Cursor"
echo "🆙 2. Update Cursor"
echo "Note: If the menu reappears after choosing 1 or 2, check any error message above."
echo "------------------------"

read -rp "Please choose an option (1 or 2): " choice

case $choice in
    1)
        installCursor
        ;;
    2)
        updateCursor
        ;;
    *)
        print_error "Invalid option. Exiting."
        exit 1
        ;;
esac

exit 0