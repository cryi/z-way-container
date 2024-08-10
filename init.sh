#!/bin/sh

# Define a log file to record the installation status
LOG_FILE="/opt/z-way-server/installed.log"

# Function to check if the application is installed
is_installed() {
    # Check if the log file exists and contains "Installed"
    if [ -f "$LOG_FILE" ]; then
        grep -q "Installed" "$LOG_FILE"
        return $?
    else
        return 1
    fi
}

# Function to install or reinstall the application
install_app() {
    echo "Installing/Reinstalling the application..."
    if wget -q -O - https://storage.z-wave.me/RaspbianInstall | bash; then
        if [ -f "/opt/z-way-server/z-way-server" ]; then
            chown -R zway:zway /etc/z-way
            chown -R zway:zway /opt/z-way-server
            echo "Installed on $(date)" > "$LOG_FILE"
            echo "Installation completed successfully."
        else
            # File does not exist
            echo "Installation failed. z-way-server not found." >&2
            exit 1
        fi
    else
        echo "Installation failed. wget or bash execution error." >&2
        exit 1
    fi
}

# Main logic
if is_installed; then
    if [ "$1" = "--reinstall" ]; then
        install_app
    else
        echo "Application is already installed. Use --reinstall to reinstall."
    fi
else
    install_app
fi
