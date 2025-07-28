module fifo_tb;
  logic wen, wclk, ren, rclk, rst_n;
  logic [7:0] data_in, data_out;
  logic full, empty;


asyn_fifo dut(wen, wclk, ren, rclk, rst_n, data_in, data_out, full, empty);
logic [7:0] data_q[$];
logic [7:0] data_r, data_c, data_w;

  initial begin
    rst_n = 1'b0;
    #50ns;
    rst_n = 1'b1;
    #2us;
    $display("End simulation");
    $finish();
  end

  initial begin
    wait(rst_n == 1'b1);
    wen <= 1'b0;
    ren <= 1'b0;
    repeat(8) begin
      write;
    end

    wait (full == 1'b1);
    
    repeat(8) begin
      read;
    end

  end


  initial begin
    wclk <= 1;
    forever begin
      #10ns;
      wclk <= ~wclk;
    end
  end
  
   initial begin
     rclk <= 1;
     forever begin
       #20ns;
       rclk <= ~rclk;
     end
  end

  task write;
    @(posedge wclk);
    data_w = $random();
    data_in = data_w;
    wen <= 1'b1;
    data_q.push_back(data_w);
    $display("%0t Send data %h to fifo", $time, data_in); 
    @(posedge wclk);
    wen <= 1'b0;
    data_in <= 0;
  endtask

  task read;
    @(posedge rclk);
    ren <= 1'b1;
    @(posedge rclk);
    ren <= 1'b0;
    #1;
    data_r = data_out;
    data_c = data_q.pop_front();
    if(data_r == data_c) $display("%0t Data match, %0h", $time, data_c);
    else $display("%0t Data not match, expected: %0h, actual: %0h", $time, data_c, data_r);
    @(posedge rclk);
    ren <= 1'b0;
  endtask

endmodule
