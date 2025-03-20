service xrdp stop
useradd -m $(printenv SSH_USER)
echo "$(printenv SSH_USER):$(printenv SSH_PASS)" | chpasswd
usermod -aG sudo $(printenv SSH_USER)
service xrdp start
sleep infinity