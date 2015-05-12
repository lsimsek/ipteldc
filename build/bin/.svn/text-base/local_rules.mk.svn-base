#
# local_rules.mk -- Project-specific rules
#

#
# Table containing the dependency rules
# The rules are in the form: <vob>/<layer>_USES  := <dependencies_list>
#
include $(NTMK_LOCAL_MKDIR)/uses_list.mk


ntmkbld_NOTHING := 
ntmkbld_SPACE := $(ntmkbld_NOTHING) $(ntmkbld_NOTHING)

#
# Now stick these dependencies in the CPPFLAGS
#
#
ifndef __ENDDIR
  __ENDDIR := 2
endif

~xCPPFLAGS_r += $(addsuffix /public_inc,$(addprefix -I$(TOPDIR)/,$($(subst $(ntmkbld_SPACE),/,$(wordlist 1,$(__ENDDIR),$(subst /, ,$(patsubst $(TOPDIR)/%,%,$(patsubst $(TARGOBJDIR)/%,%,$(<D))))))_USES)))

~xCPPFLAGS_r64 += $(addsuffix /public_inc,$(addprefix -I$(TOPDIR)/,$($(subst $(ntmkbld_SPACE),/,$(wordlist 1,$(__ENDDIR),$(subst /, ,$(patsubst $(TOPDIR)/%,%,$(patsubst $(TARGOBJDIR64)/%,%,$(<D))))))_USES)))

# We want to always have a -I$(TOPDIR)/<vob>/<layer>/inc in the compile rules

~xCPPFLAGS_r += -I$(TOPDIR)/$(subst $(ntmkbld_SPACE),/,$(wordlist 1,$(__ENDDIR),$(subst /, ,$(patsubst $(TOPDIR)/%,%,$(patsubst $(TARGOBJDIR)/%,%,$(<D))))))/inc

~xCPPFLAGS_r64 += -I$(TOPDIR)/$(subst $(ntmkbld_SPACE),/,$(wordlist 1,$(__ENDDIR),$(subst /, ,$(patsubst $(TOPDIR)/%,%,$(patsubst $(TARGOBJDIR64)/%,%,$(<D))))))/inc

#And some other standard stuff
~CPPFLAGS_r += -I$(ROOT)/usr/include/glib-2.0  -I$(ROOT)/usr/lib/glib-2.0/include

~CPPFLAGS_r64 += -I$(ROOT)/usr/include64/glib-2.0 \
                 -I$(ROOT)/usr/lib64/glib-2.0/include

# Add the family include directory
~CPPFLAGS_r += -I$(subst _$(TGT)_,_fam_,$(FQTARGOBJDIR))/include

~CPPFLAGS_r64 += -I$(subst _$(TGT)_,_fam_,$(FQTARGOBJDIR64))/include64 \
                 -I$(subst _$(TGT)_,_fam_,$(FQTARGOBJDIR))/include

### CR Q02172169 -- OBJPATH family libs dirs should come before Formal Build dir family link. 
# Add family libs dir
_SYS_LDFLAGS +=  -L$(subst _$(TGT)_,_fam_,$(FQTARGOBJDIR))/lib  -Wl,-rpath-link=$(subst _$(TGT)_,_fam_,$(FQTARGOBJDIR))/lib
_SYS_LDFLAGS64 +=  -L$(subst _$(TGT)_,_fam_,$(FQTARGOBJDIR64))/lib64 \
               -Wl,-rpath-link=$(subst _$(TGT)_,_fam_,$(FQTARGOBJDIR64))/lib64



