module baud_gen #(parameter CLK =50_000_000, parameter baud_rate = 9600)(
  input clk, rst_n,
  output reg clk_tx, clk_rx
);

  wire [15:0] divisor;
  assign divisor = CLK/baud_rate;
  reg [15:0] counter_tx, counter_rx;
  
  wire [15:0] RX_DIVISOR;
  assign RX_DIVISOR = divisor/8;

  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      counter_tx <= 0;
      clk_tx     <= 1'b1;
    end
    else begin
      if (counter_tx >= (divisor/2) -1) begin
        counter_tx <= 0;
        clk_tx     <= ~clk_tx;
      end
      else begin
        counter_tx <= counter_tx +1;
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      counter_rx <= 0;
      clk_rx     <= 1'b0;
    end
    else begin
      if (counter_rx >= (RX_DIVISOR / 2) -1) begin
        counter_rx <= 0;
        clk_rx     <= ~clk_rx;
      end
      else begin
      counter_rx <= counter_rx +1;
      end
    end
  end

endmodule



