#!/bin/bash

umask 022

function display_help {
  echo "Usage: $0 <OUTPUT_PATH>"
  echo "eg. $0 /opt/soe/projects/VSE_Design/`whoami`"
  echo ""
  echo "Create an environment required to build a VSE load based on a design"
  echo "NCGL load."
}

# Only accept one argument
if [ $# -ne 1 ] || [ $1 = "-h" ]
then
  display_help
  exit 1
fi

NCGL_BUILD_OUTPUT_DIR="$1"
shift

if [ ! -d "$NCGL_BUILD_OUTPUT_DIR" ]
then
  echo "Error: Build output directory \"$NCGL_BUILD_OUTPUT_DIR\" doesn't exist." >/dev/stderr
  display_help
  exit 1
fi

if [ ! -d "$OBJPATH" ]
then
  echo "Error: OBJPATH directory does not exist: $OBJPATH" >/dev/stderr
  exit 1
fi

BLADES_CONFIG_DIR="${USE_SRC_ROOT}/vob/ncgl/loadbuild/ntmk/mk/blades_config"

declare -a TARGETS=(i686 i686m i686d ppc ppc970 xscale_be)
declare -a BLADES=(ias atca717_M damascus scx ppc2100 ixp)
declare -a TARGET_DIRS=(_ias_ncgl_1.9_i686 _atca717_M_ncgl_1.9_i686m _damascus_ncgl_1.9_i686d _scx_ncgl_1.9_ppc _ppc2100_ncgl_1.9_ppc970 _ixp_ncgl_1.9_xscale_be)

for ((i = 0 ; i < ${#TARGETS[@]} ; i++ ))
do
  echo "target [$i]: ${TARGETS[$i]}"
  echo "blade [$i]: ${BLADES[$i]}"
  OUTPUT_DIR=$NCGL_BUILD_OUTPUT_DIR/ncgl/${TARGETS[$i]}
  OUTPUT_PKGS_DIR=$OUTPUT_DIR/pkgs
  mkdir -p $OUTPUT_PKGS_DIR
  if [ ! -d "$OUTPUT_PKGS_DIR" ]
  then
    echo "Error: Could not create directory: $OUTPUT_PKGS_DIR" >/dev/stderr
    exit 1
  fi

  SRC_PKGS_DIR="$OBJPATH/${TARGET_DIRS[$i]}/pkgs"
  if [ -d "$SRC_PKGS_DIR" ]
  then
    echo "Copying packages from $SRC_PKGS_DIR to $OUTPUT_PKGS_DIR"
    cp $SRC_PKGS_DIR/* $OUTPUT_PKGS_DIR
  else
    echo "Warning: No pkgs directory found: $SRC_PKGS_DIR" >/dev/stderr
  fi

  FORMAL_BUILD_DIR=`cat $BLADES_CONFIG_DIR/${BLADES[$i]}_build_dir`
  NCGL_BUILD_DIR="$FORMAL_BUILD_DIR/ncgl/nortel_${BLADES[$i]}"
  if [ ! -d "$NCGL_BUILD_DIR" ]
  then
    echo "Warning: No formal build directory found: $NCGL_BUILD_DIR" >/dev/stderr
    echo "Warning: Skipping ${BLADES[$i]} target, no packages copied" >/dev/stderr
    continue
  fi

  cd $OUTPUT_DIR
  ln -fs $NCGL_BUILD_DIR/nortel_${BLADES[$i]}-* $NCGL_BUILD_DIR/RPMS .
  NCGL_PKG_DIR="$NCGL_BUILD_DIR/pkgs"
  NCGL_PKG_COUNT=`find $NCGL_PKG_DIR -type f | wc -l`
  if [ $NCGL_PKG_COUNT -eq 0 ]
  then
    echo "Packages have not been built in $NCGL_PKG_DIR"
    continue
  fi
  cd $OUTPUT_PKGS_DIR

  if [ $NCGL_PKG_COUNT -gt 0 ]
  then
    #Copy the packages that exist in the formal build packages directory but
    #do not exist in the output packages directory
    echo "Copying packages from $NCGL_PKG_DIR to $OUTPUT_PKGS_DIR"
    TEMP_ERROR_FILE="/tmp/prep_vse_build.`whoami`.$$.err"
    copy_pkgs="find $NCGL_PKG_DIR -type f -not -name \.\* | grep -v -E \`ls | perl -e 'while (<>) {chomp; s/([\._]${TARGETS[$i]}[\.-]).*/\$1/; push @lines, \$_;} print join \"\|\", @lines;'\` | xargs --replace cp {} . || touch $TEMP_ERROR_FILE"
    eval $copy_pkgs
    if [ -f $TEMP_ERROR_FILE ]
    then
        rm -f $TEMP_ERROR_FILE
        exit 1
    fi
  fi
done
