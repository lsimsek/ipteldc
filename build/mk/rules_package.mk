#include /ebuild/ipteldc/ipteldc/trunk/tools/build/mk/rules_package.mk




ALL_TARGETS +=	distsrc
distsrc:: local.distsrc local.distsrc64

USER := $(shell whoami)
DATE := $(shell date +%M%S%N)

TEMPDIR=/tmp/pkg.$(FAM).$(TGT).$(PKG_VERSION).$(USER).$(DATE).$*

ifdef ALL_PACKAGES

PKG_MARKERS :=  $(addsuffix _$(TGT)_$(FAM).marker,$(addprefix $(TARGOBJDIR)/pkgs/.,$(subst -.tar.gz,,$(ALL_PACKAGES))))

local.distsrc:: $(PKG_MARKERS)

~CLEANFILES += $(PKG_MARKERS)
#
# NOTE: Hack to properly cleanup the PKG_MARKERS. This should be done 
#       via ~CLEANFILES but that seems to be broken right now
#
local.clean::
	$(RM) $(PKG_MARKERS)

.NO_CMP_SCRIPT:  $(PKG_MARKERS)

PATCH_PACKAGING_COMMAND = echo
ifdef PATCH_BUILD
  PATCH_PACKAGING_COMMAND = $(PATCH_HOME)/bin/patch_packaging
endif

$(PKG_MARKERS):  $(TARGOBJDIR)/pkgs/.%_$(TGT)_$(FAM).marker:  $(NTMK_LOCAL_MKDIR)/rules_package.mk 
	@buildop s package $*
	@$(ECHO) "PKG_MARKERS: " $(PKG_MARKERS)
	@$(ECHO) "Creating package $* ..."
	mkdir -p $(TEMPDIR)
	@$(ECHO) $(PKGTOOL) "-t i686 -a " $(FAM) " -T " $(TGT) " -o " $(TEMPDIR) " -b " $(BINDIR) " -s " $(LIBDIR) " -v " $(PKG_VERSION)  $(PKGFLAGS) $(_PKGFLAGS)
	cd $(TOPDIR)$($*_PACK_DIR); $(PKGTOOL) -t i686 -a $(FAM) -T $(TGT) -o  $(TEMPDIR) -b $(BINDIR) -s $(LIBDIR) -v $(PKG_VERSION)  $(PKGFLAGS) $(_PKGFLAGS)
	$(WRAPIT) -a $(FAM) -T $(TGT) -d $(TEMPDIR) -m $(TOPDIR)$($*_PACK_DIR)/definition.pkg -o $(TARGOBJDIR)/pkgs
	#cp $(TEMPDIR)/*.rpm $(TARGOBJDIR)/pkgs
	#  If any .map files found, process them.
	if `ls $(TEMPDIR)/*.map >/dev/null 2>&1`; then \
	   cp $(TEMPDIR)/*.map $(TARGOBJDIR)/pkgs; \
           $(PATCH_PACKAGING_COMMAND) $(TARGOBJDIR)/pkgs $(TEMPDIR)/*.map; \
	fi
	rm -rf $(TEMPDIR)
	@echo
	@echo "Packages that were output:"
	@echo "--------------------------"
	@find $(TARGOBJDIR)/pkgs -name "$**-$(PKG_VERSION)-1.i386.*"
	touch $@
	@buildop e package $*

ifdef PATCH_BUILD
  local.distsrc:: patch_pkg_wrapup
endif

.PHONY: patch_pkg_wrapup
patch_pkg_wrapup: $(PKG_MARKERS)
#  Only call patch_package_wrapup if there are .map files
	if `ls $(TARGOBJDIR)/pkgs/*.map >/dev/null 2>&1`; then \
          $(PATCH_HOME)/bin/patch_package_wrapup $(TARGOBJDIR)/pkgs/$(FAM).$(TGT).load_pif $(TARGOBJDIR)/pkgs; \
        fi

else

  local.distsrc:: 
	@$(ECHO) "No packages to create."

endif # ALL_PACKAGES

ifdef ALL_PACKAGES64

PKG_MARKERS64 :=  $(addsuffix _$(TGT)_$(FAM).marker,$(addprefix $(TARGOBJDIR64)/pkgs/.,$(subst -.tar.gz,,$(ALL_PACKAGES64))))
  local.distsrc64:: $(PKG_MARKERS64)

~CLEANFILES += $(PKG_MARKERS64)
#
# NOTE: Hack to properly cleanup the PKG_MARKERS. This should be done 
#       via ~CLEANFILES but that seems to be broken right now
#
local.clean::
	$(RM) $(PKG_MARKERS64)

.NO_CMP_SCRIPT64:  $(PKG_MARKERS64)

$(PKG_MARKERS64):  $(TARGOBJDIR64)/pkgs/.%_$(TGT)_$(FAM).marker:  $(NTMK_LOCAL_MKDIR)/rules_package.mk 
	@buildop s package64 $*
	@$(ECHO) "Creating 64 bit package $* ..."

	#++++++++++++++++++++++++++++++++++++++++++++++++++++
        ifeq ($(ntmkbw_PRODUCTID),ha)
	  # HA doesn't do wrapping.
	  cd $(TOPDIR)$($*_PACK_DIR64); $(PKGTOOL) -t i686 -a $(FAM) -T $(TGT) -b $(BINDIR64) -s $(LIBDIR64) -v $(PKG_VERSION) -o $(TARGOBJDIR64)/pkgs $(PKGFLAGS) $(_PKGFLAGS64)
	#++++++++++++++++++++++++++++++++++++++++++++++++++++
        else
	  # Rest of the products
	  cd $(TOPDIR)$($*_PACK_DIR64); $(PKGTOOL) -t i686 -a $(FAM) -T $(TGT) -b $(BINDIR64) -s $(LIBDIR64) -v $(PKG_VERSION) -m  -o $(TARGOBJDIR64)/pkgs $(PKGFLAGS) $(_PKGFLAGS64)
        endif
	#++++++++++++++++++++++++++++++++++++++++++++++++++++

	@echo
	@echo "64 bit packages that were output:"
	@echo "---------------------------------"
	@find $(TARGOBJDIR64)/pkgs -name "$**-$(PKG_VERSION)-1.i386.*"
	touch $@
	@buildop e package64 $*

else

  local.distsrc64:: 
	@$(ECHO) "No 64 bit packages to create."

endif # ALL_PACKAGES64
