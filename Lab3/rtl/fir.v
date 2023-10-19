`timescale 1ns / 1ps

module fir
#(
  parameter pADDR_WIDTH = 12,
  parameter pDATA_WIDTH = 32,
  parameter Tape_Num    = 11,
  parameter [3 : 0] S00 = 4'b0000,
                    S01 = 4'b0001,
                    S02 = 4'b0010,
                    S03 = 4'b0011,
                    S04 = 4'b0100,
                    S05 = 4'b0101,
                    S06 = 4'b0110,
                    S07 = 4'b0111,
                    S08 = 4'b1000,
                    S09 = 4'b1001,
                    S10 = 4'b1010,
                    S11 = 4'b1011,
                    S12 = 4'b1100
)
(
  output  wire                       awready,
  output  reg                        wready,
  input   wire                       awvalid,
  input   wire [(pADDR_WIDTH-1) : 0] awaddr,
  input   wire                       wvalid,
  input   wire [(pDATA_WIDTH-1) : 0] wdata,
  output  wire                       arready,
  input   wire                       rready,
  input   wire                       arvalid,
  input   wire [(pADDR_WIDTH-1) : 0] araddr,
  output  reg                        rvalid,
  output  reg  [(pDATA_WIDTH-1) : 0] rdata,
  input   wire                       ss_tvalid,
  input   wire [(pDATA_WIDTH-1) : 0] ss_tdata,
  input   wire                       ss_tlast,
  output  reg                        ss_tready,
  input   wire                       sm_tready,
  output  reg                        sm_tvalid,
  output  reg  [(pDATA_WIDTH-1) : 0] sm_tdata,
  output  wire                       sm_tlast,

  // bram for tap RAM
  output  reg  [3 : 0]               tap_WE,
  output  reg                        tap_EN,
  output  reg  [(pDATA_WIDTH-1) : 0] tap_Di,
  output  reg  [(pADDR_WIDTH-1) : 0] tap_A,
  input   wire [(pDATA_WIDTH-1) : 0] tap_Do,

  // bram for data RAM
  output  reg  [3 : 0]               data_WE,
  output  reg                        data_EN,
  output  reg  [(pDATA_WIDTH-1) : 0] data_Di,
  output  reg  [(pADDR_WIDTH-1) : 0] data_A,
  input   wire [(pDATA_WIDTH-1) : 0] data_Do,

  input   wire                       axis_clk,
  input   wire                       axis_rst_n
);

  reg [(pDATA_WIDTH-1) : 0] data_length;
  reg [(pDATA_WIDTH-1) : 0] axi_ctrl;

  always @(axis_rst_n)
  begin
    if (axis_rst_n == 1'b1)
    begin
      data_length <= 32'b0;
      axi_ctrl    <= 32'b0;
    end
  end

  reg [3 : 0] lite_write_current_state, lite_write_next_state;
  
  always @(posedge axis_clk)
  begin
    if (axis_rst_n == 1'b0)
    begin
      lite_write_current_state <= S00;
      lite_write_next_state    <= S00;
    end
  end

  always @(posedge axis_clk)
  begin
    lite_write_current_state <= lite_write_next_state;
  end

  always @(awvalid)
  begin
    case(lite_write_current_state)
      S00:
      begin
        case(awvalid)
          1'b0: lite_write_next_state = S00;
          1'b1: lite_write_next_state = S01;
        endcase
      end
      S01:
      begin
        case(awvalid)
          1'b0:   lite_write_next_state = S00;
          1'b1:   lite_write_next_state = S01;
        endcase
      end
    endcase
  end

  always @(lite_write_current_state)
  begin
    case(lite_write_current_state)
      S00: wready = 1'b0;
      S01: wready = 1'b1;
    endcase
  end
 
  always @(awvalid or wready)
  begin
    case({awvalid, wready})
      2'b10:
      begin
        if (awaddr >= 12'h20)
        begin
          tap_A  <= awaddr - 12'h20;
        end
      end
      2'b11:
      begin
        case(awaddr)
          12'h00: axi_ctrl    <= wdata;
          12'h10: data_length <= wdata;
          default:
          begin
            tap_WE <= 4'b1111;
            tap_EN <= 1'b1;
            tap_Di <= wdata;
          end
        endcase
      end
      default: tap_EN <= 1'b0;
    endcase
  end


  reg [3 : 0] lite_read_current_state, lite_read_next_state;
  
  always @(posedge axis_clk)
  begin
    if (axis_rst_n == 1'b0)
    begin
      lite_read_current_state <= S00;
      lite_read_next_state    <= S00;
    end
    else
    begin
      lite_read_current_state <= lite_read_next_state;
    end
  end

  always @(arvalid)
  begin
    case(lite_read_current_state)
      S00:
      begin
        case(arvalid)
          1'b1:    lite_read_next_state = S01;
          default: lite_read_next_state = S00;
        endcase
      end
      S01:
      begin
        case(arvalid)
          1'b0: lite_read_next_state = S00;
          1'b1: lite_read_next_state = S01;
        endcase
      end
    endcase
  end

  always @(lite_read_current_state)
  begin
    case(lite_read_current_state)
      S00: rvalid = 1'b0;
      S01: rvalid = 1'b1;
    endcase
  end

  always @(arvalid or rvalid)
  begin
    case({arvalid, rvalid})
      2'b01: tap_A  <= araddr - 12'd28;
      2'b10:
      begin
        if (araddr == 12'h00)
        begin
          rdata <= axi_ctrl;
        end
        else
        begin
          tap_WE <= 4'b0000;
          tap_EN <= 1'b1;
          tap_A  <= araddr - 12'h20;
        end
      end
      2'b11: rdata <= (araddr == 12'h00) ? axi_ctrl : tap_Do;
    endcase
  end

  reg flag;
  reg [(pADDR_WIDTH - 1) : 0] data_seq, data_head, data_tail, counter;

  always @(axi_ctrl)
  begin
    if ((axi_ctrl & 32'h0000_0001) == 32'b1)
    begin
      data_seq  <= 12'b0;
      ss_tready <= 1'b1;
    end
  end

  always @(axis_rst_n)
  begin
    if (axis_rst_n == 1'b1)
    begin
      ss_tready <= 1'b0;
      counter   <= 12'd0;
      data_head <= 12'd0;
      data_tail <= 12'd40;
    end
  end

  always @(data_seq)
  begin
    if (data_seq == 12'd44)
    begin
      ss_tready <= 1'b0;
      data_seq  <= 12'd44;
    end
    if ({ss_tvalid, ss_tready} == 2'b11)
    begin
      data_WE <= 4'b1111;
      data_EN <= 1'b1;
      data_A  <= data_seq;
      data_Di <= ss_tdata;
    end
  end

  always @(posedge axis_clk)
  begin
    data_seq <= ((axi_ctrl & 32'h0000_0001) == 32'b1 && data_seq != 12'd44) ? data_seq + 4 : data_seq;
  end

  always  @(axi_ctrl)
  begin
    ss_tready  <= (axi_ctrl & 32'h0000_0001) == 32'b1 ? 1'b1 : 1'b0;
  end


  always @(ss_tready)
  begin
    if ({ss_tvalid, ss_tready} == 2'b11 && (axi_ctrl & 32'h0000_0001) == 32'b1 && data_seq == 12'd44)
    begin
      data_WE <= 4'b1111;
      data_EN <= 1'b1;
      data_A  <= data_tail;
      data_Di <= ss_tdata;
    end
  end

  reg counter_arvalid, counter_rvalid, first_flag;
  reg [3 : 0] counter_current_state, counter_next_state;
  reg [(pDATA_WIDTH - 1) : 0] tap_data, data_data;

  always @(posedge axis_clk)
  begin
    if (axis_rst_n == 1'b0)
    begin
      first_flag <= 1'b0;
    end
  end

  always @(axi_ctrl)
  begin
    if ((axi_ctrl & 32'h0000_0001) == 32'b1)
    begin
      first_flag <= 1'b1;
      counter_arvalid <= 1'b0;
      counter_rvalid  <= 1'b0;
      counter_current_state <= S00;
      counter_next_state    <= S00;
    end
  end

  reg [3 : 0] stream_current_state, stream_next_state;

  always @(stream_current_state)
  begin
    if (stream_current_state == S01 && first_flag == 1'b1) first_flag = 1'b0;
  end

  always @(posedge axis_clk)
  begin
    counter_current_state <= counter_next_state;
  end

  always @(counter_arvalid or counter_current_state or ss_tready)
  begin
    case(counter_current_state)
      S00:
      begin
        case({counter_arvalid, ss_tready})
          2'b00:   counter_next_state = S01;
          default: counter_next_state = S00;
        endcase
      end
      S01:
      begin
        case({counter_arvalid, ss_tready})
          2'b10:   counter_next_state = S02;
          default: counter_next_state = S01;
        endcase
      end
      S02:
      begin
        case({counter_arvalid, ss_tready})
          2'b10:   counter_next_state = S03;
          default: counter_next_state = S02;
        endcase
      end
      S03:
      begin
        case({counter_arvalid, ss_tready})
          2'b10:   counter_next_state = S04;
          default: counter_next_state = S03;
        endcase
      end
      S04:
      begin
        case({counter_arvalid, ss_tready})
          2'b10:   counter_next_state = S00;
          default: counter_next_state = S04;
        endcase
      end
    endcase
  end

  always @(counter_current_state)
  begin
    case(counter_current_state)
      S00: {counter_arvalid, counter_rvalid} = 2'b00;
      S01: {counter_arvalid, counter_rvalid} = 2'b10;
      S02: {counter_arvalid, counter_rvalid} = 2'b11;
      S03: {counter_arvalid, counter_rvalid} = 2'b11;
      S04: {counter_arvalid, counter_rvalid} = 2'b11;
    endcase
  end

  always @(counter_arvalid or counter_rvalid or counter_current_state or ss_tready)
  begin
    case({counter_arvalid, counter_rvalid})
      2'b00:
      begin
        tap_EN  <= 1'b0;
        data_EN <= 1'b0;
        if (first_flag)
        begin
          data_A <= (tap_A == 12'd44) ? 12'd0 : tap_A + 4;
        end
      end
      2'b10:
      begin
        tap_WE  <= 4'b0000;
        tap_EN  <= 1'b1;
        tap_A <= ((counter - data_head) & 12'h700) ? counter - data_head + 12'd44 : counter - data_head;
        counter <= (counter == 12'd40) ? 12'b0 : counter + 4;
      end
      2'b11:
      begin
        if ((ss_tready == 1'b0) && counter_current_state == S02)
        begin
          data_WE <= 4'b0000;
          data_EN <= 1'b1;
          if (!first_flag && counter == data_head)
          begin
            case(counter)
              12'd00:  data_A <= 12'd36;
              12'd04:  data_A <= 12'd40;
              default: data_A <= counter - 12'd8;
            endcase
          end
          else if (!first_flag && counter != data_head)
          begin
            case(counter)
              12'd00:  data_A <= 12'd40;
              default: data_A <= counter - 12'd4;
            endcase
          end
        end
        else if (counter_current_state == S04)
        begin
          data_data <= data_Do;
          tap_data  <= tap_Do;
        end
      end
    endcase
  end

  reg chk_flag;

  always @(posedge axis_clk)
  begin
    if (chk_flag == 1'b1)
    begin
      if (data_seq == 12'd44)
      begin
        ss_tready <= 1'b1;
      end
      chk_flag  <= 1'b0;
    end
    else if (chk_flag == 1'b0 && data_seq == 12'd44)
    begin
      ss_tready <= 1'b0;
    end
  end

  always @(axis_rst_n)
  begin
    if (axis_rst_n == 1'b1)
    begin
      stream_current_state <= S00;
      stream_next_state    <= S00;
    end
  end

  always @(counter)
  begin
    if(chk_flag == 1'b0)
    begin
      case(stream_current_state)
        // data_tail = 40
        S00:     stream_current_state <= (counter == 12'd0) ? stream_next_state : stream_current_state;
        // data_tail = 0
        S01:     stream_current_state <= (counter == 12'd4) ? stream_next_state : stream_current_state;
        default: stream_current_state <= (counter - 12'd4 == data_tail) ? stream_next_state : stream_current_state;
      endcase
    end
  end

  always @(stream_current_state)
  begin
    case(stream_current_state)
      S00: stream_next_state = S01;
      S01: stream_next_state = S02;
      S02: stream_next_state = S03;
      S03: stream_next_state = S04;
      S04: stream_next_state = S05;
      S05: stream_next_state = S06;
      S06: stream_next_state = S07;
      S07: stream_next_state = S08;
      S08: stream_next_state = S09;
      S09: stream_next_state = S10;
      S10: stream_next_state = S00;
    endcase
  end

  always @(stream_current_state)
  begin
    case(stream_current_state)
      S00:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd0;
        data_head <= 12'd0;
        data_tail <= 12'd40;
      end
      S01:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd4;
        data_head <= 12'd4;
        data_tail <= 12'd0;
      end
      S02:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd8;
        data_head <= 12'd8;
        data_tail <= 12'd4;
      end
      S03:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd12;
        data_head <= 12'd12;
        data_tail <= 12'd8;
      end
      S04:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd16;
        data_head <= 12'd16;
        data_tail <= 12'd12;
      end
      S05:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd20;
        data_head <= 12'd20;
        data_tail <= 12'd16;
      end
      S06:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd24;
        data_head <= 12'd24;
        data_tail <= 12'd20;
      end
      S07:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd28;
        data_head <= 12'd28;
        data_tail <= 12'd24;
      end
      S08:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd32;
        data_head <= 12'd32;
        data_tail <= 12'd28;
      end
      S09:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd36;
        data_head <= 12'd36;
        data_tail <= 12'd32;
      end
      S10:
      begin
        chk_flag  <= 1'b1;
        counter   <= 12'd40;
        data_head <= 12'd40;
        data_tail <= 12'd36;
      end
    endcase
  end

  reg fir_flag;
  reg [3 : 0] reg_counter;
  reg [10 : 0] output_counter;
  reg [(pDATA_WIDTH - 1) : 0] temp_Y, output_Y;
  
  always @(posedge axis_clk)
  begin
    if (axis_rst_n == 1'b0)
    begin
      output_counter <= -11'd1;
      reg_counter    <= -4'd1;
      temp_Y         <= 32'b0;
      output_Y       <= 32'b0;
      sm_tdata       <= 32'b0;
    end
    else
    begin
      if (counter_current_state == S04)
      begin
        reg_counter <= (reg_counter == 4'd10) ? 4'b0 : (reg_counter + 4'b1);
        temp_Y   <= data_data * tap_data;
        output_Y <= temp_Y + output_Y;
      end
    end
  end

  always @(reg_counter or counter_current_state)
  begin
    case(reg_counter)
      4'b0:
      begin
        output_Y  <= 32'b0;
        sm_tvalid <= 1'b0;
        sm_tdata  <= 32'b0;
      end
      4'd10:
      begin
        case(counter_current_state)
          S04:
          begin
            output_counter <= output_counter + 11'b1;
            sm_tdata       <= output_Y;
            sm_tvalid      <= 1'b1;
          end
          default: sm_tvalid <= 1'b0;
        endcase
      end
      default:
      begin
        sm_tvalid <= 1'b0;
        sm_tdata  <= 32'b0;
      end
    endcase
  end

  always @(posedge axis_clk)
  begin
    if (ss_tlast == 1)
    begin
      axi_ctrl <= 32'h0000_0000;
    end
  end

endmodule