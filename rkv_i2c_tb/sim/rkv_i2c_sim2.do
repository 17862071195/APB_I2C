#======================================#
# TCL script for a mini regression     #
#======================================#

#======确保仿真把所有test跑完=========#
#当仿真过程出现error或break时会执行resume命令（questasim）继续往下执行
onbreak resume
onerror resume

#设置环境变量，在complist.f文件中会用到
# set environment variables
setenv DUT_SRC ../../rkv_dw_apb_i2c
setenv TB_SRC .

set INCDIR "+incdir+../../rkv_dw_apb_i2c/src \
					  +incdir+../agents/lvc_apb3 \
					  +incdir+../agents/lvc_i2c \
					  +incdir+../cfg \
					  +incdir+../cov \
					  +incdir+../reg \
					  +incdir+../env \
					  +incdir+../seq_lib \
					  +incdir+../seq_lib/elem_seqs \
					  +incdir+../seq_lib/user_elem_seqs \
					  +incdir+../seq_lib/user_virt_seqs \
					  +incdir+../tests/user_tests \
					  +incdir+../tests "

set VCOMP "vlog -timescale=1ns/1ps -l comp.log $INCDIR"


# clean the environment and remove trash files
set delfiles [glob work *.log *.ucdb sim.list]

file delete -force {*}$delfiles

# compile the design and dut with a filelist
vlib work
eval $VCOMP -f  rkv_i2c.flist
eval $VCOMP -sv ../agents/lvc_apb3/lvc_apb_if.sv 
eval $VCOMP -sv ../agents/lvc_apb3/lvc_apb_pkg.sv 
eval $VCOMP -sv ../agents/lvc_i2c/lvc_i2c_if.sv 
eval $VCOMP -sv ../agents/lvc_i2c/lvc_i2c_pkg.sv 
eval $VCOMP -sv ../env/rkv_i2c_pkg.sv 
eval $VCOMP -sv ../tb/rkv_i2c_if.sv 
eval $VCOMP -sv ../tb/rkv_i2c_tb.sv 

#prepare simrun folder
set timetag [clock format [clock seconds] -format "%Y%b%d-%H_%M"]
file mkdir regr_ucdb_${timetag}

# call UVM tests
#               {i2c_master_start_byte_test 1} \
#               {rkv_i2c_master_hs_master_code_test 1} \
set TestSets { {rkv_i2c_quick_reg_access_test 1} \
               {rkv_i2c_master_directed_write_packet_test 1} \
               {rkv_i2c_master_directed_read_packet_test 1} \
               {rkv_i2c_master_directed_interrupt_test 1} \
               {i2c_master_rx_over_intr_test 1} \
               {i2c_master_rx_full_intr_test 1} \
               {i2c_master_enabled_cg_test 1} \
               {i2c_master_tx_abrt_intr_test 1} \
               {i2c_master_activity_intr_output_test 1} \
               {master_address_cg_test 1} \
               {i2c_master_abrt_txdata_noack_test 1} \
               {i2c_master_tx_full_intr_test 1} \
               {rkv_i2c_reg_access_test 1} \
               {rkv_i2c_reg_bit_bash_test 1} \
               {rkv_i2c_reg_hw_reset_test 1} \
               {i2c_master_abrt_7b_addr_noack_test 1} \
               {i2c_master_abrt_sbyte_norstrt_test 1} \
               {i2c_master_tx_empty_intr_test 1} \
               {i2c_master_sda_control_cg_test 1} \
               {rkv_i2c_master_timeout_cg_test 1} \
               {i2c_master_abrt_10b_rd_norstrt_test 1} \
               {i2c_master_ss_cnt_test 1} \
               {i2c_master_fs_cnt_test 1} \
               {i2c_master_hs_cnt_test 1} \
             }
set VERB UVM_HIGH
#vsim -onfinish stop -cover -sv_seed 21 +UVM_TESTNAME=i2c_master_tx_abrt_intr_test -l regr_ucdb_${timetag}/run_i2c_master_tx_abrt_intr_test_21.log  work.rkv_i2c_tb
#  for {set loop 12} {$loop < $testn} {incr loop 1} {
foreach testset $TestSets {
  set testname [lindex $testset 0]
  set testsetnum [lindex $testset 1]
  set testn 14
  for {set loop 0} {$loop < $testsetnum} {incr loop 1} {
    set SEED [expr int(rand()*100)]
    echo Simulating $testname
    echo $SEED +UVM_TESTNAME=$testname -l regr_ucdb_${timetag}/run_${testname}_${SEED}.log 
    vsim -onfinish stop -cover -sv_seed $SEED \
         +UVM_TESTNAME=$testname -l regr_ucdb_${timetag}/run_${testname}_${SEED}.log work.rkv_i2c_tb
    run -all
    coverage save regr_ucdb_${timetag}/${testname}_${SEED}.ucdb
    quit -sim
  }
}

#merge the ucdb per test
vcover merge -testassociated regr_ucdb_${timetag}/regr_${timetag}.ucdb ../doc/questa_vplan.ucdb {*}[glob regr_ucdb_${timetag}/*.ucdb]
#vsim work.rkv_i2c_tb -sv_seed $SEED +UVM_TESTNAME=$TEST +UVM_VERBOSITY=$VERB -l sim.log

quit -f
