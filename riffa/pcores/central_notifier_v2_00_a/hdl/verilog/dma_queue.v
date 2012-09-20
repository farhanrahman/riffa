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
// Filename:			dma_queue.v
// Version:				1.00.a
// Verilog Standard:	Verilog-2001
// Description:			Queues and sends DMA requests to the xps_central_dma core.
//						When DMA transfers are complete, notifies the reg_handler
//						of completion status. This module attempts to handle 
//						intermittent bus errors by retrying a fixed number of times.
// History:				@mattj: Initial pre-release. Version 0.9.
//-----------------------------------------------------------------------------

module dma_queue
(
	SYS_CLK,
	SYS_RST,
	INTR_DMA,
	SIMPBUS_ADDR,
	SIMPBUS_WDATA,
	SIMPBUS_RDATA,
	SIMPBUS_BE,
	SIMPBUS_RNW,
	SIMPBUS_START,
	SIMPBUS_DONE,
	SIMPBUS_ERR,
	SIMPBUS_PROXY_ADDR,
	SIMPBUS_PROXY_WDATA,
	SIMPBUS_PROXY_RDATA,
	SIMPBUS_PROXY_BE,
	SIMPBUS_PROXY_RNW,
	SIMPBUS_PROXY_START,
	SIMPBUS_PROXY_DONE,
	SIMPBUS_PROXY_ERR,
	FIFO_WEN,
	FIFO_DATA,
	CHANNEL,
	DONE,
	DONE_ACK,
	SIGNAL,
	LEN,
	ERR
);

parameter C_ARCH = "V5";
parameter C_SIMPBUS_AWIDTH = 32;
parameter C_SIMPBUS_DWIDTH = 32;
parameter C_DMA_BASE_ADDR = 32'h00000000;
parameter C_DMA_SRC_OFF = 'h8;
parameter C_DMA_DEST_OFF = 'hC;
parameter C_DMA_LEN_OFF = 'h10;
parameter C_DMA_RESET_OFF = 'h0;
parameter C_DMA_CONTROL_OFF = 'h4;
parameter C_DMA_INTR_EN_OFF = 'h30;
parameter C_DMA_INTR_STATUS_OFF = 'h2C;
parameter C_DMA_RESET_VAL = 32'hA;
parameter C_DMA_CONTROL_VAL = 32'hC0000000;
parameter C_DMA_INTR_EN_VAL = 32'h3;
parameter C_NUM_RETRIES = 3'd3;

input								SYS_CLK;
input								SYS_RST;
input								INTR_DMA;
output	[C_SIMPBUS_AWIDTH-1:0]		SIMPBUS_ADDR;
output	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_WDATA;
input	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_RDATA;
output	[C_SIMPBUS_DWIDTH/8-1:0]	SIMPBUS_BE;
output								SIMPBUS_RNW;
output								SIMPBUS_START;
input								SIMPBUS_DONE;
input								SIMPBUS_ERR;
input	[C_SIMPBUS_AWIDTH-1:0]		SIMPBUS_PROXY_ADDR;
input	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_PROXY_WDATA;
output	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_PROXY_RDATA;
input	[C_SIMPBUS_DWIDTH/8-1:0]	SIMPBUS_PROXY_BE;
input								SIMPBUS_PROXY_RNW;
input								SIMPBUS_PROXY_START;
output								SIMPBUS_PROXY_DONE;
output								SIMPBUS_PROXY_ERR;
input								FIFO_WEN;
input	[31:0]						FIFO_DATA;
output	[4:0]						CHANNEL;
output								DONE;
input								DONE_ACK;
output								SIGNAL;
output	[31:0]						LEN;
output								ERR;

reg		[3:0]		rState=0;
reg		[3:0]		rStateInit=0;
reg		[3:0]		rStateRead=0;
reg		[3:0]		rStateSend=0;
reg		[3:0]		rStateCheck=0;
reg		[3:0]		rStateProxy=0;
reg		[3:0]		rCompState=0;
reg		[2:0]		rNumRetries=0;
reg		[2:0]		rNumTxrRetries=0;
reg		[31:0]		rSrc=0;
reg		[31:0]		rDst=0;
reg		[31:0]		rLen=0;
reg		[5:0]		rReq=0; // { channel (4 bits) | core_initiated (1 bit) | signal (1 bit) }
reg		[31:0]		rBusAddr=0;
reg		[31:0]		rBusData=0;
reg					rBusRNW=0;
reg		[3:0]		rBusBE=4'b1111;
reg					rFifoREN=0;
reg					rDone=0;
reg					rErr=0;
reg					rProxyDone=0;
reg					rProxyErr=0;
wire	[31:0]		wFifoDataOut;
wire	[8:0]		wFifoDataCount;

