# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Store and restore metadata of files, directories, links in a tree"
HOMEPAGE="https://github.com/przemoc/metastore"
EGIT_REPO_URI="https://github.com/przemoc/metastore.git"
EGIT_COMMIT="107158f9a13720dfe2f8fa9ff97a776a6b34da1b"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE=""
SLOT="0"

src_install() {
	emake install PREFIX="$D/usr" DOCDIR="$D/usr/share/doc/${PF}"
}
