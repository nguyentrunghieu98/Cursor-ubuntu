# Cursor-ubuntu
This is a guideline and script for installing or updating Cursor on Ubuntu.

## Prerequisites
- Ubuntu 22.04 or a compatible Linux distribution
- Internet connection
- `sudo` privileges
- `curl` (the script will attempt to install it if missing)
- `libfuse2` (the script will attempt to install it if missing, as it's often required for AppImages)

---

## 🎨 Available Icons
This repository includes two icon options for Cursor:
- <img src="images/cursor-icon.png" alt="Cursor Icon" width="24"/> `cursor-icon.png` – Standard Cursor logo with blue background
- <img src="images/cursor-black-icon.png" alt="Cursor Black Icon" width="24"/> `cursor-black-icon.png` – Cursor logo with dark/black background

You will be prompted to choose one of these icons during installation.

---

## ⚠️ NOTE
- Make sure to download the Cursor AppImage file **before** running the script
- For the best experience, restart your computer after installation
- The script requires sudo privileges to create files in system directories
- If you encounter any issues, see the Troubleshooting section below

---

## 🚀 Installation/Update Steps

1.  **Download the Management Script**
    * Clone this repository or download the `manage_cursor.sh` (or your chosen script name) file from the `scripts` directory.
    * Make the script executable:
        ```bash
        chmod +x scripts/manage_cursor.sh
        ```

2.  **Follow Prompts:**
    * **For Installation:**
        * First, download the Cursor Linux AppImage from [Cursor's official download page](https://www.cursor.com/downloads).
        * When prompted by the script, enter the **local file path** where you downloaded the Cursor AppImage (e.g., `~/Downloads/Cursor-x.y.z.AppImage`).
        * Enter the desired icon filename from the repository (e.g., `cursor-icon.png` or `cursor-black-icon.png`).
    * **For Update:**
        * First, download the new version of the Cursor Linux AppImage.
        * When prompted, enter the **local file path** where you downloaded the new Cursor AppImage.

3.  **Run the Script**
    * Run the script:
        ```bash
        ./scripts/manage_cursor.sh
        ```
    * The script will present a menu:
        * Choose '1' to **Install Cursor**.
        * Choose '2' to **Update Cursor**.

4.  **Launch Cursor**

    * After restarting, you should find "Cursor AI IDE" in your application menu.
    * Alternatively, you can launch it from the terminal:
        ```bash
        /opt/Cursor/cursor.AppImage --no-sandbox
        ```
## ⚠️ NOTE: It's recommended to restart your computer after installation for the best experience.

---

## 🛠️ Script Functionality
The script will:
-   Offer to install or update Cursor.
-   **During Installation:**
    -   Check for and install `curl` if missing.
    -   Check for and install `libfuse2` if missing (important for running AppImages).
    -   Move the specified Cursor AppImage to `/opt/Cursor/cursor.AppImage`.
    -   Make the AppImage executable.
    -   Download a chosen icon to `/opt/Cursor/cursor-icon.png`.
    -   Create a desktop entry (`/usr/share/applications/cursor.desktop`) for easy access.
-   **During Update:**
    -   Download the new Cursor AppImage, replacing the old one in `/opt/Cursor/`.
    -   Ensure the new AppImage is executable.

---

## 🧩 Troubleshooting
If you encounter any issues:
1.  Ensure you have `sudo` privileges and an active internet connection.
2.  Verify that the AppImage download path you provided is correct and accessible.
3.  Confirm the icon filename exists in the `images` directory of the `hieutt192/Cursor-ubuntu` GitHub repository.
4.  If Cursor fails to start after installation, ensure `libfuse2` was installed correctly. The script attempts this, but you can manually check/install with `sudo apt update && sudo apt install libfuse2`.
5.  Check script permissions (`chmod +x your_script_name.sh`).

---

## ❌ Uninstallation
To uninstall Cursor:
1.  Remove the application files:
    ```bash
    sudo rm -rf /opt/Cursor
    ```
2.  Remove the desktop entry:
    ```bash
    sudo rm -f /usr/share/applications/cursor.desktop
    ```
