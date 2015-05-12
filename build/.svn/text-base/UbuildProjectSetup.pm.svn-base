#
# This PERL module is imported by ubuild to provide extensions to support a 
# specific build implementation.
#
# Note: Because ubuild loads this code as a module this code cannot see all
#       the local ubuild variables.  
#       It must use the appropriate functions to access them.
#
#       We chose to implement as a module because when you use the 
#         do "file_name";
#       syntax the syntax error reporting is not clear.
#
use strict;
use File::Basename;

###############################################################################
# Variables.
#
#my $useSrcRoot;
#     ($useSrcRoot = `pwd`) =~ s/(.*)\/vob\/siren\/.*/$1/;
#     chomp $useSrcRoot;$ENV{USE_SRC_ROOT} = $useSrcRoot;
   $ENV{USE_SRC_ROOT} = "" if !defined $ENV{USE_SRC_ROOT};
my $tgtfam_list = "$ENV{USE_SRC_ROOT}/ebuild/ipteldc/ipteldc/trunk/tools/build/config/fam-tgt.list";
my $realProgNameDirname = "$ENV{USE_SRC_ROOT}/vob/ncgl/loadbuild/ntmk";
my $cleartool = "/usr/atria/bin/cleartool";
my ($opt_t, $opt_N, $opt_W, $tgt, $fam, $blade, $loadDirName,$viewname, $pkgMapping, $formalBuildDir, $useFormalLibs, $pkgsInDir, $prodRelease, $d, $pkgMappingVar, $loadDirName);

###############################################################################
#
use lib "$ENV{ubuild_BIN_DIR}";
use NtmkSetup;


###############################################################################
#
sub projectGetWrapperVersion() {
    return "1.11";
}

###############################################################################
# The projectInit function is called after the module is loaded.
#
sub projectInit($) {
    my ( $setupProject ) = @_;

    isDebug() && printMsg( "### projectInt( $setupProject ) ...\n" );

    # Have ubuild use it's default logic for detecting build types.
    setBuildType('auto');

    # Explicitly set the SCM module.
    addEnv( "ubuild_SCM_MODULE", "$ENV{ubuild_BIN_DIR}/ScmClearCase.pm", 1 );
    # Enable the ClearMake extensions.
    addEnv( "ubuild_USING_CLEARMAKE", "1", 1 );
}


###############################################################################
# The projectExtendEnvironment is used to extend the environment that is 
# passed to the build.
#
# Note: The environment is "cleaned" prior to starting the build, so any
#       variables that are not explicitly registered are discarded.
#
# Environment variables can be registed in one of the following ways:
#  - ubuild had predefined required and optional variables.
#  - Using the addRequiredEnv and addOptionalEnv functions.
#  - Anything defined in the setup project config file.
#
# So just to be reallly clear, probably all the variables should be defined
# in the project configuration file.  We should only define variables here 
# if there is logic associated with them.
#
# We have not started looking at command line arguments by this time so do not
# worry about that yet.
#
sub projectExtendEnvironment() {
    isDebug() && printMsg( "### projectExtendEnvironment() start\n" );

    # Let the NTMK module do the work.
    ntmkExtendEnvironment();
    # Project specific
     addRequiredEnv( "USE_LM_PROJECT", "$ENV{LM_PROJECT}", 1);
     addRequiredEnv( "OBJPATH", "$ENV{DEFAULT_OBJPATH}", 0);

    isDebug() && printMsg( "### projectExtendEnvironment() end\n" );
}


###############################################################################
# projectExtendOptions will register the project specific options.
# 
# This is where you register the arguments that your build will recognize.
# It is the step before actually parsing the arguments.
#
# Use the addOption() function.  This will result in the Perl getopts::long
# mechanism being used on your option.  For reference sample options might 
# look like:
#  'h'           - Allows [+-]h arguments.
#  '--help'      - Allows --help argument.
#  'P:s'         - Allows -P string arguments.
#  '--mailto=s'  - Allows --mailto=string arguments.
#  '--jobs=#'    - Allows --jobs=number arguments.
#
# If there are arguments that you want to pass directly to the command line 
# without needing to process them yourself you use the following syntax:
#   passThroughOption( 'j:i' );   # Enable parallel builds for GNU make.
#   passThroughOption( 'k' );     # Keep building after first error.
#   
sub projectExtendOptions() {
    isDebug() && printMsg( "### projectExtendOptions() start\n" );

    ntmkExtendOptions();
    # Project specific
    addOption( 'D' );     # Perform a full build using a Designer SYSROOT / image
    addOption( 'f:s' );    # Family build option
    addOption( 'l:s' );   # The directory where the formal build results can be found.
                          # (used for incremental designer builds)
    addOption( 't:s' );    # Target build option
    #addOption( '--list-sysroots' ); # Prints all the sysroots that are available.
    passThroughOption( 'L' ); # Register as a pass through option, we want to test for it.
    

    isDebug() && printMsg( "### projectExtendOptions() end\n" );
}


