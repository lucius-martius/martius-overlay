# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A tower-defense game about shooting down UFOs"
HOMEPAGE="https://getmonero.org/"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="media-libs/libogg[abi_x86_32]
         media-libs/libvorbis[abi_x86_32]
         media-gfx/nvidia-cg-toolkit[abi_x86_32]
         x11-libs/gtk+:2[abi_x86_32]
         media-libs/libcanberra[abi_x86_32]"

pkg_postinst() {
    ewarn "This only pulls in the dependencies, NOT the actual game itself."
    ewarn "Install the game via steam or humble-bundle or something!"
}