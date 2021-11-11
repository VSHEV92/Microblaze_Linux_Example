SRC_URI += "file://netinterfaces"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


# Overwrite interface file with netinterfaces file in rootfs

do_install_append() {
     install -m 0644 ${WORKDIR}/netinterfaces ${D}${sysconfdir}/network/interfaces
}
