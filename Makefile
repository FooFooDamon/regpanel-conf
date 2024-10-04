.PHONY: help link unlink copy remove prepare_parent_dir abort_if_installed

help:
	@echo 'Run "${MAKE} link/unlink" to install, or "${MAKE} copy/remove" to uninstall.'

INSTALL_PATH ?= ${DESTDIR}/usr/local/etc/regpanel

link: prepare_parent_dir abort_if_installed
	ln -s $${PWD} ${INSTALL_PATH}

unlink:
	@[ -e ${INSTALL_PATH} ] || exit 0; \
	[ -L ${INSTALL_PATH} ] && (set -x && rm ${INSTALL_PATH}) \
		|| (echo "*** Not a symbolic link: ${INSTALL_PATH}" && false)

copy: prepare_parent_dir abort_if_installed
	cp -r $${PWD} ${INSTALL_PATH}

remove:
	@[ -e ${INSTALL_PATH} ] || exit 0; \
	if [ -L ${INSTALL_PATH} ]; then \
		set -x && rm ${INSTALL_PATH}; \
	else \
		echo "Target is not a symbolic link, keep and rename it for safety." >&2; \
		set -x && mv ${INSTALL_PATH} ${INSTALL_PATH}.$$(date "+%Y%m%d_%H%M%S"); \
	fi

prepare_parent_dir:
	mkdir -p $(dir ${INSTALL_PATH})

abort_if_installed:
	@if [ -e ${INSTALL_PATH} ]; then \
		[ -L ${INSTALL_PATH} ] && printf "*** Symbolic link" || printf "*** Directory" >&2; \
		echo " already exists: ${INSTALL_PATH}" >&2; \
		echo "Check if it's installed by another project, and handle it manually (back it up or delete it)." >&2; \
		false; \
	fi

