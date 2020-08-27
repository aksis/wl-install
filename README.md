# wl-install
 WebLogic install script

```
sudo groupadd -g 1010 oinstall
sudo useradd -u 1010 -g oinstall -m oracle
sudo mkdir -p /u01/oracle
sudo mkdir -p /u01/wl-install
sudo chown -R oracle:oinstall /u01
```

```
sudo -u oracle sh -c "curl -sSL https://github.com/aksis/wl-install/archive/v0.1.0.tar.gz | tar -xzf - --strip 1 -C /u01/wl-install/"
```

```
sudo -u oracle sh -c "cd /u01/wl-install && ./bin/wl-install.sh -j jdk-8u261-linux-x64.tar.gz -w fmw_12.2.1.4.0_wls.jar"
```
