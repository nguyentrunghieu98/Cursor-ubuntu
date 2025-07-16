# Cursor AI IDE Installer for Ubuntu 22.04

This is a guideline and script for installing or updating Cursor on Ubuntu 22.04.

> **Note:** For Ubuntu 24.04 installation, please switch to the `Cursor-ubuntu24.04` branch or visit: [Link](https://github.com/hieutt192/Cursor-ubuntu/tree/Cursor-ubuntu24.04)

---

## 📝 Version History


---

## 2.2 (Current) 
**Add figlet Library for User-Friendly Terminal Display:**

To enhance the user experience, the script now uses the `figlet` library to display banners and ASCII art in the terminal. This makes the installation and update process more visually friendly and engaging.

- The script will automatically check and install `figlet` if it is not already present on your system.
- Banners such as "Cursor AI IDE" and a cat ASCII art will be shown at the start of the script for a more welcoming interface.

**Example output:**
```
   ______                              ____   ____   ________  ______
  / ____/_  ________________  _____   /   |  /  _/  /  _/ __ \/ ____/
 / /   / / / / ___/ ___/ __ \/ ___/  / /| |  / /    / // / / / __/   
/ /___/ /_/ / /  (__  ) /_/ / /     / ___ |_/ /   _/ // /_/ / /___   
\____/\__,_/_/  /____/\____/_/     /_/  |_/___/  /___/_____/_____/   
 
For Ubuntu 22.04
------------------------------------------------- 

  /\_/\
 ( o.o )
  > ^ <
------------------------
1. Install Cursor
2. Update Cursor
Note: If the menu reappears after choosing 1 or 2, please check the notification above for any issues.
------------------------
```

This helps users quickly recognize the script's purpose and provides a more pleasant terminal experience.

### 2.1 
- **Ubuntu Version Check:** The script now checks if your system is running Ubuntu 22.04. If not, it will prompt you to use the appropriate installer for your Ubuntu version (e.g., Ubuntu 24.04).
- **Automatic libfuse2 Installation:** The script will automatically check for and install `libfuse2` if it is missing, ensuring AppImage compatibility on Ubuntu 22.04. Since the Ubuntu Version Check is already implemented above, this automatic installation is safe and will not cause issues on other Ubuntu versions.

### 2.0 
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

## ⚙️ Prerequisites
- 🐧 Ubuntu 22.04 or a compatible Linux distribution
- 🌐 Internet connection
- 🔑 `sudo` privileges
- 📦 `curl` (the script will attempt to install it if missing)
- 📦 `libfuse2` (the script will attempt to install it automatically if missing)

---

## ✨ Features
- 🚀 **Automatic Download:** The script can automatically fetch and download the latest Cursor AppImage from the official website with a single selection.
- 📁 **Manual Path Option:** If you prefer, or if auto-download fails, you can specify the path to a Cursor AppImage file you have already downloaded.
- 🎨 **Icon Selection:** Choose your preferred icon for the application during setup.
- 🔄 **Easy Update:** The same options are available for updating Cursor to the latest version.

---

## 🎨 Available Icons
This repository includes two icon options for Cursor:
- <img src="images/cursor-icon.png" alt="Cursor Icon" width="24"/> `cursor-icon.png` – Standard Cursor logo with blue background
- <img src="images/cursor-black-icon.png" alt="Cursor Black Icon" width="24"/> `cursor-black-icon.png` – Cursor logo with dark/black background

You will be prompted to choose one of these icons during installation.

---

## ⚠️ NOTE
- If you are using **Ubuntu 22.04**, the script will check for and install `libfuse2` automatically if needed to run AppImage files.
- **Do NOT install `libfuse2` on Ubuntu 24.04 or newer!** Installing this package on Ubuntu 24.04 can cause system graphical issues and is not supported. AppImage support on Ubuntu 24.04 may require different steps.
- Make sure to download the Cursor AppImage file **before** running the script.
- For the best experience, restart your computer after installation.
- The script requires sudo privileges to create files in system directories.
- If you encounter any issues, see the Troubleshooting section below.

---

## 🚀 Installation/Update Steps

1.  **Download the Management Script**
    * Clone this repository or download the `manage_cursor.sh` file from the `scripts` directory.
    * Make the script executable:
        ```zsh
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
        ```zsh
        ./scripts/manage_cursor.sh
        ```
    * The script will present a menu:
        * Choose '1' to **Install Cursor**.
        * Choose '2' to **Update Cursor**.

4.  **Launch Cursor**
    * After restarting, you should find "Cursor AI IDE" in your application menu.
    * Alternatively, you can launch it from the terminal:
        ```zsh
        /opt/Cursor/cursor.AppImage --no-sandbox
        ```

> ⚠️ **It's recommended to restart your computer after installation for the best experience.**

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
    ```zsh
    sudo rm -rf /opt/Cursor
    ```
2.  Remove the desktop entry:
    ```zsh
    sudo rm -f /usr/share/applications/cursor.desktop
    ```
