transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Hpy/Desktop/FPGAProject/Training/fbosc1 {C:/Users/Hpy/Desktop/FPGAProject/Training/fbosc1/fbosc1.v}

vlog -vlog01compat -work work +incdir+C:/Users/Hpy/Desktop/FPGAProject/Training/fbosc1/simulation/modelsim {C:/Users/Hpy/Desktop/FPGAProject/Training/fbosc1/simulation/modelsim/fbosc1.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver -L rtl_work -L work -voptargs="+acc"  fbosc1_vlg_tst

add wave *
view structure
view signals
run -all
