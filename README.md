# Cursor-ubuntu
This is a guideline and script for installing or updating Cursor on Ubuntu.

## 📝 Version History

### 2.0 (Current)
- **Automatic Download:** Script can auto-fetch and download the latest Cursor AppImage from the official website.
- **Manual Path Option:** Option to specify a local AppImage file path if preferred or if auto-download fails.
- **Icon Selection:** User can choose the application icon during setup.
- **Easy Update:** The same options are available for updating Cursor to the latest version.
- **Improved User Prompts:** Clear error messages and fallback options for a smoother experience.

### 1.0 (Initial Release)
- Basic installation and update of Cursor AppImage via manual file path only.
- Icon selection during installation.
- Creation of desktop entry for easy launching.

---

## Prerequisites
- Ubuntu 22.04 or a compatible Linux distribution
- Internet connection
- `sudo` privileges
- `curl` (the script will attempt to install it if missing)
- `libfuse2` (**Only for Ubuntu 22.04! Do NOT install on Ubuntu 24.04 as it may cause system issues.** See note below.)

---

## ✨ Features
- **Automatic Download:** The script can automatically fetch and download the latest Cursor AppImage from the official website with a single selection.
- **Manual Path Option:** If you prefer, or if auto-download fails, you can specify the path to a Cursor AppImage file you have already downloaded.
- **Icon Selection:** Choose your preferred icon for the application during setup.
- **Easy Update:** The same options are available for updating Cursor to the latest version.

---

## 🎨 Available Icons
This repository includes two icon options for Cursor:
- <img src="images/cursor-icon.png" alt="Cursor Icon" width="24"/> `cursor-icon.png` – Standard Cursor logo with blue background
- <img src="images/cursor-black-icon.png" alt="Cursor Black Icon" width="24"/> `cursor-black-icon.png` – Cursor logo with dark/black background

You will be prompted to choose one of these icons during installation.

---

## ⚠️ NOTE
- If you are using **Ubuntu 22.04**, you may need to install `libfuse2` to run AppImage files:
    ```bash
    sudo apt update && sudo apt install -y libfuse2
    ```
- **Do NOT install `libfuse2` on Ubuntu 24.04 or newer!** Installing this package on Ubuntu 24.04 can cause system graphical issues and is not supported. AppImage support on Ubuntu 24.04 may require different steps.
- Make sure to download the Cursor AppImage file **before** running the script
- For the best experience, restart your computer after installation
- The script requires sudo privileges to create files in system directories
- If you encounter any issues, see the Troubleshooting section below

---

## 🚀 Installation/Update Steps

1.  **Download the Management Script**
    * Clone this repository or download the `manage_cursor.sh` file from the `scripts` directory.
    * Make the script executable:
        ```bash
        chmod +x scripts/manage_cursor.sh
        ```

2.  **Follow Prompts:**
    * **For Installation/Update:**
        * You will be asked how to provide the Cursor AppImage:
            * **Option 1 (Recommended):** Auto-download the latest Cursor AppImage from the official website. The script will attempt to fetch and download the newest version automatically.
                * If auto-download fails, you will see a clear error message and be prompted to enter the local file path manually.
            * **Option 2:** Specify the local file path to a previously downloaded Cursor AppImage on your computer.
        * You will also be prompted to enter the icon filename (e.g., `cursor-icon.png` or `cursor-black-icon.png`).

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
