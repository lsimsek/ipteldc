_SYS_LDFLAGS += -Wl,-rpath=/run/opt/corp/ipteldc/$(APP_RELEASE)/lib
export TARGOBJDIR
include /ebuild/ipteldc/ipteldc/trunk/tools/build/bin/local_rules.mk

# cleanup the -isystem flags
OLD_SYS_CPPFLAGS  := $(shell echo $(_SYS_CPPFLAGS) | sed -e 's/-isystem /-I/g')

ifneq ($(NCGL_PNE_LE_VERSION),14)
#Override _SYS_CPPFLAGS 
_SYS_CPPFLAGS := $(OLD_SYS_CPPFLAGS)
endif


# Define NCGL PNE/LE Version Macro for the family
# based on the environment variable from local_setup.mk.
ifneq ($(NCGL_PNE_LE_VERSION),)
  ~CPPFLAGS_r += -DNCGL_PNE_LE_VERSION=$(NCGL_PNE_LE_VERSION)
endif

# Add the patching tools version to the command line so that changing the
# version causes a commandline change that in turn causes wink-ins to work
# correctly.
ifneq ($(cppatVERSION),) 
  ~CPPFLAGS_r += -D'CPPAT_VERSION="$(cppatVERSION)"'
endif
