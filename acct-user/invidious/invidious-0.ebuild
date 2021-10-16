# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Invidious program user"
ACCT_USER_ID=567
ACCT_USER_GROUPS=( invidious )
ACCT_USER_HOME=/var/lib/invidious
ACCT_USER_HOME_PERMS=0700
ACCT_USER_SHELL=/bin/sh
acct-user_add_deps
SLOT="0"
