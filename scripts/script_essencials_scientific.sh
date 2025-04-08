# version SO family fedora
cat /etc/fedora-release
# update
yum install epel-release
rpm -Uvh https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-41.noarch.rpm
rpm -Uvh https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-41.noarch.rpm
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm
yum update
dnf -y update
# Install
yum install -y gstreamer1-plugins-good-extras gstreamer1-plugins-ugly 
yum install -y gstreamer-ffmpeg xine-lib-extras xine-lib-extras-freeworld gstreamer-plugins-bad gstreamer-plugins-bad-free-extras 
yum install -y gstreamer-plugins-bad-nonfree gstreamer1-plugins-bad gstreamer1-plugins-base-tools 
yum install -y smplayer mplayer ffmpeg
yum install -y unzip unrar-free.x86_64 p7zip.x86_64
yum install -y kernel-headers kernel-devel dkms 
dnf -y install libreoffice-langpack-es cheese hunspell hunspell-es 
dnf -y install wget curl nano 
dnf -y install java java-21-openjdk java-21-openjdk-devel 
