module fifo_mem #(parameter FIFO_DEPTH = 8, FIFO_WIDTH = 8, PTR_WIDTH = 4) (
  input wclk, rclk, r_en, w_en, full,
  input [PTR_WIDTH-1:0] b_wptr, b_rptr,
  input [FIFO_WIDTH-1:0] data_in,
  output reg [FIFO_WIDTH-1:0] data_out
);
  
  reg [FIFO_WIDTH-1:0] fifo_reg [FIFO_DEPTH-1:0];

  always@(posedge wclk) begin
    if (w_en&!full) begin
      fifo_reg[b_wptr] <= data_in;
    end
  end

  always@(posedge rclk) begin
    if(r_en) begin
      data_out <= fifo_reg[b_rptr];
    end 
  end

endmodule
