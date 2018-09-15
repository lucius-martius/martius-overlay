# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Monero all-round miner"
HOMEPAGE="https://www.mullvad.net/"
SRC_URI="https://github.com/fireice-uk/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+donate cuda +hwloc +microhttpd opencl ssl static"

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

    cmake-utils_src_configure
}

src_install(){
    newconfd ${FILESDIR}/conf xmr-stak
    newinitd ${FILESDIR}/init xmr-stak

    dobin ${BUILD_DIR}/bin/xmr-stak

    if use cuda; then
        dolib ${BUILD_DIR}/bin/libxmrstak_cuda_backend.so
    fi

    if use opencl; then
        dolib ${BUILD_DIR}/bin/libxmrstak_opencl_backend.so
    fi
}

pkg_postinst() {
	if [ ! -e "${ROOT}etc/xmr-stak/main.config" ]; then
		ewarn "To use xmr-stack:"
		if use cuda || use opencl; then
			ewarn ">our user must be a member of the 'video' group."
		fi
		ewarn "To generate config files, run as root"
		ewarn "/usr/bin/xmr-stak --cpu /etc/xmr-stak/cpu --amd /etc/xmr-stak/amd --nvidia /etc/xmr-stak/nvidia -c /etc/xmr-stak/config"
		ewarn "If the systemd will be used, xmr-stak can now be terminated and 'systemctl start xmr-stak' can be used."
	fi
}
