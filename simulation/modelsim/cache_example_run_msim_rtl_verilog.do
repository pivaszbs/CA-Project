transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Repositories/CA-Project {C:/Repositories/CA-Project/simple_ram_tb.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/CA-Project {C:/Repositories/CA-Project/simple_ram.v}