ifneq ($(FORMAL_BUILD_DIR),)

  # Need to add the target lib and include dirs from FORMAL BUILD DIR when we are building the target
  ifneq ($(TGT),fam)

    ~CPPFLAGS_r += -I$(FORMAL_BUILD_DIR)/_$(TGT)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)/include
    ~CPPFLAGS_r64 += -I$(FORMAL_BUILD_DIR)/_$(TGT)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)64/include \
                     -I$(FORMAL_BUILD_DIR)/_$(TGT)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)/include

    _SYS_LDFLAGS +=  -L$(FORMAL_BUILD_DIR)/_$(TGT)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)/lib  -Wl,-rpath-link=$(FORMAL_BUILD_DIR)/_$(TGT)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)/lib
    _SYS_LDFLAGS64 +=  -L$(FORMAL_BUILD_DIR)/_$(TGT)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)64/lib64  -Wl,-rpath-link=$(FORMAL_BUILD_DIR)/_$(TGT)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)64/lib64
  endif

  ~CPPFLAGS_r += -I$(FORMAL_BUILD_DIR)/_fam_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)/include
  ~CPPFLAGS_r64 += -I$(FORMAL_BUILD_DIR)/_fam_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)64/include \
                   -I$(FORMAL_BUILD_DIR)/_fam_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)/include

  # Need to add family lib dir from FORMAL BUILD DIR
  _SYS_LDFLAGS +=  -L$(FORMAL_BUILD_DIR)/_fam_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)/lib  -Wl,-rpath-link=$(FORMAL_BUILD_DIR)/_fam_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)/lib
  _SYS_LDFLAGS64 +=  -L$(FORMAL_BUILD_DIR)/_fam_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)64/lib64  -Wl,-rpath-link=$(FORMAL_BUILD_DIR)/_fam_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)64/lib64

endif

# Define macros for release variables, if the variables are defined
ifneq ($(VSE_RELEASE),)
  ~CPPFLAGS_r += -D'VSE_RELEASE="$(VSE_RELEASE)"'
  ~CPPFLAGS_r64 += -D'VSE_RELEASE="$(VSE_RELEASE)"'
endif

ifneq ($(APP_RELEASE),)
  ~CPPFLAGS_r += -D'APP_RELEASE="$(APP_RELEASE)"'
  ~CPPFLAGS_r64 += -D'APP_RELEASE="$(APP_RELEASE)"'
endif

# xscale_be still builds with PNE-LE 1.1

ifeq ($(FAM),xscale_be)
  ~CPPFLAGS_r += -DRUNNING_ON_PNE_LE_1_1
  ~CPPFLAGS_r64 += -DRUNNING_ON_PNE_LE_1_1
endif

# Some project wide LDFLAGS
#
_SYS_LDFLAGS += -Wl,-rpath=/usr/local/lib
_SYS_LDFLAGS64 += -Wl,-rpath=/usr/local/lib64


#+++++++++++++++++++++++++++++++++++++++++++++++
ifndef TPS_RELPATH
  ifeq ($(ntmkbw_PRODUCTID),ha)
     TPS_RELPATH := ../../../shared/thirdparty
  else
     TPS_RELPATH := ../../../thirdparty
  endif
endif
#+++++++++++++++++++++++++++++++++++++++++++++++

#
# Items to clobber...
#
CLOBBERALL += $(OBJPATH)/root 
CLOBBERALL += $(OBJPATH)/ncl

