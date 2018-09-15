# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="The client to the PoC crypto-currency Burstcoin"
HOMEPAGE="https://www.burst-coin.org/"
SRC_URI="https://github.com/PoC-Consortium/${PN}/releases/download/${PV}/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND="dev-db/mariadb
         virtual/jdk"

S=${WORKDIR}

src_install(){
    newconfd ${FILESDIR}/conf burstcoin
    newinitd ${FILESDIR}/init burstcoin

    insinto /opt/burst/
    doins -r ${S}/conf
    doins -r ${S}/html
    doins ${S}/burst.jar
    doins ${S}/genscoop.cl

    exeinto /opt/burst
    doexe ${S}/burst.sh
}

pkg_postinst() {
    ewarn "This will not install the mariadb database."
    ewarn "You need to do that yourself using /opt/burst/burst.sh"
    ewarn "import mariadb after setting up the database and database"
    ewarn "user itself. When both of those are done, enter your"
    ewarn "mariadb info in /opt/burst/conf/brs.properties and"
    ewarn "start the service."

    enewgroup burst
    enewuser burst -1 -1 /var/lib/burst "burst"
}
