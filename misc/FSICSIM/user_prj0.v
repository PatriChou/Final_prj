// This code snippet was auto generated by xls2vlog.py from source file: ./user_project_wrapper.xlsx
// User: josh
// Date: Sep-22-23

//`define USE_EDGEDETECT_IP

`timescale 1ns / 10ps

`ifdef USE_EDGEDETECT_IP
module USER_PRJ0 #(parameter pUSER_PROJECT_SIDEBAND_WIDTH   = 5,
                   parameter pADDR_WIDTH   = 12,
                   parameter pDATA_WIDTH   = 32
                 )
(
  output wire                        awready,
  output wire                        arready,
  output wire                        wready,
  output wire                        rvalid,
  output wire  [(pDATA_WIDTH-1) : 0] rdata,
  input  wire                        awvalid,
  input  wire                [11: 0] awaddr,
  input  wire                        arvalid,
  input  wire                [11: 0] araddr,
  input  wire                        wvalid,
  input  wire                 [3: 0] wstrb,
  input  wire  [(pDATA_WIDTH-1) : 0] wdata,
  input  wire                        rready,
  input  wire                        ss_tvalid,
  input  wire  [(pDATA_WIDTH-1) : 0] ss_tdata,
  input  wire                 [1: 0] ss_tuser,
  `ifdef USER_PROJECT_SIDEBAND_SUPPORT
  input  wire  [pUSER_PROJECT_SIDEBAND_WIDTH-1: 0] ss_tupsb,
  `endif
  input  wire                 [3: 0] ss_tstrb,
  input  wire                 [3: 0] ss_tkeep,
  input  wire                        ss_tlast,
  input  wire                        sm_tready,
  output wire                        ss_tready,
  output wire                        sm_tvalid,
  output wire  [(pDATA_WIDTH-1) : 0] sm_tdata,
  output wire                 [2: 0] sm_tid,
  `ifdef USER_PROJECT_SIDEBAND_SUPPORT
  output  wire [pUSER_PROJECT_SIDEBAND_WIDTH-1: 0] sm_tupsb,
  `endif
  output wire                 [3: 0] sm_tstrb,
  output wire                 [3: 0] sm_tkeep,
  output wire                        sm_tlast,
  output wire                        low__pri_irq,
  output wire                        High_pri_req,
  output wire                [23: 0] la_data_o,
  input  wire                        axi_clk,
  input  wire                        axis_clk,
  input  wire                        axi_reset_n,
  input  wire                        axis_rst_n,
  input  wire                        user_clock2,
  input  wire                        uck2_rst_n
);

localparam	RD_IDLE = 1'b0;
localparam	RD_ADDR_DONE = 1'b1;

//[TODO] does tlast from FPGA to SOC need send to UP? or use upsb as UP's tlast?
`ifdef USER_PROJECT_SIDEBAND_SUPPORT
	localparam	FIFO_WIDTH = (pUSER_PROJECT_SIDEBAND_WIDTH + 4 + 4 + 1 + pDATA_WIDTH);		//upsb, tstrb, tkeep, tlast, tdata  
`else
	localparam	FIFO_WIDTH = (4 + 4 + 1 + pDATA_WIDTH);		//tstrb, tkeep, tlast, tdata
`endif

// `ifdef USER_PROJECT_SIDEBAND_SUPPORT
// wire [33:0] dat_in_rsc_dat = {ss_tupsb[1:0], ss_tdata[31:0]};
// `else
// wire [33:0] dat_in_rsc_dat = {2'b00,         ss_tdata[31:0]};
// `endif

// wire [33:0] dat_out_rsc_dat;

wire [7:0] dat_in_rsc_dat = ss_tdata[7:0];
wire [8:0] dat_out_rsc_dat;

wire        ram0_denoise_en;
wire [15:0] ram0_denoise_q;
wire        ram0_denoise_we;
wire [15:0] ram0_denoise_d;
wire [9:0]  ram0_denoise_adr;
wire        ram1_denoise_en;
wire [15:0] ram1_denoise_q;
wire        ram1_denoise_we;
wire [15:0] ram1_denoise_d;
wire [9:0]  ram1_denoise_adr;

