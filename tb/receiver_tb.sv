module receiver_tb;
  logic clk, rst_n; 
  logic rx_serial;
  logic rx_dv;
  logic [7:0] rx_data;

  receiver dut(clk, rst_n, rx_serial, rx_dv, rx_data);

  logic [7:0] data_c, data_out;

  initial begin
    clk = 1'b1;
    forever #10ns clk = ~clk;
  end

  initial begin
    rst_n = 1'b0;
    #20ns;
    rst_n = 1'b1;
    #2us;
    $display("End simulation");
    $finish();
  end

  initial begin
    rx_serial = 1'b1;
    wait(rst_n);
    write_rx;
    wait(rx_dv);
    data_out = rx_data;
    if(data_out == data_c) $display("%0t: Data matching, %0h", $time, data_c);
    else                   $display("%0t: Data not match, expected: %0h, actual: %0h", $time, data_c, data_out); 
  end


  task write_rx;
    @(posedge clk);
    rx_serial <= 1'b0;
    for (int i=0; i <8; i++) begin
      repeat(8) @(posedge clk);
      rx_serial = $urandom(); 
      data_c[i] = rx_serial;
      
      $display("%0t: Send %0b to RX", $time, rx_serial);
    end
    repeat(8) @(posedge clk);
    rx_serial <= 1'b1;
  endtask;

endmodule
