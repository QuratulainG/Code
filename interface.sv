interface Req_if();
   logic [0:31] req_data_in;
   logic [0:3]  req_cmd_in, req_d1, req_d2, req_r1;
   logic [0:1]  req_tag_in;
endinterface : Req_if

interface Out_if();
   logic [0:31] out_data; 
   logic [0:1] out_resp;
   logic [0:1] out_tag;
endinterface : Out_if

interface Reset_if();
   logic rst;
endinterface : Reset_if

interface Clock_if();
   bit clk = 0;
   bit clk_en = 0;
   int half_period = 100;

   always begin
      #half_period;
      if (clk_en) clk = ~clk;
   end

   task set_clk_en(bit en);
      clk_en = en;
   endtask

   task set_clk_period(int clk_period);
      half_period = clk_period/2;
   endtask
endinterface : Clock_if