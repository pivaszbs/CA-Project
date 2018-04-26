transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/17.1/Project/Test_2 {D:/intelFPGA_lite/17.1/Project/Test_2/test_2.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/17.1/Project/Test_2 {D:/intelFPGA_lite/17.1/Project/Test_2/ram.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/17.1/Project/Test_2 {D:/intelFPGA_lite/17.1/Project/Test_2/cache_4way.v}

