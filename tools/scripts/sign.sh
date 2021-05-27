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

# Sign release script.

. tools/scripts/setupenv.sh

cd $RELEASEDIR

# Sign release package
echo "Prepare to sign package."
for f in $(find . -type f -name '*.tgz')
do 
    echo "Signing file $f"
    gpg --print-md SHA512 "${f##*/}" > $f.sha512
    gpg --armor --output "$f.asc" --detach-sig "$f"
done

cd $ROOTDIR