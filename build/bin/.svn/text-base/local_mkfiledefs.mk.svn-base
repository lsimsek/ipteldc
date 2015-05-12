#
# This is an example of how to add additional targets to ntmk. This file
# along with local_mkfiletmpl.mk can be customized and added the the local 
# /mk directory to extend ntmk to include addiationa targets (similar to
# PROGRAMS, PACKAGES, etc.

# In this file there are 2 main parts:
#
#   - A list of the new target(s).
#     The variable USERBUILDABLETARGETS is set to these targets.
#   - A list of rules/dependencies for these targets.
#     The template below should apply to most situations. Just update
#     the names.
#
# Once you have updated this file proceed to local_mkfiletmpl.mk which
# contains the templates used during the 'build mk' pass.

#
# The following is a simple example for 2 new targets.
#

# Update the buildable targets:

USERBUILDABLETARGETS := TGATE XMLCHECK XDRFILES SMFILES

#
# Create target rules for each:
#

# Define the toplevel target:
# We want 2 things.
#   - A dependency on $(ALL_TGATE) which contains all the things we build
#     for this target. ALL_TGATE is updated in the template.
#   - local.xprogs - This allows a Build.mk file to add additional things
#     that will be built for the target (generally not used a lot).

.PHONY: TGATE local.TGATE XMLCHECK local.XMLCHECK XDRFILES local.XDRFILES

TGATE:: local.TGATE $(TGATE_FILES)
local.TGATE:: 

XMLCHECK:: local.XMLCHECK  $(ALL_XMLCHECK)
local.XMLCHECK::

XDRFILES:: local.XDRFILES $(AL_XDRFILES)
local.XDRFILES::

SMFILES:: local.SMFILES $(AL_SMFILES)
local.SMFILES::

# This is for recurive make. During a recursive make this will make ntmk
# traverse all the subdirectories for this target.

ifeq ($(inclmake),)
TGATE:: $(ALL_SUBDIRS:=.TGATE)
XMLCHECK:: $(ALL_SUBDIRS:=.XMLCHECK)
XDRFILES:: $(ALL_SUBDIRS:=.XDRFILES)
SMFILES:: $(ALL_SUBDIRS:=.SMFILES)
endif


