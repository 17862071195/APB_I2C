#!/bin/csh -f

# ----------------------------------------------------------------------
# This "comp.sh" is used to compile the child partition independently.
# 
# Flags could be useful for debug, diagnostic and profile:
# 
#   -gdb       : run vcs1 under gdb by picking up gdb from enviroment 
#   -gdb1      : run vcs1 under gdb by picking up gdb shipped with VCS 
#   -Xrepct2   : compile time and memory report.  
#   -collect   : run collect profile 
#   -gen_c     : generate C code instead of object code 
#   -gen_c -Xmod=2 -Xcom=2 -Xail=0x20000 
#              : generate C code with original names and comment. 
#   -Xvcsdb=0x40000 
#              : keep all contents in csrc without deleting them. 
#  
# Copyright (c) 1991-2018 by Synopsys Inc. 
# ----------------------------------------------------------------------


cd /home/verifier/Code_VCS/MyIIC/rkv_i2c_tb/sim

${VCS_HOME}/bin/vcs \
    #begin of .partcomp_options\
     -Xhdlxmropt  -sverilog -ntb_opts uvm-1.2 -debug_acc+all -debug_region+cell+encrypt -l out/log/elab_rkv_i2c_tb.log -fastpartcomp=j4 -uum    -f out/obj/rkv_i2c_tb.simv.daidir/mxopt.db -sverilog  \
    #end of .partcomp_options\
    -mx_invoke_vcs_from_tool \
    -mxunielab \
    -partcomp_master_daidir=/home/verifier/Code_VCS/MyIIC/rkv_i2c_tb/sim/out/obj/rkv_i2c_tb.simv.daidir \
    -q \
    -assert \
    enable_hier \
    -full64 \
    -cm_dir \
    out/obj/rkv_i2c_tb.simv.vdb \
    -cm \
    implAssert \
    -q \
    -partcomp=so \
    -partcomp_so_dir=/home/verifier/Code_VCS/MyIIC/rkv_i2c_tb/sim/out/obj/partitionlib/_vcs_pc_package__h66j1c \
    VCS_PARTCOMP_LIB.pc__vcs_pc_package__config \
    -o /home/verifier/Code_VCS/MyIIC/rkv_i2c_tb/sim/out/obj/partitionlib/_vcs_pc_package__h66j1c/libvcspc__vcs_pc_package__h66j1c.so \
    -Mdir=/home/verifier/Code_VCS/MyIIC/rkv_i2c_tb/sim/out/obj/partitionlib/_vcs_pc_package__h66j1c/csrc \
    -Xarijit=0x2 \
    -sverilog   \
    -l /home/verifier/Code_VCS/MyIIC/rkv_i2c_tb/sim/out/obj/partitionlib/_vcs_pc_package__h66j1c/_vcs_pc_package__h66j1c.log \

cd -


# end of comp.sh
