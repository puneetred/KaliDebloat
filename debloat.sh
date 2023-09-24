#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' 
WHITE='\033[1;37m'

packages_to_uninstall=(
    maltego
    msfpc
    set
    faraday
    recordmydesktop
    pipal
    cutycapt
    hashdeep
    bulk-extractor
    binwalk
    autopsy
    sleuthkit
    pdfid
    pdf-parser
    forensic-artifacts
    guymager
    magicrescue
    scalpel
    scrounge-ntfs
    dbd
    powersploit
    sbd
    dns2tcp
    exe2hexbat
    iodine
    miredo
    proxychains4
    proxytunnel
    ptunnel
    pwnat
    sslh
    stunnel4
    udptunnel
    laudanum
    weevely
    mimikatz
    dnschef
    netsniff-ng
    rebind
    sslsplit
    tcpreplay
    ettercap-graphical
    macchanger
    mitmproxy
    responder
    wireshark
    metasploit-framework
    exploitdb
    sqlmap
    sqlitebrowser
    bully
    fern-wifi-cracker
    spooftooph
    aircrack-ng
    kismet
    pixiewps
    reaver
    wifite
    clang
    nasm
    radare2
    chntpw
    hashcat
    hashid
    hash-identifier
    ophcrack
    ophcrack-cli
    samdump2
    hydra
    hydra-gtk
    onesixtyone
    patator
    thc-pptp-bruter
    passing-the-hash
    mimikatz
    smbmap
    cewl
    crunch
    john
    medusa
    ncrack
    wordlists
    rsmangler
    dnsenum
    dnsrecon
    fierce
    lbd
    wafw00f
    arping
    fping
    hping3
    masscan
    thc-ipv6
    nmap
    theharvester
    netdiscover
    netmask
    enum4linux
    nbtscan
    smbmap
    swaks
    onesixtyone
    snmpcheck
    ssldump
    sslh
    sslscan
    sslyze
    dmitry
    ike-scan
    legion
    recon-ng
    spike
    voiphopper
    legion
    nikto
    nmap
    unix-privesc-check
    wpscan
    burpsuite
    dirb
    dirbuster
    wfuzz
    cadaver
    davtest
    skipfish
    wapiti
    whatweb
    commix
    zaproxy
    freerdp2-x11
    scalpel
    spiderfoot
)

# Function to fetch the description of a package
get_tool_description() {
    local pkg_description=$(apt-cache show "$1" | awk '/^Description:/,/^Description-md5:/ {if ($0 !~ /^Description-md5:/) print}' | sed 's/^Description: //')
    echo -e "${YELLOW}\e[1m$(echo "$pkg_description" | head -n 1)\e[0m"
    echo -e "$(echo "$pkg_description" | tail -n +2)"
}

draw_title() {
    local title="$1"
    local title_color=$RED
    local title_length=${#title}
    local border_color=$NC
    local border_width=$((title_length + 6))

    printf "${border_color}"
    printf "+"
    printf -- "-%.0s" $(seq 1 "$border_width")
    printf "+\n"
    first_word=$(echo "$title" | awk '{print $1}')
    second_word=$(echo "$title" | awk '{print $2}')
    printf "|   ${NC}${first_word}${border_color} ${title_color}\e[1m${second_word}${border_color}\e[0m   |\n"
    printf "+"
    printf -- "-%.0s" $(seq 1 "$border_width")
    printf "+${NC}\n\n"
}

uninstall_tool() {
    package_name="$1"

    if dpkg -l | grep -q "$package_name"; then
        description=$(get_tool_description "$package_name")

        draw_title "Package: $package_name" "$YELLOW"
        echo -e "${GREEN}Description:${NC}\n$description"
        
        echo -n -e "\n${YELLOW}Do you want to uninstall $package_name? (y/n): ${NC}"
        read answer
        if [ "$answer" = "y" ]; then
            sudo apt remove -y "$package_name"
        else
            echo -e "${YELLOW}$package_name will not be uninstalled.${NC}"
        fi

    else 
        echo -e "${RED}$package_name is not installed.${NC}"
    fi
}

# Function to animate the logo
animate_logo() {
    colors=("31" "33" "32" "34" "35" "36")

    # loop through the colors array infintely
    while true; do
        
        # select random color from the colors array
        color_code=${colors[$RANDOM % ${#colors[@]}]}

        # Hide the cursor
        tput civis

        # Save the original cursor position
        tput sc

        # Move the cursor to the beginning of the terminal
        tput cup 0 0

        echo -ne "\033[37m\r"  # Set text color
        echo -ne "\033[2K\r╔═════════════════════════════════════════════════════════════════════════════╗\n"
        echo -ne "\033[2K\r║                                                                             ║\n"
        echo -ne "\033[2K\r║            \033[${color_code}m█▄▀ ▄▀█ █░░ █   █▀▄ █▀▀ █▄▄ █░░ █▀█ ▄▀█ ▀█▀ █▀▀ █▀█\033[37m              ║\n"
        echo -ne "\033[2K\r║            \033[${color_code}m█░█ █▀█ █▄▄ █   █▄▀ ██▄ █▄█ █▄▄ █▄█ █▀█ ░█░ ██▄ █▀▄\033[37m              ║\n"
        echo -ne "\033[2K\r║                                                   by puneetred              ║\n"
        echo -ne "\033[2K\r╚═════════════════════════════════════════════════════════════════════════════╝\n"
        echo -ne "\033[2K\r"
        
        # Restore the original cursor position
        tput rc
        
        # Show the cursor again
        tput cnorm

        sleep 1
    done
}

execute_uninstall() {
    clear 
    animate_logo &

    # Loop through the packages to uninstall
    for package in "${packages_to_uninstall[@]}"; do
        LOGO_HEIGHT=7
        # echo logo height number of new lines
        for i in $(seq 1 $LOGO_HEIGHT); do
            echo
        done
        
        clear_lines() {
            tput cup $LOGO_HEIGHT 0
            tput ed
        }
        clear_lines

        uninstall_tool "$package"
    done

    # Clean up the system
    sudo apt autoclean
    sudo apt autoremove
    sudo apt update

    # Uncomment the following line to remove configurations of all removed packages
    # dpkg -l | grep '^rc' | awk '{print $2}' | sudo xargs dpkg --purge

    echo "=================================="
    echo "The script has been successfully executed"
    echo "Thanks for using this script"
}


execute_uninstall


