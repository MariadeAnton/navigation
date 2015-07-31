#!/bin/bash
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET="$(readlink "$SOURCE")"
  if [[ $SOURCE == /* ]]; then
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

echo "Current directory: "$DIR
source $DIR/shared.sh
sourceROS

set +e
# Check Ubuntu release
#codename=`lsb_release --codename | cut -f2`
#echo "Ubuntu "$codename
#case $codename in
#  # | --- indigo --- |   
#  # | 13.10 |  14.04 |
#  "saucy"|"trusty");;
#  *) 	echo "Ubuntu `lsb_release --release | cut -f2` not supported. Manual installation is suggested."
#  if confirm; then
#    exit
#  fi;;
#esac

# Install ROS hydro
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu precise main" > /etc/apt/sources.list.d/ros-latest.list' 
wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -
sudo apt-get update
if [ ! -z "$(apt-cache search ros-hydro-desktop-full)" ]; then
  export ROS_DISTRO=hydro
else
  echo "ROS hydro cannot be automatically installed on the current OS. Please proceed manually."
  exit
fi

# Install ROS indigo
#sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu" `lsb_release --codename | cut -f2` "main" > /etc/apt/sources.list.d/ros-latest.list'
#sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116
#sudo apt-get update
#if [ ! -z "$(apt-cache search ros-indigo-desktop-full)" ]; then
#  export ROS_DISTRO=indigo
#else
#  echo "ROS indigo cannot be automatically installed on the current OS. Please proceed manually."
#  exit
#fi

sudo apt-get install -y ros-$ROS_DISTRO-desktop-full
source /opt/ros/$ROS_DISTRO/setup.bash
sudo rosdep init | sed "s/ERROR: default/WARNING: default/"
rosdep update

# Other ROS packages
sudo apt-get install -y ros-hydro-cmake-modules
#other packages
sudo apt-get install libpgm-dev
set -e
