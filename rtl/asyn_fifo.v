module asyn_fifo #(parameter FIFO_DEPTH=8, FIFO_WIDTH=8) (
  input w_en, w_clk, r_en, r_clk, rst_n,
  input [FIFO_WIDTH-1:0] data_in, 
  output [FIFO_WIDTH-1:0] data_out,
  output full, empty);
  
wire[3:0] g_rptr, g_wptr, g_rptr_sync, g_wptr_sync, b_wptr, b_rptr;


  synchronizer #(4) sync_wptr (.clk(w_clk),
                               .rst_n(rst_n),
                               .data_in(g_rptr),
                             .data_out(g_rptr_sync));
                              
  synchronizer #(4) sync_rptr (.clk(r_clk),
                               .rst_n(rst_n),
                               .data_in(g_wptr),
                             .data_out(g_wptr_sync));

  wptr_handler #(4) wptr_h (.wclk(w_clk),
                            .wrst_n(rst_n),
                            .w_en(w_en),
                            .g_rptr_sync(g_rptr_sync),
                            .g_wptr(g_wptr),
                            .full(full),
                            .b_wptr(b_wptr));

  rptr_handler #(4) rptr_h (.rclk(r_clk),
                           .rrst_n(rst_n),
                           .r_en(r_en),
                           .g_wptr_sync(g_wptr_sync),
                           .g_rptr(g_rptr),
                           .b_rptr(b_rptr),
                           .empty(empty));

  fifo_mem #(8,8,4) fifo_m (.wclk(w_clk),
                            .rclk(r_clk),
                            .r_en(r_en),
                            .w_en(w_en),
                            .full(full),
                            .b_wptr(b_wptr),
                            .b_rptr(b_rptr),
                            .data_in(data_in),
                          .data_out(data_out));

 endmodule


