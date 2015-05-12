#
# prebuild.mk -- Rules that are executed prior to the actual build
#
# We need to prepare the build environment with:
# 	- the includes and libraries pertaining to the xtools 
#	  (  gcc libs, glibc and the linux headers )
#	- packages needed by the build
#


#
# Include the config file for the card we're building.
#

#++++++++++++++++++++++++++++++++++++++++++++++++
ifneq ($(ntmkbw_PRODUCTID),ha)
  ifdef TARGET_MACH
    include $(NTMK_LOCAL_MKDIR)/blades_config/${TGT}_${FAM}.in
  endif
endif
#++++++++++++++++++++++++++++++++++++++++++++++++

#Don't include the rest if incremental build (no -D switch specified)
ifeq ($(FORMAL_BUILD_DIR),)

#Some definitions
INSTALL_API := ${USE_SRC_ROOT}/vobs/lsba_platform_tools/build/mk/common/install-api
FAM_ROOT := $(subst _$(TGT)_,_fam_,$(ROOT))
#
# We must determine the directories where the previous layers' binary
# packages are to be fetched from.
#
#++++++++++++++++++++++++++++++++++++++++++++++++
ifneq ($(ntmkbw_PRODUCTID),ha)
 export  PRVL_PKGS_IN_DIR := $(strip $(shell ${USE_SRC_ROOT}/vobs/lsba_platform_tools/build/bin/get_prvldirs.sh $(TGT)_$(FAM) $(NTMK_LOCAL_MKDIR)/blades_config $(NTMK_LOCAL_MKDIR)))
  TMP_PRVL_PKGS_IN_DIR := $(shell echo $(PRVL_PKGS_IN_DIR) | sed -e 's/[:,]/ /g')
  PKGS_IN_DIR := $(wildcard $(TMP_PRVL_PKGS_IN_DIR) $(addsuffix /pkgs, $(TMP_PRVL_PKGS_IN_DIR))  $(addsuffix 64/pkgs, $(TMP_PRVL_PKGS_IN_DIR)) $(addsuffix /RPMS/$(_CARCH), $(TMP_PRVL_PKGS_IN_DIR)))
  ifdef EXTRA_PKGS_IN_DIR
    PKGS_IN_DIR +=  $(EXTRA_PKGS_IN_DIR)/$(TGT)_$(FAM)
  endif
endif

#++++++++++++++++++++++++++++++++++++++++++++++++

ifneq ($(ntmkbw_PRODUCTID),ha)
  TMP_PKGS_IN:= $(foreach PKG,$(PKGS_IN),package:$(PKG),$(foreach DIR,$(PKGS_IN_DIR),$(wildcard $(DIR)/$(PKG))))
  PKGS_IN := $(notdir $(TMP_PKGS_IN))
endif

#
# Flag pkgs that do not exist.
#
NON_EXISTING := $(filter package:%,$(PKGS_IN))
ifneq ($(NON_EXISTING),)
  $(error $(NON_EXISTING) cannot be found)
  _x := $(shell echo '$(NON_EXISTING) cannot be found' 1>&2)
  error
endif

#
# Markers to see if we already expanded the packages.
#
PKGS_IN_MARKERS_TGZ := $(addprefix $(ROOT)/.,$(notdir $(subst .tgz,.done,$(filter %.tgz,$(PKGS_IN)))))
PKGS_IN_MARKERS_BZ2 := $(addprefix $(ROOT)/.,$(notdir $(subst .tar.bz2,.done,$(filter %.tar.bz2,$(PKGS_IN)))))
PKGS_IN_MARKERS_RPM := $(addprefix $(ROOT)/.,$(notdir $(subst .rpm,.done,$(filter %.rpm,$(PKGS_IN)))))
PKGS_IN_MARKERS_PARCEL := $(addprefix $(ROOT)/.,$(notdir $(subst .parcel,.done,$(filter %.parcel,$(PKGS_IN)))))

#
# The target that expands the upstream packages.
#

pkgs_in: $(ROOT)/.$(TGT)_$(FAM).done

$(ROOT)/.$(TGT)_$(FAM).done: $(PKGS_IN_MARKERS_TGZ) $(PKGS_IN_MARKERS_BZ2) $(PKGS_IN_MARKERS_RPM) $(PKGS_IN_MARKERS_PARCEL)
  ifneq ($^,)
	find $(ROOT) -type f | xargs chmod 555
  endif
	touch $@

ifneq ($(TGT),fam)
$(ROOT)/.$(TGT)_$(FAM).done $(PKGS_IN_MARKERS_TGZ) $(PKGS_IN_MARKERS_BZ2) $(PKGS_IN_MARKERS_RPM) $(PKGS_IN_MARKERS_PARCEL): $(ROOT)/.$(TGT)_$(FAM)_hardlinks.done
$(FAM_ROOT)/.fam_$(FAM).done:
	echo "Did you build the $(FAM) family first?"
endif

ifneq ($(ntmkbw_PRODUCTID),ha)
pkgs_in: $(TARGOBJDIR)/$(TGT)_$(FAM).prvlrealdir
endif

vpath %.tgz $(PKGS_IN_DIR)
vpath %.bz2 $(PKGS_IN_DIR)
vpath %.rpm $(PKGS_IN_DIR)
vpath %.parcel $(PKGS_IN_DIR)

$(PKGS_IN_MARKERS_TGZ): $(ROOT)/.%.done: %.tgz
	@$(INSTALL_API) "$(PREVIOUS_SYSROOT_DIR)/$(_CARCH)" $(ROOT) $^
	@touch $@

$(PKGS_IN_MARKERS_BZ2): $(ROOT)/.%.done: %.tar.bz2
	@$(INSTALL_API) "$(PREVIOUS_SYSROOT_DIR)/$(_CARCH)" $(ROOT) $^
	@touch $@

$(PKGS_IN_MARKERS_RPM): $(ROOT)/.%.done: %.rpm
	@$(INSTALL_API) "$(PREVIOUS_SYSROOT_DIR)/$(_CARCH)" $(ROOT) $^
	@touch $@

$(PKGS_IN_MARKERS_PARCEL): $(ROOT)/.%.done: %.parcel
	@$(INSTALL_API) "$(PREVIOUS_SYSROOT_DIR)/$(_CARCH)" $(ROOT) $^
	@touch $@

 $(TARGOBJDIR)/$(TGT)_$(FAM).prvlrealdir:  $(NTMK_LOCAL_MKDIR)/blades_config/$(TGT)_$(FAM).prvlrealdir
	rm -f $@; cp $< $@

.NO_CONFIG_REC: %.done
.NO_DO_FOR_SIBLING: %.done
.PHONY: devl pkgs_in

endif # Don't include the rest

