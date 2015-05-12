#!/bin/sh
#
# This script determines the chain of directories that describe
# the previous layers (builds) in a NCGL-type product
#
#FIRST_FILE=${ARCH}.prvlrealdir
#FIRST_FILE_PATH=${NTMK_LOCAL_CONFDIR}/blades_config/${FIRST_FILE}

function check_dir () {
 if [ ! -d $1 ]
  then
  echo "Cannot find $1"  >/dev/stderr
  exit 1
 fi
}


ARCH=$1
FIRST_DIR=$2
LOCAL_MK_DIR=$3

#
# Where are we?  We want to know this so we can potentially use a site
# specific file to locate where the "prvlrealdir" is at at that site.
#
# The PRVLREALDIR_ROOT is an anchor prefix that will be specified in the site
# file and can be used to anchor whatever path is specified in the
# actual <arch>.prvlrealdir file.
#
# If a site specific file does not exist then we just do what we had always
# done -- use the simple contents of <arch>.prvlrealdir.
#
SITE=`cat /opt/tools/._ntcad.tree_info  2>/dev/null | grep 'Site' | awk '{print $NF}'`
if [ ! -z "${SITE}" ]; then
    if [ -r ${LOCAL_MK_DIR}/${SITE}.site ]; then
	# This file should export the variable 'PRVLREALDIR_ROOT'
	# If we don't get here it will be empty.
	. ${LOCAL_MK_DIR}/${SITE}.site
    fi
fi


FIRST_FILE=${ARCH}.prvlrealdir
FIRST_FILE_PATH=${FIRST_DIR}/${FIRST_FILE}

if [ ! -f ${FIRST_FILE_PATH} ]
  then
  echo "Cannot find ${FIRST_FILE_PATH}" >/dev/stderr
  exit 1
fi
NEXT_DIR=`cat  ${FIRST_FILE_PATH}`
check_dir  ${PRVLREALDIR_ROOT}${NEXT_DIR}
echo ${PRVLREALDIR_ROOT}${NEXT_DIR}
while [ -f ${PRVLREALDIR_ROOT}${NEXT_DIR}/${FIRST_FILE} ]
  do
  NEXT_DIR=`cat ${PRVLREALDIR_ROOT}${NEXT_DIR}/${FIRST_FILE}`
  check_dir  ${PRVLREALDIR_ROOT}${NEXT_DIR}
  echo ${PRVLREALDIR_ROOT}${NEXT_DIR}
done
