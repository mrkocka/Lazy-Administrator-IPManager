# Lazy Administrator IPManager

The aim of the project is to make it easier for system administrators to set a static IP address on an Ubuntu server. After answering a few questions, the script configures the server's IP address, default nameserver, and gateway.

## Deployment

A projekt elindításához futtasd a LaIPm.sh fájlt. Ha nem vagy root, használd a sudo parancsot.

```bash
  sudo ./LaIPm.sh
```

But don't forget to make the file executable! ;)

```bash
  chmod +x LaIPm.sh
```

### During the program's execution

![App Screenshot](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/img/runscreen.png)

After asking a few simple questions, the script creates the necessary configuration file in the /etc/netplan directory.
After successful execution, the script offers the option to restart.

### The contents of /etc/netplan after execution

![App Screenshot](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/img/filescreen.png)

As can be seen, the script renamed the original file and kept it as if it were a backup. The original DHCP version can be restored at any time.

### More info

In earlier versions, it caused issues if the Ethernet port had a different name. Therefore, as an initial step, the script checks what the active Ethernet port's designation is on the server.
![App Screenshot](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/img/activeInterface.png)

## License

[GNU v3.0](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/LICENSE)

## Authors

- [@mrkocka](https://github.com/mrkocka)

![Logo](https://raw.githubusercontent.com/mrkocka/Lazy-Administrator-IPManager/main/img/Mr.K_noBG.png)
