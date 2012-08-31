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

#define DATA_SIZE (20*1024*1024)
#define FILE_NAME "data.txt"
#define LOG_FILE "log.txt"
#define DEBUG 	1
#define INFO 	1
#define LOG	0
#define MAX(a,b) a > b ? a : b

struct timeval start, end;
long usecs;

#define GETTIME(t) gettimeofday(&t, NULL)
#define GETUSEC(e,s) e.tv_usec - s.tv_usec 
#define PRINTUS(u) printf("Time required to send data to FPGA : %ld us\n", us)

unsigned int gData[DATA_SIZE/4];
unsigned int senddata[DATA_SIZE/4];

int fpeek(FILE *stream)
{
    int c;

    c = fgetc(stream);
    ungetc(c, stream);

    return c;
}

/**
 * Main entry point.
 */
int main(int argc, char* argv[]) 
{
	fpga_dev * fpgaDev;
	int rtn, channel, timeout;
	int i = 0;
	int DATA_POINTS = 0;
	unsigned int arg = 4294967295;
	unsigned int c;
	unsigned int lastVal = 0;
	timeout = 10*1000; // 5 secs.
	channel = argc == 2 ? atoi(argv[1]) : 0;

	#if INFO == 1
	printf("channel = %d \n", channel);
	#endif

	FILE *fin = fopen(FILE_NAME,"r"); 
	assert(fin != NULL);

	while(!feof(fin)){
		fscanf(fin,"%d", &c);
		if(!feof(fin)){
			senddata[i++] = c;
		}
	}

	assert(i > 0);

	DATA_POINTS = MAX(1, i);
	#if INFO == 1	
	printf("DATA_POINTS: %d\n",DATA_POINTS);
	#endif
	fclose(fin);

	#if INFO == 1
	for(i = 0; i < DATA_POINTS; i++){
		printf("senddata[%d] = %d\n",i,senddata[i]);
	}
	#endif

	lastVal = senddata[DATA_POINTS-1];
	for(i = DATA_POINTS - 1; i > 0; i--){
		senddata[i] = senddata[i-1];
	}
	senddata[0] = lastVal;

	for(i = 0; i < DATA_POINTS; i++){
		senddata[i] = fpga_flip_endian(senddata[i]);
	}

	if ((rtn = fpga_init(&fpgaDev)) < 0) {
		#if DEBUG == 1
		printf("error opening fpga: %d\n", rtn);
		#endif	
		return rtn;
	}

	if ((rtn = fpga_channel_open(fpgaDev, channel, timeout)) < 0) {
		#if DEBUG == 1
		printf("error opening fpga channel: %d\n", rtn);
		#endif
		return rtn;
	}

	#if INFO == 1
 	printf("Opened.\n");
	#endif
	while(1) {
//		printf("rtn= %d\n", fpga_send_args(fpgaDev, channel, arg, arg, 2, 1));
//		printf("rtn= %d\n", fpga_send_args(fpgaDev, channel, 0, 0, 2, 1));
		GETTIME(start);
		if((rtn = fpga_send_data(fpgaDev, channel, (unsigned char *) senddata, DATA_POINTS*4, 1)) < 0){
			#if DEBUG == 1
			printf("error sending args to fpga: %d\n", rtn);
			#endif
			break;
		}
		GETTIME(end);

		usecs = GETUSEC(end,start);
		#if INFO == 1
		printf("Time required to send data to FPGA : %ld us\n", usecs);
		#endif
		GETTIME(start);
		if ((rtn = fpga_recv_data(fpgaDev, channel, (unsigned char *)gData, DATA_SIZE)) < 0) {
			#if DEBUG == 1
			printf("error receiving data from fpga: %d\n", rtn);
			#endif
			break;
		}
		GETTIME(end);
		
		usecs = GETUSEC(end,start);
		#if INFO == 1
		printf("Time required to receive data from FPGA : %ld us\n", usecs);
		printf("Received data response, length: 0x%x , %d bytes\n", rtn,rtn);
		#endif
		DATA_POINTS = MAX(DATA_POINTS,rtn/4);
		break;

	}
#if INFO == 1	
i = 0;
		printf("gData[%d]\t= %10d, fpga_flip_endian(gData[%d])\t= %10d,	senddata[%d]\t= %10d, fpga_flip_endian(senddata[%d])\t=%10d\n",i,gData[i],i,fpga_flip_endian(gData[i]),i,senddata[i],i,fpga_flip_endian(senddata[i]));
i = DATA_POINTS - 1;

		printf("gData[%d]\t= %10d, fpga_flip_endian(gData[%d])\t= %10d,	senddata[%d]\t= %10d, fpga_flip_endian(senddata[%d])\t=%10d\n",i,gData[i],i,fpga_flip_endian(gData[i]),i,senddata[i],i,fpga_flip_endian(senddata[i]));
  	printf("Done.\n");
#endif
	fpga_channel_close(fpgaDev, 0);
  	fpga_free(fpgaDev);
#if INFO == 1
	printf("Bytes received: %d, Throughput: %f MB/s,\n", rtn, (double)(((rtn/(1024.0*1024.0))/(usecs*1.0))*1000000.0));
#endif

#if LOG == 1
	FILE *fout = fopen(LOG_FILE,"a+");	
	fprintf(fout,"%d,%f,\n", rtn, (double)(((rtn/(1024.0*1024.0))/(usecs*1.0))*1000000.0));
	fclose(fout);	
#endif

	#if INFO == 1  
	printf("Exiting.\n");
	#endif
	return 0;
}

