# clock 200 MHz
set_property PACKAGE_PIN N11 [get_ports sys_clk_i]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk_i]

# phy ref clk
set_property PACKAGE_PIN P16 [get_ports {phy0_clk}]
set_property IOSTANDARD LVCMOS33 [get_ports phy0_clk]

set_property PACKAGE_PIN R10 [get_ports {phy0_clk1}]
set_property IOSTANDARD LVCMOS33 [get_ports phy0_clk1]

# phy 0 signals
set_property PACKAGE_PIN M16 [get_ports {RMII_PHY_M_0_crs_dv}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_0_crs_dv]
set_property PACKAGE_PIN L13 [get_ports {RMII_PHY_M_0_rx_er}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_0_rx_er]
set_property PACKAGE_PIN L14 [get_ports {RMII_PHY_M_0_tx_en}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_0_tx_en]

set_property PACKAGE_PIN M14 [get_ports {RMII_PHY_M_0_rxd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_0_rxd[0]]
set_property PACKAGE_PIN K13 [get_ports {RMII_PHY_M_0_rxd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_0_rxd[1]]
set_property PACKAGE_PIN R13 [get_ports {RMII_PHY_M_0_txd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_0_txd[0]]
set_property PACKAGE_PIN T12 [get_ports {RMII_PHY_M_0_txd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_0_txd[1]]

# phy 1 signals
set_property PACKAGE_PIN P11 [get_ports {RMII_PHY_M_1_crs_dv}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_1_crs_dv]
set_property PACKAGE_PIN P10 [get_ports {RMII_PHY_M_1_rx_er}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_1_rx_er]
set_property PACKAGE_PIN P13 [get_ports {RMII_PHY_M_1_tx_en}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_1_tx_en]

set_property PACKAGE_PIN P14 [get_ports {RMII_PHY_M_1_rxd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_1_rxd[0]]
set_property PACKAGE_PIN T14 [get_ports {RMII_PHY_M_1_rxd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_1_rxd[1]]
set_property PACKAGE_PIN T15 [get_ports {RMII_PHY_M_1_txd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_1_txd[0]]
set_property PACKAGE_PIN N13 [get_ports {RMII_PHY_M_1_txd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports RMII_PHY_M_1_txd[1]]

# MDIO pins
set_property PACKAGE_PIN N16 [get_ports {MDIO_0_mdc}];
set_property IOSTANDARD LVCMOS33 [get_ports MDIO_0_mdc] 
set_property PACKAGE_PIN P15 [get_ports {MDIO_0_mdio_io}]; 
set_property IOSTANDARD LVCMOS33 [get_ports MDIO_0_mdio_io]

set_property PACKAGE_PIN R12 [get_ports {MDIO_1_mdc}];  
set_property IOSTANDARD LVCMOS33 [get_ports MDIO_1_mdc]
set_property PACKAGE_PIN T13 [get_ports {MDIO_1_mdio_io}];
set_property IOSTANDARD LVCMOS33 [get_ports MDIO_1_mdio_io]  