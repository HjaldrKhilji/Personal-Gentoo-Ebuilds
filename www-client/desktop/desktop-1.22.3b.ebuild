# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9
DESCRIPTION="Zen browser custom ebuild"
HOMEPAGE="https://zen-browser.app/"
SRC_URI="https://github.com/zen-browser/desktop/releases/download/$PVR/zen.source.tar.zst"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
#source: https://github.com/zen-browser/desktop/blob/dev/requirements.txt
RDEPEND="
	>=dev-python/click-8.1.8
        >=dev-python/mypy-extensions-1.0.0
        >=dev-python/packaging-24.2
        >=dev-python/pathspec-1.1.1
        >=dev-python/platformdirs-4.3.6
        >=dev-python/pycodestyle-2.12.1
        >=dev-python/requests-2.34.2
        "
DEPEND="${RDEPEND}"

BDEPEND="
	>=net-libs/nodejs-22
        >=dev-lang/python-3.11
        >=dev-lang/rust-1.95.0
        app-arch/zstd
	llvm-runtimes/clang-runtime
	llvm-runtimes/compiler-rt-sanitizers
	dev-util/sccache
	app-shells/bash
	sys-apps/findutils
	app-arch/gzip
	dev-build/make
	dev-lang/perl
	app-arch/tar
	app-arch/unzip
        "
S=$WORKDIR
src_unpack() {
        tar -xf  $DISTDIR/zen.source.tar.zst
}
src_compile() {
	cd $S
	./mach build
	echo "ac_add_options --with-ccache=sccache">mozconfig
}
