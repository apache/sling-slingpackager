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

SLING_JAR="org.apache.sling.starter-11.jar"
SLING_DOWNLOAD="https://downloads.apache.org/sling/$SLING_JAR"
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

echo "Copeing release files."

# Copy code to release directory
cp -p -a $ROOTDIR/bin $RELEASEDIR
cp -p -a $ROOTDIR/cmds $RELEASEDIR
cp -p -a $ROOTDIR/utils $RELEASEDIR
cp -p -a $ROOTDIR/test $RELEASEDIR
cp package.json LICENSE NOTICE $RELEASEDIR

cd $RELEASEDIR

# Prepare sling instance and run tests
mkdir sling
cd sling
echo "Downloading Sling jar $SLING_DOWNLOAD"
curl $SLING_DOWNLOAD -o $SLING_JAR

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

# Run tests
cd $RELEASEDIR
npm test

# Stop and remove sling
cd sling
java -jar $SLING_JAR stop
sleep 2
cd $RELEASEDIR
rm -rf sling

# Create release package
npm pack

# Sign release package
echo "Prepare to sign package."
for f in $(find . -type f -name '*.tgz')
do 
    echo "Signing file $f"
    gpg --print-md SHA512 "${f##*/}" > $f.sha512
    gpg --armor --output "$f.asc" --detach-sig "$f"
done

# Upload signed release package to ASF archive

# Now NPM publish (dry run for now)
cd $RELEASEDIR
npm publish apache-sling-slingpackager-*.tgz --access public --dry-run


