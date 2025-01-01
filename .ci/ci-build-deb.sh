#!/bin/sh
#
# ci-build-deb.sh - Copyright (c) 2018-2025 - Olivier Poncet
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#

# ----------------------------------------------------------------------------
# variables
# ----------------------------------------------------------------------------

opt_topdir="$(pwd)"
opt_wrkdir="${opt_topdir}/_build"

# ----------------------------------------------------------------------------
# check if we are in a git repository
# ----------------------------------------------------------------------------

if [ ! -d "${opt_topdir}/.git" ]
then
    echo "*** not a git repository ***"
    exit 1
fi

# ----------------------------------------------------------------------------
# check if we have the required Makefile
# ----------------------------------------------------------------------------

if [ ! -f "${opt_topdir}/Makefile" ]
then
    echo "*** the Makefike was not found ***"
    exit 1
fi

# ----------------------------------------------------------------------------
# debug mode
# ----------------------------------------------------------------------------

set -x

# ----------------------------------------------------------------------------
# remove to the build directory if needed
# ----------------------------------------------------------------------------

rm -rf "${opt_wrkdir}"                                               || exit 1

# ----------------------------------------------------------------------------
# clone current repository
# ----------------------------------------------------------------------------

git clone "${opt_topdir}" "${opt_wrkdir}"                            || exit 1

# ----------------------------------------------------------------------------
# move to the build directory
# ----------------------------------------------------------------------------

cd "${opt_wrkdir}"                                                   || exit 1

# ----------------------------------------------------------------------------
# remove the .git directory (not needed)
# ----------------------------------------------------------------------------

rm -rf ".git"                                                        || exit 1

# ----------------------------------------------------------------------------
# build the debian package
# ----------------------------------------------------------------------------

make buildpackage                                                    || exit 1

# ----------------------------------------------------------------------------
# move to the parent directory
# ----------------------------------------------------------------------------

cd "${opt_topdir}"                                                   || exit 1

# ----------------------------------------------------------------------------
# remove to the build directory not needed anymore
# ----------------------------------------------------------------------------

rm -rf "${opt_wrkdir}"                                               || exit 1

# ----------------------------------------------------------------------------
# End-Of-File
# ----------------------------------------------------------------------------
