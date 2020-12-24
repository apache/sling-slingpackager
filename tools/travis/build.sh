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

# Build script for Travis-CI.

# Update this when creating a new release
RELEASE_VERSION="0.0.5"

PACK_NAME="slingpackager"
SCRIPTDIR=$(cd $(dirname "$0") && pwd)
ROOTDIR=$(cd $SCRIPTDIR/../.. && pwd)
RELEASEDIR="$ROOTDIR/releases/$PACK_NAME"

# Scan code
mvn apache-rat:check

echo "Code scan successful."

# Make new release directory
if [ -d "$RELEASEDIR" ] 
then
    rm -rf $RELEASEDIR
fi
mkdir -p $RELEASEDIR

echo "Creating release."

# Copy code to release directory
cp -p -a $ROOTDIR/bin $RELEASEDIR
cp -p -a $ROOTDIR/cmds $RELEASEDIR
cp -p -a $ROOTDIR/utils $RELEASEDIR
cp -p -a $ROOTDIR/test $RELEASEDIR
cp package.json LICENSE NOTICE $RELEASEDIR

cd $RELEASEDIR
npm pack

# Sign the release


