# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Collection of scripts to augment portage packages"
HOMEPAGE="https://github.com/lucius-martius/portage-bashrc-martius"
SRC_URI="https://github.com/lucius-martius/portage-bashrc-martius/archive/v${PV}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+zfs +initramfs +efi symlink"
REQUIRED_USE="zfs? ( initramfs )
              ?? ( symlink efi )"


RDEPEND="app-portage/portage-bashrc-mv
         initramfs?
           ( || (
             sys-kernel/gentoo-kernel[-initramfs]
             sys-kernel/vanilla-kernel[-initramfs]
           ) )
         efi? ( sys-boot/efibootmgr )"

src_install() {
  insinto /etc/portage/bashrc.d
  doins ${S}/bashrc.d/10-kernel_common.sh
  if use zfs; then
    doins ${S}/bashrc.d/50-kernel_zfs_builtin.sh
  fi
  doins ${S}/bashrc.d/70-kernel_install.sh
  doins ${S}/bashrc.d/70-kernel_null_installkernel.sh
  doins ${S}/bashrc.d/70-kernel_uninstall.sh
  doins ${S}/bashrc.d/80-kernel_config.sh
  if use symlink; then
    doins ${S}/bashrc.d/80-kernel_symlink.sh
  fi
  if use efi; then
    doins ${S}/bashrc.d/80-kernel_update_efi.sh
  fi

  if use initramfs; then
    doins ${S}/bashrc.d/60-kernel_initramfs.sh
    insinto /usr/share
    doins script/initramfs.init
  fi
}