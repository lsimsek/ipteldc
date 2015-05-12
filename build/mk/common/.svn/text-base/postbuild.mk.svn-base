# Where to put the loads
ifndef LOAD_ROOT
  LOAD_ROOT := $(OBJPATH)
endif

CREATE_TAR := /ebuild/ipteldc/ipteldc/trunk/tools/pkgtools/bin/createTars

#Where to take the parcels from
# Note: This would not work if we have any 64-bit pkgs, since this is a single dir
# Other Note: createNcls needs to be update to only grab parcels, not rpms.
PARCELS_SOURCE_DIR := $(TARGOBJDIR)/pkgs
export ntmkbw_VSE_RELEASE=$(VSE_RELEASE)

ncl_load: 
	export toolDEBUG=$(toolDEBUG) && cd $(dir $(CREATE_NCLS)) && $(CREATE_NCLS)  -f $(FAM) -t $(TGT) -i $(PARCELS_SOURCE_DIR) -o $(LOAD_ROOT)/ncl; exit 0


create_tars:
	@echo; echo "Creating $(ntmkbw_PRODUCTID) TARs `date "+%F %X"`"; echo
	set -x;  export PKG_VER=$(PKG_VERSION); export toolDEBUG=$(toolDEBUG) &&  $(CREATE_TAR)


.PHONY: ncl_load create_tars
