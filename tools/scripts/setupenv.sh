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

export SLING_JAR="org.apache.sling.starter-11.jar"
export SLING_DOWNLOAD="https://downloads.apache.org/sling/$SLING_JAR"
export PACK_NAME="slingpackager"
export SCRIPTDIR=$(cd $(dirname "$0") && pwd)
export ROOTDIR=$(cd $SCRIPTDIR/../.. && pwd)
export RELEASEDIR="$ROOTDIR/releases/$PACK_NAME"

# echo "ROOTDIR is $ROOTDIR"
# echo "RELEASEDIR $RELEASEDIR"