# If the build is not incremental (it is a full designer build, with its own sysroot),
# delete all the sysroots (for all architectures) too
ifndef FORMAL_BUILD_DIR
  CLOBBERALL += $(wildcard $(NCGL_SYSTEM_ROOT)/../*)
endif

DOC_APIFILES := $(wildcard $(NTMK_LOCAL_MKDIR)/blades_config/doc.apifiles)

top: do_mk top_no_mk
.NOTPARALLEL: do_mk top_no_mk

do_mk:
	@echo; echo "Generating makefile fragments `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(RMAKE) $(_MAKEFLAGS) mk
  ifneq ($(ntmkbw_PRODUCTID),wrs)
	@+cd $(NTMK_LOCAL_MKDIR)/$(TPS_RELPATH) && $(RMAKE) $(_MAKEFLAGS) mk DO_ALL_MK=1
  endif
top_no_mk:
  ifneq ($(filter ha wrs,$(ntmkbw_PRODUCTID)),)
   ifndef SKIP_WRS # This line will be deleted
	@echo Preparing the thirdparty software...
	@+cd $(GFQTOPDIR)/base_os/config/$(FAM)/$(TGT) &&  export BINTAP_BUILD_ENABLED=N  &&  $(GMAKE) $(_MAKEFLAGS) MAKECMDGOALS=mk mk CC_JOBFLAG= 
   endif  # This line will be deleted
  endif
  ifneq ($(ntmkbw_PRODUCTID),wrs)
	@echo; echo "Installing binary packages `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(RMAKE) $(_MAKEFLAGS)  pkgs_in  CC_JOBFLAG=
	@echo; echo "Starting 3rd party code build `date "+%F %X"`"; echo
  endif
  ifneq ($(filter ha wrs,$(ntmkbw_PRODUCTID)),)
   ifndef SKIP_WRS # This line will be deleted
	@+cd $(GFQTOPDIR)/base_os/config/$(FAM)/$(TGT) && export BINTAP_BUILD_ENABLED=N &&  $(GMAKE) $(_MAKEFLAGS) MAKESTYLE=recurs $(subst -J,-j,$(CC_JOBFLAG))
   else
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(RMAKE) $(_MAKEFLAGS) expandwrsapi CC_JOBFLAG=
   endif  # This line will be deleted
  endif
  ifneq ($(ntmkbw_PRODUCTID),wrs)
	@+cd $(NTMK_LOCAL_MKDIR)/$(TPS_RELPATH) && $(GMAKE) $(_MAKEFLAGS) MAKESTYLE=recurs  $(subst -J,-j,$(CC_JOBFLAG))
	@echo; echo "Starting $(ntmkbw_PRODUCTID) code build"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS) setup
    ifneq (,$(filter $(ntmkbw_PRODUCTID),ha Siren ssg))
      ifneq ($(DOC_APIFILES),)
	@echo; echo "Starting $(ntmkbw_PRODUCTID) datamodel `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS) datamodel
      endif
    endif
	@echo; echo "Starting $(ntmkbw_PRODUCTID) code build `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS)
    ifeq ($(ntmkbw_PRODUCTID),cavse)
      ifneq ($(DOC_APIFILES),)
	@echo; echo "Starting $(ntmkbw_PRODUCTID) datamodel `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS) datamodel
      endif
    endif
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS)
	@echo; echo "Creating $(ntmkbw_PRODUCTID) packages ..."; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS) pkg
  endif

compile_no_mk:
	@echo; echo "Installing binary packages ..."; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(RMAKE) $(_MAKEFLAGS) $(CC_JOBFLAG) pkgs_in
	@echo; echo "Starting 3rd party code build: $(GMAKE)"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/$(TPS_RELPATH) && $(GMAKE) $(_MAKEFLAGS) MAKESTYLE=recurs  $(subst -J,-j,$(CC_JOBFLAG))
	@echo; echo "Starting $(ntmkbw_PRODUCTID) code build"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS) setup
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS)

# This rule is used only for patch builds, 
# to ensure all relevant objects are rebuilt 
# by resetting the timestamps of all associated build output files.
resettimestamp:
	@find $(subst $(TOPDIR),$(TARGOBJDIR),$(shell pwd)) -type f -print | xargs --no-run-if-empty -t touch -t 200001010000


thirdparty:
	@echo; echo "Starting 3rd party code build: `date "+%F %X"`"; echo
  ifneq ($(filter ha wrs,$(ntmkbw_PRODUCTID)),)
   ifndef SKIP_WRS # This line will be deleted
	@+cd $(GFQTOPDIR)/base_os/config/$(FAM)/$(TGT) &&  $(GMAKE) $(_MAKEFLAGS) MAKECMDGOALS=mk $(subst -J,-j,$(CC_JOBFLAG)) mk 
	@+cd $(GFQTOPDIR)/base_os/config/$(FAM)/$(TGT) &&  $(GMAKE) $(_MAKEFLAGS) MAKESTYLE=recurs $(subst -J,-j,$(CC_JOBFLAG))
   else
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(RMAKE) $(_MAKEFLAGS) expandwrsapi CC_JOBFLAG=
   endif  # This line will be deleted
  endif
  ifneq ($(ntmkbw_PRODUCTID),wrs)
	@+cd $(NTMK_LOCAL_MKDIR)/$(TPS_RELPATH) && $(RMAKE) $(_MAKEFLAGS) mk
	@echo; echo "Starting 3rd party code build: $(GMAKE) `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/$(TPS_RELPATH) && $(GMAKE) -I $(NTMK_LOCAL_MKDIR) -I $(MAKEFILEDIR) $(_MAKEFLAGS) MAKESTYLE=recurs  $(subst -J,-j,$(CC_JOBFLAG))
  endif


createTar:
	@echo; echo "Creating $(ntmkbw_PRODUCTID) TAR  `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(RMAKE) $(_MAKEFLAGS) create_tars  CC_JOBFLAG=

# When we are SKIPPING_WRS, we still need to get the WRS content
# into the images directory and into the sysroot. We clone the
# images from the specified PKGS_IN_DIR and install the API
# RPMS into the sysroot. We used name of the manifest files
# to derive the name of the API RPM and we use the order of
# creation of the manifest files to defined the order of
# installing the API RPMs.
expandwrsapi:
	@echo; echo "Installing WRS API binaries: `date "+%F %X"`"; echo
  ifneq ($(PKGS_IN_DIR),)
	@srcImageDir=`readlink -f $(PKGS_IN_DIR)/RPMS/..` ; \
	 dstImageDir="$(IMAGEOUTPUT_LOCATION)/$(FAM)/$(TGT)_$(FAM)" ; \
	 if [ -d "$${srcImageDir}/mk" ] ; then \
	   mkdir -p "$${dstImageDir}" || exit 1 ; \
	   cd "$${srcImageDir}" || exit 1 ; \
	   if [ `readlink -f .` -ef `readlink -f "$${dstImageDir}"` ] ; then \
	     echo " Same src and dest image directories, skipping image sync" ; \
	   else \
	     rsync -aR --delete . "$${dstImageDir}" || exit 1 ; \
	   fi ; \
	   mkdir -p "$(ROOT)" || exit 1 ; \
	   apiDir="$${dstImageDir}/apkg/$(_CARCH)" ; \
	   ls -1t "$${dstImageDir}/mk"/*.mf 2> /dev/null | \
	   ( cd "$(ROOT)" ; \
	     while read f ; do \
	       if [ -e "$${f/%.mf/.done}" ] ; then \
	         for rpmName in $$(awk '\
BEGIN {inApi = 0} \
/^pkgtype / {if ($$2 == "api") {inApi = 1} else {inApi = 0}; } \
/^pkg / {if (inApi == 1) {print $$2} ; }' < "$${f/%.mf/.done}") ; do \
	           echo "Installing mf: $${apiDir}/$${rpmName}" ; \
	           rpm2cpio "$${apiDir}/$${rpmName}" | cpio -idmu --no-preserve-owner --no-absolute-filenames --quiet || exit 1 ; \
	         done ; \
	       else \
	         nameVer=`basename $${f} .mf | sed -e 's/[^^]*^//'` ; \
	         rpmRoot=`echo $${nameVer} | sed -e 's/\^.*//'` ; \
	         rpmVerRel=`echo $${nameVer} | sed -e 's/[^^]*^//'` ; \
	         rpmVer=`echo $${rpmVerRel} | sed -e 's/-.*//'` ; \
	         rpmRel=`echo $${rpmVerRel} | sed -e 's/^'$${rpmVer}'[\-]*//'` ; \
	         nameVer="$${rpmRoot}-$${rpmVer}$${rpmRel:+-$${rpmRel/-/_}}" ; \
	         rpmName=`find "$${apiDir}" -name "$${nameVer}*.*.rpm" -print | head -n 1` ; \
	         echo "Installing: $${rpmName}" ; \
	         rpm2cpio "$${rpmName}" | cpio -idmu --no-preserve-owner --no-absolute-filenames --quiet || exit 1 ; \
	       fi ; \
	     done \
	   ) \
	 else \
	   echo "*********** No API directory, skipping *********** " ; \
	 fi
  else
	@$(error No PKGS_IN_DIR set when using SKIP_WRS)
  endif

