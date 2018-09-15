# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Mullvad client for connecting to the VPN service"
HOMEPAGE="https://www.mullvad.net/"
SRC_URI="https://www.mullvad.net/media/client/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="net-misc/openvpn
        dev-lang/python:2.7
        dev-python/wxpython
        x11-libs/gksu
        dev-python/ipaddr
        sys-apps/net-tools
		dev-python/netifaces
		net-firewall/iptables
		net-dns/openresolv"

src_prepare() {
    chmod +x setup.py
    eapply_user
}

src_configure() {
    python2 setup.py build
}

src_install() {
    cd ${P}
    python2 setup.py install --root "${D}"

    mkdir -p ${P}/etc/openvpn
    cp "${FILESDIR}/update-resolv-conf" "${D}/etc/openvpn/"
    chmod +x ${P}/etc/openvpn/update-resolv-conf
}
