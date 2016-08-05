transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Hpy/Desktop/FPGAProject/Training {C:/Users/Hpy/Desktop/FPGAProject/Training/I2C.v}
vlog -vlog01compat -work work +incdir+C:/Users/Hpy/Desktop/FPGAProject/Training {C:/Users/Hpy/Desktop/FPGAProject/Training/pstoda.v}
vlog -vlog01compat -work work +incdir+C:/Users/Hpy/Desktop/FPGAProject/Training {C:/Users/Hpy/Desktop/FPGAProject/Training/out16hi.v}

vlog -vlog01compat -work work +incdir+C:/Users/Hpy/Desktop/FPGAProject/Training/simulation/modelsim {C:/Users/Hpy/Desktop/FPGAProject/Training/simulation/modelsim/I2C.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
