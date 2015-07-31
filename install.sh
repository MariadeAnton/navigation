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
 
set -e  # exit on error
set -u  # exit on unset var
 
$DIR/scripts/install_dependencies.sh 
. $DIR/scripts/shared.sh 
 
set +u # ROS setup.bash script can't be run in a strict bash
sourceROS
set -u
 
#cd $DIR
#if [ ! -f $DIR/.catkin_workspace ]; then
# Set up a ROS workspace
#    cd src 
#    catkin_init_workspace
#    cd ..
#fi
 
#catkin_make
bash