formal: top do_ncl_load
.NOTPARALLEL:  top do_ncl_load

formal_no_mk: top_no_mk do_ncl_load
.NOTPARALLEL:  top_no_mk do_ncl_load

do_ncl_load:
	@echo; echo "Creating $(ntmkbw_PRODUCTID) NCL load `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(RMAKE) $(_MAKEFLAGS) ncl_load CC_JOBFLAG=


test: do_mk test_no_mk
.NOTPARALLEL:   do_mk test_no_mk

test_no_mk:
	@echo; echo "Starting $(ntmkbw_PRODUCTID) build setup `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS) setup
	@echo; echo "Starting $(ntmkbw_PRODUCTID) code build `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS)
	@echo; echo "Creating $(ntmkbw_PRODUCTID) packages `date "+%F %X"`"; echo
	@+cd $(NTMK_LOCAL_MKDIR)/../ && $(IMAKE) $(_MAKEFLAGS) pkg

pkg: distsrc

setup: XDRFILES SMFILES TGATE

ltest: do_mk ltest_no_mk
.NOTPARALLEL:   do_mk ltest_no_mk

ltest_no_mk:
	@echo; echo "Starting $(ntmkbw_PRODUCTID) build setup `date "+%F %X"`"; echo
	@$(IMAKE) $(_MAKEFLAGS) setup
	@echo; echo "Starting $(ntmkbw_PRODUCTID) code build `date "+%F %X"`"; echo
	@$(IMAKE) $(_MAKEFLAGS)
	@echo; echo "Creating $(ntmkbw_PRODUCTID) packages `date "+%F %X"`"; echo
	@$(IMAKE) $(_MAKEFLAGS) pkg

