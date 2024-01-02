#!/bin/bash

update_sources_list() {
    cd /etc/apt/
    if [ -f "sources.list" ]; then
        mv sources.list sources.list.old
    fi
    cat << EOF > sources.list
deb [check-valid-until=no] http://archive.debian.org/debian/ jessie main contrib non-free
deb-src [check-valid-until=no] http://archive.debian.org/debian/ jessie main contrib non-free
#deb [check-valid-until=no] http://archive.debian.org/ jessie/updates main contrib non-free
#deb-src [check-valid-until=no] http://archive.debian.org/ jessie/updates main contrib non-free
deb http://chip.jfpossibilities.com/chip/debian/repo jessie main
deb http://chip.jfpossibilities.com/chip/debian/pocketchip jessie main
EOF
    echo "sources.list updated."
}

update_preferences() {
    cd /etc/apt/
    if [ -f "preferences" ]; then
        mv preferences preferences.old
    fi
    cat << EOF > preferences
Package: *
Pin: origin chip.jfpossibilities.com
Pin-Priority: 1050
EOF
    echo "preferences file updated."
}

add_no_check_valid() {
    echo "Acquire::Check-Valid-Until false;" | tee -a /etc/apt/apt.conf.d/10-nocheckvalid
    echo "Added Check-Valid-Until false."
}

apt_get_update() {
    apt-get update
    echo "apt-get update executed."
}

apt_get_upgrade() {
    apt-get upgrade --force-yes
    echo "System upgraded."
}

install_openssh_server() {
    apt-get install -y openssh-server
    echo "openssh-server installed."
}

install_debian_keyring() {
    apt-get install -y debian-archive-keyring
    echo "debian-archive-keyring installed."
}

install_locales() {
    apt-get install -y locales
    echo "locales package installed."
}

generate_locales() {
    locale-gen en_US en_US.UTF-8
    echo "en_US and en_US.UTF-8 locales generated."
}

reconfigure_locales() {
    dpkg-reconfigure locales
    echo "locales reconfigured."
}

reconfigure_tzdata() {
    dpkg-reconfigure tzdata
    echo "timezone data reconfigured."
}

install_git() {
    apt-get install git --force-yes
    echo "Git installed."
}

install_pocketdesk() {
    git clone https://github.com/senorlocksmith/PocketDesk.git
    cd PocketDesk

    echo "Select the PocketDesk package to install:"
    echo "1. PocketDESK.sh"
    echo "2. PocketDESKlite.sh"
    read -p "Enter your choice (1 or 2): " pocketdesk_choice

    case $pocketdesk_choice in
        1)
            sudo chmod +x PocketDESK.sh
            ./PocketDESK.sh
            echo "PocketDESK installed."
            ;;
        2)
            sudo chmod +x PocketDESKlite.sh
            ./PocketDESKlite.sh
            echo "PocketDESKlite installed."
            ;;
        *)
            echo "Invalid option selected."
            ;;
    esac
}

clone_and_install_chip_battery_status() {
    git clone https://github.com/PeterDekkers/chip-battery-status.git
    cd chip-battery-status
    sudo ./install.sh
    echo "chip-battery-status installed."
    echo "To configure, follow these steps:"
    echo "1. Right-click on an existing panel item, choose 'Panel > Add New Items...'"
    echo "2. Select 'Generic Monitor', hit 'Add'."
    echo "3. Right-click the new '(genmon) xxx' item, choose 'Properties'."
    echo "4. In 'Command' field, enter 'chip-battery-xfce-genmon', set 'Period (s)' to '5'."
    echo "To uninstall, run 'sudo ./uninstall.sh' from the 'chip-battery-status' directory."
}

clone_pocketinstaller() {
    git clone https://github.com/IkerGarcia/PocketInstaller.git
    echo "PocketInstaller repository cloned."
}

clone_and_run_chipbuild() {
    git clone https://github.com/senorlocksmith/chipbuild.git
    cd chipbuild
    sudo chmod +x pocket_builder.sh
    ./pocket_builder.sh
    echo "chipbuild script executed."
}

# Display menu options
echo "Select the operation to perform:"
echo "1. Setup PocketCHIP for 2024"
echo "2. Edit sources.list"
echo "3. Edit preferences"
echo "4. Add Acquire::Check-Valid-Until false to 10-nocheckvalid"
echo "5. Run apt-get update"
echo "6. Run apt-get upgrade"
echo "7. Install openssh-server"
echo "8. Install debian-archive-keyring"
echo "9. Install locales"
echo "10. Generate en_US and en_US.UTF-8 locales"
echo "11. Reconfigure locales"
echo "12. Reconfigure timezone data"
echo "13. Install Git"
echo "14. Install PocketDesk"
echo "15. Clone and install CHIP Battery Status"
echo "16. Clone PocketInstaller repository"
echo "17. Clone and run chipbuild"

# Get user input
read -p "Enter your choice (1-16): " choice

# Execute the selected option
case $choice in
    1)
        update_sources_list
        update_preferences
        add_no_check_valid
        apt_get_update
        install_openssh_server
        install_debian_keyring
        install_locales
        generate_locales
        reconfigure_locales
        reconfigure_tzdata
        install_git
        install_pocketdesk
        ;;
    2) update_sources_list ;;
    3) update_preferences ;;
    4) add_no_check_valid ;;
    5) apt_get_update ;;
    6) apt_get_upgrade ;;
    7) install_openssh_server ;;
    8) install_debian_keyring ;;
    9) install_locales ;;
    10) generate_locales ;;
    11) reconfigure_locales ;;
    12) reconfigure_tzdata ;;
    13) install_git ;;
    14) install_pocketdesk ;;
    15) clone_and_install_chip_battery_status ;;
    16) clone_pocketinstaller ;;
    17) clone_and_run_chipbuild ;;
    *) echo "Invalid option selected." ;;
esac
