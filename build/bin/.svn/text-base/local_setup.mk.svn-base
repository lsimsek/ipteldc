#
# local_setup.mk
#

# Some tools and configs used 
FAM_TGT_LIST := ${USE_SRC_ROOT}/vobs/lsba_platform_tools/build/config/fam-tgt.list
FAM_CARCH_LIST := ${USE_SRC_ROOT}/vobs/lsba_platform_tools/build/config/fam-carch.list
GET_ARCH :=  ${USE_SRC_ROOT}/vobs/lsba_platform_tools/build/bin/getArch
FAM_PNE_LIST := ${USE_SRC_ROOT}/vobs/lsba_platform_tools/build/config/fam-pne.list

#+++++++++++++++++++++++++++++++++++++++++++
ifeq ($(ntmkbw_PRODUCTID),ha)
  # Include the board definition file
  ifdef FAM
    include $(NTMK_LOCAL_MKDIR)/blades_config/$(TGT)_$(FAM).in
    export BUILT_PKGS
  endif
endif
#+++++++++++++++++++++++++++++++++++++++++++

# Compiler architecture
  export _CARCH := $(strip $(shell $(GET_ARCH) -m $(FAM) -f $(FAM_CARCH_LIST)))

ifneq ($(ntmkbw_PRODUCTID),ha)
 ifneq ($(ntmkbw_PRODUCTID),wrs)
  PKG_VERSION_VERIFY := $(strip $(shell echo $(PKG_VERSION) | grep -q -E "^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:alnum:]]+\.[[:digit:]]+$$" >/dev/null 2>&1 && echo -n "yes" || echo -n "no"))

  ifeq ($(PKG_VERSION_VERIFY),no)
    $(error ERROR: Incorrect PKG_VERSION format. PKG_VERSION must match major.minor.mr.build.patch, where 'build' consists of alphanumeric characters and all other components are numbers.)
    _x := $(shell echo 'ERROR: Incorrect PKG_VERSION format. PKG_VERSION must match major.minor.mr.build.patch, where 'build' consists of alphanumeric characters and all other components are numbers.' 1>&2)
    error
  endif
 endif
endif

# Trim <patch> digits.
export CNP_VERSION_INSTDIR:=$(basename $(PKG_VERSION))

#Other vars 
export LM_PROJECT := $(USE_LM_PROJECT)

# The SYSROOT
ifdef FORMAL_BUILD_DIR
  # Add the path to the libs path
    export NCGL_SYSTEM_ROOT_ARCH := $(FORMAL_BUILD_DIR)/root/$(ntmkbw_PRODUCTID)_$(TGT)_$(FAM)/$(_CARCH)
    ifdef NCGL_SYSTEM_ROOT_READLINK
      export NCGL_SYSTEM_ROOT_ARCH := $(shell readlink -f $(FORMAL_BUILD_DIR)/root/$(ntmkbw_PRODUCTID)_$(TGT)_$(FAM)/$(_CARCH))
    else
      export NCGL_SYSTEM_ROOT_ARCH := $(FORMAL_BUILD_DIR)/root/$(ntmkbw_PRODUCTID)_$(TGT)_$(FAM)/$(_CARCH)
    endif
else
  ifdef NCGL_SYSTEM_ROOT
    export NCGL_SYSTEM_ROOT_ARCH := $(NCGL_SYSTEM_ROOT)/$(_CARCH)
  else
    export NCGL_SYSTEM_ROOT_ARCH := $(OBJPATH)/root/$(ntmkbw_PRODUCTID)_$(TGT)_$(FAM)/$(_CARCH)
  endif
endif

ifndef NCGL_SYSTEM_ROOT
  export NCGL_SYSTEM_ROOT := $(subst /%%%,,$(dir $(NCGL_SYSTEM_ROOT_ARCH))%%%)
endif

export TOPDIR
export NCGLVER := $(ntmkbw_NCGLVER)

