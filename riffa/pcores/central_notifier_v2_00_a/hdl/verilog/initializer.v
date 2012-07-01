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
// Filename:			initializer.v
// Version:				1.00.a
// Verilog Standard:	Verilog-2001
// Description:			Initializes the PCIe Bridge and other related components.
// History:				@mattj: Initial pre-release. Version 0.9.
//-----------------------------------------------------------------------------

module initializer
(
	SYS_CLK,
	SYS_RST,
	EXT_INIT_START,
	EXT_INIT_DONE,
	REG_INIT,
	REG_INIT_DONE,
	REG_INIT_DATA,
	REG_INIT_NUM,
	SIMPBUS_INIT_ADDR,
	SIMPBUS_INIT_WDATA,
	SIMPBUS_INIT_RDATA,
	SIMPBUS_INIT_BE,
	SIMPBUS_INIT_RNW,
	SIMPBUS_INIT_START,
	SIMPBUS_INIT_DONE,
	SIMPBUS_INIT_ERR,
	SIMPBUS_PROXY_ADDR,
	SIMPBUS_PROXY_WDATA,
	SIMPBUS_PROXY_RDATA,
	SIMPBUS_PROXY_BE,
	SIMPBUS_PROXY_RNW,
	SIMPBUS_PROXY_START,
	SIMPBUS_PROXY_DONE,
	SIMPBUS_PROXY_ERR
);

parameter C_SIMPBUS_AWIDTH = 32;
parameter C_SIMPBUS_DWIDTH = 32;
parameter C_INIT_BUS = 1;
parameter C_PCIE_BASE_ADDR = 'h0;
parameter C_PCIE_IPIF2PCI_LEN = 1024;
parameter C_PCIE_BIER_OFF = 'h0044;
parameter C_PCIE_BCR_OFF = 'h0030;
parameter C_PCIE_IPIF2PCI_OFF = 'h04;
parameter C_PCIE_IPIF2PCI_INC = 'h08;
parameter C_PCIE_BIER_VAL = 'h7DF04000;
parameter C_PCIE_BCR_VAL = 'h107;

input								SYS_CLK;
input								SYS_RST;
output								EXT_INIT_START;
input								EXT_INIT_DONE;
input								REG_INIT;
output								REG_INIT_DONE;
input	[C_SIMPBUS_DWIDTH-1:0]		REG_INIT_DATA;
input	[2:0]						REG_INIT_NUM;
input	[C_SIMPBUS_AWIDTH-1:0]		SIMPBUS_INIT_ADDR;
input	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_INIT_WDATA;
output	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_INIT_RDATA;
input	[C_SIMPBUS_DWIDTH/8-1:0]	SIMPBUS_INIT_BE;
input								SIMPBUS_INIT_RNW;
input								SIMPBUS_INIT_START;
output								SIMPBUS_INIT_DONE;
output								SIMPBUS_INIT_ERR;
output	[C_SIMPBUS_AWIDTH-1:0]		SIMPBUS_PROXY_ADDR;
output	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_PROXY_WDATA;
input	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_PROXY_RDATA;
output	[C_SIMPBUS_DWIDTH/8-1:0]	SIMPBUS_PROXY_BE;
output								SIMPBUS_PROXY_RNW;
output								SIMPBUS_PROXY_START;
input								SIMPBUS_PROXY_DONE;
input								SIMPBUS_PROXY_ERR;


reg		[2:0]			rState=0;
reg		[2:0]			rCompState=0;
reg						rProxyRNW=0;
reg		[31:0]			rProxyAddr=0;
reg		[31:0]			rProxyData=0;
reg						rRegInitDone=0;
wire					wExternalInit;

