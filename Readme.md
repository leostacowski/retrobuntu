# Retrobuntu

Repository containing the files to setup a docker container with [adguard/adguardhome:latest](https://hub.docker.com/r/adguard/adguardhome/tags?page=1&name=latest) DNS server inside a [Ubuntu Server 24.04.2 LTS](https://ubuntu.com/download/server) VM.

## 📄 Table of Contents

- [Retrobuntu](#retrobuntu)
  - [📄 Table of Contents](#-table-of-contents)
  - [💭 Considerations](#-considerations)
  - [🔨 Instructions](#-instructions)
    - [1. 🖥️ Setup Ubuntu Server](#1-️-setup-ubuntu-server)
    - [2. 🐋 Setup Docker](#2--setup-docker)
    - [3. 🚪 Free up Port 53 from _systemd-resolved_](#3--free-up-port-53-from-systemd-resolved)
    - [4. 📁 Pull the Repository](#4--pull-the-repository)
    - [5. ⏰ Schedule _docker compose up_ with _crontab_](#5--schedule-docker-compose-up-with-crontab)
    - [6. 🚀 Start your DNS server](#6--start-your-dns-server)

## 💭 Considerations

- I'm not a Linux or Docker expert, so I'm open to all types of comments and suggestions.
- This setup is open to suggestions and improvements. Feel free to open an issue or a pull request.
- [AdGuardHome.yaml](https://github.com/leostacowski/retrobuntu/blob/main/AdGuardHome.yaml) contains all the settings that will be copied into the Docker image, currently the user and password included in the file are for my personal setup. Also feel free to change anything else you want.
- [compose.yaml](https://github.com/leostacowski/retrobuntu/blob/main/compose.yaml) and [dockerfile](https://github.com/leostacowski/retrobuntu/blob/main/dockerfile) are the files that will be used to build the Docker Container. Feel free to change anything to your setup needs.
- At the end of this setup, your Ubuntu Server VM will be able to receive requests on these URLs:
  - `<your-vm-ip-address>:53` (For UDP and TCP DNS requests);
  - `<your-vm-ip-address>:100` (For AdGuard Home UI);
  - `<your-vm-ip-address>:3000` (For the initial setup page).

## 🔨 Instructions

My motivation for documenting the setup is to hopefully help anyone that, like me, already searched the internet for these keywords and is still stuck in this process:

- "_Assign unique IP address to Docker Containers_";
- "_How to install AdGuard Home on Ubuntu Server_";
- "_How to use port 53 for DNS requests on Ubuntu Server_";
- "_How to run Docker Compose on reboot_";
- "_How to clone a Git repository on Ubuntu Server_".

Hope this helps!

Below are the steps to setup the Ubuntu Server and AdGuard Home DNS server.

### 1. 🖥️ Setup Ubuntu Server

After creating the fresh VM with [Ubuntu Server 24.04.2 LTS](https://ubuntu.com/download/server) (Making sure that it has internet access), run the commands:

- Switch to root user.

```
sudo su
```

- Update and upgrade packages. Then reboot the server.

```
apt update && apt upgrade -y && reboot
```

### 2. 🐋 Setup Docker

Following the steps from the official [Docker documentation](https://docs.docker.com/engine/install/ubuntu/).

- Switch to root user.

```
sudo su
```

```
apt-get install ca-certificates curl
```

```
install -m 0755 -d /etc/apt/keyrings
```

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
```

```
chmod a+r /etc/apt/keyrings/docker.asc
```

```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
```

```
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 3. 🚪 Free up Port 53 from _systemd-resolved_

Based on [this answer from Stack Exchange](https://unix.stackexchange.com/a/676977) and [this Linux Uprising article](https://www.linuxuprising.com/2020/07/ubuntu-how-to-free-up-port-53-used-by.html).

- Switch to root user.

```
sudo su
```

- Edit the _resolved.conf_ file.

```
nano /etc/systemd/resolved.conf

# 1. Change the line "#DNS=" to "DNS=1.1.1.1";
# 2. Change the line "#FallbackDNS=" to "FallbackDNS=8.8.8.8";
# 3. Change the line "#DNSStubListener=yes" to "DNSStubListener=no";
# 4. Save the changes.
```

- Reboot the server.

```
reboot
```

### 4. 📁 Pull the Repository

- Switch to root user.

```
sudo su
```

- Create _adguardhome_ folder.

```
mkdir adguardhome
```

- Enter the folder.

```
cd adguardhome
```

- Init the git repository.

```
git init
```

- Clone this repository.

```
git clone https://github.com/leostacowski/retrobuntu.git
```

### 5. ⏰ Schedule _docker compose up_ with _crontab_

- Switch to root user.

```
sudo su
```

- Edit _crontab_.

```
crontab -e
```

- Add this line at the end of the file (Note that `<ubuntu-server-username>` should be replaced with your Ubuntu Server username):

`@reboot docker compose -f /home/<ubuntu-server-username>/adguardhome/compose.yaml up -d --build --remove-orphans --pull missing`

### 6. 🚀 Start your DNS server

- Switch to root user.

```
sudo su
```

- Start your docker container.

```
# <ubuntu-server-username> should be replaced with your Ubuntu Server username.
docker compose -f /home/<ubuntu-server-username>/adguardhome/compose.yaml up -d --build --remove-orphans --pull missing
```
