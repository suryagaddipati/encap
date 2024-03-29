#!/bin/bash

source /usr/local/src/common.bash

#name = name of this directory and the git tag name

############################# STUFF TO CONFIGURE ########################

SRCDIR="$topsrcdir/git"


#########################################################################


[ -d "$SRCDIR" ] || Fail "$SRCDIR does not exist as a directory"


#########################################################################

# To see diverse package options run:
#cmake "$SRCDIR" -L ; exit
# but make sure the cmake does not shit in the local git repo
# so maybe do it will a copy of the repo source tree and not
# SRCDIR as we defined it above.

builddir=
# create a new build_03/ or build_04/ or so on.
MkBuildDir builddir

set -x

cd "$SRCDIR" || Fail

# used: from the ../git/ directory
#git tag git tag -a dtk-4.0 -m "cube install 0"
#git push --tag
# to make the tag

# dump the source tree of a given version with a git tag $name
git archive  --format=tar $name | $(cd "$builddir" && tar -xf -) || Fail

cd "$builddir" || Fail
cmake\
 -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON\
 -DCMAKE_INSTALL_PREFIX:PATH="$prefix"\
 -DDTK_BUILD_WITH_FLTK:BOOL=ON\
 -DDGL_BUILD_WITH_FLTK:BOOL=ON\
 -DDGL_BUILD_WITH_FLTK:BOOL=ON\
 -DDIVERSE_BUILD_WITH_DADS:BOOL=OFF\
 -DDIVERSE_BUILD_WITH_DGL:BOOL=OFF\
 -DDADS_BUILD_WITHOUT_DADS:BOOL=ON\
 -DCMAKE_CXX_FLAGS:STRING="-g -Wall" || Fail

make -j10 || Fail # parallel make, woo ho!
make install || Fail

PrintSuccess
