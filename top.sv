import uvm_pkg::*;
`include "uvm_macros.svh"   
import calc_tb_pkg::*;

module top;
   
   parameter ch_size = 4;
   
   Req_if Rx0(), Rx1(), Rx2(), Rx3();
   Out_if Tx0(), Tx1(), Tx2(), Tx3();
   Reset_if rst_if();
   Clock_if clk_if();
   
   virtual Req_if req_if[ch_size];
   virtual Out_if out_if[ch_size];
	
   calc3_top d3 (.out1_data(Tx0.out_data), .out1_resp(Tx0.out_resp), .out1_tag(Tx0.out_tag), 
                 .out2_data(Tx1.out_data), .out2_resp(Tx1.out_resp), .out2_tag(Tx1.out_tag), 
                 .out3_data(Tx2.out_data), .out3_resp(Tx2.out_resp), .out3_tag(Tx2.out_tag), 
                 .out4_data(Tx3.out_data), .out4_resp(Tx3.out_resp), .out4_tag(Tx3.out_tag), 
                 .scan_out(scan_out),
                 .scan_in(1'b0), .a_clk(1'b0), .b_clk(1'b0), .c_clk(clk_if.clk), 
                 .req1_cmd(Rx0.req_cmd_in), .req1_d1(Rx0.req_d1), .req1_d2(Rx0.req_d2), 
                 .req1_data(Rx0.req_data_in), .req1_r1(Rx0.req_r1), .req1_tag(Rx0.req_tag_in), 
                 .req2_cmd(Rx1.req_cmd_in), .req2_d1(Rx1.req_d1), .req2_d2(Rx1.req_d2), 
                 .req2_data(Rx1.req_data_in), .req2_r1(Rx1.req_r1), .req2_tag(Rx1.req_tag_in), 
                 .req3_cmd(Rx2.req_cmd_in), .req3_d1(Rx2.req_d1), .req3_d2(Rx2.req_d2), 
                 .req3_data(Rx2.req_data_in), .req3_r1(Rx2.req_r1), .req3_tag(Rx2.req_tag_in), 
                 .req4_cmd(Rx3.req_cmd_in), .req4_d1(Rx3.req_d1), .req4_d2(Rx3.req_d2), 
                 .req4_data(Rx3.req_data_in), .req4_r1(Rx3.req_r1), .req4_tag(Rx3.req_tag_in), 
                 .reset(rst_if.rst));

   initial begin

      // assign real if to virtual if
      req_if[0] = Rx0;
      req_if[1] = Rx1;
      req_if[2] = Rx2;
      req_if[3] = Rx3;
      out_if[0] = Tx0;
      out_if[1] = Tx1;
      out_if[2] = Tx2;
      out_if[3] = Tx3;
      
      // set virtual interfaces in config_db
      for (int i = 0; i < ch_size; i++) begin
         uvm_config_db#(virtual Req_if)::set(null, "*", $sformatf("req_if.*agent%0d*", i), req_if[i]);
         uvm_config_db#(virtual Out_if)::set(null, "*", $sformatf("out_if.*agent%0d*", i), out_if[i]);          
      end
      uvm_config_db#(virtual Reset_if)::set(null, "*", "rst_if", rst_if);
      uvm_config_db#(virtual Clock_if)::set(null, "*", "clk_if", clk_if);

      // run test
      clk_if.set_clk_en(1);
      run_test("calc_test");
      
   end

endmodule : top