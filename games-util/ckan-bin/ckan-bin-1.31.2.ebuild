# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

HOMEPAGE="https://github.com/KSP-CKAN/CKAN/"
SRC_URI="https://github.com/KSP-CKAN/CKAN/releases/download/v${PV}/ckan-${PV}-1.noarch.rpm -> ${P}.rpm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-lang/mono[-minimal]"
BDEPEND="media-gfx/imagemagick"

S="${WORKDIR}"

src_prepare() {
	zcat "usr/share/man/man1/ckan.1.gz" > "ckan.1"

	# convert "${S}/usr/share/icons/ckan.ico" "${S}/ckan.png"

	eapply_user
}

src_install() {
	dobin "usr/bin/ckan"

	insinto "/usr/lib/ckan"
	doins "usr/lib/ckan/ckan.exe"

	insinto "/usr/share/applications/"
	doins "usr/share/applications/ckan.desktop"

	insinto "/usr/share/icons"
	doins "usr/share/icons/ckan.ico"

	doman "ckan.1"
}