DUMMY := $(shell echo NCGL_SYSTEM_ROOT = $(NCGL_SYSTEM_ROOT) 1>&2)

# Set the target arch:
ifndef OS
  OS := ncgl
endif

# PNE-LE 3.0 variable
  export pne_le_version := $(strip $(shell $(GET_ARCH) -m $(FAM) -f $(FAM_PNE_LIST)))

ifdef FAM
  IMAGE_$(FAM) := $(NCGL_SYSTEM_ROOT)/$(_CARCH)
  TARGET_VAR := $(TGT)
  TARGET_ARCH := $(OS) $(NCGLVER)  $(FAM)

  TC_VERSION_WRL_43 = wrll-toolchain-4.4a-341
  TC_VERSION_WRL_33 = wrll-toolchain-4.3a-291
  TC_VERSION_WRL_30 = wrll-toolchain-4.3-85
  TC_VERSION_WRL_14 = wrs1.4-3.4.4_aa
  COMPILER_VERSION ?= $(TC_VERSION_WRL_$(pne_le_version))
  COMPILER_VERSION ?= unknown

  COMPILER_VER := $(_CARCH)-$(COMPILER_VERSION)
  # Put the compiler in the path
  COMPILER_PATH := $(shell $$vulcanbasePATH/bin/toolpath ncgl $(COMPILER_VER))/bin
  export PATH := $(COMPILER_PATH):$(PATH)
  TOOL_PREFIX := $(COMPILER_VER)-
endif
export NCGL_PNE_LE_VERSION=$(pne_le_version)

# See if we are changing the behaviour of the licproxy. 
# If BYPASS_LIC_PROXY exists, it is included at this point.
# It could contain:
#
#       # Bypass the licproxy
#       export NCGL_BYPASS_LIC_PROXY=y
#
# Or it could change one or more of the licproxy settings:
#
#       # Turn on debugging (always needed)
#       export DEBUG_WRS_PROXY=y
#       # One or more of the following
#       # Path to the license proxy data file
#       export LM_LICENSE_FILE=<path>
#       # Dir PATH containing the proxy executable
#       export WIND_LIC_PROXY=<path>
#       # Dir PATH to a new get_feature executable
#       export NCGL_BYPASS_LIC_PROXY="y"
#       export NCGL_ALT_GETFEATURE_PATH="<path>"

-include $(NTMK_LOCAL_MKDIR)/BYPASS_LIC_PROXY

# This is hard to explain, but winkin works better if:
# If the current version of packageMappings.list is identical as content
# to the one on the integration stream, use that one
ifdef PKGTOOLS_MAPLIST_CONFIG_FILE
  export PKGTOOLS_MAPLIST_CONFIG_FILE
endif

GNUMAKE := make
PKGTOOL = ${USE_SRC_ROOT}/vobs/lsba_platform_tools/pkgtool/bin/pkgtool
WRAPIT = ${USE_SRC_ROOT}/vobs/lsba_platform_tools/pkgtool/bin/wrapit

XML2CTOOL      = ${USE_SRC_ROOT}/vobs/lsba_platform_tools/xml2c/bin/xml2c
XML2Cv2        = ${USE_SRC_ROOT}/vobs/lsba_platform_tools/xml2c/bin/xml2cV2
XML2CWRAPPER   = ${USE_SRC_ROOT}/vobs/lsba_platform_tools/xml2c/bin/xml2cwrapper
XML2CWRAPPER2  = ${USE_SRC_ROOT}/vobs/lsba_platform_tools/xml2c/bin/xml2cwrapper2
XMLCHECKCMD    = ${USE_SRC_ROOT}/vobs/lsba_platform_tools/xml_validator/bin/validateXml
OAM_CONFIG_XSD = ${USE_SRC_ROOT}/vobs/lsba_platform_tools/xml2c/templates/schemas/oamConfigDm.xsd
XMLSCHEMADIR   = ${USE_SRC_ROOT}/vobs/lsba_platform_tools/xml_validator/templates/schemas

