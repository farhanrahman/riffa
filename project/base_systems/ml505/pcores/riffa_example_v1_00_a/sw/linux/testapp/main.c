/*******************************************************************************
 * Copyright (c) 2012, Matthew Jacobsen
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer. 
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution. 
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * The views and conclusions contained in the software and documentation are those
 * of the authors and should not be interpreted as representing official policies, 
 * either expressed or implied, of the FreeBSD Project.
 */

/*
 * Filename: main.c
 * Version: 0.9
 * Description: Sample C user software to use with riffa_example IP core. Needs
 *  fpga_comm.h and fpga_comm.c for compilation.
 * History: @mattj: Initial pre-release. Version 0.9.
 */
#include <stdio.h>
#include <stdlib.h>
#include "fpga_comm.h"

//#define DATA_SIZE (1*1024*1024)
#define DATA_SIZE (4)

unsigned int gData[DATA_SIZE/4]; // 1 MB (should be good)

/**
 * Main entry point.
 */
int main(int argc, char* argv[]) 
{
	fpga_dev * fpgaDev;
  int rtn, channel, timeout;
	unsigned int arg0, arg1;
	printf("Reached here \n");
	timeout = 10*1000; // 10 secs.
	channel = 0;
	arg0 = (unsigned int)rand();
	arg1 = (unsigned int)rand();

	if ((rtn = fpga_init(&fpgaDev)) < 0) {
		printf("error opening fpga: %d\n", rtn);
		return rtn;
	}

	if ((rtn = fpga_channel_open(fpgaDev, channel, timeout)) < 0) {
		printf("error opening fpga channel: %d\n", rtn);
		return rtn;
	}

  printf("Opened.\n");

	while (1) {
		if ((rtn = fpga_send_args(fpgaDev, channel, arg0, arg1, 2, 1)) < 0) {
			printf("error sending args to fpga: %d\n", rtn);
			break;
		}

		printf("Called with args: 0x%x, 0x%x.\n", arg0, arg1);

		if ((rtn = fpga_recv_data(fpgaDev, channel, (unsigned char *)gData, DATA_SIZE)) < 0) {
			printf("error receiving data from fpga: %d\n", rtn);
			break;
		}

		printf("Received data response, length: 0x%x\n", rtn);
		printf("Response values 0 & 1: 0x%x, 0x%x should equal 0x%x, 0x%x\n", 
			fpga_flip_endian(gData[0]), fpga_flip_endian(gData[1]), arg0, arg1);

		break;
	}

  printf("Done.\n");

	fpga_channel_close(fpgaDev, 0);
  fpga_free(fpgaDev);
  printf("Exiting.\n");

	return 0;
}

