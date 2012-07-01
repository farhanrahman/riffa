//----------------------------------------------------------------------------
//	Copyright (c) 2012, Matthew Jacobsen
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without
//	modification, are permitted provided that the following conditions are met: 
//	
//	1. Redistributions of source code must retain the above copyright notice, this
//	   list of conditions and the following disclaimer. 
//	2. Redistributions in binary form must reproduce the above copyright notice,
//	   this list of conditions and the following disclaimer in the documentation
//	   and/or other materials provided with the distribution. 
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//	The views and conclusions contained in the software and documentation are those
//	of the authors and should not be interpreted as representing official policies, 
//	either expressed or implied, of the FreeBSD Project.
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
// Filename:			plb_master_driver.v
// Version:				1.00.a
// Verilog Standard:	Verilog-2001
// Description:			Implements logic to connect PLB v46 bus signals to a 
//						SIMPBUS set of signals.
// History:				@mattj: Initial pre-release. Version 0.9.
//-----------------------------------------------------------------------------

module plb_master_driver
(
	Bus2IP_Clk,                     // Bus to IP clock
	Bus2IP_Reset,                   // Bus to IP reset	
	IP2Bus_MstRd_Req,               // IP to Bus master read request
	IP2Bus_MstWr_Req,               // IP to Bus master write request
	IP2Bus_Mst_Addr,                // IP to Bus master address bus
	IP2Bus_Mst_BE,                  // IP to Bus master byte enables
	IP2Bus_Mst_Lock,                // IP to Bus master lock
	IP2Bus_Mst_Reset,               // IP to Bus master reset
	Bus2IP_Mst_CmdAck,              // Bus to IP master command acknowledgement
	Bus2IP_Mst_Cmplt,               // Bus to IP master transfer completion
	Bus2IP_Mst_Error,               // Bus to IP master error response
	Bus2IP_Mst_Rearbitrate,         // Bus to IP master re-arbitrate
	Bus2IP_Mst_Cmd_Timeout,         // Bus to IP master command timeout
	Bus2IP_MstRd_d,                 // Bus to IP master read data bus
	Bus2IP_MstRd_src_rdy_n,         // Bus to IP master read source ready
	IP2Bus_MstWr_d,                 // IP to Bus master write data bus
	Bus2IP_MstWr_dst_rdy_n,      	// Bus to IP master write destination ready
	ADDR,							// PLB address for this transaction
	WRITE_DATA,						// Data to write to the PLB address
	READ_DATA,						// Data read from the PLB address (valid with DONE is high)
	BE,								// Data byte enables
	RNW,							// Read not write signal to indicate type of transaction
	START,							// Starts the transaction. Must be a pulse.
	DONE,							// PLB transaction complete signal
	ERR								// PLB transaction error signal
);

parameter C_MST_AWIDTH = 32;
parameter C_MST_DWIDTH = 32;
parameter C_NUM_RETRIES = 3'd8;

// -- Bus protocol ports, do not add to or delete
input							Bus2IP_Clk;
input							Bus2IP_Reset;
output							IP2Bus_MstRd_Req;
output							IP2Bus_MstWr_Req;
output	[0:C_MST_AWIDTH-1]		IP2Bus_Mst_Addr;
output	[0:C_MST_DWIDTH/8-1]	IP2Bus_Mst_BE;
output							IP2Bus_Mst_Lock;
output							IP2Bus_Mst_Reset;
input							Bus2IP_Mst_CmdAck;
input							Bus2IP_Mst_Cmplt;
input							Bus2IP_Mst_Error;
input							Bus2IP_Mst_Rearbitrate;
input							Bus2IP_Mst_Cmd_Timeout;
input	[0:C_MST_DWIDTH-1]		Bus2IP_MstRd_d;
input							Bus2IP_MstRd_src_rdy_n;
output	[0:C_MST_DWIDTH-1]		IP2Bus_MstWr_d;
input							Bus2IP_MstWr_dst_rdy_n;
input	[0:C_MST_AWIDTH-1]		ADDR;
input	[0:C_MST_DWIDTH-1]		WRITE_DATA;
output	[0:C_MST_DWIDTH-1]		READ_DATA;
input	[0:C_MST_DWIDTH/8-1]	BE;
input							RNW;
input							START;
output							DONE;
output							ERR;

reg		[0:2]					rState=0;
reg		[0:2]					rNumRetries=0;
reg								rBusReset=0;
reg								rBusRReq=0;
reg								rBusWReq=0;
reg		[0:C_MST_DWIDTH-1]		rBusData=0;
reg								rDone=0;
reg								rError=0;

assign IP2Bus_MstRd_Req = rBusRReq;
assign IP2Bus_MstWr_Req = rBusWReq;
assign IP2Bus_Mst_Addr = ADDR;
assign IP2Bus_MstWr_d = WRITE_DATA;
assign IP2Bus_Mst_BE = BE;
assign IP2Bus_Mst_Reset = rBusReset;
assign IP2Bus_Mst_Lock = 0;
assign READ_DATA = rBusData;
assign DONE = rDone;
assign ERR = rError;

