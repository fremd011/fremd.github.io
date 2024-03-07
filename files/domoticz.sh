#!/bin/sh
# Domoticz installer script by @lmahmutov

cd /tmp/
echo "Download files"
wget https://github.com/fremd011/openlumi.github.io/raw/master/files/liblua5.3-5.3_5.3.5-4_arm_cortex-a9_neon.ipk
wget https://github.com/fremd011/openlumi.github.io/raw/master/files/lua5.3_5.3.5-4_arm_cortex-a9_neon.ipk
wget https://github.com/fremd011/openlumi.github.io/raw/master/files/domoticz_2022.1-5_arm_cortex-a9_neon.ipk

echo "start installation"
opkg update
opkg install curl git-http libmbedtls12 libustream-mbedtls shadow-usermod
opkg install /tmp/liblua5.3-5.3_5.3.5-4_arm_cortex-a9_neon.ipk
opkg install /tmp/lua5.3_5.3.5-4_arm_cortex-a9_neon.ipk
opkg install /tmp/domoticz_2021.1-1_arm_cortex-a9_neon.ipk

usermod -a -G audio domoticz
usermod -a -G dialout domoticz

echo "Add plugin"
cd /etc/domoticz/plugins/
DIR="iDetect"
if [ -d "$DIR" ]; then
  # Take action if $DIR exists. #
  echo "previous installation find remove it"
  rm -r /etc/domoticz/plugins/iDetect
fi
git clone https://github.com/d-EScape/Domoticz_iDetect.git iDetect
chmod +x iDetect/plugin.py

echo "Moving files and download domoticz config"
mv /var/lib/domoticz/domoticz.db /etc/domoticz/domoticz.db
mv /var/lib/domoticz/domoticz.db-shm /etc/domoticz/domoticz.db-shm
mv /var/lib/domoticz/domoticz.db-wal /etc/domoticz/domoticz.db-wal

sed -i -e "s:option userdata .*:option userdata '/etc/domoticz/':" /etc/config/domoticz

# TODO: consider using sed
wget https://raw.githubusercontent.com/fremd011/openlumi.github.io/master/files/domoticz_init -O /etc/init.d/domoticz
chmod 755 /etc/init.d/domoticz

chown -R domoticz:domoticz /etc/domoticz
echo "Installation complete, reboot"
# reboot