wire        ram0_edgedect_en;
wire [15:0] ram0_edgedect_q;
wire        ram0_edgedect_we;
wire [15:0] ram0_edgedect_d;
wire [9:0]  ram0_edgedect_adr;
wire        ram1_edgedect_en;
wire [15:0] ram1_edgedect_q;
wire        ram1_edgedect_we;
wire [15:0] ram1_edgedect_d;
wire [9:0]  ram1_edgedect_adr;


reg         reg_rst;
reg  [10:0] reg_widthIn;
reg  [9:0]  reg_heightIn;
reg  [1:0]  reg_ctrl_denoise;
reg  [1:0]  reg_ctrl_edgedect;

wire        IP_done;
reg         reg_IP_done;

wire awvalid_in;
wire wvalid_in;

reg [31:0] RegisterData;

//write addr channel
assign 	awvalid_in	= awvalid; 
wire awready_out;
assign awready = awready_out;

//write data channel
assign 	wvalid_in	= wvalid;
wire wready_out;
assign wready = wready_out;

// if both awvalid_in=1 and wvalid_in=1 then output awready_out = 1 and wready_out = 1
assign awready_out = (awvalid_in && wvalid_in) ? 1 : 0;
assign wready_out = (awvalid_in && wvalid_in) ? 1 : 0;


