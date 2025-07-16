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

# --- Download Latest Cursor AppImage Function ---
download_latest_cursor_appimage() {
    API_URL="https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"
    USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    DOWNLOAD_PATH="/tmp/latest-cursor.AppImage"
    FINAL_URL=$(curl -sL -A "$USER_AGENT" "$API_URL" | jq -r '.url // .downloadUrl')

    if [ -z "$FINAL_URL" ] || [ "$FINAL_URL" = "null" ]; then
        echo "==============================="  
        echo "❌ Could not get the final AppImage URL from Cursor API."
        echo "==============================="
        return 1
    fi

    echo "Downloading latest Cursor AppImage from: $FINAL_URL"
    wget -q -O "$DOWNLOAD_PATH" "$FINAL_URL"

    if [ $? -eq 0 ] && [ -s "$DOWNLOAD_PATH" ]; then
        echo "✅ Downloaded latest Cursor AppImage successfully!"
        echo "$DOWNLOAD_PATH"
        return 0
    else
        echo "==============================="
        echo "❌ Failed to download the AppImage."
        echo "==============================="
        return 1
    fi
}

# --- Installation Function ---
installCursor() {
    # Check if the AppImage already exists using the global path
    if ! [ -f "$APPIMAGE_PATH" ]; then
        figlet -f slant "Install Cursor"
        echo "Installing Cursor AI IDE on Ubuntu..."
        echo "How do you want to provide the Cursor AppImage?"
        echo "1. Automatically download the latest version (recommended)"
        echo "2. Specify local file path manually"
        echo "------------------------"
        read -rp "Choose 1 or 2: " appimage_option

        if [ "$appimage_option" = "1" ]; then
            # --- Dependency Checks ---
            if ! command -v curl &> /dev/null; then
                echo "curl is not installed. Installing..."
                sudo apt-get update
                sudo apt-get install -y curl
            fi
            if ! command -v jq &> /dev/null; then
                echo "jq is not installed. Installing..."
                sudo apt-get update
                sudo apt-get install -y jq
            fi
            if ! command -v wget &> /dev/null; then
                echo "wget is not installed. Installing..."
                sudo apt-get update
                sudo apt-get install -y wget
            fi
            if ! dpkg -s libfuse2 &> /dev/null; then
                echo "libfuse2 is not installed. Installing..."
                sudo apt-get update
                sudo apt-get install -y libfuse2
            fi
            # --- End Dependency Checks ---

            echo "⏳ Downloading the latest Cursor AppImage, please wait..."
            CURSOR_DOWNLOAD_PATH=$(download_latest_cursor_appimage | tail -n 1)
            if [ $? -ne 0 ] || [ ! -f "$CURSOR_DOWNLOAD_PATH" ]; then
                echo "==============================="
                echo "❌ Auto-download failed!"
                echo "==============================="
                echo "Would you like to specify the local file path manually instead? (y/n)"
                read -r retry_option
                if [[ "$retry_option" =~ ^[Yy]$ ]]; then
                    read -rp "Enter Cursor AppImage download path in your laptop/PC: " CURSOR_DOWNLOAD_PATH
                else
                    echo "Exiting installation."
                    exit 1
                fi
            fi
        else
            read -rp "Enter Cursor AppImage download path in your laptop/PC: " CURSOR_DOWNLOAD_PATH
        fi

        read -rp "Enter icon filename from GitHub (e.g., cursor-icon.png): " ICON_NAME_FROM_GITHUB
        ICON_DOWNLOAD_URL="https://raw.githubusercontent.com/hieutt192/Cursor-ubuntu/main/images/$ICON_NAME_FROM_GITHUB"

        echo "Creating installation directory ${CURSOR_INSTALL_DIR}..."
        sudo mkdir -p "$CURSOR_INSTALL_DIR"
        if [ $? -ne 0 ]; then
            echo "❌ Failed to create installation directory. Please check permissions."
            exit 1
        fi
        echo "Installation directory ${CURSOR_INSTALL_DIR} created successfully."

        echo "Move Cursor AppImage to $APPIMAGE_PATH..."
        sudo mv "$CURSOR_DOWNLOAD_PATH" "$APPIMAGE_PATH"
        if [ $? -ne 0 ]; then
            echo "==============================="
            echo "❌ Failed to move AppImage. Please check the URL and permissions."
            echo "==============================="
            exit 1
        fi
        echo "Cursor AppImage moved successfully."

        echo "Making AppImage executable..."
        sudo chmod +x "$APPIMAGE_PATH"
        if [ $? -ne 0 ]; then
            echo "==============================="
            echo "❌ Failed to make AppImage executable. Please check permissions."
            echo "==============================="
            exit 1
        fi
        echo "AppImage is now executable."

        echo "Downloading Cursor icon to $ICON_PATH..."
        sudo curl -L "$ICON_DOWNLOAD_URL" -o "$ICON_PATH"

        echo "Creating .desktop entry for Cursor..."
        sudo tee "$DESKTOP_ENTRY_PATH" >/dev/null <<EOL
[Desktop Entry]
Name=Cursor AI IDE
Exec=$APPIMAGE_PATH
Icon=$ICON_PATH
Type=Application
Categories=Development;
MimeType=x-scheme-handler/cursor;
EOL

        echo "==============================="
        echo "✅ Cursor AI IDE installation complete. You can find it in your application menu."
        echo "==============================="
    else
        echo "==============================="
        echo "ℹ️ Cursor AI IDE seems to be already installed at $APPIMAGE_PATH."
        echo "If you want to update, please choose the update option."
        echo "==============================="
        exec "$0"
    fi
}

