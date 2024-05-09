# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Collection of scripts to augment portage packages"
HOMEPAGE="https://github.com/lucius-martius/portage-bashrc-martius"
SRC_URI="https://github.com/lucius-martius/portage-bashrc-martius/archive/v${PV}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-kernel-symlink +kernel-uninstall"

RDEPEND="app-portage/portage-bashrc-mv"

src_install() {
  insinto /etc/portage/bashrc.d
  doins ${S}/bashrc.d/10-kernel_common.sh

  if use kernel-uninstall; then
	doins ${S}/bashrc.d/70-kernel_uninstall.sh
  fi

  doins ${S}/bashrc.d/80-kernel_config.sh

  if use kernel-symlink; then
	doins ${S}/bashrc.d/80-kernel_symlink.sh
  fi
}
