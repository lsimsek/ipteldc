# This is the second file requiered to support project defined targets.
# See local_mkfiledefs.mk, if you haven't already.
#
# This file provides the 'code' used during the 'build mk' pass of
# the build to take the templates and add 'code' to the generated
# Build_*.mk files.
#

#
# Get a handle on our template files which we use later.
#

TGATETEMPLATEp1 := $(NTMK_LOCAL_MKDIR)/tgatep1.tmk
TGATETEMPLATEp2 := $(NTMK_LOCAL_MKDIR)/tgatep2.tmk

XMLCHECKTEMPLATEp1 := $(NTMK_LOCAL_MKDIR)/xmlcheckp1.tmk
XMLCHECKTEMPLATEp2 := $(NTMK_LOCAL_MKDIR)/xmlcheckp2.tmk

XDRFILESTEMPLATEp1 := $(NTMK_LOCAL_MKDIR)/xdrfilesp1.tmk
XDRFILESTEMPLATEp2 := $(NTMK_LOCAL_MKDIR)/xdrfilesp2.tmk

SMFILESTEMPLATEp1 := $(NTMK_LOCAL_MKDIR)/smfilesp1.tmk
SMFILESTEMPLATEp2 := $(NTMK_LOCAL_MKDIR)/smfilesp2.tmk

# Get a list of all (target indendent).

ALL_TGATE_VARS :=  $(foreach P,$(filter %TGATE,$(.VARIABLES)),$($(P)))
ALL_XMLCHECK_VARS :=  $(foreach P,$(filter %XMLCHECK,$(.VARIABLES)),$($(P)))
ALL_XDRFILES_VARS :=  $(foreach P,$(filter %XDRFILES,$(.VARIABLES)),$($(P)))
ALL_SMFILES_VARS :=  $(foreach P,$(filter %SMFILES,$(.VARIABLES)),$($(P)))

# If we have any then define the template macros.

ifdef ALL_TGATE_VARS
  # For each define the setup.
  # Note: the 'ifneq' is required to handle targeted TGATE.
  # Note: The template file must have code to add to the variable
  #       ALL_TGATE. This variable is used in local_mkfiletmpl.mk to
  #       set the target dependecies.
  TGATEP1_TMPL = \
  for P in $(patsubst %,'%',$(ALL_TGATE_VARS)); do \
    echo 'ifneq ($$(filter '"$$P"',$$(_TGATE)),)' ; \
    $(SED) -e "s,%TGATE%,$$P,g" $(TGATETEMPLATEp1) ; \
    echo 'endif' ; \
  done;

  # Now the actual rules.
  # Note: There is no 'ifneq' around this one since it is 
  # handled in the above template.

  TGATEP2_TMPL = \
  for P in $(patsubst %,'%',$(sort $(ALL_TGATE_VARS))); do \
    $(SED) -e "s,%TGATE%,$$P,g" $(TGATETEMPLATEp2) ; \
  done;
else
  # The defaults.
  # Note: These are required.

  TGATEP1_TMPL := :;
  TGATEP2_TMPL := :;
endif

ifdef ALL_XMLCHECK_VARS
  XMLCHECKP1_TMPL = \
  for P in $(patsubst %,'%',$(ALL_XMLCHECK_VARS)); do \
    echo 'ifneq ($$(filter '"$$P"',$$(_XMLCHECK)),)' ; \
    $(SED) -e "s,%XMLCHECK%,$$P,g" $(XMLCHECKTEMPLATEp1) ; \
    echo 'endif' ; \
  done;
                                                                                
  # Now the actual rules.
                                                                                
  XMLCHECKP2_TMPL = \
  for P in $(patsubst %,'%',$(sort $(ALL_XMLCHECK_VARS))); do \
    $(SED) -e "s,%XMLCHECK%,$$P,g" $(XMLCHECKTEMPLATEp2) ; \
  done;
else
  # The defaults.
  # Note: These are required.
                                                                                
  XMLCHECKP1_TMPL := :;
  XMLCHECKP2_TMPL := :;
endif

ifdef ALL_XDRFILES_VARS
  XDRFILESP1_TMPL = \
  for P in $(patsubst %,'%',$(ALL_XDRFILES_VARS)); do \
    echo 'ifneq ($$(filter '"$$P"',$$(_XDRFILES)),)' ; \
    $(SED) -e "s,%XDRFILES%,$$P,g" $(XDRFILESTEMPLATEp1) ; \
    echo 'endif' ; \
  done;

  # Now the actual rules.

  XDRFILESP2_TMPL = \
  for P in $(patsubst %,'%',$(sort $(ALL_XDRFILES_VARS))); do \
    $(SED) -e "s,%XDRFILES%,$$P,g" $(XDRFILESTEMPLATEp2) ; \
  done;
else
  # The defaults.
  # Note: These are required.

  XDRFILESP1_TMPL := :;
  XDRFILESP2_TMPL := :;
endif

ifdef ALL_SMFILES_VARS
  SMFILESP1_TMPL = \
  for P in $(patsubst %,'%',$(ALL_SMFILES_VARS)); do \
    echo 'ifneq ($$(filter '"$$P"',$$(_SMFILES)),)' ; \
    $(SED) -e "s,%SMFILES%,$$P,g" $(SMFILESTEMPLATEp1) ; \
    echo 'endif' ; \
  done;

  # Now the actual rules.

  SMFILESP2_TMPL = \
  for P in $(patsubst %,'%',$(sort $(ALL_SMFILES_VARS))); do \
    $(SED) -e "s,%SMFILES%,$$P,g" $(SMFILESTEMPLATEp2) ; \
  done;
else
  # The defaults.
  # Note: These are required.

  SMFILESP1_TMPL := :;
  SMFILESP2_TMPL := :;
endif

