SHELL := /bin/bash

# собрать проект из bsp-файла
bsp:
	source /opt/PetaLinux/settings.sh; \
	petalinux-create -t project -s Simple_GPIO_Driver.bsp -n peta_project

# собрать проект из xsa-файла
xsa: microblaze_paltform.xsa 
	source /opt/PetaLinux/settings.sh; \
	petalinux-create --type project --template microblaze --name peta_project; \
	cd peta_project; \
	petalinux-config --get-hw-description .. --silentconfig; \
	petalinux-build; \
	petalinux-package --boot --fpga images/linux/system.bit --offset 0x000000  --u-boot --offset 0x800000 --kernel --offset 0xA00000 --flash-size 32 --flash-intf SPIx1 --force; \
	petalinux-package --prebuilt
# создать xsa-файл	
microblaze_paltform.xsa:
	vivado -mode batch -source create_xsa.tcl

# очистить проект
clean:
	rm -Rf vivado_project
	rm -Rf peta_project
	rm -Rf .Xil
	rm *.xsa *.log *.jou *.str *.bit *.mmi
