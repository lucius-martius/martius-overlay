# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="An open source alternative front-end to YouTube"
HOMEPAGE="https://getmonero.org/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/iv-org/${PN}.git"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND="gnome-base/librsvg
		 dev-db/postgresql
		 acct-user/invidious
		 acct-group/invidious"

BDEPEND="dev-util/shards"

src_unpack(){
	git-r3_src_unpack

	cd ${S} || die
	shards install || die
}

src_compile(){
	ebegin "Building from source"
	crystal build --release --threads 4 --verbose ${S}/src/invidious.cr || die
	eend
}

src_install(){
	invidious_dir="/usr/share/invidious"

	newconfd ${FILESDIR}/conf invidious
	newinitd ${FILESDIR}/init invidious

	dobin ${S}/invidious

	insinto /etc/invidious
	newins ${S}/config/config.example.yml config.yml
	dosym /etc/invidious/config.yml ${invidious_dir}/config/config.yml

	insinto ${invidious_dir}
	doins -r ${S}/locales
	doins -r ${S}/config
	doins -r ${S}/assets
}

pkg_postinst() {
	elog "In case this is the first install,"
	elog "you need to setup the database with:"
	elog "  emerge --config www-apps/invidious"
}

pkg_config(){
	ebegin "Initializing postgre database."
	cd /usr/share/invidious || die "Could not find the invidious data dir."
	su postgres <<'EOF'
psql -c "CREATE USER kemal WITH PASSWORD 'kemal';"
createdb -O kemal invidious
psql invidious kemal < /usr/share/invidious/config/sql/channels.sql
psql invidious kemal < /usr/share/invidious/config/sql/videos.sql
psql invidious kemal < /usr/share/invidious/config/sql/channel_videos.sql
psql invidious kemal < /usr/share/invidious/config/sql/users.sql
psql invidious kemal < /usr/share/invidious/config/sql/session_ids.sql
psql invidious kemal < /usr/share/invidious/config/sql/nonces.sql
psql invidious kemal < /usr/share/invidious/config/sql/annotations.sql
psql invidious kemal < /usr/share/invidious/config/sql/playlists.sql
psql invidious kemal < /usr/share/invidious/config/sql/playlist_videos.sql
EOF
	eend $?
}
