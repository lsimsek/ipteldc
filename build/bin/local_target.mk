#
# local_target.mk --
#

# This is to compensate for the bug in ntmk 2.14
OBJVOB := $(OBJPATH)
OBJVOB64 := $(OBJPATH64)

# For pkgtool

export TARGOBJDIR
export TARGOBJDIR64

#
# Add the include directory - for the generated header files:
#
ifeq (,$(filter $(TARGOBJDIR),$(_PREFIXES)))
  _PREFIXES += $(TARGOBJDIR)
endif

#
# If incremental build, we want to see the include and lib directory of the
# form al build
#

#++++++++++++++++++++++++++++++++++++++++++++++
ifeq ($(ntmkbw_PRODUCTID),ha)
  ifdef FORMAL_BUILD_DIR
    # Add the path to the libs path
    ifneq ($(USE_FORMAL_LIBS),N)
      ifeq (,$(filter $(FORMAL_BUILD_DIR),$(_PREFIXES)))
        _PREFIXES += $(FORMAL_BUILD_DIR)
      endif
    endif
  endif
endif
#++++++++++++++++++++++++++++++++++++++++++++++


#++++++++++++++++++++++++++++++++++++++++++++++
ifneq ($(ntmkbw_PRODUCTID),ha)
  ifdef FORMAL_BUILD_DIR
    # Add the path to the libs path
    ifneq ($(USE_FORMAL_LIBS),N)
      ifeq (,$(filter $(FORMAL_BUILD_DIR)/_$(TARGET_VAR)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH),$(_PREFIXES)))
        _PREFIXES += $(FORMAL_BUILD_DIR)/_$(TARGET_VAR)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH)
      endif
    endif
  else
    # For wink in - we must have the same script for formal and incremental builds
    DUMMY_FORMAL_DIR := $(shell echo $(NCGL_SYSTEM_ROOT)/../../_$(TARGET_VAR)_$(TARGET_OS)_$(TARGET_REL)_$(TARGET_MACH) | sed -e ':label; s=//*[^/][^/]*//*\.\.//*=/=; t label')
    ifeq (,$(filter $(DUMMY_FORMAL_DIR),$(_PREFIXES)))
       _PREFIXES += $(DUMMY_FORMAL_DIR)
    endif
  endif
endif
#++++++++++++++++++++++++++++++++++++++++++++++

#
# Create some directories here.
# It's easier this way - otherwise we might run into parallelization problems.
#
DUMMY := $(shell umask 022; mkdir -p $(ROOT) 2>/dev/null)
DUMMY := $(shell mkdir -p $(TARGOBJDIR)/pkgs $(TARGOBJDIR)/include)
DUMMY := $(shell mkdir -p $(TARGOBJDIR64)/pkgs $(TARGOBJDIR64)/include)
ifeq ($(ntmkbw_PRODUCTID),ha)
 DUMMY := $(shell  if [ ! -e $(TARGOBJDIR)/RPMS ];then  ln -sf ../images/$(FAM)/$(TGT)_$(FAM)/apkg $(TARGOBJDIR)/RPMS; fi)
 DUMMY := $(shell  if [ ! -e $(TARGOBJDIR64)/RPMS ];then  ln -sf ../images/$(FAM)/$(TGT)_$(FAM)/apkg $(TARGOBJDIR64)/RPMS; fi)
endif