assign SIMPBUS_ADDR = rBusAddr;
assign SIMPBUS_WDATA = rBusData;
assign SIMPBUS_BE = rBusBE;
assign SIMPBUS_RNW = rBusRNW;
assign SIMPBUS_START = (rState == 2 && (rStateInit == 7 || rStateInit == 8) || 
						rState == 3 && (rStateSend == 7 || rStateSend == 8) || 
						rState == 4 && (rStateCheck == 7 || rStateCheck == 8) || 
						rState == 9 && (rStateProxy == 7 || rStateProxy == 8));

assign SIMPBUS_PROXY_RDATA = rBusData;
assign SIMPBUS_PROXY_DONE = rProxyDone;
assign SIMPBUS_PROXY_ERR = rProxyErr;

assign CHANNEL = rReq[5:1];
assign SIGNAL = rReq[0];
assign LEN = rLen;
assign DONE = rDone;
assign ERR = rErr;

// DMA parameters FIFO storage.
generate
	if (C_ARCH == "V5") begin: v5
		fifo_ramb_32w512d dmaFifo (
			.clk(SYS_CLK),
			.srst(SYS_RST),
			.din(FIFO_DATA),
			.wr_en(FIFO_WEN),
			.rd_en(rFifoREN),
			.dout(wFifoDataOut),
			.full(),
			.empty(),
			.data_count(wFifoDataCount)
		);
	end
	else if (C_ARCH == "V6") begin: v6
		fifo_ramb_32w512d_v6 dmaFifo (
			.clk(SYS_CLK),
			.srst(SYS_RST),
			.din(FIFO_DATA),
			.wr_en(FIFO_WEN),
			.rd_en(rFifoREN),
			.dout(wFifoDataOut),
			.full(),
			.empty(),
			.data_count(wFifoDataCount)
		);
	end
endgenerate

