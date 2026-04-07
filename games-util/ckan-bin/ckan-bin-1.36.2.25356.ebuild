# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

HOMEPAGE="https://github.com/KSP-CKAN/CKAN/"

if [[ "${PV}" =~ ^([0-9]+?\.[0-9]+?\.[0-9]+?)\..+?$ ]]; then
  TV=${BASH_REMATCH[1]}
fi

SRC_URI="https://github.com/KSP-CKAN/CKAN/releases/download/v${TV}/ckan-${PV}-1.noarch.rpm -> ${P}.rpm"

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

	local size
	for size in 16 32 48 64 96 128 256; do
	  insinto /usr/share/icons/hicolor/${size}x${size}/apps/
	  newins usr/share/icons/hicolor/${size}x${size}/apps/${PN%-bin}.png ${PN%-bin}.png
	done;

	doman "ckan.1"
}
