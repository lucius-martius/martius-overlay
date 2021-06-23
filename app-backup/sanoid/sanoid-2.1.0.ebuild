# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DESCRIPTION="Tool to auto-snapshot and sync ZFS filesystems"
HOMEPAGE="https://github.com/jimsalterjrs/sanoid"
SRC_URI="https://github.com/jimsalterjrs/sanoid/archive/v${PV}.tar.gz -> sanoid-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"


DEPEND="dev-perl/Config-IniFiles
		dev-perl/Capture-Tiny
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