###############################################################################
# projectUnknownOptions allows the project to do something with the unknown 
# options.  If it does not remove all the contents from ARGV then an error
# will be generated.
#
sub projectUnknownOptions() {
    isDebug() && printMsg( "### projectUnknownOptions() start\n" );

    # These must be the targets we pass on to the build.
    while ( @ARGV ) {
        my $target = shift( @ARGV );

        # We can detect special targets like clean...
        # We use the addArg() function to insert the argument in the logical
        # middle of the command line.
        addArg( $target );
    } 

    isDebug() && printMsg( "### projectUnknownOptions() end\n" );
}


###############################################################################
# Processing the options.
#
sub projectProcessOptionsEarly() {
    isDebug() && printMsg( "### projectProcessOptionsEarly() start\n" );
      $opt_t =  getOption('t');
      setOption('t','');
    isDebug() && printMsg( "### projectProcessOptionsEarly() end\n" );
}

###############################################################################
# projectProcessOptionsLate allows the project to process the options after 
# ubuild had done it's option processing.
#
# You normally do your processing here so that if the user did --help then 
# ubuild has already responded to it and ended.
#
#
# Typically you use a style like:
#   my $opt_S = getOptions('S');
#   
#  if ( $opt_S ) {
#    # Do something about it.
#  }
# where "do something about it" is typically one of the following...
#  - Update a variable that will be used while generating the command line.
#  - Add something else to the environment using addRequiredEnv or 
#    addOptionalEnv.
#  - Respond directly to the user, then end the script.
#    if ( $opt_GoMakeCoffee ) {
#        printMsg( "Ok done.\n" );
#        trackUsageAndExit( 0 );
#    }
#
# Recommend that you comment in the code what each option is doing.
#
sub projectProcessOptionsLate() {
    isDebug() && printMsg( "### projectProcessOptionsLate() start\n" );

    #######################################################
    # NTMK support.
    ntmkProcessOptions();


    ####################################################### 
    ## Siren Options
     if ( getOption('S')){
        printMsg("\nConfigured architectures for this project:\n");
         foreach (sort glob($realProgNameDirname . "/mk/blades_config/*.in")) {
        $_ = basename($_); s/\.in$//;
        }
        exit 0;
     }
     
     my $opt_f =  getOption('f');
     my $opt_D =  getOption('D');
     my $opt_P =  getOption('P');
     my $opt_l =  getOption('l');
     $opt_W =  getOption('W');
           
     ###  Processing family and target option

     if ( $opt_f && $opt_t ) {
         fail("ERROR: The '-f' and '-t' options are incompatible.\n");
     } elsif ( !$opt_f && !$opt_t ){
         $fam = "$ENV{ntmkbw_DEFAULTFAM}";
         $tgt = "fam";
     } elsif ($opt_f) {
	 if (`$ENV{USE_SRC_ROOT}/ebuild/ipteldc/ipteldc/trunk/tools/build/bin/getArch -m $opt_f -f $tgtfam_list` eq "") {
           die "ERROR: Family $opt_f does not exist\n";
         }
         $fam = $opt_f;
         $tgt = "fam";
     } elsif ($opt_t) {
         $tgt = $opt_t;
         $fam = `$ENV{USE_SRC_ROOT}/ebuild/ipteldc/ipteldc/trunk/tools/build/bin/getArch -v $opt_t -f $tgtfam_list`;
         if ($fam eq "") {
           die "ERROR: Target $opt_t does not exist\n";
         }
     }
     addArg ("FAM=$fam");
     addArg ("TGT=$tgt");
     

     my $formalBuildDir = $realProgNameDirname . "/mk/blades_config/" . $tgt . "_" . $fam ."_build_dir";
    
    $blade = "$ENV{ntmkbw_ARCHPREFIX}".`$ENV{USE_SRC_ROOT}/ebuild/ipteldc/ipteldc/trunk/tools/build/bin/getArch -m $fam -v $tgt -f $tgtfam_list`;
    # -P opt.
    #
    if ($opt_P) {
         if (! -d $opt_P) {
         die "ERROR: Cannot find directory $opt_P: $!\nPLease check that the directory exists.\n";
         }
         $pkgsInDir = "PKGS_IN_DIR=$opt_P";
         addArg ("PKGS_IN_DIR=$opt_P");
         printMsg("Using PKGS_IN_DIR directory: $pkgsInDir\n");
    }
 
    if ($opt_l) {
       $loadDirName = "$ENV{ntmkbw_LOADSLOCATION}/$opt_l$ENV{ntmkbw_LOADSLOCATION_SUFFIX}";
       eval ($ENV{ntmkbw_LOADDIRNAME_POSTPROCESSING});
       # Does the formal build dir exist?
       if (-d $loadDirName) {
         printMsg("\n Using formal build directory:\n");
         printMsg("$loadDirName\n\n");
       } else {
         die ("ERROR: Cannot find directory $loadDirName: $!\nPLease check that the directory exists.\n");
       }
    }

    # This one is specific to HA - the PKGS_IN directory is also derived from the file $formalBuildDir

    if ($opt_D and !$opt_P and $ENV{ntmkbw_PKGSINDIRNAME_FROMFILE}) {
        open(F, $formalBuildDir) || die "ERROR: Cannot open file $formalBuildDir: $!\n";
        chomp($d=<F>);
        close(F);
        die "ERROR: File $formalBuildDir is empty\n" if $d eq "";
        $pkgsInDir = $d . $ENV{ntmkbw_LOADSLOCATION_SUFFIX};
        printMsg("$ENV{ntmkbw_PKGSINDIRNAME_POSTPROCESSING}\n");  
        eval ($ENV{ntmkbw_PKGSINDIRNAME_POSTPROCESSING});
       $pkgsInDir = "PKGS_IN_DIR=$pkgsInDir";
     }

    ########################New options ####################

    # If -D or -l were not given, this means that the build is not isolated.
    # We have to find the formal build diretcory 
    # and pass it to SYSROOT
    #
    if (!$opt_D and !$opt_l) {
      # Do we detect the formal build dir by reading a file?
      if ($ENV{ntmkbw_FORMALBUILDDIRNAME_FROMFILE}) {
        open(F, $formalBuildDir) || die "ERROR: Cannot open file $formalBuildDir: $!\n";
        chomp($d=<F>);
        close(F);
        die "ERROR: File $formalBuildDir is empty\n" if $d eq "";
        $loadDirName = $d . $ENV{ntmkbw_LOADSLOCATION_SUFFIX};
        eval ($ENV{ntmkbw_LOADDIRNAME_POSTPROCESSING});
      }
      # No, by detecting a baseline
      else {
      #Are we in a view?
      $viewname = `$cleartool pwv -short 2>/dev/null`;
      chomp $viewname;
      if ($viewname ne "" && $viewname ne '** NONE **') {
         # We are in a view
         # Is it the integration stream?
         my $stream = `$cleartool lsstream -short`;
         chomp $stream;
         if ($stream =~ $ENV{ntmkbw_INTSTREAMPATTERN}) {
           # We are on the integration stream, get the latest build:
           $loadDirName = readlink("$ENV{ntmkbw_LOADSLOCATION}/$ENV{ntmkbw_LATESTBUILD}") or die "ERROR: $ENV{ntmkbw_LOADSLOCATION}/$ENV{ntmkbw_LATESTBUILD} not available. workaround: Use the -l option\n";
           $loadDirName = $loadDirName . $ENV{ntmkbw_LOADSLOCATION_SUFFIX};
         } else {    
            $loadDirName = `$cleartool lsstream -fmt "%[found_bls]p"`;
	   # This is hard to explain, but winkin works better if:
	   # If the current version of packageMappings.list is identical as content
	   # to the one on the integration stream, use that one
	  if (! $opt_W ) {
             $pkgMapping = `getFileIntVer.sh $ENV{USE_SRC_ROOT}/ebuild/ipteldc/ipteldc/trunk/tools/pkgtools/config/packageMapping.list $loadDirName\@$ENV{ntmkbw_PVOB}`;
	    chomp $pkgMapping ;
            if ($pkgMapping eq "") {
                my $pkgMappingVar = "";
	    } else {
	        $pkgMappingVar = "PKGTOOLS_MAPLIST_CONFIG_FILE=$pkgMapping";
	    } 
 
           } 
	   eval($ENV{ntmkbw_BLTODIR});
           # Baseline not found
           if ($loadDirName eq "") {
               
              printMsg("ERROR: Your view does not allow for automatic detection of the formal build dir\n");
              printMsg("Please specify the -D switch for an isolated designer build\n");
              printMsg("or -l <formal_build_directory> for an incremental build\n");
              die;
           } 
           $loadDirName = "$ENV{ntmkbw_LOADSLOCATION}/$loadDirName$ENV{ntmkbw_LOADSLOCATION_SUFFIX}";
          }       
         #We found a directory
         # Does the formal build dir exist?
         if ( -d $loadDirName ) {
           
           printMsg("\nUsing formal build directory:\n");
           printMsg("$loadDirName\n\n");
         } else {
           printMsg("ERROR: Cannot find directory $loadDirName: $!\n");
           printMsg("You have the following choices: \n");
           printMsg("  - your baseline might be too old:\n        rebase your stream to a newer baseline\n");
           printMsg("  - you are on a nested development stream:\n        specify the -l <formal_build_dir> option\n");
           printMsg("  - you have a special configuration:\n        perform a full build by adding the -D option\n");
           printMsg("  - you have a mising mount on the build machine:\n        call NT4HELP\n");
           printMsg("  - the sbuild tool is broken :(\n        call 5TOOL.\n");
           die;
         } #       
      } else {
        # Not in a view 
        printMsg("Please specify the -D switch for an isolated designer build\n");
        printMsg("or -l <formal_build_directory> for an incremental build\n");
        die;
      } # 
    } #
    # -N option makes sense only if we did not specified -D
    if ($opt_N) {
      # 
      $useFormalLibs = "N";
     } 
  }

 
     #######################################################
     
     addArg ("FORMAL_BUILD_DIR=$loadDirName");
     addArg ("USE_FORMAL_LIBS=$useFormalLibs");
     addArg ($pkgsInDir);
     addArg ($prodRelease);
     my $ntmkbw_PKGVERSION = $ENV{ntmkbw_PKGVERSION} ||  "$ENV{ntmkbw_PRODUCTREL}".".". `date '+%y%W99.0'`;
     chomp $ntmkbw_PKGVERSION;
    
      addArg ("PKG_VERSION=$ntmkbw_PKGVERSION");
     if ($ENV{ntmkbw_PROD_RELEASE}) {
        $prodRelease = "PROD_RELEASE=$ENV{ntmkbw_PROD_RELEASE}";
     }
     addArg ("PROD_RELEASE=$ENV{ntmkbw_PROD_RELEASE}");
     addArg ("ntmkbw_PRODUCTID=$ENV{ntmkbw_PRODUCTID}");
     addArg ("ntmkbw_NCGLVER=$ENV{ntmkbw_NCGLVER}");
     addArg ("ALLOW_.CPP_FILES=Y");
     if (defined $ENV{ntmkbw_VSE_RELEASE}) {
       addArg ("VSE_RELEASE=$ENV{ntmkbw_VSE_RELEASE}");
     }
     if (defined $ENV{ntmkbw_APP_RELEASE}){
       addArg ("APP_RELEASE=$ENV{ntmkbw_APP_RELEASE}");
     }
     ##addArg ($saEnv);
     isDebug() && printMsg( "### projectProcessOptionsLate() end\n" );
}


