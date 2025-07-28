module uart_control #(parameter CLK=50_000_000, parameter baud_rate = 9600) (
  input clk, rst_n, w_en, r_en, rxd,
  input  [7:0] data_in,
  output [7:0] data_out,
  output empty, full, txd
);
  
  wire r_en_tx, clk_tx, empty_tx;
  wire [7:0] data_tx_out;

  asyn_fifo #(8,8) fifo_tx (.w_en(w_en),
                            .w_clk(clk),
                            .r_en(r_en_tx),
                            .r_clk(clk_tx),
                            .data_in(data_in),
                            .data_out(data_tx_out),
                            .full(full),
                            .empty(empty_tx),
			    .rst_n(rst_n)	
                           );

  transmitter transmit (.clk(clk_tx),
                        .rst_n(rst_n),
                        .empty(empty_tx),
                        .data_in(data_tx_out),
                        .fifo_rd_en(r_en_tx),
                        .txd(txd)
                       );
  wire w_en_rx, clk_rx;
  wire [7:0] data_in_rx; 
  
  asyn_fifo #(8,8) fifo_rx (.w_en(w_en_rx),
                            .w_clk(clk_rx),
                            .r_en(r_en),
                            .r_clk(clk),
                            .rst_n(rst_n),
                            .data_in(data_in_rx),
                            .data_out(data_out),
                            .full(),
                            .empty(empty)
                          );

  receiver rec (.clk(clk_rx),
                .rst_n(rst_n),
                .rx_serial(rxd),
                .rx_dv(w_en_rx),
                .rx_data(data_in_rx)
              );
                              
  baud_gen gen (.clk(clk),
                .rst_n(rst_n),
                .clk_tx(clk_tx),
                .clk_rx(clk_rx)
              );

endmodule

