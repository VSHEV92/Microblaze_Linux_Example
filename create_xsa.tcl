# -------------------------------------------
# ------ Скрипт для создания xsa-файла ------
# -------------------------------------------

# создание нового проекта
create_project vivado_project vivado_project -part xc7a50tftg256-1
set_property board_part em.avnet.com:7a50t:part0:1.0 [current_project]

# добавление xdc-файла
add_files -fileset constrs_1 -norecurse pins.xdc

# добавление репозитория с ядром "Преобразователь MII в RMII"
set_property  ip_repo_paths  mii_to_rmii_v2_0 [current_project]
update_ip_catalog

# --------------------------------------------------------------------------------------------------------
# создание block design
create_bd_design "linux_example"

# добавление MIG
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0
apply_board_connection -board_interface "ddr3_sdram" -ip_intf "mig_7series_0/mig_ddr_interface" -diagram "linux_example" 

# добавление Microblaze
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {1} axi_periph {Enabled} cache {32KB} clk {/mig_7series_0/ui_clk (100 MHz)} cores {1} debug_module {Debug Only} ecc {None} local_mem {64KB} preset {Application}}  [get_bd_cells microblaze_0]
set_property -dict [list CONFIG.G_TEMPLATE_LIST {4} CONFIG.C_USE_FPU {0} CONFIG.C_FPU_EXCEPTION {0} CONFIG.C_NUMBER_OF_PC_BRK {1} CONFIG.C_NUMBER_OF_RD_ADDR_BRK {0} CONFIG.C_NUMBER_OF_WR_ADDR_BRK {0} CONFIG.C_ADDR_TAG_BITS {16} CONFIG.C_CACHE_BYTE_SIZE {16384} CONFIG.C_DCACHE_ADDR_TAG {16} CONFIG.C_DCACHE_BYTE_SIZE {16384} CONFIG.C_DCACHE_USE_WRITEBACK {0} CONFIG.C_DCACHE_VICTIMS {8}] [get_bd_cells microblaze_0]

# добавление clock wizard
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
set_property -dict [list CONFIG.PRIM_SOURCE {Global_buffer} CONFIG.CLKOUT2_USED {true} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000} CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50.000} CONFIG.CLKOUT2_REQUESTED_PHASE {90.000} CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} CONFIG.MMCM_CLKOUT1_DIVIDE {20} CONFIG.MMCM_CLKOUT1_PHASE {90.000} CONFIG.NUM_OUT_CLKS {2} CONFIG.CLKOUT1_JITTER {151.636} CONFIG.CLKOUT2_JITTER {151.636} CONFIG.CLKOUT2_PHASE_ERROR {98.575}] [get_bd_cells clk_wiz_0]
set_property -dict [list CONFIG.CLKOUT3_USED {true} CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {10} CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} CONFIG.MMCM_CLKOUT1_DIVIDE {20} CONFIG.MMCM_CLKOUT2_DIVIDE {100} CONFIG.NUM_OUT_CLKS {3} CONFIG.CLKOUT1_JITTER {151.636} CONFIG.CLKOUT1_PHASE_ERROR {98.575} CONFIG.CLKOUT2_JITTER {151.636} CONFIG.CLKOUT2_PHASE_ERROR {98.575} CONFIG.CLKOUT3_JITTER {209.588} CONFIG.CLKOUT3_PHASE_ERROR {98.575}] [get_bd_cells clk_wiz_0]

# добавление таймера
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0

# добавление uart
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
apply_board_connection -board_interface "usb_uart" -ip_intf "axi_uartlite_0/UART" -diagram "linux_example" 
set_property -dict [list CONFIG.C_BAUDRATE {115200}] [get_bd_cells axi_uartlite_0]

# добавление gpio leds
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
apply_board_connection -board_interface "leds_8bits" -ip_intf "axi_gpio_0/GPIO" -diagram "linux_example"

# добавление spi
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0
set_property -dict [list CONFIG.C_SPI_MEMORY {2} CONFIG.C_SPI_MODE {2} CONFIG.C_SCK_RATIO {2}] [get_bd_cells axi_quad_spi_0]
set_property -dict [list CONFIG.C_USE_STARTUP {0} CONFIG.C_USE_STARTUP_INT {0} CONFIG.C_FIFO_DEPTH {256}] [get_bd_cells axi_quad_spi_0]

