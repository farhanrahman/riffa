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
#include <assert.h>
#include <sys/time.h>
#include <unistd.h>

#define DATA_SIZE (1*1024*1024)

#define FILE_NAME "data.txt"

#define MAX(a,b) a > b ? a : b

struct timeval start, end;
long usecs;

#define GETTIME(t) gettimeofday(&t, NULL)
#define GETUSEC(e,s) e.tv_usec - s.tv_usec 
#define PRINTUS(u) printf("Time required to send data to FPGA : %ld us\n", us)

unsigned int gData[DATA_SIZE/4];
unsigned int senddata[DATA_SIZE/4];
/**
 * Main entry point.
 */
int main(int argc, char* argv[]) 
{
	fpga_dev * fpgaDev;
	int rtn, channel, timeout;
	int i = 0;
	int DATA_POINTS = 0;


	timeout = 3000*1000; // 30 secs.
	channel = argc == 2 ? atoi(argv[1]) : 0;
	printf("channel = %d \n", channel);


	FILE *fin = fopen(FILE_NAME,"r"); 
	assert(fin != NULL);

	while(!feof(fin)){
		fscanf(fin,"%d", &senddata[i++]);
	}

	assert(i > 0);

	DATA_POINTS = MAX(1, i-1);	

	fclose(fin);	

	if ((rtn = fpga_init(&fpgaDev)) < 0) {
		printf("error opening fpga: %d\n", rtn);
		return rtn;
	}

	if ((rtn = fpga_channel_open(fpgaDev, channel, timeout)) < 0) {
		printf("error opening fpga channel: %d\n", rtn);
		return rtn;
	}


 	printf("Opened.\n");
	
	while(1) {
		GETTIME(start);
		if((rtn = fpga_send_data(fpgaDev, channel, (unsigned char *) senddata, DATA_POINTS*4, 1)) < 0){
			printf("error sending args to fpga: %d\n", rtn);
			break;
		}
		GETTIME(end);

		usecs = GETUSEC(end,start);

		printf("Time required to send data to FPGA : %ld us\n", usecs);

		GETTIME(start);
		if ((rtn = fpga_recv_data(fpgaDev, channel, (unsigned char *)gData, DATA_POINTS*4)) < 0) {
			printf("error receiving data from fpga: %d\n", rtn);
			break;
		}
		GETTIME(end);
		
		usecs = GETUSEC(end,start);
		
		printf("Time required to receive data from FPGA : %ld us\n", usecs);
		
		printf("Received data response, length: 0x%x\n", rtn);
		break;

	}
	
	for(i = 0; i < DATA_POINTS; i++){
		if(gData[i] != senddata[i]){
			printf("TEST FAILED. gData[%d] = %d is not equal to senddata[%d] = %d\n", i,gData[i],i,senddata[i]);
			return -1;
		}
//		printf("gData[%d] = %d, senddata[%d] = %d\n", i,gData[i],i,senddata[i]);
	}

	printf("TEST PASSED. All data sent has been received in the same format and order \n");
  	printf("Done.\n");

	fpga_channel_close(fpgaDev, 0);
  	fpga_free(fpgaDev);
  	printf("Exiting.\n");

	return 0;
}

