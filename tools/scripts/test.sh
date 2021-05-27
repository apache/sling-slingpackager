#!/bin/bash
set -e
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Run tests script.

. tools/scripts/setupenv.sh

cd $RELEASEDIR

# Prepare sling instance and run tests
mkdir sling
cd sling
echo "Downloading Sling jar $SLING_DOWNLOAD"
curl $SLING_DOWNLOAD -o $RELEASEDIR/sling/$SLING_JAR

echo "Starting sling in ${PWD}"
( 
    (
        java -jar $SLING_JAR start & echo $! > sling.pid
    ) >> sling_install.log 2>&1
) &

cd $RELEASEDIR
npm install

cd sling
if (java -jar $SLING_JAR status)
then
    echo "Sling is running."
else
    echo "Sling failed to start. Unable to run tests! Check sling_install.log"
    cat sling_install.log
    exit 1
fi

echo "Sling PID is " & cat sling.pid

# Stop sling before exit for any reason.
function finish {
    echo "Stopping test sling instance."
    cd $RELEASEDIR/sling
    java -jar $SLING_JAR stop
}
trap finish EXIT

# Run tests
cd $RELEASEDIR
npm test

cd $ROOTDIR