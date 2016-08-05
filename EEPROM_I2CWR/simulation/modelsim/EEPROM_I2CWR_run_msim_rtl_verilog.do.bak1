transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Hpy/Desktop/FPGAProject/Training/EEPROM_I2CWR {C:/Users/Hpy/Desktop/FPGAProject/Training/EEPROM_I2CWR/EEPROM_I2CWR.v}

vlog -vlog01compat -work work +incdir+C:/Users/Hpy/Desktop/FPGAProject/Training/EEPROM_I2CWR/simulation/modelsim {C:/Users/Hpy/Desktop/FPGAProject/Training/EEPROM_I2CWR/simulation/modelsim/EEPROM_I2CWR.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver -L rtl_work -L work -voptargs="+acc"  EEPROM_I2CWR_vlg_tst

add wave *
view structure
view signals
run -all
