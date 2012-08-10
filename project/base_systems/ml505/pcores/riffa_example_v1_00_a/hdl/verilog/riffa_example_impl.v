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

module riffa_example_impl (
	SYS_CLK,
	SYS_RST,
	INTERRUPT,
	INTERRUPT_ERR,
	INTERRUPT_ACK,
	DOORBELL,
	DOORBELL_ERR,
	DOORBELL_LEN,
	DOORBELL_ARG,
	DMA_REQ,
	DMA_REQ_ACK,
	DMA_SRC,
	DMA_DST,
	DMA_LEN,
	DMA_SIG,
	DMA_DONE,
	DMA_ERR,
	BUF_REQ,
	BUF_REQ_ACK,
	BUF_REQ_ADDR,
	BUF_REQ_SIZE,
	BUF_REQ_RDY,
	BUF_REQ_ERR,
	BUF_REQD,
	BUF_REQD_ADDR,
	BUF_REQD_SIZE,
	BUF_REQD_RDY,
	BUF_REQD_ERR,
	MEM_EN,
	MEM_WEN,
	MEM_DATA_OUT,
	MEM_DATA_IN,
	MEM_ADDR
);

parameter C_BRAM_ADDR = 'h00000000;
parameter C_BRAM_SIZE = 'h8000;
parameter C_BRAM_SIZE_LOG2 = 15;
parameter C_SIMPBUS_AWIDTH = 32;

input	 				SYS_CLK;
input					SYS_RST;

output					INTERRUPT;
output					INTERRUPT_ERR;
input					INTERRUPT_ACK;
input					DOORBELL;
input					DOORBELL_ERR;
input	[C_SIMPBUS_AWIDTH-1:0]		DOORBELL_LEN;
input	[31:0]				DOORBELL_ARG;


output					DMA_REQ;
input					DMA_REQ_ACK;
output	[C_SIMPBUS_AWIDTH-1:0]		DMA_SRC;
output	[C_SIMPBUS_AWIDTH-1:0]		DMA_DST;
output	[C_SIMPBUS_AWIDTH-1:0]		DMA_LEN;
output					DMA_SIG;
input					DMA_DONE;
input					DMA_ERR;
output					BUF_REQ;
input					BUF_REQ_ACK;
input	[C_SIMPBUS_AWIDTH-1:0]		BUF_REQ_ADDR;
input	[4:0]				BUF_REQ_SIZE;
input					BUF_REQ_RDY;
input					BUF_REQ_ERR;
input					BUF_REQD;
output	[C_SIMPBUS_AWIDTH-1:0]		BUF_REQD_ADDR;
output	[4:0]				BUF_REQD_SIZE;
output					BUF_REQD_RDY;
output					BUF_REQD_ERR;
output					MEM_EN;
output	[3:0]				MEM_WEN;
output	[31:0]				MEM_DATA_OUT;
input	[31:0]				MEM_DATA_IN;
output	[31:0]				MEM_ADDR;


reg	[3:0]				rState=0;
reg	[31:0]				rAddr=0;
reg	[31:0]				rData=0;
reg					rWen=0;
reg	[31:0]				rSrc=0;
reg	[31:0]				rDst=0;
reg	[31:0]				rLen=0;

wire	[31:0]				wBufSize;


assign MEM_EN = 1;
assign MEM_WEN = (rWen == 1 ? 4'b1111 : 0);
assign MEM_DATA_OUT = rData;
assign MEM_ADDR = rAddr;

assign INTERRUPT = (rState == 9 || rState == 10);
assign INTERRUPT_ERR = (rState == 10);

assign DMA_REQ = (rState == 6);
assign DMA_SRC = C_BRAM_ADDR + rSrc;
assign DMA_DST = rDst;
assign DMA_LEN = rLen;
assign DMA_SIG = 1;

assign BUF_REQ = (rState == 4);
assign wBufSize = (1<<BUF_REQ_SIZE);

assign BUF_REQD_ADDR = C_BRAM_ADDR;
assign BUF_REQD_SIZE = C_BRAM_SIZE_LOG2;
assign BUF_REQD_RDY = 1;
assign BUF_REQD_ERR = 0;



always @(posedge SYS_CLK or posedge SYS_RST) begin
	if (SYS_RST) begin
		rState <= 0;
		rSrc <= 0;
		rDst <= 0;
		rLen <= 0;
		rAddr <= 0;
		rData <= 0;
		rWen <= 0;
	end
	else begin
		case (rState)
			4'd0: begin // Wait for doorbell (start request).
				if (DOORBELL /*&& DOORBELL_LEN == 0*/) begin
					rSrc <= 0;
					rState <= (DOORBELL_ERR ? 0 : 1);
				end
			end
			4'd1: begin // Save ARG0 to BRAM.
				rWen <= 0;
				rData <= DOORBELL_ARG;
				rAddr <= 0;
				rState <= 2;
			end
			4'd2: begin // Save ARG1 to BRAM.
				rWen <= 0;
				rData <= DOORBELL_ARG;
				rAddr <= 4;
				rState <= 3;
			end
			4'd3: begin // Do processing here if you like.
				// In this case, we just wait a cycle and then
				// "return" the results (which are just the 
				// BRAM contents with args written to it).
				rWen <= 0;
				rState <= 4;
			end
			4'd4: begin // Request buffer.
				if (BUF_REQ_ACK) begin
					/*Go to the next state only if 
					 *Acknowledgement received from PC*/
					rState <= 5;
				end
			end
			4'd5: begin // Get buffer.
				if (BUF_REQ_RDY) begin
					rDst <= BUF_REQ_ADDR;
					rLen <= (C_BRAM_SIZE-rSrc < wBufSize ? C_BRAM_SIZE-rSrc : wBufSize); 
					rState <= (BUF_REQ_ERR ? 10 : 6);
				end
			end
			4'd6: begin // Request DMA data to PC.
				if (DMA_REQ_ACK) begin
					rSrc <= rSrc + rLen;
					rState <= 8; 
				end
			end
			4'd8: begin // Wait for DMA to complete.
				if (DMA_DONE) begin
					// Repeat if necessary, until all the data is transferred.
					rState <= (DMA_ERR ? 10 : (C_BRAM_SIZE > rSrc ? 4 : 9));
				end
			end
			4'd9: begin // Signal an interrupt (signal done).
				rState <= (INTERRUPT_ACK ? 0 : 9);
			end
			4'd10: begin // Signal an interrupt (signal error).
				rState <= (INTERRUPT_ACK ? 0 : 10);
			end
			default: begin
				rState <= 0;
			end
		endcase
	end
end

endmodule
