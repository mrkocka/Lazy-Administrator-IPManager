#!/bin/bash

greeting(){
    echo "Üdvözöllek a Lusta Rendszergazda IPManager_1.2 felhasználójaként."
}

get_active_interface(){
    # Keresd meg az aktív Ethernet interfészt
    interface=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^e.*')
    echo "Aktív Ethernet interfész: $interface"
}

work(){
    # Kérje be a felhasználótól a szükséges adatokat
    read -p "Kérem az IP címet (például: 192.168.10.22/24): " ip_cim
    read -p "Kérem a névszerver IP címeit (például: 8.8.8.8,1.1.1.1): " nameservers
    read -p "Kérem az útvonal irányításához szükséges útválasztót (például: 192.168.10.1): " gateway

    # A névszerverek feldolgozása
    IFS=',' read -r -a nameserver_array <<< "$nameservers"

    # Fájl helye
    cel_hely="/etc/netplan"
    fajlnev="00-installer-config.yaml"
    backup_fajlnev="00-installer-config-org.yaml"

    # Ellenőrizze, hogy létezik-e a cél fájl, és ha igen, nevezze át
    if [ -f "$cel_hely/$fajlnev" ]; then
        mv "$cel_hely/$fajlnev" "$cel_hely/$backup_fajlnev"
    fi

    # Az adatokat írjuk a fájlba
    echo "# Static IP" > "$cel_hely/$fajlnev"
    echo "network:" >> "$cel_hely/$fajlnev"
    echo "  ethernets:" >> "$cel_hely/$fajlnev"
    echo "    $interface:" >> "$cel_hely/$fajlnev"
    echo "      dhcp4: no" >> "$cel_hely/$fajlnev"
    echo "      addresses:" >> "$cel_hely/$fajlnev"
    echo "        - $ip_cim" >> "$cel_hely/$fajlnev"
    echo "      nameservers:" >> "$cel_hely/$fajlnev"
    echo "        addresses:" >> "$cel_hely/$fajlnev"

    for ns in "${nameserver_array[@]}"
    do
      echo "          - $ns" >> "$cel_hely/$fajlnev"
    done

    echo "      routes:" >> "$cel_hely/$fajlnev"
    echo "        - to: 0.0.0.0/0" >> "$cel_hely/$fajlnev"
    echo "          via: $gateway" >> "$cel_hely/$fajlnev"
    echo "  version: 2" >> "$cel_hely/$fajlnev"

    echo "Az adatok sikeresen elmentve a $cel_hely/$fajlnev fájlba."
}

reboot() {
    # Felajánlja az újraindítás lehetőségét
    read -p "Szeretné újraindítani a rendszert? (igen/nem): " ujrainditas

    if [ "$ujrainditas" == "igen" ]; then
        echo "A rendszer újraindítása..."
        sudo reboot
    else
        echo "A rendszer nem lesz újraindítva."
    fi
}

greeting
get_active_interface
work
reboot
