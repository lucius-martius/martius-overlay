# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils versionator

MY_PV=$(replace_version_separator 3 '-')
MY_P="${PN}-${MY_PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Monero Nvidia GPU miner"
HOMEPAGE="https://www.mullvad.net/"
SRC_URI="https://github.com/fireice-uk/${PN}/archive/v${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+microhttpd static ssl"

RDEPEND="microhttpd? ( net-libs/libmicrohttpd )
         ssl? ( dev-libs/openssl )
         dev-util/nvidia-cuda-toolkit
         sys-devel/gcc:5.4.0"

CMAKE_BUILD_TYPE=Release

CC=/usr/bin/gcc-5.4.0
CXX=/usr/bin/g++-5.4.0
CFLAGS="${CFLAGS} -fno-lto"
CXXFLAGS="${CXXFLAGS} -fno-lto"
LDFLAGS="${LDFLAGS} -fno-lto"

src_configure(){
    local mycmakeargs=(
        -DMICROHTTPD_REQUIRED=$(usex microhttpd ON OFF )
        -DCMAKE_LINK_STATIC=$(usex static ON OFF )
        -DOpenSSL_REQUIRED=$(usex ssl ON OFF )
    )
    cmake-utils_src_configure
}

src_prepare(){
	default
	epatch "${FILESDIR}/no-donation.patch"
}

src_install(){
    newconfd ${FILESDIR}/conf xmr-stak-nvidia
    newinitd ${FILESDIR}/init xmr-stak-nvidia

    insinto /etc/xmr-stak/nvidia/
    doins ${S}/config.txt

    dobin ${BUILD_DIR}/bin/xmr-stak-nvidia
}