# --- Update Function ---
updateCursor() {
    # Uses global APPIMAGE_PATH
    if [ -f "$APPIMAGE_PATH" ]; then
        figlet -f slant "Update Cursor"
        echo "Updating Cursor AI IDE..."
        echo "How do you want to provide the new Cursor AppImage?"
        echo "1. Automatically download the latest version (recommended)"
        echo "2. Specify local file path manually"
        echo "------------------------"
        read -rp "Choose 1 or 2: " appimage_option

        if [ "$appimage_option" = "1" ]; then
            # --- Dependency Checks ---
            if ! command -v curl &> /dev/null; then
                echo "curl is not installed. Installing..."
                sudo apt-get update
                sudo apt-get install -y curl
            fi
            if ! command -v jq &> /dev/null; then
                echo "jq is not installed. Installing..."
                sudo apt-get update
                sudo apt-get install -y jq
            fi
            if ! command -v wget &> /dev/null; then
                echo "wget is not installed. Installing..."
                sudo apt-get update
                sudo apt-get install -y wget
            fi
            if ! dpkg -s libfuse2 &> /dev/null; then
                echo "libfuse2 is not installed. Installing..."
                sudo apt-get update
                sudo apt-get install -y libfuse2
            fi
            # --- End Dependency Checks ---
            
            echo "⏳ Downloading the latest Cursor AppImage, please wait..."
            CURSOR_DOWNLOAD_PATH=$(download_latest_cursor_appimage | tail -n 1)
            if [ $? -ne 0 ] || [ ! -f "$CURSOR_DOWNLOAD_PATH" ]; then
                echo "==============================="
                echo "❌ Auto-download failed!"
                echo "==============================="
                echo "Would you like to specify the local file path manually instead? (y/n)"
                read -r retry_option
                if [[ "$retry_option" =~ ^[Yy]$ ]]; then
                    read -rp "Enter new Cursor AppImage download path in your laptop/PC: " CURSOR_DOWNLOAD_PATH
                else
                    echo "Exiting update."
                    exit 1
                fi
            fi
        else
            read -rp "Enter new Cursor AppImage download path in your laptop/PC: " CURSOR_DOWNLOAD_PATH
        fi

        echo "Removing old Cursor AppImage at $APPIMAGE_PATH..."
        sudo rm -f "$APPIMAGE_PATH"
        if [ $? -ne 0 ]; then
            echo "==============================="
            echo "❌ Failed to remove old AppImage. Please check permissions."
            echo "==============================="
            exit 1
        fi
        echo "Old AppImage removed successfully."

        echo "Move new Cursor AppImage in $CURSOR_DOWNLOAD_PATH to $APPIMAGE_PATH..."
        sudo mv "$CURSOR_DOWNLOAD_PATH" "$APPIMAGE_PATH"
        if [ $? -ne 0 ]; then
            echo "==============================="
            echo "❌ Failed to move new AppImage. Please check the URL and permissions."
            echo "==============================="
            exit 1
        fi
        echo "New AppImage moved successfully."

        echo "Making new AppImage executable..."
        sudo chmod +x "$APPIMAGE_PATH"
        if [ $? -ne 0 ]; then
            echo "==============================="
            echo "❌ Failed to make new AppImage executable. Please check permissions."
            echo "==============================="
            exit 1
        fi
        echo "New AppImage is now executable."

        echo "==============================="
        echo "✅ Cursor AI IDE update complete. Please restart Cursor if it was running."
        echo "==============================="
    else
        echo "==============================="
        echo "❌ Cursor AI IDE is not installed. Please run the installer first."
        echo "==============================="
        exec "$0"
    fi
}

# --- Main Menu ---
# Ensure figlet is installed for banner
if ! command -v figlet &> /dev/null; then
    echo "figlet is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y figlet
fi

figlet -f slant "Cursor AI IDE"
echo "For Ubuntu 22.04"
echo "-------------------------------------------------"
echo "  /\\_/\\"
echo " ( o.o )"
echo "  > ^ <"
echo "------------------------"
echo "1. Install Cursor"
echo "2. Update Cursor"
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
        echo "==============================="
        echo "❌ Invalid option. Exiting."
        echo "==============================="
        exit 1
        ;;
esac

exit 0