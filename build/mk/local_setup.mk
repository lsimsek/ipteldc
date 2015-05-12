include /ebuild/ipteldc/ipteldc/trunk/tools/build/bin/local_setup.mk

CREATE_NCLS = /ebuild/ipteldc/ipteldc/trunk/tools/pkgtools/bin/createNcls

# Add: no-error to ignore warnings for now,
#      NCGL_PNE_LE_VERSION= 30 for PNE-LE3.0
export NCGL_CC_POSTOPTS := -Wno-error

# Turn on patching by family and architecture. Putting the information here
# allows incremental builds to be patchable as well.
export PATCH_BUILD=
export PATCH_HOME=

ifeq ($(BINTAP_BUILD_ENABLED), 1)
   export PATCH_HOME=$(cppatPATH)

   # Temporarily allow violations while having the compile wrapper
   # default to not allowing violations.
   #ifeq ($(findstring -nopatchfatal, $(PATCH_WRAPPER_OPTIONS)),)
   #   PATCH_WRAPPER_OPTIONS += -nopatchfatal
   #   export PATCH_WRAPPER_OPTIONS
   #endif

   ifeq ($(FAM), intel_c)
      # atca717m is removed until it is built in the official loads.
      ifneq ($(findstring $(TGT), fam alonso nehalem stamford ce3100 atca6900),)
         export PATCH_BUILD=1
      endif
   endif
   ifeq ($(FAM), intel_p4)
      ifneq ($(findstring $(TGT), fam atca7101),)
         export PATCH_BUILD=1
      endif
   endif
   ifeq ($(FAM), powerpc_e500v2)
      ifneq ($(findstring $(TGT), fam atcaf120),)
         export PATCH_BUILD=1
      endif
   endif
   ifeq ($(FAM), powerpc_7400)
      ifneq ($(findstring $(TGT), fam atcaf101),)
         export PATCH_BUILD=1
      endif
   endif
   ifeq ($(FAM), powerpc_970)
      ifneq ($(findstring $(TGT), fam atca6101 kat2000),)
         export PATCH_BUILD=1
      endif
   endif
   ifeq ($(FAM), mips_octeon)
      ifneq ($(findstring $(TGT), fam amc58xx at5800),)
         export PATCH_BUILD=1
      endif
   endif
endif


