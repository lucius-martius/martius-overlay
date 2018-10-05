# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit multilib versionator rpm

SRC_REV="4"

MY_PV="$(get_version_component_range 1-3)"
MY_PVR="$(replace_version_separator 3 -)"
MY_P="esci-interpreter-perfection-v330-${MY_PVR}"

DESCRIPTION="Epson Perfection V330 PHOTO scanner plugin for SANE 'epkowa' backend."
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="amd64? ( https://src.fedoraproject.org/lookaside/pkgs/iscan-firmware/${MY_P}.x86_64.rpm/4aef1dacc55f257f25f5c73cbdf6e3ed/${MY_P}.x86_64.rpm )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* ~amd64"

DEPEND=">=media-gfx/iscan-2.21.0"
RDEPEND="${DEPEND}"

QA_PREBUILT="usr/lib64/esci/libesci-interpreter-perfection-v330.so*"

src_install() {
	local MY_LIB="/usr/$(get_libdir)"

	# install scanner firmware
	insinto /usr/share/esci
	doins "${WORKDIR}/usr/share/esci/"*

	# install scanner plugins
	insinto "${MY_LIB}/esci"
	INSOPTIONS="-m0755"
	doins "${WORKDIR}/usr/$(get_libdir)/esci/"*
}

pkg_postinst() {
	local MY_LIB="/usr/$(get_libdir)"

	# Needed for scaner to work properly.
	iscan-registry --add interpreter usb 0x04b8 0x0142 "${MY_LIB}/esci/libesci-interpreter-perfection-v330 /usr/share/esci/esfwad.bin"
	elog
	elog "Firmware file esfwad.bin for Epson Perfection V330 PHOTO"
	elog "has been installed in /usr/share/esci and registered for use."
	elog
}

pkg_prerm() {
	local MY_LIB="/usr/$(get_libdir)"

	iscan-registry --remove interpreter usb 0x04b8 0x0142 "${MY_LIB}/esci/libesci-interpreter-perfection-v330 /usr/share/esci/esfwad.bin"
}
 
