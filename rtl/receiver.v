module receiver (
  input clk, rst_n,
  input rx_serial,

  output reg rx_dv,
  output reg [7:0] rx_data
);

  parameter IDLE = 3'b000;
  parameter START_BIT = 3'b001;
  parameter DATA_BIT = 3'b010;
  parameter STOP_BIT = 3'b011;
  parameter CLEAN = 3'b100;

  reg rx_data_b;    // for synchronize
  reg rx_data_reg;  // for synchronize

  reg [3:0] count;            // for timing data_rx_serial in
  reg [3:0] bit_counter;      // for bit counter for rx_data
  reg [2:0] state, next_state;


  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      rx_data_b   <= 1'b0;
      rx_data_reg <= 1'b0;
    end else begin
      rx_data_b   <= rx_serial;
      rx_data_reg <= rx_data_b;
    end
  end

  always@(*) begin
    if(!rst_n) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end
  
  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      state <= IDLE;
      rx_dv <= 1'b0;
      count <= 0;
      bit_counter <= 0;
      rx_data <= 0;
    end 
    else begin
      case (state)
        IDLE: begin
          count       <= 0;
          bit_counter <= 0;
          rx_dv       <= 1'b0;
          if(rx_data_reg == 1'b0) next_state <= START_BIT;
          else                    next_state <= IDLE;
        end
        
        START_BIT: begin
          rx_dv <= 1'b0;
          if(count == 4) begin
            if(rx_data_reg == 1'b0) begin
              count      <= 0;
              next_state <= DATA_BIT;
            end
            else next_state <= IDLE;
          end
          else begin
            count <= count +1;
            next_state <= START_BIT;
          end
        end
        
        DATA_BIT: begin
          rx_dv <= 1'b0;
          if(count == 7) begin
            count <= 0;
            rx_data[bit_counter] <= rx_data_reg;
            if(bit_counter == 7) begin
              next_state <= STOP_BIT;
              bit_counter <= 0;
            end
            else begin
              bit_counter <= bit_counter + 1;
              next_state <= DATA_BIT;
            end
          end
          else begin
            count <= count + 1;
            next_state <= DATA_BIT;
          end
        end
        
        STOP_BIT: begin
          if(count == 7) begin
            rx_dv <= 1'b1;
            count <= 0;
            next_state <= CLEAN;
          end
          else begin
            count <= count + 1;
            next_state <= STOP_BIT;
          end
        end

        CLEAN: begin
          next_state <= IDLE;
        end

        default: begin
          next_state <= IDLE;
        end
      endcase
    end
  end
  
endmodule



  








