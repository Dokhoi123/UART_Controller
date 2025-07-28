module uart_control_tb;

  logic clk, rst_n, w_en, r_en;
  logic [7:0] data_in, data_out;
  logic empty, full, txd, rxd;

  uart_control dut(clk, rst_n, w_en, r_en, rxd, data_in, data_out, empty, full, txd);
  logic [7:0] data_c, data_r;
  
  initial begin
    rst_n = 1'b0;
    #20ns;
    rst_n = 1'b1;
    #10ms;
    $display("End simulation");
    $finish();
  end

  initial begin
    clk = 1'b1;
    forever #10ns clk = ~clk;
  end

  initial begin
    w_en = 1'b0;
    r_en = 1'b0;
    rxd = 1'b1;
    wait(rst_n);
    @(posedge clk);
    data_in = $urandom();
    w_en = 1'b1;
    data_c = data_in;
    $display("%Ot Data sent: %0h",$time, data_c);
    @(posedge clk);
    w_en <= 1'b0;

    repeat(8) begin
    @(posedge clk);
      data_in = $urandom();
      w_en = 1'b1;
      $display("%Ot Data sent: %0h",$time, data_in);
      @(posedge clk);
      w_en <= 1'b0;
    end

    wait(txd == 1'b0);
    #156269ns
    for(int i=0; i<8; i++) begin
      data_r[i] <= txd;
      $display("Receive %b from tx",txd);
      #106166ns;
    end
    
    if(data_c==data_r) $display("%0t Data matching: %0h", $time, data_r);
    else               $display("%0t Data not match, expected: %0h, actual: %0h", $time, data_c, data_r);

    rxd = 1'b0;
    #106166ns;

    for(int i=0; i<8; i++) begin
      rxd = $urandom;
      data_c[i] = rxd;
    $display("Send %b to rx",data_c[i]);
      #106166ns;
    end
    rxd = 1'b1;
    wait(!empty);
    @(posedge clk);
    r_en = 1'b1;
    @(posedge clk);
    #1ns;
    r_en = 1'b0;
    data_r = data_out;
    if(data_r==data_c) $display("%t Data matching,%0h", $time, data_r);
    else               $display("%t Data not match, expected: %h, actual: %h", $time, data_c, data_r);
  end
endmodule