# добавление iic
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0
apply_board_connection -board_interface "iic_eeprom" -ip_intf "axi_iic_0/IIC" -diagram "linux_example" 

# добавление ethernet-lite
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_1

# добавление преобразователи mii в rmii
create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0
create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_1

# подключение портов MIG
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {/mig_7series_0/ui_clk (100 MHz)} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Cached)} Slave {/mig_7series_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}}  [get_bd_intf_pins mig_7series_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {sys_rst} Manual_Source {Auto}}  [get_bd_pins mig_7series_0/sys_rst]

# подключение портов clock wizard
connect_bd_net [get_bd_pins clk_wiz_0/reset] [get_bd_pins mig_7series_0/ui_clk_sync_rst]
connect_bd_net [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins mig_7series_0/ui_clk]
make_bd_pins_external  [get_bd_pins clk_wiz_0/clk_out2]
set_property name phy0_clk [get_bd_ports clk_out2_0]
copy_bd_objs /  [get_bd_ports {phy0_clk}]
connect_bd_net [get_bd_ports phy0_clk1] [get_bd_pins clk_wiz_0/clk_out2]

# подключение портов преобразователей mii в rmii
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins mii_to_rmii_1/ref_clk]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins mii_to_rmii_0/ref_clk]
connect_bd_net [get_bd_pins mii_to_rmii_0/rst_n] [get_bd_pins rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net [get_bd_pins mii_to_rmii_1/rst_n] [get_bd_pins rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_intf_net [get_bd_intf_pins axi_ethernetlite_0/MII] [get_bd_intf_pins mii_to_rmii_0/MII] 
connect_bd_intf_net [get_bd_intf_pins axi_ethernetlite_1/MII] [get_bd_intf_pins mii_to_rmii_1/MII]
make_bd_intf_pins_external  [get_bd_intf_pins mii_to_rmii_0/RMII_PHY_M]
make_bd_intf_pins_external  [get_bd_intf_pins mii_to_rmii_1/RMII_PHY_M]

# подключение AXI-Lite портов таймера и uart
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_timer_0/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_timer_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_uartlite_0/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_uartlite_0/S_AXI]

# подключение портов gpio leds
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_gpio_0/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]

# подключение портов spi
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {/clk_wiz_0/clk_out3 (10 MHz)} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_quad_spi_0/AXI_LITE} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_quad_spi_0/AXI_LITE]
connect_bd_net [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins clk_wiz_0/clk_out3]
make_bd_intf_pins_external  [get_bd_intf_pins axi_quad_spi_0/SPI_0]

# подключение портов iic
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_iic_0/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_iic_0/S_AXI]

# подключение портов ethernet-lite
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_ethernetlite_0/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_ethernetlite_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_ethernetlite_1/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_ethernetlite_1/S_AXI]
make_bd_intf_pins_external  [get_bd_intf_pins axi_ethernetlite_0/MDIO]
make_bd_intf_pins_external  [get_bd_intf_pins axi_ethernetlite_1/MDIO]

# подключение прерываний
set_property -dict [list CONFIG.NUM_PORTS {6}] [get_bd_cells microblaze_0_xlconcat]
connect_bd_net [get_bd_pins axi_timer_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In0]
connect_bd_net [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In1]
connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In2]
connect_bd_net [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In3]
connect_bd_net [get_bd_pins axi_ethernetlite_0/ip2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In4]
connect_bd_net [get_bd_pins axi_ethernetlite_1/ip2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In5]

# проверка block design
validate_bd_design
regenerate_bd_layout
save_bd_design
close_bd_design [get_bd_designs linux_example]

# --------------------------------------------------------------------------------------------------------
# создание block design wrapper
make_wrapper -files [get_files vivado_project/vivado_project.srcs/sources_1/bd/linux_example/linux_example.bd] -top
add_files -norecurse vivado_project/vivado_project.gen/sources_1/bd/linux_example/hdl/linux_example_wrapper.v
update_compile_order -fileset sources_1

# синтез проекта
launch_runs synth_1 -jobs 2
wait_on_run synth_1

# имплементация проекта
set_property strategy Performance_Explore [get_runs impl_1]
launch_runs impl_1 -jobs 2
wait_on_run impl_1

# создание bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1

# создание xsa-файла
write_hw_platform -fixed -include_bit -force -file microblaze_paltform.xsa

close_project