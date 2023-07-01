vlog interface.sv calc_tb_pkg.sv design/calc3_top.v top.sv

vsim -voptargs=+acc work.calc3_top work.top -l test.log -cvgperinstance -coverage +TEST_SEQ_NAME=vseq_store_fetch