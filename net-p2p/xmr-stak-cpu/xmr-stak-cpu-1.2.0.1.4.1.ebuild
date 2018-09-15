# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils versionator

MY_PV=$(replace_version_separator 3 '-')
MY_P="${PN}-${MY_PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Monero CPU miner"
HOMEPAGE="https://www.mullvad.net/"
SRC_URI="https://github.com/fireice-uk/${PN}/archive/v${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+microhttpd static ssl"

RDEPEND="microhttpd? ( net-libs/libmicrohttpd )
         ssl? ( dev-libs/openssl )"

CMAKE_BUILD_TYPE=Release

src_prepare(){
	default 
	epatch "${FILESDIR}/no-donation.patch"
}

src_configure(){
    local mycmakeargs=(
        -DMICROHTTPD_REQUIRED=$(usex microhttpd ON OFF )
        -DCMAKE_LINK_STATIC=$(usex static ON OFF )
        -DOpenSSL_REQUIRED=$(usex ssl ON OFF )
    )
    cmake-utils_src_configure
}

src_install(){
    newconfd ${FILESDIR}/conf xmr-stak-cpu
    newinitd ${FILESDIR}/init xmr-stak-cpu

    insinto /etc/xmr-stak/cpu/
    doins ${S}/config.txt

    dobin ${BUILD_DIR}/bin/xmr-stak-cpu
}