always @(posedge Bus2IP_Clk or posedge Bus2IP_Reset) begin
	if (Bus2IP_Reset) begin
		rState <= 0;
		rBusReset <= 0;
		rBusWReq <= 0;
		rBusRReq <= 0;
		rBusData <= 0;
		rDone <= 0;
		rError <= 0;
		rNumRetries <= 0;
	end
	else begin		
		case (rState)
			3'd0: begin // Waiting for a new requet.
				if (START) begin
					rState <= 1;
				end
			end
			3'd1: begin // Send request (read or write) to DMA controller.
				rBusRReq <= RNW;
				rBusWReq <= !RNW;
				rState <= 2;
			end
			3'd2: begin // Wait for command ack.
				if (Bus2IP_Mst_Error || Bus2IP_Mst_Rearbitrate || Bus2IP_Mst_Cmd_Timeout) begin
					rBusRReq <= 0;
					rBusWReq <= 0;
					rState <= 4;
				end
				else if (Bus2IP_Mst_Cmplt) begin
					rBusRReq <= 0;
					rBusWReq <= 0;
					rBusData <= Bus2IP_MstRd_d;
					rDone <= 1;
					rState <= 6;
				end
				else if (Bus2IP_Mst_CmdAck) begin
					rBusRReq <= 0;
					rBusWReq <= 0;
					rState <= 3;
				end
			end
			3'd3: begin // Wait for completion.
				if (Bus2IP_Mst_Error || Bus2IP_Mst_Rearbitrate || Bus2IP_Mst_Cmd_Timeout) begin
					rState <= 4;
				end
				else if (Bus2IP_Mst_Cmplt) begin
					rBusData <= Bus2IP_MstRd_d;
					rDone <= 1;
					rState <= 6;
				end
			end
			3'd4: begin // Reset PLB error & re-send current data.
				rBusReset <= 1;
				rState <= 5;
			end
			3'd5: begin // Restart up to C_NUM_RETRIES.
				rBusReset <= 0;
				if (rNumRetries == C_NUM_RETRIES) begin
					rError <= 1;
					rDone <= 1;
					rState <= 6;
				end
				else begin
					rNumRetries <= rNumRetries + 1;
					rState <= 1;
				end
			end
			3'd6: begin // Reset.
				rNumRetries <= 0;
				rDone <= 0;
				rError <= 0;
				rState <= 7;
			end
			3'd7: begin // Wait a cycle before continuing.
				rState <= 0;
			end
		endcase
	end
end

/*
wire [35:0] wControl0, wControl1, wControl2, wControl3, wControl4, wControl5, wControl6, wControl7;

chipscope_icon cs_icon(
	.CONTROL0(wControl0),
	.CONTROL1(wControl1),
	.CONTROL2(wControl2),
	.CONTROL3(wControl3),
	.CONTROL4(wControl4),
	.CONTROL5(wControl5),
	.CONTROL6(wControl6),
	.CONTROL7(wControl7)
);
 
chipscope_ila_1 a0(.CLK(Bus2IP_Clk), .CONTROL(wControl0), .TRIG0(1'd0));
chipscope_ila_128 a1(.CLK(Bus2IP_Clk), .CONTROL(wControl1), .TRIG0({32'd0, WRITE_DATA, ADDR, 9'd0, PLB_MWrErr, PLB_MRdErr, PLB_MBusy, PLB_MTimeout, PLB_MRearbitrate, Bus2IP_MstWr_dst_rdy_n, Bus2IP_Mst_Cmd_Timeout, Bus2IP_Mst_Rearbitrate, Bus2IP_Mst_Error, Bus2IP_Mst_Cmplt, Bus2IP_Mst_CmdAck, Bus2IP_Reset, rError, rDone, rBusWReq, rBusRReq, rBusReset, rNumRetries, rState}));
chipscope_ila_1 a2(.CLK(Bus2IP_Clk), .CONTROL(wControl2), .TRIG0(1'd0));
chipscope_ila_1 a3(.CLK(Bus2IP_Clk), .CONTROL(wControl3), .TRIG0(1'd0));
chipscope_ila_1 a4(.CLK(Bus2IP_Clk), .CONTROL(wControl4), .TRIG0(1'd0));
chipscope_ila_1 a5(.CLK(Bus2IP_Clk), .CONTROL(wControl5), .TRIG0(1'd0));
chipscope_ila_1 a6(.CLK(Bus2IP_Clk), .CONTROL(wControl6), .TRIG0(1'd0));
chipscope_ila_1 a7(.CLK(Bus2IP_Clk), .CONTROL(wControl7), .TRIG0(1'd0));
*/

endmodule
