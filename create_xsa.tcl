# -------------------------------------------
# ------ Скрипт для создания xsa-файла ------
# -------------------------------------------

# создание нового проекта
create_project vivado_project vivado_project -part xc7a50tftg256-1
set_property board_part em.avnet.com:7a50t:part0:1.0 [current_project]

# добавление xdc-файла
add_files -fileset constrs_1 -norecurse clock_pin.xdc

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
apply_board_connection -board_interface "qspi_flash" -ip_intf "axi_quad_spi_0/SPI_0" -diagram "linux_example" 

# добавление iic
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0
apply_board_connection -board_interface "iic_eeprom" -ip_intf "axi_iic_0/IIC" -diagram "linux_example" 

# подключение портов MIG
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {/mig_7series_0/ui_clk (100 MHz)} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Cached)} Slave {/mig_7series_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}}  [get_bd_intf_pins mig_7series_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {sys_rst} Manual_Source {Auto}}  [get_bd_pins mig_7series_0/sys_rst]

# подключение AXI-Lite портов таймера и uart
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_timer_0/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_timer_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_uartlite_0/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_uartlite_0/S_AXI]

# подключение портов gpio leds
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_gpio_0/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]

# подключение портов spi
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_quad_spi_0/AXI_LITE} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_quad_spi_0/AXI_LITE]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/mig_7series_0/ui_clk (100 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins axi_quad_spi_0/ext_spi_clk]

# подключение портов iic
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_clk (100 MHz)} Clk_slave {Auto} Clk_xbar {/mig_7series_0/ui_clk (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_iic_0/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_iic_0/S_AXI]

# подключение прерываний
set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells microblaze_0_xlconcat]
connect_bd_net [get_bd_pins axi_timer_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In0]
connect_bd_net [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In1]
connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In2]
connect_bd_net [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In3]

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
launch_runs impl_1 -jobs 2
wait_on_run impl_1

# создание bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1

# создание xsa-файла
write_hw_platform -fixed -include_bit -force -file microblaze_paltform.xsa

close_project