// Master state machine to send out DMA transfer requests to the
// DMA Controller and to service proxy SIMPBUS requests.
always @(posedge SYS_CLK or posedge SYS_RST) begin
	if (SYS_RST) begin
		rState <= 0;
		rStateInit <= 0;
		rStateRead <= 0;
		rStateSend <= 0;
		rStateCheck <= 0;
		rStateProxy <= 0;
		rCompState <= 0;
		rNumRetries <= 0;
		rNumTxrRetries <= 0;
		rSrc <= 0;
		rDst <= 0;
		rLen <= 0;
		rReq <= 0;
		rBusAddr <= 0;
		rBusData <= 0;
		rBusRNW <= 0;
		rBusBE <= 4'b1111;
		rFifoREN <= 0;
		rDone <= 0;
		rErr <= 0;
		rProxyDone <= 0;
		rProxyErr <= 0;
	end
	else begin		
		case (rState)
			4'd0: begin // Waiting for FIFO to fill or proxy access to be requested.
				rState <= (SIMPBUS_PROXY_START ? 9 : (wFifoDataCount >= 4 ? 1 : 0)); 
			end
			4'd1: begin // Read src, dst, len, req in separate state machine.
				case (rStateRead)
					4'd0: begin // Wait for start.
						if (rState == 1) begin
							rNumRetries <= 0;
							rCompState <= 3;
							rStateRead <= 1;
						end
					end
					4'd1: begin // Request next value out of FIFO.
						rFifoREN <= 1;
						rStateRead <= 2;
					end
					4'd2: begin // Wait for read.
						rFifoREN <= 0;
						rStateRead <= rCompState;
					end
					4'd3: begin // Read src from the FIFO.
						rSrc <= wFifoDataOut;
						rCompState <= 4;
						rStateRead <= 1;
					end
					4'd4: begin // Read dst from the FIFO.
						rDst <= wFifoDataOut;
						rCompState <= 5;
						rStateRead <= 1;
					end
					4'd5: begin // Read len from the FIFO.
						rLen <= wFifoDataOut;
						rCompState <= 6;
						rStateRead <= 1;
					end
					4'd6: begin // Read req from the FIFO.
						rReq <= wFifoDataOut[31:26];
						rStateRead <= 7;
					end
					4'd7: begin // Done reading.
						rNumRetries <= 0;
						rStateRead <= 0;
						rState <= (rLen == 0 ? 5 : 2); // Short circuit for zero length transfer.
					end
				endcase
			end
			4'd2: begin // Initialize DMA controller in separate state machine.
				case (rStateInit)
					4'd0: begin // Wait for start.
						if (rState == 2) begin
							rNumRetries <= 0;
							rStateInit <= 1;
						end
					end
					4'd1: begin // Send reset.
						rBusRNW <= 0;
						rBusAddr <= C_DMA_BASE_ADDR + C_DMA_RESET_OFF;
						rBusData <= C_DMA_RESET_VAL;
						rBusBE <= 4'b1111;
						rCompState <= 2;
						rStateInit <= 7;
					end
					4'd2: begin // Send addr increment.
						rBusRNW <= 0;
						rBusAddr <= C_DMA_BASE_ADDR + C_DMA_CONTROL_OFF;
						rBusData <= C_DMA_CONTROL_VAL;
						rBusBE <= 4'b1111;
						rCompState <= 3;
						rStateInit <= 7;
					end
					4'd3: begin // Send intr enable.
						rBusRNW <= 0;
						rBusAddr <= C_DMA_BASE_ADDR + C_DMA_INTR_EN_OFF;
						rBusData <= C_DMA_INTR_EN_VAL;
						rBusBE <= 4'b1111;
						rCompState <= 4;
						rStateInit <= 7;
					end
					4'd4: begin // Done with DMA initialization.
						rNumRetries <= 0;
						rStateInit <= 0;
						rState <= 3;
					end
					4'd5: begin // DMA attempt failed. Retry? 
						if (rNumRetries == C_NUM_RETRIES) begin
							rStateInit <= 6;
						end
						else begin // Restart initializing.
							rNumRetries <= rNumRetries + 1;
							rStateInit <= 1;
						end
					end
					4'd6: begin // DMA initialization failed.
						rNumRetries <= 0;
						rStateInit <= 0;
						rState <= 6; // Failure state.
					end
					4'd7: begin // Send request (read or write) to DMA controller.
						rStateInit <= 8;
					end
					4'd8: begin // Wait for completion (this will happen at some point).
						if (SIMPBUS_DONE) begin
							if (SIMPBUS_ERR) begin // Try to again.
								rStateInit <= 5;
							end
							else begin // Move on to next phase.
								rBusData <= SIMPBUS_RDATA;
								rStateInit <= rCompState;
							end
						end
					end
				endcase
			end
			4'd3: begin // Send src, dst, len in separate state machine.
				case (rStateSend)
					4'd0: begin // Wait for start.
						if (rState == 3) begin
							rNumRetries <= 0;
							rStateSend <= 1;
						end
					end
					4'd1: begin // Send src.
						rBusRNW <= 0;
						rBusAddr <= C_DMA_BASE_ADDR + C_DMA_SRC_OFF;
						rBusData <= rSrc;
						rBusBE <= 4'b1111;
						rCompState <= 2;
						rStateSend <= 7;
					end
					4'd2: begin // Send dst.
						rBusRNW <= 0;
						rBusAddr <= C_DMA_BASE_ADDR + C_DMA_DEST_OFF;
						rBusData <= rDst;
						rBusBE <= 4'b1111;
						rCompState <= 3;
						rStateSend <= 7;
					end
					4'd3: begin // Send length.
						rBusRNW <= 0;
						rBusAddr <= C_DMA_BASE_ADDR + C_DMA_LEN_OFF;
						rBusData <= rLen;
						rBusBE <= 4'b1111;
						rCompState <= 4;
						rStateSend <= 7;
					end
					4'd4: begin // Done send.
						rNumRetries <= 0;
						rStateSend <= 0;
						rState <= 4;
					end
					4'd5: begin // Send attempt failed. Retry? 
						if (rNumRetries == C_NUM_RETRIES) begin
							rStateSend <= 6;
						end
						else begin // Restart send.
							rNumRetries <= rNumRetries + 1;
							rStateSend <= 1;
						end
					end
					4'd6: begin // Send failed.
						rNumRetries <= 0;
						rStateSend <= 0;
						rState <= 6; // Failure state.
					end
					4'd7: begin // Send request (read or write) to DMA controller.
						rStateSend <= 8;
					end
					4'd8: begin // Wait for completion (this will happen at some point).
						if (SIMPBUS_DONE) begin
							if (SIMPBUS_ERR) begin // Try again.
								rStateSend <= 5;
							end
							else begin // Move on to next phase.
								rBusData <= SIMPBUS_RDATA;
								rStateSend <= rCompState;
							end
						end
					end
				endcase
			end
			4'd4: begin // Wait for DMA transfer to complete & check status in separate state machine.
				case (rStateCheck)
					4'd0: begin // Wait for start (end of DMA transfer).
						if (rState == 4 && INTR_DMA) begin
							rNumRetries <= 0;
							rStateCheck <= 1;
						end
					end
					4'd1: begin // Wait for DMA transfer to complete.
						rBusRNW <= 1;
						rBusAddr <= C_DMA_BASE_ADDR + C_DMA_INTR_STATUS_OFF;
						rBusBE <= 4'b1111;
						rCompState <= 2;
						rStateCheck <= 7;
					end
					4'd2: begin // Verify and clear the interrupt status.
						rBusRNW <= 0;
						rBusAddr <= C_DMA_BASE_ADDR + C_DMA_INTR_STATUS_OFF;
						rBusBE <= 4'b1111;
						rCompState <= (rBusData == 1 ? 3 : 4); // rBusData == 1 would be success, 2 or 3 would be error.
						rStateCheck <= 7;
					end
					4'd3: begin // Done with DMA check, transfer success.
						rNumRetries <= 0;
						rStateCheck <= 0;
						rState <= 5;
					end
					4'd4: begin // Done with DMA check, transfer failure.
						rNumRetries <= 0;
						rStateCheck <= 0;
						rState <= 8;
					end
					4'd5: begin // DMA attempt failed. Retry? 
						if (rNumRetries == C_NUM_RETRIES) begin
							rStateCheck <= 6;
						end
						else begin // Restart initializing.
							rNumRetries <= rNumRetries + 1;
							rStateCheck <= 1;
						end
					end
					4'd6: begin // DMA check failed.
						rNumRetries <= 0;
						rStateCheck <= 0;
						rState <= 6; // Failure state.
					end
					4'd7: begin // Send request (read or write) to DMA controller.
						rStateCheck <= 8;
					end
					4'd8: begin // Wait for completion (this will happen at some point).
						if (SIMPBUS_DONE) begin
							if (SIMPBUS_ERR) begin // Try to again.
								rStateCheck <= 5;
							end
							else begin // Move on to next phase.
								rBusData <= SIMPBUS_RDATA;
								rStateCheck <= rCompState;
							end
						end
					end
				endcase
			end
			4'd5: begin // DMA transfer success.
				rDone <= 1;
				rErr <= 0;
				rState <= 7;
			end
			4'd6: begin // Unrecoverable failure. Signal error. 
				rDone <= 1;
				rErr <= 1;
				rState <= 7;
			end
			4'd7: begin // Wait for ack.
				if (DONE_ACK) begin
					rDone <= 0;
					rState <= 10;
				end
			end
			4'd8: begin // Retry DMA transfer?
				if (rNumTxrRetries == C_NUM_RETRIES) begin
					rState <= 6;
				end
				else begin // Restart transfer.
					rNumTxrRetries <= rNumTxrRetries + 1;
					rState <= 2; // Restart at DMA initialization.
				end
			end
			4'd9: begin // Read or write as requested by the proxy.
				case (rStateProxy)
					4'd0: begin // Wait for start.
						if (rState == 9) begin
							rNumRetries <= 0;
							rStateProxy <= 1;
						end
					end
					4'd1: begin // Perform the read or write.
						rBusRNW <= SIMPBUS_PROXY_RNW;
						rBusAddr <= SIMPBUS_PROXY_ADDR;
						rBusData <= SIMPBUS_PROXY_WDATA;
						rBusBE <= SIMPBUS_PROXY_BE;
						rCompState <= 2;
						rStateProxy <= 7;
					end
					4'd2: begin // Done reading or writing.
						rNumRetries <= 0;
						rProxyDone <= 1;
						rStateProxy <= 3;
					end
					4'd3: begin // Turn off done.
						rProxyDone <= 0;
						rProxyErr <= 0;
						rStateProxy <= 4;
					end
					4'd4: begin // Wait a cycle until restarting.
						rStateProxy <= 0;
						rState <= 0;
					end
					4'd5: begin // Read or write attempt failed. Retry? 
						if (rNumRetries == C_NUM_RETRIES) begin
							rStateProxy <= 6;
						end
						else begin // Restart read or write.
							rNumRetries <= rNumRetries + 1;
							rStateProxy <= 1;
						end
					end
					4'd6: begin // Read or write failed.
						rNumRetries <= 0;
						rProxyDone <= 1; // Done.
						rProxyErr <= 1; // With err.
						rStateProxy <= 3; // Finish up.
					end
					4'd7: begin // Send read or write request.
						rStateProxy <= 8;
					end
					4'd8: begin // Wait for completion (this will happen at some point).
						if (SIMPBUS_DONE) begin
							if (SIMPBUS_ERR) begin // Try again.
								rStateProxy <= 5;
							end
							else begin // Success.
								rBusData <= SIMPBUS_RDATA;
								rStateProxy <= rCompState;
							end
						end
					end
				endcase
			end
			4'd10: begin // Reset.
				rNumRetries <= 0;
				rNumTxrRetries <= 0;
				rDone <= 0;
				rErr <= 0;
				rState <= 0;
			end
			default: begin
				rState <= 0;
			end
		endcase
	end
end

/*
wire [35:0] wControl0;

chipscope_icon cs_icon(
	.CONTROL0(wControl0)
);
chipscope_ila_128 a0(.CLK(SYS_CLK), .CONTROL(wControl0), .TRIG0({DONE_ACK, SIMPBUS_DONE, SIMPBUS_ERR, INTR_DMA, rErr, rDone, rReq, rLen, rDst, rSrc, rStateCheck, rStateSend, rStateRead, rStateInit, rState}));
*/

endmodule
