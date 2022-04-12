# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools bash-completion-r1

DESCRIPTION='Manage config files in $HOME via fake bare git repositories'
HOMEPAGE="https://github.com/RichiH/vcsh/"

SRC_URI="https://github.com/RichiH/vcsh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="man bash-completion"

RESTRICT="test"

RDEPEND="dev-vcs/git
		 man? ( app-text/ronn )"
DEPEND=""

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	# TODO: Man page requires app-text/ronn which requires ruby
	econf $(use_with man man-page)
}

src_compile() {
	default
}

src_install() {
	if use bash-completion; then
		dobashcomp completions/vcsh
	fi
	dodoc -r doc
	dobin vcsh
}
