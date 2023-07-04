import uvm_pkg::*;
`include "uvm_macros.svh"  

module calc_tb_assertions(out1_data, out1_resp, out1_tag, out2_data, out2_resp, out2_tag, out3_data, out3_resp, out3_tag, out4_data, out4_resp, out4_tag, scan_out, a_clk, b_clk, c_clk, req1_cmd, req1_d1, req1_d2, req1_data, req1_r1, req1_tag, req2_cmd, req2_d1, req2_d2, req2_data, req2_r1, req2_tag, req3_cmd, req3_d1, req3_d2, req3_data, req3_r1, req3_tag, req4_cmd, req4_d1, req4_d2, req4_data, req4_r1, req4_tag, reset, scan_in);

   input [0:1]  out1_resp, out1_tag, out2_resp, out2_tag, out3_resp, out3_tag, out4_resp, out4_tag;
   input [0:31] out1_data, out2_data, out3_data, out4_data;
   input 	    scan_out;
   
   input [0:1]  req1_tag, req2_tag, req3_tag, req4_tag;
   input        a_clk, b_clk, c_clk, reset, scan_in;
   input [0:3]  req1_cmd, req1_d1, req1_d2, req1_r1, req2_cmd, req2_d1, req2_d2, req2_r1, req3_cmd, req3_d1, req3_d2, req3_r1, req4_cmd, req4_d1, req4_d2, req4_r1;
   input [0:31] req1_data, req2_data, req3_data, req4_data;

   // tag queues for unique_tags assertion
   bit [0:1] tag_q1[$], tag_q2[$], tag_q3[$], tag_q4[$];
   always @(negedge c_clk) begin
      
	if (req1_cmd != 0) 
	   tag_q1.push_back(req1_tag);
	if (req2_cmd != 0) 
         tag_q2.push_back(req2_tag);
	if (req3_cmd != 0) 
         tag_q3.push_back(req3_tag);
	if (req4_cmd != 0) 
         tag_q4.push_back(req4_tag);
		   
      if (out1_resp != 0) begin
         foreach (tag_q1[i]) begin
            if (tag_q1[i] == out1_tag) begin
               tag_q1.delete(i);
            end
         end
      end
	if (out2_resp != 0) begin
         foreach (tag_q2[i]) begin
            if (tag_q2[i] == out2_tag) begin
               tag_q2.delete(i);
            end
         end
      end
	if (out3_resp != 0) begin
         foreach (tag_q3[i]) begin
            if (tag_q3[i] == out3_tag) begin
               tag_q3.delete(i);
            end
         end
      end
	if (out4_resp != 0) begin
         foreach (tag_q4[i]) begin
            if (tag_q4[i] == out4_tag) begin
               tag_q4.delete(i);
            end
         end
      end
      if (reset) begin
         tag_q1.delete();
	   tag_q2.delete();
	   tag_q3.delete();
	   tag_q4.delete();
      end
   end
   
   // each cmd will get a response after some time
   property cmd_resp(bit clk, rst, bit [0:3] cmd, bit [0:1] rsp);
      @(negedge clk) disable iff (rst)
         cmd != 0 |-> ##[0:8] rsp inside {1,2,3};
   endproperty

   // only an in-flight tag (i.e., tags that went into the DUT via req_tag) will come out via out_tag
   // and the only valid tags are {0,1,2,3}
   property valid_out_tag (bit clk, rst, bit [0:1] tag_q[$], out_tag, out_resp);
      @(negedge clk) disable iff (rst)
         out_resp != 0 |-> (out_tag inside {tag_q}) && (out_tag inside {0,1,2,3});
   endproperty

   // check that only unique tags are in-flight
   function has_unique_tags(bit [0:1] tags[]);
      bit [0:1] tmp[$];
      tmp = tags.unique();
      return(tmp.size() == tags.size());
   endfunction
   property unique_tags (bit clk, rst, bit [0:1] tags[]);
      @(negedge clk) disable iff (rst)
         has_unique_tags(tags);
   endproperty
   
   // check that there is a dead cycle after each cmd
   property dead_cycles (bit clk, rst, bit [0:3] cmd);
      @(negedge clk) disable iff (rst)
         cmd !=0 |=> cmd == 0;
   endproperty
   
   cmd_resp0: assert property (cmd_resp(c_clk, reset, req1_cmd, out1_resp))
              else `uvm_error("cmd_resp0", "Ch0: Response for cmd not received")
   cmd_resp1: assert property (cmd_resp(c_clk, reset, req2_cmd, out2_resp))
              else `uvm_error("cmd_resp1", "Ch1: Response for cmd not received")
   cmd_resp2: assert property (cmd_resp(c_clk, reset, req3_cmd, out3_resp))
              else `uvm_error("cmd_resp2", "Ch2: Response for cmd not received")
   cmd_resp3: assert property (cmd_resp(c_clk, reset, req4_cmd, out4_resp))
              else `uvm_error("cmd_resp3", "Ch3: Response for cmd not received")

   vld_out_tag0: assert property (valid_out_tag(c_clk, reset, tag_q1, out1_tag, out1_resp))
                 else `uvm_error("vld_out_tag0", "Ch0: Invlaid out tag found")
   vld_out_tag1: assert property (valid_out_tag(c_clk, reset, tag_q2, out2_tag, out2_resp))
                 else `uvm_error("vld_out_tag1", "Ch1: Invlaid out tag found")
   vld_out_tag2: assert property (valid_out_tag(c_clk, reset, tag_q3, out3_tag, out3_resp))
                 else `uvm_error("vld_out_tag2", "Ch2: Invlaid out tag found")
   vld_out_tag3: assert property (valid_out_tag(c_clk, reset, tag_q4, out4_tag, out4_resp))
                 else `uvm_error("vld_out_tag3", "Ch3: Invlaid out tag found")
	
   unique_tags0: assert property (unique_tags(c_clk, reset, tag_q1))
                 else `uvm_error("unique_tag0", "Ch0: Duplicate tag found ")
   unique_tags1: assert property (unique_tags(c_clk, reset, tag_q2))
                 else `uvm_error("unique_tag1", "Ch1: Duplicate tag found ")
   unique_tags2: assert property (unique_tags(c_clk, reset, tag_q3))
                 else `uvm_error("unique_tag2","Ch2: Duplicate tag found ")
   unique_tags3: assert property (unique_tags(c_clk, reset, tag_q4))
                 else `uvm_error("unique_tag3", "Ch3: Duplicate tag found ")

   dead_cycles0: assert property (dead_cycles(c_clk, reset, req1_cmd))
                 else `uvm_error("dead_cycles0", "Ch0: Invlaid transaction. No dead cycle after a command.")	
   dead_cycles1: assert property (dead_cycles(c_clk, reset, req2_cmd))
                 else `uvm_error("dead_cycles1", "Ch1: Invlaid transaction. No dead cycle after a command.")	
   dead_cycles2: assert property (dead_cycles(c_clk, reset, req3_cmd))
                 else `uvm_error("dead_cycles2", "Ch2: Invlaid transaction. No dead cycle after a command.")	
   dead_cycles3: assert property (dead_cycles(c_clk, reset, req4_cmd))
                 else `uvm_error("dead_cycles3", "Ch3: Invlaid transaction. No dead cycle after a command.")	
	
endmodule : calc_tb_assertions