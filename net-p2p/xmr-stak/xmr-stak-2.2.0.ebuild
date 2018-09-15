# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Monero all-round miner"
HOMEPAGE="https://www.mullvad.net/"
SRC_URI="https://github.com/fireice-uk/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+aeon +donate cuda +hwloc +microhttpd opencl ssl static +xmr"

RDEPEND="microhttpd? ( net-libs/libmicrohttpd )
         ssl? ( dev-libs/openssl )
         hwloc? ( sys-apps/hwloc )
         cuda? ( dev-util/nvidia-cuda-toolkit )
         opencl? ( virtual/opencl )
         <=sys-devel/gcc-6.4.9999"

CMAKE_BUILD_TYPE=Release

src_prepare(){
    default

    if ! use donate; then
        epatch "${FILESDIR}/no-donation.patch"
    fi

    cmake-utils_src_prepare
}

src_configure(){
    local mycmakeargs=(
        -DMICROHTTPD_ENABLE=$(usex microhttpd ON OFF )
        -DCMAKE_LINK_STATIC=$(usex static ON OFF )
        -DOpenSSL_ENABLE=$(usex ssl ON OFF )
        -DHWLOC_ENABLE=$(usex hwloc ON OFF )
        -DOpenCL_ENABLE=$(usex opencl ON OFF )
        -DCUDA_ENABLE=$(usex cuda ON OFF )
    )

    if use xmr && ! use aeon; then
        mycmakeargs+=(
            -DXMR-STAK_CURRENCY=monero
        )
    elif use aeon && ! use xmr; then
        mycmakeargs+=(
            -DXMR-STAK_CURRENCY=aeon
        )
    fi

    cmake-utils_src_configure
}

src_install(){
    newconfd ${FILESDIR}/conf xmr-stak
    newinitd ${FILESDIR}/init xmr-stak

    #Generate config files
    printf "%s\n%s\n%s\n%s\n%s\n%s" \
           "pool.usxmrpool.com:3333" \
           "<wallet-address>" "" "y" "n" "n" \
      | ${BUILD_DIR}/bin/xmr-stak > /dev/null &
    pid=$!
    sleep 1
    kill ${pid}

    insinto /etc/xmr-stak/
    doins ${S}/config.txt
    doins ${S}/cpu.txt

    use cuda && doins ${S}/nvidia.txt
    use opencl && doins ${S}/amd.txt

    dobin ${BUILD_DIR}/bin/xmr-stak

    if use cuda; then
        dolib ${BUILD_DIR}/bin/libxmrstak_cuda_backend.so
    fi

    if use opencl; then
        dolib ${BUILD_DIR}/bin/libxmrstak_opencl_backend.so
    fi
}