//write register
always @(posedge axi_clk or negedge axi_reset_n)  begin
  if ( !axi_reset_n ) begin
    reg_widthIn         <= 640;
    reg_heightIn        <= 360;
    reg_ctrl_denoise    <= 0;
    reg_ctrl_edgedect   <= 0;
    reg_rst             <= 0;
  end else begin
    if ( awvalid_in && wvalid_in ) begin		//when awvalid_in=1 and wvalid_in=1 means awready_out=1 and wready_out=1
      if          (awaddr[11:2] == 10'h000 ) begin //offset 0
        if ( wstrb[0] == 1) reg_rst           <= wdata[0];
      end else if (awaddr[11:2] == 10'h001 ) begin //offset 1
        if ( wstrb[0] == 1) reg_widthIn[7:0]  <= wdata[7:0];
        if ( wstrb[1] == 1) reg_widthIn[10:8] <= wdata[10:8];
      end else if (awaddr[11:2] == 10'h002 ) begin //offset 2
        if ( wstrb[0] == 1) reg_heightIn[7:0] <= wdata[7:0];
        if ( wstrb[1] == 1) reg_heightIn[9:8] <= wdata[9:8];
      end else if (awaddr[11:2] == 10'h003 ) begin //offset 3
        if ( wstrb[0] == 1) reg_ctrl_denoise <= wdata[1:0];
      end else if (awaddr[11:2] == 10'h004 ) begin //offset 4
        if ( wstrb[0] == 1) reg_ctrl_edgedect<= wdata[1:0];
      end
    end
  end
end

always @(posedge axi_clk or negedge axi_reset_n)  begin
  if ( !axi_reset_n ) begin
      reg_IP_done <= 0;
  end else begin
    if (IP_done)
      reg_IP_done <= 1;
    else if ( awvalid_in && wvalid_in ) begin        //when awvalid_in=1 and wvalid_in=1 means awready_out=1 and wready_out=1 
      if (awaddr[11:2] == 10'h005 ) begin //offset 5
        if ( wstrb[0] == 1) reg_IP_done <= 0;
      end
    end
  end
end


//read register
reg [(pDATA_WIDTH-1) : 0] rdata_tmp;
assign arready = 1; //always assigned to 1, limitation: only support 1T in arvalid, if master issue 2T in arvalid then only 1st raddr is captured.
reg rvalid_out ;
assign rvalid = rvalid_out;
assign rdata =  rdata_tmp;
reg rd_state;
reg rd_next_state;
reg [pADDR_WIDTH-1:0] rd_addr;

////
always @(posedge axi_clk or negedge axi_reset_n)  begin
  if ( !axi_reset_n ) 
    rd_state <= RD_IDLE;
  else
    rd_state <= rd_next_state;
end

always@(*)begin
  case(rd_state)
    RD_IDLE:
      if(arvalid && arready) rd_next_state = RD_ADDR_DONE;
      else      rd_next_state = RD_IDLE;
    RD_ADDR_DONE:
      if(rready && rvalid_out) rd_next_state = RD_IDLE;
      else    rd_next_state = RD_ADDR_DONE;
    default:rd_next_state = RD_IDLE;
  endcase
end 

always @(posedge axi_clk or negedge axi_reset_n)  begin
  if ( !axi_reset_n ) begin
    rd_addr <= 0;
	rvalid_out <= 0;
  end	
  else begin
    if (rd_state == RD_IDLE )
	  if(arvalid && arready) begin
		rd_addr <= araddr;
		rvalid_out <= 1;
	  end	
	if (rd_state == RD_ADDR_DONE ) 
	  if(rready && rvalid_out)
		rvalid_out <= 0;
  end	
end

////
always @* begin
  if      (rd_addr[11:2] == 10'h000) rdata_tmp = reg_rst;
  else if (rd_addr[11:2] == 10'h001) rdata_tmp = reg_widthIn;
  else if (rd_addr[11:2] == 10'h002) rdata_tmp = reg_heightIn;
  else if (rd_addr[11:2] == 10'h003) rdata_tmp = reg_ctrl_denoise;
  else if (rd_addr[11:2] == 10'h004) rdata_tmp = reg_ctrl_edgedect;
  else if (rd_addr[11:2] == 10'h005) rdata_tmp = reg_IP_done;
  else                              rdata_tmp = 0;
end

//DUT
// assign sm_tdata  = dat_out_rsc_dat[31: 0]; 

// `ifdef USER_PROJECT_SIDEBAND_SUPPORT
// assign sm_tupsb = dat_out_rsc_dat[33:32];
// `endif

// assign sm_tlast = dat_out_rsc_dat[33];
assign sm_tdata  = {24'b0, dat_out_rsc_dat[7: 0]}; 

`ifdef USER_PROJECT_SIDEBAND_SUPPORT
assign sm_tupsb = 0;
`endif

assign sm_tlast = dat_out_rsc_dat[8];
assign {sm_tstrb, sm_tkeep} = 0;

wire dat_in_rsc_rdy;

assign ss_tready = dat_in_rsc_rdy;

always @(posedge axi_clk or negedge axi_reset_n)  begin
  if ( !axi_reset_n ) begin
    reg_IP_done  <= 0;
  end else if (IP_done) begin
    reg_IP_done  <= IP_done ;
  end
end

// EdgeDetect_Top U_EdgeDetect (
//     .clk                     (axi_clk           ), //user_clock2 ?
//     .rst                     (reg_rst           ), 
//     .arst_n                  (axi_reset_n       ), //~uck2_rst_n ? 
//     .widthIn                 (reg_widthIn       ), //I 
//     .heightIn                (reg_heightIn      ), //I
//     .sw_in                   (reg_sw_in         ), //I
//     .crc32_pix_in_rsc_dat    (crc32_stream_in   ), //O
//     .crc32_pix_in_triosy_lz  (),                   //O, not useful
//     .crc32_dat_out_rsc_dat   (crc32_stream_out  ), //O
//     .crc32_dat_out_triosy_lz (IP_done           ), //O
//     .dat_in_rsc_dat          (dat_in_rsc_dat    ), //I
//     .dat_in_rsc_vld          (ss_tvalid         ), //I
//     .dat_in_rsc_rdy          (dat_in_rsc_rdy    ), //O
//     .dat_out_rsc_dat         (dat_out_rsc_dat   ), //O
//     .dat_out_rsc_vld         (sm_tvalid         ), //O
//     .dat_out_rsc_rdy         (sm_tready         ), //I
//     .line_buf0_rsc_en        (ram0_en           ), //O
//     .line_buf0_rsc_q         (ram0_q            ), //I
//     .line_buf0_rsc_we        (ram0_we           ), //O
//     .line_buf0_rsc_d         (ram0_d            ), //O
//     .line_buf0_rsc_adr       (ram0_adr          ), //O
//     .line_buf1_rsc_en        (ram1_en           ), //O
//     .line_buf1_rsc_q         (ram1_q            ), //I 
//     .line_buf1_rsc_we        (ram1_we           ), //O 
//     .line_buf1_rsc_d         (ram1_d            ), //O 
//     .line_buf1_rsc_adr       (ram1_adr          )  //O
//     );

EdgeDetect_IP_EdgeDetect_Top U_EdgeDetect (
    .clk                                (axi_clk),          //I
    .rst                                (reg_rst),          //I
    .arst_n                             (axis_rst_n),       //I
    .dat_in_rsc_dat                     (dat_in_rsc_dat ),  //I
    .dat_in_rsc_vld                     (ss_tvalid),        //I
    .dat_in_rsc_rdy                     (dat_in_rsc_rdy),   //O
    .widthIn                            (reg_widthIn),      //I
    .heightIn                           (reg_heightIn),     //I
    .dat_out_rsc_dat                    (dat_out_rsc_dat),  //O
    .dat_out_rsc_vld                    (sm_tvalid),        //O
    .dat_out_rsc_rdy                    (sm_tready),        //I
    .ctrl_denoise_rsc_dat               (reg_ctrl_denoise), //I
    .ctrl_edgedect_rsc_dat              (reg_ctrl_edgedect),//I
    // .ctrl_status_rsc_dat                (IP_done),          //O

    .line_buf0_rsc_Denoise_inst_en      (ram0_denoise_en),  //O
    .line_buf0_rsc_Denoise_inst_q       (ram0_denoise_q),   //I
    .line_buf0_rsc_Denoise_inst_we      (ram0_denoise_we),  //O
    .line_buf0_rsc_Denoise_inst_d       (ram0_denoise_d),   //O
    .line_buf0_rsc_Denoise_inst_adr     (ram0_denoise_adr), //O
    .line_buf1_rsc_Denoise_inst_en      (ram1_denoise_en),  //O
    .line_buf1_rsc_Denoise_inst_q       (ram1_denoise_q),   //I
    .line_buf1_rsc_Denoise_inst_we      (ram1_denoise_we),  //O
    .line_buf1_rsc_Denoise_inst_d       (ram1_denoise_d),   //O
    .line_buf1_rsc_Denoise_inst_adr     (ram1_denoise_adr), //O
    
    .line_buf0_rsc_EdgeDetect_Filter_inst_en (ram0_edgedect_en),    //O
    .line_buf0_rsc_EdgeDetect_Filter_inst_q  (ram0_edgedect_q),     //I
    .line_buf0_rsc_EdgeDetect_Filter_inst_we (ram0_edgedect_we),    //O
    .line_buf0_rsc_EdgeDetect_Filter_inst_d  (ram0_edgedect_d),     //O
    .line_buf0_rsc_EdgeDetect_Filter_inst_adr (ram0_edgedect_adr),  //O
    .line_buf1_rsc_EdgeDetect_Filter_inst_en (ram1_edgedect_en),    //O
    .line_buf1_rsc_EdgeDetect_Filter_inst_q  (ram1_edgedect_q),     //I
    .line_buf1_rsc_EdgeDetect_Filter_inst_we (ram1_edgedect_we),    //O
    .line_buf1_rsc_EdgeDetect_Filter_inst_d  (ram1_edgedect_d),     //O
    .line_buf1_rsc_EdgeDetect_Filter_inst_adr (ram1_edgedect_adr)   //O
    );


//SRAM
SPRAM #(.data_width(16),.addr_width(10),.depth(256)) U_DENOISE_SPRAM_0(
    .adr (ram0_denoise_adr ), 
    .d   (ram0_denoise_d   ), 
    .en  (ram0_denoise_en  ), 
    .we  (ram0_denoise_we  ), 
    .clk (axi_clk  ), //user_clock2 ? 
    .q   (ram0_denoise_q   )
);

SPRAM #(.data_width(16),.addr_width(10),.depth(256)) U_DENOISE_SPRAM_1(
    .adr (ram1_denoise_adr ), 
    .d   (ram1_denoise_d   ), 
    .en  (ram1_denoise_en  ), 
    .we  (ram1_denoise_we  ), 
    .clk (axi_clk  ), //user_clock2 ? 
    .q   (ram1_denoise_q   )
);

SPRAM #(.data_width(16),.addr_width(10),.depth(256)) U_EDGEDECT_SPRAM_0(
    .adr (ram0_edgedect_adr ), 
    .d   (ram0_edgedect_d   ), 
    .en  (ram0_edgedect_en  ), 
    .we  (ram0_edgedect_we  ), 
    .clk (axi_clk  ), //user_clock2 ? 
    .q   (ram0_edgedect_q   )
);

SPRAM #(.data_width(16),.addr_width(10),.depth(256)) U_EDGEDECT_SPRAM_1(
    .adr (ram1_edgedect_adr ), 
    .d   (ram1_edgedect_d   ), 
    .en  (ram1_edgedect_en  ), 
    .we  (ram1_edgedect_we  ), 
    .clk (axi_clk  ), //user_clock2 ? 
    .q   (ram1_edgedect_q   )
);
//~

endmodule

`else
  /*
  module USER_PRJ0 #( parameter pUSER_PROJECT_SIDEBAND_WIDTH   = 5,
            parameter pADDR_WIDTH   = 12,
                    parameter pDATA_WIDTH   = 32
                  )
  (
    output wire                        awready,
    output wire                        arready,
    output wire                        wready,
    output wire                        rvalid,
    output wire  [(pDATA_WIDTH-1) : 0] rdata,
    input  wire                        awvalid,
    input  wire                [11: 0] awaddr,
    input  wire                        arvalid,
    input  wire                [11: 0] araddr,
    input  wire                        wvalid,
    input  wire                 [3: 0] wstrb,
    input  wire  [(pDATA_WIDTH-1) : 0] wdata,
    input  wire                        rready,
    input  wire                        ss_tvalid,
    input  wire  [(pDATA_WIDTH-1) : 0] ss_tdata,
    input  wire                 [1: 0] ss_tuser,
    `ifdef USER_PROJECT_SIDEBAND_SUPPORT
    input  wire                 [pUSER_PROJECT_SIDEBAND_WIDTH-1: 0] ss_tupsb,
    `endif
    input  wire                 [3: 0] ss_tstrb,
    input  wire                 [3: 0] ss_tkeep,
    input  wire                        ss_tlast,
    input  wire                        sm_tready,
    output wire                        ss_tready,
    output wire                        sm_tvalid,
    output wire  [(pDATA_WIDTH-1) : 0] sm_tdata,
    output wire                 [2: 0] sm_tid,
    `ifdef USER_PROJECT_SIDEBAND_SUPPORT
    output  wire                 [pUSER_PROJECT_SIDEBAND_WIDTH-1: 0] sm_tupsb,
    `endif
    output wire                 [3: 0] sm_tstrb,
    output wire                 [3: 0] sm_tkeep,
    output wire                        sm_tlast,
    output wire                        low__pri_irq,
    output wire                        High_pri_req,
    output wire                [23: 0] la_data_o,
    input  wire                        axi_clk,
    input  wire                        axis_clk,
    input  wire                        axi_reset_n,
    input  wire                        axis_rst_n,
    input  wire                        user_clock2,
    input  wire                        uck2_rst_n
  );

  //[TODO] does tlast from FPGA to SOC need send to UP? or use upsb as UP's tlast?
  `ifdef USER_PROJECT_SIDEBAND_SUPPORT
    localparam	FIFO_WIDTH = (pUSER_PROJECT_SIDEBAND_WIDTH + 4 + 4 + 1 + pDATA_WIDTH);		//upsb, tstrb, tkeep, tlast, tdata  
  `else
    localparam	FIFO_WIDTH = (4 + 4 + 1 + pDATA_WIDTH);		//tstrb, tkeep, tlast, tdata
  `endif


  wire awvalid_in;
  wire wvalid_in;

  reg [31:0] RegisterData;

  //write addr channel
  assign 	awvalid_in	= awvalid; 
  wire awready_out;
  assign awready = awready_out;

  //write data channel
  assign 	wvalid_in	= wvalid;
  wire wready_out;
  assign wready = wready_out;

  // if both awvalid_in=1 and wvalid_in=1 then output awready_out = 1 and wready_out = 1
  assign awready_out = (awvalid_in && wvalid_in) ? 1 : 0;
  assign wready_out = (awvalid_in && wvalid_in) ? 1 : 0;

  assign arready = 1;

  assign rvalid = 1;
  assign rdata =  RegisterData;

  //write register
  always @(posedge axi_clk or negedge axi_reset_n)  begin
    if ( !axi_reset_n ) begin
      RegisterData <= 32'haa55aa55;
    end
    else begin
      if ( awvalid_in && wvalid_in ) begin		//when awvalid_in=1 and wvalid_in=1 means awready_out=1 and wready_out=1
        if (awaddr[11:2] == 10'h000 ) begin //offset 0
          if ( wstrb[0] == 1) RegisterData[7:0] <= wdata[7:0];
          if ( wstrb[1] == 1) RegisterData[15:8] <= wdata[15:8];
          if ( wstrb[2] == 1) RegisterData[23:16] <= wdata[23:16];
          if ( wstrb[3] == 1) RegisterData[31:24] <= wdata[31:24];  
        end
        else begin
          RegisterData <= RegisterData;
        end
      end
    end
  end

  reg [2:0] r_ptr;
  reg [2:0] w_ptr;
  reg [(FIFO_WIDTH-1) : 0] fifo[7:0];

  wire full;
  wire empty;

  assign empty = (r_ptr == w_ptr);
  assign full = (r_ptr == (w_ptr+1) );

  assign ss_tready = !full;

  //for push to fifo
  always @(posedge axis_clk or negedge axis_rst_n)  begin
    if ( !axis_rst_n ) begin
      w_ptr <= 0;
    end
    else begin
    if ( ss_tready && ss_tvalid) begin
      `ifdef USER_PROJECT_SIDEBAND_SUPPORT
        fifo[w_ptr] <= {ss_tupsb, ss_tstrb, ss_tkeep, ss_tlast, ss_tdata}; 
      `else
        fifo[w_ptr] <= {ss_tstrb, ss_tkeep, ss_tlast, ss_tdata}; 
      `endif
      w_ptr <= w_ptr + 1;
    end
    end
  end  

  //for pop from fifo

  `ifdef USER_PROJECT_SIDEBAND_SUPPORT
    assign {sm_tupsb, sm_tstrb, sm_tkeep, sm_tlast, sm_tdata} = fifo[r_ptr];
  `else
    assign {sm_tstrb, sm_tkeep, sm_tlast, sm_tdata} = fifo[r_ptr];
  `endif

  assign sm_tvalid = !empty;
  always @(posedge axis_clk or negedge axis_rst_n)  begin
    if ( !axis_rst_n ) begin
      r_ptr <= 0;
    end
    else begin
    if ( sm_tready && sm_tvalid) begin
      r_ptr <= r_ptr + 1;
    end
    end
  end  

  assign sm_tid = 3'b000;		//[TODO] remove tid in user project.
  assign low__pri_irq  = 1'b0;
  assign High_pri_req  = 1'b0;
  assign la_data_o     = 24'b0;


  endmodule // USER_PRJ0
  */
`endif

