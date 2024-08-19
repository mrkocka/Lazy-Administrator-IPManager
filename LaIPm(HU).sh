#!/bin/bash

greeting(){
    echo "Üdvözöllek a Lusta Rendszergazda IPManager_1.2 felhasználójaként."
}

get_active_interface(){
    # Keresd meg az aktív Ethernet interfészt
    interface=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^e.*')

    if [ -z "$interface" ]; then
        echo "Nem található aktív Ethernet interfész. Ellenőrizze a hálózati kapcsolatot."
        exit 1
    fi

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
    backup_mappa="/var/backups/netplan-backups"
    backup_fajlnev="00-installer-config-org.yaml"

    # Hozd létre a biztonsági mentés mappát, ha nem létezik
    if [ ! -d "$backup_mappa" ]; then
        mkdir -p "$backup_mappa"
        if [ $? -ne 0 ]; then
            echo "Nem sikerült létrehozni a biztonsági mentés mappát: $backup_mappa"
            exit 1
        fi
    fi

    # Ellenőrizze, hogy létezik-e a cél fájl, és ha igen, nevezze át és mozgassa a biztonsági mentés mappába
    if [ -f "$cel_hely/$fajlnev" ]; then
        mv "$cel_hely/$fajlnev" "$backup_mappa/$backup_fajlnev"
        if [ $? -ne 0 ]; then
            echo "Nem sikerült áthelyezni a fájlt a biztonsági mentés mappába: $backup_mappa"
            exit 1
        fi
        echo "Biztonsági másolat készült és áthelyezve: $backup_mappa/$backup_fajlnev"
    fi

    # Az adatokat írjuk a fájlba
    {
    echo "# Static IP"
    echo "network:"
    echo "  ethernets:"
    echo "    $interface:"
    echo "      dhcp4: no"
    echo "      addresses:"
    echo "        - $ip_cim"
    echo "      nameservers:"
    echo "        addresses:"
    for ns in "${nameserver_array[@]}"; do
        echo "          - $ns"
    done
    echo "      routes:"
    echo "        - to: 0.0.0.0/0"
    echo "          via: $gateway"
    echo "  version: 2"
    } > "$cel_hely/$fajlnev"

    if [ $? -eq 0 ]; then
        echo "Az adatok sikeresen elmentve a $cel_hely/$fajlnev fájlba."
    else
        echo "Hiba történt a $fajlnev fájl mentésekor."
        exit 1
    fi
}

reboot() {
    # Felajánlja az újraindítás lehetőségét
    read -p "Szeretné újraindítani a rendszert? (igen/nem): " ujrainditas

    if [[ "$ujrainditas" =~ ^[iI]gen$ ]]; then
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