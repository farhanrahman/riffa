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
	output								INTERRUPT,
	output								INTERRUPT_ERR,
	input								INTERRUPT_ACK,
	input								DOORBELL,
	input								DOORBELL_ERR,
	input	[C_SIMPBUS_AWIDTH-1:0]		DOORBELL_LEN,
	input	[31:0]						DOORBELL_ARG,
	output								DMA_REQ,
	input								DMA_REQ_ACK,
	output	[C_SIMPBUS_AWIDTH-1:0]		DMA_SRC,
	output	[C_SIMPBUS_AWIDTH-1:0]		DMA_DST,
	output	[C_SIMPBUS_AWIDTH-1:0]		DMA_LEN,
	output								DMA_SIG,
	input								DMA_DONE,
	input								DMA_ERR,
	output								BUF_REQ,
	input								BUF_REQ_ACK,
	input	[C_SIMPBUS_AWIDTH-1:0]		BUF_REQ_ADDR,
	input	[4:0]						BUF_REQ_SIZE,
	input								BUF_REQ_RDY,
	input								BUF_REQ_ERR,
	input								BUF_REQD,
	output	[C_SIMPBUS_AWIDTH-1:0]		BUF_REQD_ADDR,
	output	[4:0]						BUF_REQD_SIZE,
	output								BUF_REQD_RDY,
	output								BUF_REQD_ERR,
	output								MEM_EN,
	output	[3:0]						MEM_WEN,
	output	[31:0]						MEM_DATA_OUT,
	input	[31:0]						MEM_DATA_IN,
	output	[31:0]						MEM_ADDR
);

reg		[2:0]						rState=0;
reg		[31:0]						rAddr=0;
reg		[31:0]						rData=0;
reg		[31:0]						rDst=0;
reg									rWen=0;
reg									rDidFirstDma=0;


assign MEM_EN = 1;
assign MEM_WEN = (rWen == 1 ? 4'b1111 : 0);
assign MEM_DATA_OUT = (rData[7:0]<<24 | rData[15:8]<<16 | rData[23:16]<<8 | rData[31:24]);
assign MEM_ADDR = rAddr;

assign INTERRUPT = (rState == 7);
assign INTERRUPT_ERR = 0;

assign DMA_REQ = (rState == 5);
assign DMA_SRC = C_BRAM_ADDR;
assign DMA_DST = rDst;
assign DMA_LEN = C_BRAM_SIZE;
assign DMA_SIG = 1;

assign BUF_REQ = (rState == 3);

assign BUF_REQD_ADDR = C_BRAM_ADDR;
assign BUF_REQD_SIZE = 14;
assign BUF_REQD_RDY = 1;
assign BUF_REQD_ERR = 0;

always @(posedge SYS_CLK or posedge SYS_RST) begin
	if (SYS_RST) begin
		rState <= 0;
		rDst <= 0;
		rAddr <= 0;
		rData <= 0;
		rWen <= 0;
		rDidFirstDma <= 0;
	end
	else begin
		case (rState)
			3'd0: begin // Wait for request.
				rDidFirstDma <= 0;
				if (DOORBELL) begin
					// Save DOORBELL_LEN in BRAM position 0
					rData <= DOORBELL_LEN;
					rAddr <= 0*4;
					rWen <= 1;
					rState <= (DOORBELL_ERR ? 0 : 1);
				end
				else begin
					rAddr <= 0;
					rData <= 0;
					rWen <= 0;
					rState <= 0;
				end
			end
			3'd1: begin // Save ARG0 in BRAM position 1.
				rData <= DOORBELL_ARG;
				rAddr <= 1*4;
				rWen <= 1;
				rState <= 2;
			end
			3'd2: begin // Save ARG1 in BRAM position 2.
				rData <= DOORBELL_ARG;
				rAddr <= 2*4;
				rWen <= 1;
				rState <= 3;
			end
			3'd3: begin // Request PC buffer.
				rWen <= 0;
				rState <= (BUF_REQ_ACK ? 4 : 3);
			end
			3'd4: begin // Get PC buffer (assumes it's at least C_BRAM_SIZE, it's usually configured to be 1MB).
				if (BUF_REQ_RDY) begin
					rDst <= BUF_REQ_ADDR;
					rState <= (BUF_REQ_ERR ? 0 : 5);
				end
			end
			3'd5: begin // DMA data to PC.
				rState <= (DMA_REQ_ACK ? 6 : 5);
			end
			3'd6: begin // Wait for DMA to complete.
				if (DMA_DONE) begin
					rDidFirstDma <= 1;
					rState <= (DMA_ERR ? 0 : (rDidFirstDma ? 7 : 3));
				end
			end
			3'd7: begin // Signal an interrupt (for done).
				if (INTERRUPT_ACK) begin
					rState <= 0;
				end
			end
			default: begin
				rState <= 0;
			end
		endcase
	end
end

endmodule
