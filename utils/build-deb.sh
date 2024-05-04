#!/bin/sh
#
# build-deb.sh - Copyright (c) 2018-2024 - Olivier Poncet
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
# backup our debian directory
# ----------------------------------------------------------------------------

mv "debian" "debian.org"                                             || exit 1

# ----------------------------------------------------------------------------
# prepare the source package
# ----------------------------------------------------------------------------

dh_make --yes --single --copyright gpl2 --createorig                 || exit 1

# ----------------------------------------------------------------------------
# remove the generated debian directory
# ----------------------------------------------------------------------------

rm -rf "debian"                                                      || exit 1

# ----------------------------------------------------------------------------
# restore our debian directory
# ----------------------------------------------------------------------------

mv "debian.org" "debian"                                             || exit 1

# ----------------------------------------------------------------------------
# build the debian package
# ----------------------------------------------------------------------------

dpkg-buildpackage --no-sign                                          || exit 1

# ----------------------------------------------------------------------------
# End-Of-File
# ----------------------------------------------------------------------------