#
# Rule for the MIB files:
#
COMPILE.x =  $(CD) $(_TARGDIR) && rpcgen


#
# Some more "clobber" and "clean" targets.
#
ifeq ($(ATRIAHOME),)
  ATRIAHOME := /usr/atria
endif
INVIEW := $(shell $(ATRIAHOME)/bin/cleartool pwv -short 2>/dev/null)
INVIEW := $(shell test "$(INVIEW)" != '** NONE **' -a "$(INVIEW)" != "" && echo yes)

clobberview:
	@if [ -z "$(INVIEW)" ]; then \
	   echo "clobberview target is only available within a view."; \
	   exit 1; \
	else \
	   echo "$(ATRIAHOME)/bin/cleartool lspriv -other -do | xargs rm -rf"; \
	   $(ATRIAHOME)/bin/cleartool lspriv -other -do | xargs rm -rf; \
	fi

clobberpkgs:
	rm -rf $(TARGOBJDIR)/pkgs
	rm -rf $(TARGOBJDIR64)/pkgs

clobbersysroot:
	test -w `dirname $(ROOT)` && rm -rf `dirname $(ROOT)`

clobberncl:
#	rm -rf $(OBJPATH)/ncl/$($(ARCH)_CODE)

.PHONY: top top_no_mk do_mk thirdparty pkg formal formal_no_mk do_ncl_load test test_no_mk  clobberview clobberpkgs clobbersysroot clobberncl
.NO_CONFIG_REC: top top_no_mk do_mk thirdparty pkg formal formal_no_mk do_ncl_load test test_no_mk $(ARCH).log
.NO_DO_FOR_SIBLING: thirdparty

# This is for the WRS Debugger

local.all:: WRSlocaldebug

WRS_PATH_MAPPER :=  ${USE_SRC_ROOT}/vobs/lsba_platform_tools/build/bin/path_mapper
WRS_LOCAL_DEBUG_FILE := $(GFQTARGOBJDIR)/$(TGT)_$(FAM).dbginfo
MYVIEW := $(shell $(ATRIAHOME)/bin/cleartool pwv -short 2>/dev/null)
export $(ARCH)_BINPATH = /view/$(MYVIEW)$(BINDIR)
export $(ARCH)_BINPATH64 = /view/$(MYVIEW)$(BINDIR64)
export $(ARCH)_LIBPATH = /view/$(MYVIEW)$(LIBDIR)
export $(ARCH)_LIBPATH64 = /view/$(MYVIEW)$(LIBDIR64)

WRSlocaldebug:
	if [ -x $(WRS_PATH_MAPPER) ] ; then \
	    $(WRS_PATH_MAPPER) -a $(TGT)_$(FAM) -f $(WRS_LOCAL_DEBUG_FILE); \
	fi

WRS_DEBUG_FILE := $(NTMK_LOCAL_MKDIR)/../WRS.$(ARCH).dbginfo
ifneq ($(ntmkbw_PRODUCTID),ha)
    PRVLREALDIRS = $(shell $(NTMK_LOCAL_MKDIR)/../get_prvldirs.sh $(ARCH) $(NTMK_LOCAL_MKDIR)/blades_config)
