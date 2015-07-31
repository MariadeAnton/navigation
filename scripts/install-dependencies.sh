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

echo $DIR
source $DIR/shared.sh

set +e && sourceROS && set -e # ROS setup.bash can't be run in a strict bash :(

# Manage ROS installation
if[ $ROS_DISTRO == "indigo"]; then
  echo "ROS $ROS_DISTRO seems already installed. Calling apt-get install again to make sure"
 
  # Check Ubuntu release
  codename=`lsb_release --codename | cut -f2`
  case $codename in
    # | --- indigo --- |   
    # | 13.10 |  14.04 |
    "saucy"|"trusty");;
    *) 	echo "Ubuntu  `lsb_release --release | cut -f2` not officially supported. Manual installation is suggested."
    if confirm; then
      exit
    fi;;
  esac

  # Install ROS
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu" `lsb_release --codename | cut -f2` "main" > /etc/apt/sources.list.d/ros-latest.list'
  sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116
  sudo apt-get update
  if [ ! -z "$(apt-cache search ros-indigo-desktop-full)" ]; then
    export ROS_DISTRO=indigo
  else
    echo "ROS indigo cannot be automatically installed on the current OS. Please proceed manually."
    exit
  fi

  sudo apt-get install -y ros-$ROS_DISTRO-desktop-full
  source /opt/ros/$ROS_DISTRO/setup.bash
  set +e # need to do this because thie following yields error on existing ROS installations
  sudo rosdep init | sed "s/ERROR: default/WARNING: default/"
  rosdep update
  set -e 
else
  echo "ROS $ROS_DISTRO is installed, but not officially supported."
  if confirm; then
    exit
  fi

