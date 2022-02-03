#!/bin/bash

#  Copyright (C) 2018-2021 LEIDOS.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); you may not
#  use this file except in compliance with the License. You may obtain a copy of
#  the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#  License for the specific language governing permissions and limitations under
#  the License.

# CARMA packages checkout script
# Optional argument to set the root checkout directory with no ending '/' default is '~'

set -exo pipefail

dir=~
while [[ $# -gt 0 ]]; do
      arg="$1"
      case $arg in
            -d|--develop)
                  BRANCH=develop
                  shift
            ;;
            -r|--root)
                  dir=$2
                  shift
                  shift
            ;;
      esac
done

if [[ "$BRANCH" = "develop" ]]; then
      git clone https://github.com/usdot-fhwa-stol/carma-msgs.git ${dir}/src/CARMAMsgs --branch $BRANCH
      git clone https://github.com/usdot-fhwa-stol/carma-utils.git ${dir}/src/CARMAUtils --branch $BRANCH
else
      git clone https://github.com/usdot-fhwa-stol/carma-msgs.git ${dir}/src/CARMAMsgs --branch carma-system-3.11.0
      git clone https://github.com/usdot-fhwa-stol/carma-utils.git ${dir}/src/CARMAUtils --branch carma-system-3.11.0
fi

# Required to build the dbw_pacifica_msgs message set.
git clone https://github.com/NewEagleRaptor/raptor-dbw-ros.git ${dir}/src/raptor-dbw-ros --branch master 
cd ${dir}/src/raptor-dbw-ros
git reset --hard f50f91cd88ad27b2ce05bab1f8ff780931c41475
cd ${dir}

# Required for ford fusion drive by wire
git clone https://bitbucket.org/DataspeedInc/dbw_mkz_ros.git ${dir}/src/dbw-mkz-ros --branch 1.2.4

git clone https://github.com/astuff/pacmod3.git ${dir}/src/pacmod3 --branch ros1_master
cd ${dir}/src/pacmod3
git reset --hard 4e5e9cd5e821f4f19e31e10ba42f20449860b940
cd ${dir}

git clone https://github.com/astuff/kvaser_interface.git ${dir}/src/kvaser_interface --branch ros1_master
cd ${dir}/src/kvaser_interface
git reset --hard e2aa169e32577f2468993b89edf7a0f67d1e7f0e
cd ${dir}

sudo apt-get install -y apt-utils
source /opt/autoware.ai/ros/install/setup.bash
cd ${dir}/
rosdep install --from-paths src --ignore-src -r -y
