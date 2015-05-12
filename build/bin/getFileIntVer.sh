#!/bin/sh

if [ ! "$toolDEBUG" = "" ]; then
  set -x
fi
#
# If the current version of $1 is identical as contents with the one on its 
# foundation composite baseline $2, return that version of $1 instead
#
STREAM=`/usr/atria/bin/cleartool lsstream -short`
CURRENT_VERSION=`/usr/atria/bin/cleartool ls -short $1 |grep $STREAM`

# If the file is on the integration (actually parent) stream, exit
if [ "$CURRENT_VERSION" = "" ]; then
  exit 0
fi

# Get the version on the integration stream
FOUNDATION_VERSION=`/usr/atria/bin/cleartool lsbl -fmt '%[depends_on_closure]p' $2 | \
tr ' ' '\012' | \
xargs -ibaseline /usr/atria/bin/cleartool lsbl -fmt '%[component]p\040%n\n' baseline | \
grep tools | \
sed -e 's/^[^ ]* //' | \
xargs -ibaseline /usr/atria/bin/cleartool describe -short $1@@/baseline 2>/dev/null`

# Compare the current version and the one on the integration stream
if [ -n "$FOUNDATION_VERSION" ]; then
  diff $1 $FOUNDATION_VERSION 2>&1 >/dev/null &&  echo $FOUNDATION_VERSION
fi
   

