#!/bin/sh
cd ~
mkdir temp
cd temp

cd ~/temp
wget http://plex-net.co.jp/plex/px-s1ud/PX-S1UD_driver_Ver.1.0.1.zip
unzip PX-S1UD_driver_Ver.1.0.1.zip
sudo cp PX-S1UD_driver_Ver.1.0.1/x64/amd64/isdbt_rio.inp /lib/firmware/

sudo apt install build-essential git build-essential pkg-config cmake gcc autoconf automake curl git-core vainfo pcscd libpcsclite-dev libccid pcsc-tools pkg-config -y

cd ~/temp
wget https://github.com/stz2012/libarib25/archive/master.zip
unzip master.zip
cd libarib25-master
cmake .
make all
sudo make install
cd ../

cd ~/temp
wget http://www13.plala.or.jp/sat/recdvb/recdvb-1.3.2.tgz
tar xvzf recdvb-1.3.2.tgz
cd recdvb-1.3.2
./autogen.sh
./configure  --enable-b25
make all
sudo make install
cd ../

cd ~/temp
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash
sudo apt install -y nodejs
sudo npm install pm2 -g
sudo npm install mirakurun -g --unsafe-perm --production
sudo npm install arib-b25-stream-test --unsafe
sudo pm2 install pm2-logrotate

sudo apt install python python3 python2 -y
cd ~/
git clone git://github.com/kanreisa/Chinachu.git ~/chinachu
cd ~/chinachu/
./chinachu installer

cd ~/chinachu/usr
MACHINE=`uname -m`
FFMPEG_FN=="ffmpeg-release-i686-static"
case ${MACHINE} in
  "x86_64")
    FFMPEG_FN="ffmpeg-release-amd64-static"
    ;;
  "aarch64")
    FFMPEG_FN="ffmpeg-release-arm64-static"
    ;;
  "armv8l")
    FFMPEG_FN="ffmpeg-release-arm64-static"
    ;;
  "armv7l")
    FFMPEG_FN="ffmpeg-release-armhf-static"
    ;;
  "armv6l")
    FFMPEG_FN="ffmpeg-release-armel-static"
    ;;
esac

FFMPEG_XZ="https://johnvansickle.com/ffmpeg/releases/${FFMPEG_FN}.tar.xz"

wget -O ${FFMPEG_FN}.tar.xz $FFMPEG_XZ
xz -dv "${FFMPEG_FN}.tar.xz"

tar -xvf "${FFMPEG_FN}.tar" -C bin --strip-components 1
rm -v "${FFMPEG_FN}.tar"

cd ~/chinachu/usr/bin
rm -rfv "avconv"
rm -rfv "avprobe"
ln -sv "ffmpeg" "avconv"
ln -sv "ffprobe" "avprobe"

cd ~/chinachu/.nave
rm -rfv "node"
rm -rfv "npm"
ln -sv "/usr/bin/node" "node"
ln -sv "/usr/bin/npm" "npm"
cd ~/chinachu

cp config.sample.json config.json
nano config.json
sudo cp ./tuners.yml /usr/local/etc/mirakurun/tuners.yml
sudo cp ./channels.yml /usr/local/etc/mirakurun/channels.yml
sudo cp ./server.yml /usr/local/etc/mirakurun/server.yml
./chinachu service wui execute
sudo nano /etc/logrotate.d/chinachu
