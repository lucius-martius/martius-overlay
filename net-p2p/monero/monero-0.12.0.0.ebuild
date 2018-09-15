# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils user

DESCRIPTION="A private, secure, untraceable, decentralised digital currency"
HOMEPAGE="https://getmonero.org/"
SRC_URI="https://github.com/monero-project/${PN}/archive/v${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND="dev-libs/boost
         dev-libs/expat
         dev-libs/openssl
         net-libs/zeromq
         net-dns/unbound[threads]
         net-libs/miniupnpc
         net-libs/cppzmq"

CMAKE_BUILD_TYPE=Release

src_configure(){
    local mycmakeargs=(
        -DSTACK_TRACE=OFF
        -DBUILD_DOCUMENTATION=$(usex doc ON OFF)
    )

    cmake-utils_src_configure
}

src_install(){
    newconfd ${FILESDIR}/conf monerod
    newinitd ${FILESDIR}/init monerod

    dobin ${BUILD_DIR}/bin/monerod
    dobin ${BUILD_DIR}/bin/monero-wallet-rpc
    dobin ${BUILD_DIR}/bin/monero-wallet-cli
    dobin ${BUILD_DIR}/bin/monero-blockchain-export
    dobin ${BUILD_DIR}/bin/monero-blockchain-import
}

pkg_postinst() {
    enewgroup monero
    enewuser monero -1 -1 /var/lib/monero "monero"
}