assign wExternalInit = (rState == 2 || rState == 3);
assign EXT_INIT_START = wExternalInit;
assign SIMPBUS_PROXY_START = (wExternalInit ? SIMPBUS_INIT_START : rState == 5);
assign SIMPBUS_PROXY_RNW = (wExternalInit ? SIMPBUS_INIT_RNW : rProxyRNW);
assign SIMPBUS_PROXY_BE = (wExternalInit ? SIMPBUS_INIT_BE : 4'b1111);
assign SIMPBUS_PROXY_ADDR = (wExternalInit ? SIMPBUS_INIT_ADDR : rProxyAddr);
assign SIMPBUS_PROXY_WDATA = (wExternalInit ? SIMPBUS_INIT_WDATA : rProxyData);
assign SIMPBUS_INIT_RDATA = (wExternalInit ? SIMPBUS_PROXY_RDATA : 0);
assign SIMPBUS_INIT_DONE = (wExternalInit ? SIMPBUS_PROXY_DONE : 0);
assign SIMPBUS_INIT_ERR = (wExternalInit ? SIMPBUS_PROXY_ERR : 0);
assign REG_INIT_DONE = rRegInitDone;

// State machine to handle initialization.
always @(posedge SYS_CLK or posedge SYS_RST) begin
	if (SYS_RST) begin
		rState <= 0;
		rCompState <= 0;
		rProxyRNW <= 0;
		rProxyAddr <= 0;
		rProxyData <= 0;
		rRegInitDone <= 0;
	end
	else begin		
		case (rState) 
			3'd0: begin // Reset PCIe bridge interrupt enable register.
				rProxyRNW <= 0;
				rProxyAddr <= C_PCIE_BASE_ADDR + C_PCIE_BIER_OFF;
				rProxyData <= C_PCIE_BIER_VAL;
				rCompState <= 1;
				rState <= 5;
			end
			3'd1: begin // Reset PCIe bridge control register.
				rProxyRNW <= 0;
				rProxyAddr <= C_PCIE_BASE_ADDR + C_PCIE_BCR_OFF;
				rProxyData <= C_PCIE_BCR_VAL;
				rCompState <= (C_INIT_BUS ? 2 : 4);
				rState <= 5;
			end
			3'd2: begin // Start the external initialization.
				rState <= 3;
			end
			3'd3: begin // Wait for the external initialization to complete.
				rState <= (EXT_INIT_DONE ? 4 : 3);
			end
			3'd4: begin // Wait for register init values.
				if (REG_INIT) begin
					rRegInitDone <= 1;
					// Currently only care about IPIF BAR HW addresses (nums: 0-5). 
					if (REG_INIT_NUM >= 0 && REG_INIT_NUM <= 5) begin
						// Update the PCIe bridge.
						rProxyRNW <= 0;
						rProxyAddr <= C_PCIE_BASE_ADDR + C_PCIE_IPIF2PCI_OFF + 
							(REG_INIT_NUM*C_PCIE_IPIF2PCI_INC);
						// Mask off lower bits.
						rProxyData <= (REG_INIT_DATA & ~(C_PCIE_IPIF2PCI_LEN - 1));
						rCompState <= 4;
						rState <= 5;
					end
				end
				else begin
					rRegInitDone <= 0;
				end
			end
			3'd5: begin // Send request (read or write).
				rRegInitDone <= 0;
				rState <= 6;
			end
			3'd6: begin // Wait for done signal.
				if (SIMPBUS_PROXY_DONE) begin
					rProxyData <= SIMPBUS_PROXY_RDATA;
					rState <= 7;
				end
			end
			3'd7: begin // Wait a cycle before continuing.
				rState <= rCompState;
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
 
chipscope_ila_128 a0(.CLK(SYS_CLK), .CONTROL(wControl0), .TRIG0({17'd0, SIMPBUS_PROXY_ERR, SIMPBUS_PROXY_DONE, SIMPBUS_PROXY_START, wExternalInit, rRegInitDone, REG_INIT_NUM, REG_INIT_DATA, REG_INIT, rProxyData, rProxyAddr, rCompState, rState}));
chipscope_ila_1 a1(.CLK(SYS_CLK), .CONTROL(wControl1), .TRIG0(1'd0));
chipscope_ila_1 a2(.CLK(SYS_CLK), .CONTROL(wControl2), .TRIG0(1'd0));
chipscope_ila_1 a3(.CLK(SYS_CLK), .CONTROL(wControl3), .TRIG0(1'd0));
chipscope_ila_1 a4(.CLK(SYS_CLK), .CONTROL(wControl4), .TRIG0(1'd0));
chipscope_ila_1 a5(.CLK(SYS_CLK), .CONTROL(wControl5), .TRIG0(1'd0));
chipscope_ila_1 a6(.CLK(SYS_CLK), .CONTROL(wControl6), .TRIG0(1'd0));
chipscope_ila_1 a7(.CLK(SYS_CLK), .CONTROL(wControl7), .TRIG0(1'd0));
*/

endmodule
