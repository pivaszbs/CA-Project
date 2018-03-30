transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/user/Documents/GitHub/I2P-Project/CA-Project {C:/Users/user/Documents/GitHub/I2P-Project/CA-Project/simple_ram.v}
vlog -vlog01compat -work work +incdir+C:/Users/user/Documents/GitHub/I2P-Project/CA-Project {C:/Users/user/Documents/GitHub/I2P-Project/CA-Project/cache_example.v}
vlog -vlog01compat -work work +incdir+C:/Users/user/Documents/GitHub/I2P-Project/CA-Project {C:/Users/user/Documents/GitHub/I2P-Project/CA-Project/2way_cache.v}

