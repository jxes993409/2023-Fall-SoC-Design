module user_mm
#(  parameter pADDR_WIDTH = 12,
    parameter pDATA_WIDTH = 32,
    parameter Tape_Num    = 11
)
(
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
    output [31:0] wbs_dat_o
    
  /*
  input   wire                     ss_tvalid, 
  input   wire [(pDATA_WIDTH-1):0] ss_tdata, 
  input   wire                     ss_tlast, 
  output  wire                     ss_tready, 

  input   wire                     sm_tready, 
  output  wire                     sm_tvalid, 
  output  wire [(pDATA_WIDTH-1):0] sm_tdata, 
  output  wire                     sm_tlast,

  input   wire                     axis_clk,
  input   wire                     axis_rst_n
  */
);

reg [7:0] A [15:0];
reg [7:0] B [15:0];
reg [7:0] result;

reg [7:0] sum;
reg [3:0] i, j, k;

reg [3:0] output_counter;
reg check_out;
reg last;

wire valid;



//////////////////////////////////////////////////////////////  ap things /////////////////////////////////////////////////////////

reg ap_start;
reg ap_done;
reg ap_idle;
reg check_ap;

/*
wire decode;
wire decode_write;
wire [3:0] decode_ap;
wire [3:0] decode_data;

//  just decode 
assign decode = (ss_tdata[31:20] == 12'h340) ? 1 : 0;
//  1 for write , 0 for read
assign decode_write = (ss_tdata[11:8]==4'b1111) ? 1 : 0;
// ap addr
assign decode_ap = ss_tdata[3:0];
//  write ap content
assign decode_data = ss_tdata[7:4];
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

assign valid = wbs_stb_i & wbs_cyc_i & wbs_adr_i[31:20]==12'h340;

assign wbs_ack_o = (valid & wbs_adr_i[19:0]==0) ? check_ap : check_out;
assign wbs_dat_o = result;

//assign ss_tready = 1;
//assign sm_tdata = (decode & !decode_write && decode_ap==4'd0) ? {29'd0,ap_idle,ap_done,ap_start} : sum;
//assign sm_tvalid = (decode & !decode_write && decode_ap==4'd0) ? check_ap : check_out;
//assign sm_tlast = sm_tvalid & sm_tready & last;


// initial A, B, i, j, k and sum
always @(posedge wb_clk_i) begin
  if (wb_rst_i) begin
    // A
    A[0] <= 8'h0;
    A[1] <= 8'h1;
    A[2] <= 8'h2;
    A[3] <= 8'h3;
    A[4] <= 8'h0;
    A[5] <= 8'h1;
    A[6] <= 8'h2;
    A[7] <= 8'h3;
    A[8] <= 8'h0;
    A[9] <= 8'h1;
    A[10] <= 8'h2;
    A[11] <= 8'h3;
    A[12] <= 8'h0;
    A[13] <= 8'h1;
    A[14] <= 8'h2;
    A[15] <= 8'h3;
    // B
    B[0] <= 8'h1;
    B[1] <= 8'h2;
    B[2] <= 8'h3;
    B[3] <= 8'h4;
    B[4] <= 8'h5;
    B[5] <= 8'h6;
    B[6] <= 8'h7;
    B[7] <= 8'h8;
    B[8] <= 8'h9;
    B[9] <= 8'ha;
    B[10] <= 8'hb;
    B[11] <= 8'hc;
    B[12] <= 8'hd;
    B[13] <= 8'he;
    B[14] <= 8'hf;
    B[15] <= 8'h10;
  end
end


/*
always @(posedge wb_clk_i) begin
  if(wb_rst_i) begin
    ap_start <= 0;
    ap_done <= 0;
    ap_idle <= 1;
    check_ap <= 0;
  end
  else begin
    if(valid) begin
      if(wbs_we_i)begin
        if(wbs_adr_i==32'h34000000)begin //only ap_start can be written , and ap_idle become 0
          ap_start <= wbs_dat_i[0];
          ap_done <= ap_done;
          ap_idle <= 0;
          check_ap <= 1;
        end
      end
      else if(wbs_adr_i[19:0]==0)begin  //if ap has been read , ap_done must be reset
          ap_start <= wbs_dat_i[0];
          ap_done <= 0;
          ap_idle <= ap_idle;
          check_ap <= 1;
      end
    end

    //not sure
       
    else if(ap_start) begin //once ap_start is written , then ap_start will be 0 after that
      ap_start <= 0;
      ap_done <= ap_done;
      ap_idle <= ap_idle;
    end
    

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    else if(last & wbs_ack_o)begin //After the last data is transfered , ap_start and ap_idle must be 1
      ap_start <= ap_start;
      ap_done <= 1;
      ap_idle <= 1;
      check_ap <= 1;
    end
    else begin
      ap_start <= ap_start;
      ap_done <= ap_done;
      ap_idle <= ap_idle;
      check_ap <= (wbs_ack_o) ? 0 : check_ap;
    end
  end
end
*/

// wait start
always @(posedge wb_clk_i) begin
  if(wb_rst_i) begin       
    sum <= 8'h0;
    i <= 4'h0;
    j <= 4'h0;
    k <= 4'h0;
    output_counter <= 0;
    check_out <= 0;
  end
  else begin
    if (valid & !wbs_we_i) begin
      if (i == 4'd4) begin
          sum <= 8'd0;
          i <= 4'd15;
          j <= 4'd15;
          k <= 4'd15;
          if(wbs_ack_o)
            check_out <= 0;
      end
      else if (j == 4'd4) begin
          j <= 4'd0;
          k <= 4'd0;
          i <= i + 1;
          if(wbs_ack_o)
            check_out <= 0;
      end
      else if (k == 4'd4) begin
          result <= sum;
          // flag sm_tvalid
          j <= j + 1;
          k <= 4'd0;
          sum <= 8'd0;
          check_out <= 1;
          output_counter <= output_counter + 1;
       end
      else if (k < 4'd4) begin
          sum <= sum + A[(i << 2) + k] * B[(k << 2) + j];
          k <= k + 1;  
          if(wbs_ack_o)
            check_out <= 0;
      end
    end
  end
end

endmodule
