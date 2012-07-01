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
// Filename:			simpbus_slv_plbv46_adapter_impl.v
// Version:				1.00.a
// Verilog Standard:	Verilog-2001
// Description:			Implements logic to connect PLB v46 bus signals to a 
//						SIMPBUS set of signals.
// History:				@mattj: Initial pre-release. Version 0.9.
//-----------------------------------------------------------------------------

module simpbus_slv_plbv46_adapter_impl
(
	Bus2IP_Clk,                     // Bus to IP clock
	Bus2IP_Reset,                   // Bus to IP reset
	Bus2IP_Addr,                    // Bus to IP address bus
	Bus2IP_Data,                    // Bus to IP data bus
	Bus2IP_BE,                      // Bus to IP byte enables
	Bus2IP_RdCE,                    // Bus to IP read chip enable
	Bus2IP_WrCE,                    // Bus to IP write chip enable
	IP2Bus_Data,                    // IP to Bus data bus
	IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
	IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
	IP2Bus_Error,                   // IP to Bus error response
	SIMPBUS_ADDR,
	SIMPBUS_WDATA,
	SIMPBUS_RDATA,
	SIMPBUS_BE,
	SIMPBUS_RNW,
	SIMPBUS_START,
	SIMPBUS_DONE,
	SIMPBUS_ERR
);

parameter C_BUS_ADDR_OFF = 'h0;
parameter C_SLV_AWIDTH = 32;
parameter C_SLV_DWIDTH = 32;
parameter C_NUM_REG = 132;

input							Bus2IP_Clk;
input							Bus2IP_Reset;
input	[0:C_SLV_AWIDTH-1]		Bus2IP_Addr;
input	[0:C_SLV_DWIDTH-1]		Bus2IP_Data;
input	[0:(C_SLV_DWIDTH/8)-1]	Bus2IP_BE;
input	[0:C_NUM_REG-1]			Bus2IP_RdCE;
input	[0:C_NUM_REG-1]			Bus2IP_WrCE;
output	[0:C_SLV_DWIDTH-1]		IP2Bus_Data;
output							IP2Bus_RdAck;
output							IP2Bus_WrAck;
output							IP2Bus_Error;
output	[0:C_SLV_AWIDTH-1]		SIMPBUS_ADDR;
output	[0:C_SLV_DWIDTH-1]		SIMPBUS_WDATA;
input	[0:C_SLV_DWIDTH-1]		SIMPBUS_RDATA;
output	[0:(C_SLV_DWIDTH/8)-1]	SIMPBUS_BE;
output							SIMPBUS_RNW;
output							SIMPBUS_START;
input							SIMPBUS_DONE;
input							SIMPBUS_ERR;

reg		[1:0]					rState=0;

assign IP2Bus_Data = SIMPBUS_RDATA;
assign IP2Bus_WrAck = (SIMPBUS_DONE && Bus2IP_WrCE);
assign IP2Bus_RdAck = (SIMPBUS_DONE && Bus2IP_RdCE);
assign IP2Bus_Error = (SIMPBUS_DONE && SIMPBUS_ERR);

assign SIMPBUS_ADDR = Bus2IP_Addr - C_BUS_ADDR_OFF;
assign SIMPBUS_WDATA = Bus2IP_Data;
assign SIMPBUS_BE = Bus2IP_BE;
assign SIMPBUS_RNW = (Bus2IP_RdCE != 0);
assign SIMPBUS_START = (rState <= 1 && (Bus2IP_WrCE || Bus2IP_RdCE)); 

// State machine to control pulsing the start signal.
always @(posedge Bus2IP_Clk or posedge Bus2IP_Reset) begin
	if (Bus2IP_Reset) begin
		rState <= 0;
	end
	else begin
		case (rState)
			2'd0:
				rState <= (Bus2IP_WrCE || Bus2IP_RdCE ? 1 : 0);
			2'd1:
				rState <= (SIMPBUS_DONE ? 2 : 1);
			2'd2:
				rState <= 3;
			2'd3:
				rState <= 0;
		endcase
	end
end

endmodule
