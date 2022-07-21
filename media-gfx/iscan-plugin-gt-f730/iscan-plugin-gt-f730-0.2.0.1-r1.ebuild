# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multilib rpm

#SRC_REV="4"

MY_PV="$(ver_cut 1-3)"
MY_PVR="$(ver_rs 3 -)"
MY_P="esci-interpreter-perfection-v330-${MY_PVR}"

DESCRIPTION="Epson Perfection V330 PHOTO scanner plugin for SANE 'epkowa' backend."
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"

#TODO: Move to epson provided RPMs like the arch PKGBUILD uses
SRC_URI="amd64? ( https://src.fedoraproject.org/lookaside/pkgs/iscan-firmware/${MY_P}.x86_64.rpm/4aef1dacc55f257f25f5c73cbdf6e3ed/${MY_P}.x86_64.rpm )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* ~amd64"

DEPEND="<media-gfx/iscan-3"
RDEPEND="${DEPEND}"

QA_PREBUILT="usr/lib64/esci/libesci-interpreter-perfection-v330.so*"

src_unpack() {
	mkdir -p "${S}"
	cd "${S}"
	rpm_src_unpack
}

src_install() {
	local MY_LIB="/usr/$(get_libdir)"

	# install scanner firmware
	insinto /usr/share/esci
	doins "${S}/usr/share/esci/"*

	# install scanner plugins
	insinto "${MY_LIB}/esci"
	INSOPTIONS="-m0755"
	doins "${S}/usr/$(get_libdir)/esci/"*
}

pkg_postinst() {
	local MY_LIB="/usr/$(get_libdir)"

	# Needed for scaner to work properly.
	iscan-registry --add interpreter usb 0x04b8 0x0142 "${MY_LIB}/esci/libesci-interpreter-perfection-v330 /usr/share/esci/esfwad.bin" || die
	elog
	elog "Firmware file esfwad.bin for Epson Perfection V330 PHOTO"
	elog "has been installed in /usr/share/esci and registered for use."
	elog
}

pkg_prerm() {
	local MY_LIB="/usr/$(get_libdir)"

	iscan-registry --remove interpreter usb 0x04b8 0x0142 "${MY_LIB}/esci/libesci-interpreter-perfection-v330 /usr/share/esci/esfwad.bin" || die
}
