#!/bin/sh
#
# uninstall.sh - Copyright (c) 2018-2025 - Olivier Poncet
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

opt_prefix="${PREFIX:-/usr}"
opt_bindir="${DESTDIR}${opt_prefix}/bin"
opt_shrdir="${DESTDIR}${opt_prefix}/share"

# ----------------------------------------------------------------------------
# files
# ----------------------------------------------------------------------------

opt_src01="./bin/pve-bulk"
opt_dst01="${opt_bindir}/pve-bulk"
opt_src02="./share/bash-completion/completions/pve-bulk"
opt_dst02="${opt_shrdir}/bash-completion/completions/pve-bulk"

# ----------------------------------------------------------------------------
# debug
# ----------------------------------------------------------------------------

set -x

# ----------------------------------------------------------------------------
# uninstall files
# ----------------------------------------------------------------------------

rm -f "${opt_dst01}"                                                 || exit 1
rm -f "${opt_dst02}"                                                 || exit 1

# ----------------------------------------------------------------------------
# End-Of-File
# ----------------------------------------------------------------------------