###############################################################################
# This allows you to print a little summary before the actual build starts.
#
#
sub projectPrebuildSummary() {
    isDebug() && printMsg( "### projectPrebuildSummary() start\n" );

    isDebug() && printMsg( "### projectPrebuildSummary() end\n" );
}

###############################################################################
# If the build needs to be run in a specific (not the current) directory
# then return it here.
#
sub projectBuildDirectory() {
    return undef;
}

###############################################################################
# This is where you formulate the command line to execute.  
#
# ubuild will do the environment setup so you don't have to worry about that.
#
# You should use the generateDefaultCommandLine function to modify your command 
# line.  This will add any pass through options that were present.
#
sub projectGenerateCommandLine() {
    my $commandLine = ntmkGenerateCommandLine();

    printMsg("$commandLine \n");
    # If you want to see the command line you can add --debug-cmd to your 
    # ~/.ubuild file.

    return $commandLine;
}

###############################################################################
# This allows ubuild to perform work after the build completes.
#
# It accepts a single argument that is the return code from the build.
#
sub projectPostBuild($) {
    my ($returnCode) = @_;

    isDebug() && printMsg( "### projectPostBuild($returnCode) start\n" );
    
    isDebug() && printMsg( "### projectPostBuild() end\n" );
}

###############################################################################
# This allows the project to append specific content to the trkusage logging.
#
# It is passed the command line that was executed, and it can modify it / 
# replace it.  The return is added to the trkusage call.
#
sub projectTrkusage($) {
    my ( $buildCommand ) = @_;

    return $buildCommand;
}

###############################################################################
#
sub projectHelpFiles($) {
    my ( $helpFiles ) = @_;

    # Add NTMK help.
    ntmkHelpFiles( $helpFiles );

    # Add our help.
    unshift( @{$helpFiles}, "$ENV{ubuild_CONFIG_DIR}/project.hlp" );
}

###############################################################################
1;
