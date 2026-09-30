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
BDEPEND=">=net-libs/nodejs-22
        >=dev-lang/python-3.11
        >=dev-lang/rust-1.95.0"
	# Firefox builds are made internally with Clang/llvm because You cannot have Rust without LLVM, hence the following
	BDEPEND+="
	llvm-runtimes/clang-runtime
	llvm-runtimes/compiler-rt-sanitizers"
	#found as dependencies in /python/mozboot/mozboot specifically in the gentoo.py and linux_common.py files
	BDEPEND+="
	app-shells/bash
	sys-apps/findutils
	app-arch/gzip
	dev-build/make
	dev-lang/perl
	app-arch/tar
	app-arch/unzip"
BDEPEND+="
	 >=dev-python/orjson-3.10
	 >=dev-python/psutil-5.4.2
	 >=dev-python/zstandard-0.11.1
	 <=dev-python/zstandard-0.25.0
	 =dev-python/pyyaml-6.0.3
	 
"
if [[ USE =~ .*ccache.* ]]; then
	BDEPEND=$BDEPEND dev-util/sccache
fi
S=$WORKDIR
src_unpack() {
        tar -xf  $DISTDIR/zen.source.tar.zst
}
src_configure() {
	cd $S
	./mach configure #to produce /obj-x86_64-pc-linux-gnu/mozinfo.json, like it isnt worth doing it myself if one can just automate it
	mkdir python_activate_path
	python -m venv python_activate_path
	. python_activate_path
	pip install rtoml
	pip install taskcluster-taskgraph
	if [[ USE =~ .*ccache.* ]]; then
		echo 'ac_add_options --with-ccache=sccache' >> mozconfig
	fi
	if [[ USE =~ .*artifact.* ]]; then
		echo 'ac_add_options --enable-artifact-builds' >> mozconfig
		if [[ USE =~ .*cacche.* ]]; then
			die "You cant specify the artifact USE flag while ccache is specific as well"
		fi
	fi
	#agentic support cant be added for now, sorry for the inconvinience there
}
src_compile() {
	./mach build
}
pkg_postinst() {
	deactivate $S/python_activate_path
}