JAVACMD := java
ANT := ant
#
# Source Kernel Build tool; the -n option returns the Make arguments
# that should be used for building the kernel/KLMs.
#
SKERNB := ${USE_SRC_ROOT}/vobs/lsba_platform_tools/build/bin/skernb

#
# KLM Make arguments [cuts off $(MAKE) bit].
# We have to export CC and COMPILER_PATH because they are not available
# in the shell.
#
WRSBUILDMK = $(wildcard $(ROOT)/usr/src/linux/wrsBuild.mk)
#ifneq ($(WRSBUILDMK),)
KLM_MK_ARGS = $(shell export CC=$(CC) && export COMPILER_PATH=$(COMPILER_PATH) && $(SKERNB) -n <$(WRSBUILDMK) 2>/dev/null | cut -c 7-)
#endif

#
# KLM build rule.
#
define klm_rule
	cd $(CURRDIR) && \
	$(GMAKE) $(KLM_MK_ARGS) -C $(ROOT)/usr/src/linux M=`pwd` modules
endef

#
# KLM standard clean.
#
define klm_clean
	cd $(CURRDIR) && \
	rm -rf *.ko *.o *.mod.c *.mod.o .*.o.cmd .*.ko.cmd .tmp_versions
endef

define klm_rule_objdir
	mkdir -p  $(OBJDIR) && cp $(CURRDIR)/* $(OBJDIR) && \
	chmod 664 $(OBJDIR)/* && \
	cd $(OBJDIR) && \
	$(GMAKE) $(KLM_MK_ARGS) -C $(ROOT)/usr/src/linux M=`pwd` modules
endef



# Init some user targets:
AL_XDRFILES :=
AL_SMFILES :=

# Compiler options to be used for all MIPS targets
ge_mips_CXXFLAGS += -fno-omit-frame-pointer -fno-optimize-sibling-calls
ge_mips_CXXFLAGS64 += -fno-omit-frame-pointer -fno-optimize-sibling-calls
ge_mips_CFLAGS += -fno-omit-frame-pointer -fno-optimize-sibling-calls
ge_mips_CFLAGS64 += -fno-omit-frame-pointer -fno-optimize-sibling-calls
mot_mips_CXXFLAGS += -fno-omit-frame-pointer -fno-optimize-sibling-calls
mot_mips_CXXFLAGS64 += -fno-omit-frame-pointer -fno-optimize-sibling-calls
mot_mips_CFLAGS += -fno-omit-frame-pointer -fno-optimize-sibling-calls
mot_mips_CFLAGS64 += -fno-omit-frame-pointer -fno-optimize-sibling-calls

# Overriding VARLIST definition from NTMK
# to allow family / target builds
# For all the following variables, the targets will not build what was already built for the family, e.g.PROGRAMS or <fam>_PROGRAMS
# Removing USERBUILDABLETARGETS variable and adding the value of it. USERBUILDABLETARGETS is define in local_mkfiledefs.mk which executes after local_setup.mk
TGT_SKIPPED_TARGETS := $(addprefix %,PROGRAMS PROGRAMS64 LIBRARIES LIBRARIES64 PACKAGES PACKAGES64 INSTALLS FILES IFILES GATES TGATE XMLCHECK XDRFILES SMFILES)

ifneq ($(TGT),fam)
VARLIST = $(strip \
            $(foreach v,$(TARGET_VAR) $(PLATFORM_ALIASES),$(foreach os,$(_ostypelist),$($(v)_$(os)_$(TARGET_MACH)_$(strip $(_vartype))))) \
            $(foreach v,$(TARGET_VAR) $(PLATFORM_ALIASES),$(foreach os,$(_ostypelist),$($(v)_$(os)_$(strip $(_vartype))))) \
            $(foreach v,$(TARGET_VAR) $(PLATFORM_ALIASES),$($(v)_$(TARGET_MACH)_$(strip $(_vartype)))) \
            $(foreach os,$(_ostypelist),$($(os)_$(TARGET_MACH)_$(strip $(_vartype)))) \
            $($(filter-out $(TGT_SKIPPED_TARGETS),$(TARGET_MACH)_$(strip $(_vartype)))) \
            $(foreach os,$(_ostypelist),$($(os)_$(strip $(_vartype)))) \
            $(foreach v,$(TARGET_VAR) $(PLATFORM_ALIASES),$($(v)_$(strip $(_vartype)))) \
            $($(filter-out $(TGT_SKIPPED_TARGETS),_$(strip $(_vartype)))) \
            $($(filter-out $(TGT_SKIPPED_TARGETS),$(strip $(_vartype)))))
endif

# Adding the portage setup

# Everything goes under this directory, unless overriden
IMAGEOUTPUT_LOCATION ?= $(OBJPATH)/images

#
# Portage variables:
#

# To set name of the image
 IMAGE_$(FAM)_$(TGT)_$(FAM) := $(IMAGE_$(FAM))

# I might want to override afs to place it conveniently
# Where image / sysroot is created by portage
IMAGE_$(FAM)_afs           ?= $(IMAGE_$(FAM))

# The locations of the compiler and tools.

export ROOTtools=$(shell toolpath)
export ROOTcompiler=$(shell toolpath)
TPSunpack:=$(GFQTOPDIR)/base_os/tools/bin/TPSunpack

# The location of the tarballs and ebuilds for '3rd party code'.
# Note: GFQTOPDIR/3rdpty is already included by default.

export NTMK3rdpty=$(CURDIR) \
                  /vob/ncgl/windriver/pkg_cache \
                  /vob/ncgl/base_os/nortel \
                  /vob/ncgl/base_os/wrs \
                  /opt/corp/projects/mce_dev/portage/nortel
export NTMK3rdptyWorkingDirs=/localdisk/viewstore $(TMPDIR) /tmp $(GFQCOMPATH)
export NTMK3rdptyWorkingSpace=1000000

# Needed in Portage for RPMs creation
ifndef CREATE_TARS 
  TPSunpack:=$(GFQTOPDIR)/base_os/tools/bin/TPSunpack
  export aPKGer=$(USE_SRC_ROOT)/vob/ncgl/base_os/tools/bin/tPKGer
  export tPKGer=$(USE_SRC_ROOT)/vob/ncgl/base_os/tools/bin/tPKGer
  export PKGext=rpm
endif
#
export _RPMARCH := $(_CARCH)

ifndef LICENCE_SETUP_COM
  FlexlmrcHomeOrig := $(shell echo "Original HOME: $(HOME)" 1>&2)
  export LM_LICENSE_FILE=$(shell grep -E -q "^`id -un`$$" /opt/corp/projects/cmtools/rtd_licensing/gb_wrsusers  && echo /opt/tools/licenses/wrs_gb || echo /opt/tools/licenses/wrs_na)
  export DEBUG_WRS_PROXY=1
  export HOME := $(shell h=`eval ls -d ~\`id -un\``; echo $${h:-/tmp/`id -un`})/flexlmrc
  FlexlmrcClear := $(shell mkdir -p $(HOME); rm -f $(HOME)/.flexlmrc)
  FlexlmrcHome := $(shell echo "Flexlmrc HOME set to: $(HOME)" 1>&2)
  FlexlmrcLicense := $(shell echo "Using Flexlm license: $(LM_LICENSE_FILE)" 1>&2)
  export LICENCE_SETUP_COM=done
endif




# This is a bug in NTMK, HOST_CC etc. are not set correctly in a recursive invocation of NTMK
# See setup.mk
ifdef HOST_CC
  HOST_CC := $(HOST_CC)
endif
