# Lazy Administrator IPManager

The aim of the project is to make it easier for system administrators to set a static IP address on an Ubuntu server. After answering a few questions, the script configures the server's IP address, default nameserver, and gateway.

## Deployment

Run the LaIPm.sh file to start the project. If you are not root, use the sudo command.
(If you need the English version, use the LaIPm(ENG).sh file.)

```bash
  sudo ./LaIPm_eng.sh
```

But don't forget to make the file executable! ;)

```bash
  sudo chmod +x LaIPm_eng.sh
```

### During the program's execution

![App Screenshot](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/img/runscreen.png)

After asking a few simple questions, the script creates the necessary configuration file in the /etc/netplan directory.
After successful execution, the script offers the option to restart.

### The contents of /etc/netplan after execution

![App Screenshot](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/img/filescreen.png)

As you can see, the script creates a backup from the original file in the following path: /var/backups/netplan-backups/backup_folder/

![App Screenshot](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/img/backup_tree.png)

The original DHCP version can be restored at any time from this file.

### More info

In earlier versions, it caused issues if the Ethernet port had a different name. Therefore, as an initial step, the script checks what the active Ethernet port's designation is on the server.

![App Screenshot](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/img/activeInterface.png)

## License

[GNU v3.0](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/LICENSE)

## Authors

- [@mrkocka](https://github.com/mrkocka)

![Logo](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/img/Mr.K_noBG.png)