endif

WRSdebug:
	if [ -f $(WRS_LOCAL_DEBUG_FILE) ] ; then \
	    cat $(WRS_LOCAL_DEBUG_FILE) > $(WRS_DEBUG_FILE); \
	fi; \
	for DIR in $(PRVLREALDIRS) ; do \
	    if [ -f $$DIR/*.dbginfo ] ; then \
	        cat $$DIR/*.dbginfo >> $(WRS_DEBUG_FILE); \
	    fi; \
	done

XDRFILES::

.PHONY: XDRFILES

# This is for the patching scenario, to copy the
# generated headers from the formal build output into the local view

ifneq ($(FORMAL_BUILD_DIR),)
syncInclude:
	mkdir -p $(TARGOBJDIR)/include
	mkdir -p $(TARGOBJDIR64)/include
	rsync -a --ignore-existing $(FORMAL_BUILD_DIR)/_$(TARGET_VAR)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)/include/ $(TARGOBJDIR)/include
	rsync -a --ignore-existing $(FORMAL_BUILD_DIR)/_$(TARGET_VAR)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)64/include/ $(TARGOBJDIR64)/include
endif

# AUTODOC tools and build targets.
# We only want these to run if the tools and dependencies exist.

ifneq ($(DOC_APIFILES),)

CREATE_TAR := ${USE_SRC_ROOT}/vobs/lsba_platform_tools/build/bin/create_tarfile

DME_PKG := $(FQTARGOBJDIR)/pkgs/dme_$(TGT)_$(FAM)-$(PKG_VERSION).tgz
$(DME_PKG): $(DOC_APIFILES)
	$(CREATE_TAR) $(NTMK_LOCAL_MKDIR)/blades_config/doc.apifiles $(FQTARGOBJDIR)/pkgs/dme_$(TGT)_$(FAM)-$(PKG_VERSION).tgz

pkg_dme: $(DME_PKG)

datamodel:: pkg_dme

.PHONY: datamodel pkg_dme


PABLO_DME := $(wildcard /vob/pablo_dme)
PABLO_DME_CNP_BIN := $(wildcard $(PABLO_DME)/cnp/bin)
PABLO_DME_DOCGEN_BIN := $(wildcard $(PABLO_DME)/docgen/bin)

ifneq ($(PABLO_DME_CNP_BIN),)

MERGEMODEL := $(PABLO_DME_CNP_BIN)/mergemodel
VALIDATEMODEL := $(PABLO_DME_CNP_BIN)/validatemodel
CDOCGEN := $(PABLO_DME_CNP_BIN)/cdocgen
EDOCGEN := $(PABLO_DME_CNP_BIN)/edocgen
SDOCGEN := $(PABLO_DME_CNP_BIN)/sdocgen
CDOCREPORT := $(PABLO_DME_DOCGEN_BIN)/cdocreport
EDOCREPORT := $(PABLO_DME_DOCGEN_BIN)/edocreport
COMMANDDOC := $(PABLO_DME_DOCGEN_BIN)/commanddoc
EVENTDDOC := $(PABLO_DME_DOCGEN_BIN)/eventdoc
STATSDOC := $(PABLO_DME_DOCGEN_BIN)/statsdoc
BOOKBUILD := $(PABLO_DME)/util/bin/bookbuild
VOCABBUILD := $(PABLO_DME)/util/bin/vocabbuild
DESIGNHTML := $(PABLO_DME_CNP_BIN)/designhtml

MERGE_FILES := $(strip $(shell cat ${DOC_APIFILES} | sed '/^\#/d' | cut -d" " -f1))
PRVL_DATAMODEL_FILES := $(wildcard $(ROOT)/data_model)
ifneq ($(PRVL_DATAMODEL_FILES),)
MERGE_FILES += $(shell find ${PRVL_DATAMODEL_FILES} -type f)
endif
DATAMODEL_DIR := $(TARGOBJDIR)/data_model
MERGED_MODEL_FILE := $(DATAMODEL_DIR)/$(ntmkbw_PRODUCTID)_merged_model.xml

$(MERGED_MODEL_FILE): $(MERGE_FILES)
	mkdir -p $(DATAMODEL_DIR)/designdoc $(DATAMODEL_DIR)/custdoc/xml $(DATAMODEL_DIR)/vocab
	$(MERGEMODEL) -o $(MERGED_MODEL_FILE) $(MERGE_FILES)

mergemodel: $(MERGED_MODEL_FILE)

validatemodel: $(MERGED_MODEL_FILE)
	$(VALIDATEMODEL) $(MERGED_MODEL_FILE)

CDOC_FILE := $(DATAMODEL_DIR)/custdoc/xml/cdoc/command.cdoc
$(CDOC_FILE): $(MERGED_MODEL_FILE)
	$(CDOCGEN) -o $(CDOC_FILE) $(MERGED_MODEL_FILE)

cdocgen: $(CDOC_FILE)

EDOC_ALARM := $(DATAMODEL_DIR)/custdoc/xml/edoc/alarm.edoc
$(EDOC_ALARM): $(MERGED_MODEL_FILE)
	$(EDOCGEN) -a $(EDOC_ALARM) $(MERGED_MODEL_FILE)

EDOC_LOG := $(DATAMODEL_DIR)/custdoc/xml/edoc/log.edoc
$(EDOC_LOG): $(MERGED_MODEL_FILE)
	$(EDOCGEN) -l $(EDOC_LOG) $(MERGED_MODEL_FILE)

edocgen: $(EDOC_ALARM) $(EDOC_LOG)

SDOC_FILE := $(DATAMODEL_DIR)/custdoc/xml/sdoc/pm.sdoc
$(SDOC_FILE): $(MERGED_MODEL_FILE)
	$(SDOCGEN) $(MERGED_MODEL_FILE) $(SDOC_FILE)

sdocgen: $(SDOC_FILE)

MODEL_PKG := $(FQTARGOBJDIR)/pkgs/mergedmodel_$(ARCH)-$(PKG_VERSION).tgz
$(MODEL_PKG): $(MERGED_MODEL_FILE)
	cd $(TARGOBJDIR); \
	tar cvfz $(MODEL_PKG) data_model/$(ntmkbw_PRODUCTID)_merged_model.xml

pkg_model: $(MODEL_PKG)

CDOCREPORT_DIR := $(DATAMODEL_DIR)/designdoc/cdoc
cdocreport: $(CDOC_FILE)
	$(CDOCREPORT) -o $(CDOCREPORT_DIR) $(CDOC_FILE)

EDOCALARMREPORT_DIR := $(DATAMODEL_DIR)/designdoc/alarms
edocalarmreport: $(EDOC_ALARM)
	$(EDOCREPORT) -o $(EDOCALARMREPORT_DIR) $(EDOC_ALARM)

EDOCLOGREPORT_DIR := $(DATAMODEL_DIR)/designdoc/logs
edoclogreport: $(EDOC_LOG)
	$(EDOCREPORT) -o $(EDOCLOGREPORT_DIR) $(EDOC_LOG)

COMMANDDOC_DIR := $(DATAMODEL_DIR)/custdoc/command/web
commanddoc: $(CDOC_FILE)
	$(COMMANDDOC) -w $(COMMANDDOC_DIR) $(CDOC_FILE)

STATSDOC_DIR := $(DATAMODEL_DIR)/custdoc/pm/web
statsdoc: $(SDOC_FILE)
	$(STATSDOC) -w $(STATSDOC_DIR) $(SDOC_FILE)

EVENTDOCALARM_DIR := $(DATAMODEL_DIR)/custdoc/alarm/web
eventdocalarm: $(EDOC_ALARM)
	$(EVENTDDOC) -w $(EVENTDOCALARM_DIR) $(EDOC_ALARM)

EVENTDOCLOG_DIR := $(DATAMODEL_DIR)/custdoc/log/web
eventdoclog: $(EDOC_LOG)
	$(EVENTDDOC) -w $(EVENTDOCLOG_DIR) $(EDOC_LOG)

TOOLSGUIDE_DIR := $(DATAMODEL_DIR)/toolsguide
toolsguide:
	$(BOOKBUILD) -o $(TOOLSGUIDE_DIR) $(PABLO_DME)/cnp/docs/toolsguide/top.xml

CDE_VOCABDIR := $(DATAMODEL_DIR)/vocab/cde
cde_vocabbuild:
	$(VOCABBUILD) -o $(CDE_VOCABDIR) -v cde $(PABLO_DME)/cnp/vocab/cde.rng

CNPDOC_VOCABDIR := $(DATAMODEL_DIR)/vocab/cnpdoc
cnpdoc_vocabbuild:
	$(VOCABBUILD) -o $(CNPDOC_VOCABDIR) -v cnpdoc $(PABLO_DME)/cnp/vocab/cnpdoc.rng

EDOC_VOCABDIR := $(DATAMODEL_DIR)/vocab/edoc
edoc_vocabbuild:
	$(VOCABBUILD) -o $(EDOC_VOCABDIR) -v edoc $(PABLO_DME)/docgen/vocab/edoc.rng

CDOC_VOCABDIR := $(DATAMODEL_DIR)/vocab/cdoc
cdoc_vocabbuild:
	$(VOCABBUILD) -o $(CDOC_VOCABDIR) -v cdoc $(PABLO_DME)/docgen/vocab/cdoc-v2.rng

SDOC_VOCABDIR := $(DATAMODEL_DIR)/vocab/sdoc
sdoc_vocabbuild:
	$(VOCABBUILD) -o $(SDOC_VOCABDIR) -v cde $(PABLO_DME)/docgen/vocab/sdoc.rng

DESIGNHTML_DIR := $(DATAMODEL_DIR)/designdoc/web
designhtml: $(MERGED_MODEL_FILE)
	$(DESIGNHTML) -o $(DESIGNHTML_DIR) $(MERGED_MODEL_FILE)

datamodel:: pkg_dme validatemodel pkg_model

datamodel_reports: datamodel cdocgen edocgen sdocgen cdocreport statsdoc edocalarmreport edoclogreport commanddoc eventdocalarm eventdoclog toolsguide cde_vocabbuild cnpdoc_vocabbuild edoc_vocabbuild cdoc_vocabbuild sdoc_vocabbuild designhtml

.PHONY: mergemodel validatemodel pkg_model cdocgen edocgen cdocreport statsdoc edocalarmreport edoclogreport commanddoc eventdocalarm eventdoclog toolsguide edoc_vocabbuild cdoc_vocabbuild sdoc_vocabbuild designhtml

endif
endif

# This rule is to create hardlinks from the target to the family sysroot. 
# prebuild.mk uses it but we put the rule here so the portage build can use it too.

export FAM_ROOT := $(subst _$(TGT)_,_fam_,$(ROOT))
export FAM_TARGOBJDIR := $(subst _$(TGT)_,_fam_,$(FQTARGOBJDIR))

ifeq ($(ntmkbw_PRODUCTID),wrs)
  PRUNE_PATH := "./nonexisting"
else
  PRUNE_PATH :=  "./nonexisting"  #"./usr/include/asm*"
endif

$(ROOT)/.$(TGT)_$(FAM)_hardlinks.done: $(FAM_ROOT)/.fam_$(FAM).done
	rm -rf  $(ROOT); mkdir -p  $(ROOT)
	cd $(FAM_ROOT) && find . -path "./usr/src" -prune -o -path $(PRUNE_PATH) -prune -o -type d -print | sort | xargs -iXyb9ql  mkdir -p $(ROOT)/Xyb9ql
	cd $(FAM_ROOT) && find . -path "./usr/src" -prune -o -path $(PRUNE_PATH) -prune -o -type l -print | xargs -iYn29Xbo  cp -d Yn29Xbo $(ROOT)/Yn29Xbo
	cd $(FAM_ROOT) && find . -path "./usr/src" -prune -o -path $(PRUNE_PATH) -prune -o -type f -print | xargs -iU3n9qp ln U3n9qp $(ROOT)/U3n9qp
	rm -rf $(ROOT)/etc/3rdpty/cp/$(3rdptyTgtPkgsOverwrite)
	rm -rf $(ROOT)/etc/3rdpty/cpv/$(3rdptyTgtPkgsOverwrite)^*
	touch $@

