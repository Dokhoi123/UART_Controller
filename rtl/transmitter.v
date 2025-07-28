module transmitter(
  input clk, rst_n, empty,
  input [7:0] data_in,
  output reg fifo_rd_en,
  output reg txd
);

 localparam IDLE = 2'b00;
 localparam READ = 2'b01;
 localparam TX   = 2'b10;

 reg [1:0] state, next_state;
 reg [9:0] shift_reg;
 reg [3:0] bit_counter;

 always@(posedge clk or negedge rst_n) begin
   if(!rst_n) begin
     state <= IDLE;
     bit_counter <= 0;
     shift_reg <= 0;
   end
   else begin
     state <= next_state;
     case(state)
      READ: begin
        shift_reg <= {1'b1, data_in, 1'b0};
        bit_counter <=0;
      end

      TX: begin
        shift_reg <= shift_reg >> 1;
        bit_counter <= bit_counter + 1;
      end
    endcase
  end
end

always@(*) begin
  case(state)
    IDLE: begin
      if(!empty) begin
        next_state <= READ;
        fifo_rd_en <= 1'b1;
      end
      else begin 
        next_state <= IDLE;
        fifo_rd_en <= 1'b0;
        txd <= 1'b1;
        fifo_rd_en <= 1'b0;
      end
    end

    READ: begin
      next_state <= TX;
      txd <= 1'b1;
      fifo_rd_en <= 1'b0;
    end

    TX: begin
      txd <= shift_reg[0];
      if(bit_counter == 9) begin
        next_state<= IDLE;
      end
      else next_state <= TX;
    end

    default: next_state <= IDLE;

  endcase
end

endmodule


