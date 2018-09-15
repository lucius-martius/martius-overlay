# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit git-r3

EGIT_REPO_URI="https://github.com/jimsalterjrs/sanoid"
EGIT_COMMIT="34e4c248bce29103a3f62a08246bc0d51aee23b8"
DESCRIPTION="Tool to auto-snapshot and sync ZFS filesystems"
HOMEPAGE="https://github.com/jimsalterjrs/sanoid"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"


DEPEND="dev-perl/Config-IniFiles
        sys-apps/pv
        app-arch/lzop
        sys-block/mbuffer"

src_install() {
    insinto /etc/sanoid/
    doins ${S}/sanoid.conf
    doins ${S}/sanoid.defaults.conf

    dosbin sanoid
    dosbin syncoid
}