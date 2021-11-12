SHELL := /bin/bash

# собрать проект из bsp-файла
bsp:
	source /opt/Xilinx/PetaLinux/2021.1/tool/settings.sh; \
	petalinux-create -t project -s microblaze_example.bsp -n peta_project

# собрать проект из xsa-файла
xsa: microblaze_paltform.xsa 
	source /opt/Xilinx/PetaLinux/2021.1/tool/settings.sh; \
	petalinux-create --type project --template microblaze --name peta_project; \
	cd peta_project; \
	petalinux-config --get-hw-description .. --silentconfig; \
	cp ../init-ifupdown project-spec/meta-user/recipes-bsp; \
	cp ../system-user.dtsi project-spec/meta-user/recipes-bsp/device-tree/files; \

	
# создать xsa-файл	
microblaze_paltform.xsa:
	vivado -mode batch -source create_xsa.tcl

# очистить проект
clean:
	make clean_peta
	make clean_vivado
	
clean_peta:
	rm -Rf peta_project
	rm *.bit *.mmi
	
clean_vivado:
	rm -Rf vivado_project
	rm -Rf .Xil
	rm *.xsa *.log *.jou *.str
