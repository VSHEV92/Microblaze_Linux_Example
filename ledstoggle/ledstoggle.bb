#
# This file is the ledstoggle recipe.
#

SUMMARY = "Simple ledstoggle application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://ledstoggle.c \
	   file://Makefile \
		  "
S = "${WORKDIR}"

DEPENDS = " libgpiod"

do_compile() {
	     ${CC} ${CFLAGS} ${LDFLAGS} -o ledstoggle ledstoggle.c -lgpiod
}

do_install() {
	     install -d ${D}${bindir}
	     install -m 0755 ledstoggle ${D}${bindir}
}
