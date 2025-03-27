sudo su
apt update && apt upgrade -y && reboot

# install docker
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Setup DNS server
sudo su
nano /etc/systemd/resolved.conf 
# Change "#DNS=" to "DNS=1.1.1.1"
# Change "#FallbackDNS=" to "FallbackDNS=8.8.8.8"
# Change "#DNSStubListener=yes" to "DNSStubListener=no"
# Save file
reboot

# Setup git repository
sudo su
mkdir adguardhome
cd adguardhome
git init
git clone https://github.com/leostacowski/retrobuntu.git

# Start docker
docker compose up -d