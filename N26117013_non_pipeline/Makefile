root_dir := $(PWD)
src_dir := ./src
inc_dir := ./include
sim_dir := ./sim
bld_dir := ./build
CYCLE=`grep -v '^$$' $(root_dir)/sim/CYCLE`
MAX=`grep -v '^$$' $(root_dir)/sim/MAX`

$(bld_dir):
	mkdir -p $(bld_dir)

prog0: | $(bld_dir)
	make -C $(sim_dir)/prog0/; \
	cd $(bld_dir); \
	ncverilog $(root_dir)/$(sim_dir)/top_tb.sv \
	+incdir+$(root_dir)/$(src_dir)+$(root_dir)/$(src_dir)/AXI+$(root_dir)/$(inc_dir)+$(root_dir)/$(sim_dir) \
	+define+prog0$(FSDB_DEF) \
	-define CYCLE=$(CYCLE) \
	-define CYCLE2=$(CYCLE2) \
	-define MAX=$(MAX) \
	+ncaccess+rwc +loadpli1=debpli:novas_pli_boot \
	+prog_path=$(root_dir)/$(sim_dir)/prog0

prog1: | $(bld_dir)
	make -C $(sim_dir)/prog1/; \
	cd $(bld_dir); \
	ncverilog $(root_dir)/$(sim_dir)/top_tb.sv \
	+incdir+$(root_dir)/$(src_dir)+$(root_dir)/$(inc_dir)+$(root_dir)/$(sim_dir) \
	+define+prog1$(FSDB_DEF) \
	-define CYCLE=$(CYCLE) \
	-define MAX=$(MAX) \
	+ncaccess+rwc +loadpli1=debpli:novas_pli_boot \
	+prog_path=$(root_dir)/$(sim_dir)/prog1

prog2: | $(bld_dir)
	make -C $(sim_dir)/prog2/; \
	cd $(bld_dir); \
	ncverilog $(root_dir)/$(sim_dir)/top_tb.sv \
	+incdir+$(root_dir)/$(src_dir)+$(root_dir)/$(inc_dir)+$(root_dir)/$(sim_dir) \
	+define+prog2$(FSDB_DEF) \
	-define CYCLE=$(CYCLE) \
	-define MAX=$(MAX) \
	+ncaccess+rwc +loadpli1=debpli:novas_pli_boot \
	+prog_path=$(root_dir)/$(sim_dir)/prog2

# Utilities
nWave: | $(bld_dir)
	cd $(bld_dir); \
	nWave &
clean:
	rm -rf $(bld_dir); \
	rm -rf $(sim_dir)/prog*/result*.txt; \
	make -C $(sim_dir)/prog0/ clean; \
	make -C $(sim_dir)/prog1/ clean; \
	make -C $(sim_dir)/prog2/ clean; \
	make -C $(sim_dir)/prog3/ clean; \
	make -C $(sim_dir)/prog4/ clean;
