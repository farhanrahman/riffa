//`timescale 1ns / 1ps
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
// Filename:			riffa_example_impl.v
// Version:				1.00.a
// Verilog Standard:	Verilog-2001
// Description:			Implements logic to receive and send transfers from/to the 
//						host PC.
// History:				@mattj: Initial pre-release. Version 0.9.
//-----------------------------------------------------------------------------

module riffa_example_impl #(
	parameter C_SIMPBUS_AWIDTH = 32,
	parameter C_BRAM_ADDR = 'h00000000,
	parameter C_BRAM_SIZE = 'h4000
)
(
	input	 							SYS_CLK,
	input								SYS_RST,
	output								DMA_REQ,
	input								DMA_REQ_ACK,
	output	[C_SIMPBUS_AWIDTH-1:0]					DMA_SRC,
	output	[C_SIMPBUS_AWIDTH-1:0]					DMA_DST,
	output	[C_SIMPBUS_AWIDTH-1:0]					DMA_LEN,
	output								DMA_SIG,
	input								DMA_DONE,
	input								DMA_ERR,
	output								BUF_REQ,
	input								BUF_REQ_ACK,
	input	[C_SIMPBUS_AWIDTH-1:0]					BUF_REQ_ADDR,
	input	[4:0]							BUF_REQ_SIZE,
	input								BUF_REQ_RDY,
	input								BUF_REQ_ERR,
	input								START,
	output								START_ACK,
	output								DONE,
	output								DONE_ERR
);

reg		[2:0]							rState=0;
reg		[31:0]							rDst=0;




assign DMA_REQ = (rState == 3);
assign DMA_SRC = C_BRAM_ADDR;
assign DMA_DST = rDst;
assign DMA_LEN = C_BRAM_SIZE;
assign DMA_SIG = 1;

assign START_ACK = (rState != 0);

assign BUF_REQ = (rState == 1);

assign DONE_ERR = (rState == 6);
assign DONE = (rState == 5);

always @(posedge SYS_CLK or posedge SYS_RST) begin
	if (SYS_RST) begin
		rState <= 0;
		rDst <= 0;
	end
	else begin
		case (rState)
			3'd0: begin // Wait for request.
				if (START) begin
					rState <= 1;
				end
			end
			3'd1: begin // Request PC buffer.
				rState <= (BUF_REQ_ACK ? 2 : 1);
			end
			3'd2: begin // Get PC buffer (assumes it's at least C_BRAM_SIZE, it's usually configured to be 1MB).
				if (BUF_REQ_RDY) begin
					rDst <= BUF_REQ_ADDR;
					rState <= (BUF_REQ_ERR ? 0 : 3);
				end
			end
			3'd3: begin // DMA data to PC.
				rState <= (DMA_REQ_ACK ? 4 : 3);
			end
			3'd4: begin // Wait for DMA to complete.
				if (DMA_DONE) begin
					rState <= (DMA_ERR ? 6 : 5);
				end
			end
			3'd5: begin //Flag DONE
				rState <= 0;
			end
			3'd6: begin //Flag Error
				rState <= 0;
			end
			default: begin
				rState <= 0;
			end
		endcase
	end
end

endmodule
