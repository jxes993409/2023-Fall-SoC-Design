module user_fir #(
    parameter BITS = 32,
    parameter DELAYS=10
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);

  assign wbs_ack_o = ready;

  wire [3:0] wstrb;
  wire [31:0] rdata;
  wire [31:0] wdata;
  wire decoded;

  reg ready;

  assign decoded = wbs_adr_i[31:20] == 12'h380 ? 1'b1 : 1'b0;
  assign wstrb = wbs_sel_i & {4{wbs_we_i}};

  assign wbs_dat_o = rdata;
  assign wdata = wbs_dat_i;

  wire        awvalid;
  wire [11:0] awaddr;
  wire        wvalid;
  // w.o
  wire        awready;
  wire        wready;
  // r.i
  wire        rready;
  wire        arvalid;
  wire [11:0] araddr;
  // r.o
  wire        arready;
  wire        rvalid;
  wire [31:0] fir_rdata;
  // slave.i
  wire        ss_tvalid;
  wire [31:0] ss_tdata;
  wire        ss_tlast;
  // slave.o
  wire        ss_tready;
  // master.i
  wire        sm_tready;
  // master.o
  wire        sm_tvalid; 
  wire [31:0] sm_tdata; 
  wire        sm_tlast;
  // tap BRAM.i
  wire [3:0]  tap_WE;
  wire        tap_EN;
  wire [31:0] tap_Di;
  wire [11:0] tap_A;
  // tap BRAM.o
  wire [31:0] tap_Do;
  // data BRAM.i
  wire [3:0]  data_WE;
  wire        data_EN;
  wire [31:0] data_Di;
  wire [11:0] data_A;
  // data BRAM.o
  wire [31:0] data_Do;

  wire [31:0] data_out;
  wire fir_decoded;
  wire ss_chk;

  wire clk = wb_clk_i;
  wire rst = wb_rst_i;

  // assign wbs_ack_o = ready;

  always @(posedge clk) begin
      if (rst) begin
          ready <= 1'b0;
      end
      else begin
          ready <= 1'b0;
          if((wready || ss_tready) && !ready)begin
              ready <= 1'b1;
          end
          // check x
          else if((wbs_stb_i && wbs_cyc_i) && (wbs_adr_i[31:0] == 32'h3200_0004 && (rdata >> 3) == 1'b1) && !ready)begin
              ready <= 1'b1;
          end
          // check y
          else if((wbs_stb_i && wbs_cyc_i) && (wbs_adr_i[31:0] == 32'h3200_0004 && (rdata >> 4) == 1'b1) && !ready)begin
              ready <= 1'b1;
          end
          // output y
          else if((wbs_stb_i && wbs_cyc_i) && (wbs_adr_i[31:0] == 32'h3200_0088 && sm_tvalid && sm_tready) && !ready)begin
              ready <= 1'b1;
          end
      end
  end

  assign ss_chk = wbs_stb_i && wbs_cyc_i;

  reg [6:0] ss_count;

  assign awvalid = wbs_stb_i && wbs_cyc_i && fir_decoded && wstrb;
  assign wvalid  = wbs_stb_i && wbs_cyc_i && fir_decoded && wstrb;
  assign fir_decoded = ((wbs_adr_i[31:20] == 12'h320) && (wbs_adr_i[7:0] < 8'h80)) ? 1'b1 : 1'b0;

                  // addr = ap_ctrl
  assign awaddr = ((wbs_adr_i[7:0] == 8'h04) && (awvalid&wvalid)) ? 12'h00 :
                  // addr = data length
                  ((wbs_adr_i[7:0] == 8'h10) && (awvalid&wvalid)) ? 12'h10 :
                  // addr = tap
                  ((wbs_adr_i[7:0] >= 8'h40) && (awvalid&wvalid)) ? wbs_adr_i[7:0] - 12'h20 :
                  // addr = x[n]
                  ((wbs_adr_i[31:0] == 32'h3200_0080)) ? 12'h80 : 12'hff;
  // input
  assign rready  = wbs_stb_i && wbs_cyc_i && fir_decoded && !wstrb;
  assign arvalid = wbs_stb_i && wbs_cyc_i && fir_decoded && !wstrb;

                  // addr = ap_ctrl
  assign araddr = ((wbs_adr_i[7:0] == 8'h04) & (rready&arvalid)) ? 12'h00 :
                  // addr = data length
                  ((wbs_adr_i[7:0] == 8'h10) & (rready&arvalid)) ? 12'h10 :
                  // addr = tap
                  ((wbs_adr_i[7:0] >= 8'h40) & (rready&arvalid)) ? wbs_adr_i[7:0] - 12'h20 :
                  // addr = y[n]
                  ((wbs_adr_i[31:0] == 32'h3200_0088)) ? 12'h88 : 12'hff;

  assign ss_tvalid = 1'b1;
  assign ss_tdata = wdata;

  always @(posedge clk) begin
      if (rst) begin
          ss_count <= 6'b0;
      end
      else if (ss_tready)begin
          ss_count <= ss_count + 1'b1;
      end
      else begin
          ss_count <= ss_count;
      end
  end
  assign ss_tlast = (ss_count == 7'd64) ? 1'b1 : 1'b0;

  assign sm_tready = 1'b1;

                  // ap_ctrl, tap, data len
  assign rdata = (rready && arvalid) ? fir_rdata :
                  // Y
                  (wbs_adr_i[31:4] == 28'h3200_008) ? sm_tdata :
                  // rdata = rdata
                  32'b0;

  fir fir_DUT (
        .axis_clk(clk),
        .axis_rst_n(rst),

        // w
        .awready(awready),
        .wready(wready),

        .awvalid(awvalid),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wdata(wdata),

        // r
        .arready(arready),

        .rready(rready),
        .arvalid(arvalid),
        .araddr(araddr),

        .rvalid(rvalid),
        .rdata(fir_rdata),

        // master
        .sm_tready(sm_tready),

        .sm_tvalid(sm_tvalid),
        .sm_tdata(sm_tdata),
        .sm_tlast(sm_tlast),

        // slave
        .ss_tvalid(ss_tvalid),
        .ss_tdata(ss_tdata),
        .ss_tlast(ss_tlast),

        .ss_tready(ss_tready),

        // tap BRAM
        .tap_WE(tap_WE),
        .tap_EN(tap_EN),
        .tap_Di(tap_Di),
        .tap_A(tap_A),

        .tap_Do(tap_Do),

        // data BRAM
        .data_WE(data_WE),
        .data_EN(data_EN),
        .data_Di(data_Di),
        .data_A(data_A),

        .data_Do(data_Do),

        .ss_chk(ss_chk)
    );

    bram tap_ram(
        .CLK(clk),
        .WE0(tap_WE),
        .EN0(tap_EN),
        .Di0(tap_Di),
        .A0({20'b0, tap_A}),

        .Do0(tap_Do)
    );

    bram data_ram(
        .CLK(clk),
        .WE0(data_WE),
        .EN0(data_EN),
        .Di0(data_Di),
        .A0({20'b0, data_A}),

        .Do0(data_Do)
    );


endmodule

`default_nettype wire