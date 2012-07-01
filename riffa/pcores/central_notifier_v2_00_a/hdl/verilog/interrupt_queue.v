`timescale 1ns / 1ps
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
// Filename:			interrupt_queue.v
// Version:				1.00.a
// Verilog Standard:	Verilog-2001
// Description:			Handles signaling the interrupts on the PCIe endpoint.
// History:				@mattj: Initial pre-release. Version 0.9.
//-----------------------------------------------------------------------------

module interrupt_queue (
	CLK,
	RST,
	INTR_IN,		// Interrupt trigger requested
	INTR_CLEAR,		// Interrupt acknowledged signal
	INTR_OUT		// Interrupt line out to the PCIe endpoint's MSI trigger
);
   
// Master clock input
input				CLK;
input 				RST;
   
// Interrupt intput/output
input				INTR_IN;					
input				INTR_CLEAR;			
output 				INTR_OUT;		
 
reg		[2:0]		rState=0;

assign INTR_OUT = (rState >= 3);

always @(posedge CLK or posedge RST) begin
	if (RST) begin
		rState <= 0;
	end
	else begin
		case (rState)
		3'd0: begin // Wait for an interrupt request.
			rState <= (INTR_IN ? 3 : 0);
		end
		3'd1: begin // Wait for the cleared signal.
			rState <= (INTR_CLEAR ? 2 : 1);
		end
		3'd2: begin // Wait a cycle before continuing.
			rState <= 0;
		end
		3'd3: begin // Signal INTR_OUT high.
			rState <= 4;
		end
		3'd4: begin // Signal INTR_OUT high.
			rState <= 5;
		end
		3'd5: begin // Signal INTR_OUT high.
			rState <= 6;
		end
		3'd6: begin // Signal INTR_OUT high.
			rState <= 7;
		end
		3'd7: begin // Signal INTR_OUT high.
			rState <= 1;
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
 
chipscope_ila_128 a0(.CLK(Bus2IP_Clk), .CONTROL(wControl0), .TRIG0({29'd0, rState, INTR_OUT, INTR_CLEAR, rIntrReg, rIntrReq, INTR_IN}));
chipscope_ila_1 a1(.CLK(Bus2IP_Clk), .CONTROL(wControl1), .TRIG0(1'd0));
chipscope_ila_1 a2(.CLK(Bus2IP_Clk), .CONTROL(wControl2), .TRIG0(1'd0));
chipscope_ila_1 a3(.CLK(Bus2IP_Clk), .CONTROL(wControl3), .TRIG0(1'd0));
chipscope_ila_1 a4(.CLK(Bus2IP_Clk), .CONTROL(wControl4), .TRIG0(1'd0));
chipscope_ila_1 a5(.CLK(Bus2IP_Clk), .CONTROL(wControl5), .TRIG0(1'd0));
chipscope_ila_1 a6(.CLK(Bus2IP_Clk), .CONTROL(wControl6), .TRIG0(1'd0));
chipscope_ila_1 a7(.CLK(Bus2IP_Clk), .CONTROL(wControl7), .TRIG0(1'd0));
*/

endmodule
