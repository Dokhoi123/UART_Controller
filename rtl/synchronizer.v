module synchronizer #(parameter WIDTH = 4) (
  input clk,
  input rst_n,
  input [WIDTH-1:0] data_in,
  output reg [WIDTH-1:0] data_out
);

 reg [WIDTH-1:0] q1;
 always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    q1 <= 0;
    data_out <= 0;
  end
  else begin
    q1 <= data_in;
    data_out <= q1;
  end
end

endmodule
