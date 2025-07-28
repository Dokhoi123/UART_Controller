module transmitter_tb;
  logic clk, rst_n, empty;
  logic [7:0] data_in;
  logic fifo_rd_en, txd;
  
  transmitter dut(clk, rst_n, empty, data_in, fifo_rd_en, txd);
  
  logic [7:0] data_q[$];
  logic [7:0] data_c, data_r;
  logic rx;

  initial begin
    rst_n = 1'b0;
    #20ns;
    rst_n = 1'b1;
    #2us;
    $display("End simulation");
    $finish();
  end

  initial begin
    clk = 1'b1;
    forever #10ns clk = ~clk;
  end

  initial begin
    wait(rst_n)
    empty = 1'b0;
    write_tx;
    #1ns;
    read_tx;
    @(posedge clk);
    empty = 1'b1;
    wait(fifo_rd_en == 1'b0);
    $display("FIFO empty");
    
  end


  task write_tx;
    @(posedge clk);
    if(fifo_rd_en == 1'b1) begin
      data_in = $urandom();
      data_q.push_back(data_in);
      $display("%0t: Send data %0h to transmitter", $time, data_in);
      @(posedge clk);
      data_in = 0;
    end
  endtask
  
  task read_tx;
    rx = txd;
    if(rx == 1'b0) begin
      for(int u=0; u<8; u++) begin
        @(posedge clk);
        #1ns;
        rx = txd;
        data_r[u] <= rx;
        $display("%0t Get %b from tx", $time, rx);
      end
      @(posedge clk);
      $display("%0t: Data data receive, %0h", $time, data_r);
      data_c = data_q.pop_front();
      if(data_c == data_r) $display("%0t: Data match, %0h", $time, data_r);
      else                 $display("%0t: Data not match, expected: %b, actual: %b", $time, data_c, data_r);
    end
  endtask

endmodule  


