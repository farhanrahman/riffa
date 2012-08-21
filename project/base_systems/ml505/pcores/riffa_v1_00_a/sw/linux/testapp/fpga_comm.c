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
 * Filename: fpga_comm.c
 * Version: 0.9
 * Description: Linux PCIe communications API for RIFFA. Uses RIFFA kernel
 *  driver defined in "fpga_driver.h".
 * History: @mattj: Initial pre-release. Version 0.9.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <math.h>
#include <string.h>
#include <sys/mman.h>
#include <linux/sched.h>
#include <pthread.h>
#include "fpga_comm.h"

/* Structs, fully defined. */
struct thread_args
{
	fpga_dev * fpgaDev;
	int channel;
	unsigned char * data;
	int len;
	int start;
};

struct fpga_dev
{
	int fd;
	unsigned char * cfgMem;
	unsigned char * bufMem[NUM_IPIF_BAR];
	int numBuffers;
	int intrFds[NUM_CHANNEL];
	pthread_t sendThreads[NUM_CHANNEL];
	pthread_t recvThreads[NUM_CHANNEL];
	thread_args sendThreadArgs[NUM_CHANNEL];
	thread_args recvThreadArgs[NUM_CHANNEL];
};

/* Initialize/finalize functions. */
int fpga_init(fpga_dev ** fpgaDev) {
	int fd;
	int i = 0;

	// Allocate space for the fpga_dev
	(*fpgaDev) = malloc(sizeof(fpga_dev));
	if (*fpgaDev == NULL) {
		fprintf(stderr, "Failed to malloc fpga_dev\n");
		return -ENOMEM;
	}

	// Open the device file.
	fd = open(FPGA_DEV_PATH, O_RDWR | O_SYNC);
	if(fd < 0) {
		return fd;
	}
	
	// Map the DMA regions.
	for (i = NUM_IPIF_BAR-1; i >= 0; i--) {
		(*fpgaDev)->bufMem[i] = mmap(NULL, IPIF_BAR_SIZE, PROT_READ | PROT_WRITE, 
			MAP_FILE | MAP_SHARED, fd, PCI_BAR_0_SIZE + (IPIF_BAR_SIZE*i));
		if((*fpgaDev)->bufMem[i] == MAP_FAILED)
			break;
	}
	(*fpgaDev)->numBuffers = NUM_IPIF_BAR-1 - i;
	if((*fpgaDev)->numBuffers == 0)
		return -ENOMEM;

	// Map the config region.
	(*fpgaDev)->cfgMem = mmap(NULL, PCI_BAR_0_SIZE, PROT_READ | PROT_WRITE, 
		MAP_FILE | MAP_SHARED, fd, 0);
	if((*fpgaDev)->cfgMem == MAP_FAILED) {
		fprintf(stderr, "mmap() failed to map fpga config region\n");
		return -ENOMEM;
	}

	// Initialize the channel fds
	for (i = 0; i < NUM_CHANNEL; i++)
		(*fpgaDev)->intrFds[i] = -1;

	return 0;
}


void fpga_free(fpga_dev * fpgaDev) {
	int i;

	// Close the open interrupt channels.
	for (i = 0; i < NUM_CHANNEL; i++)
		fpga_channel_close(fpgaDev, fpgaDev->intrFds[i]);

	// Unmap the memory regions.
	for (i = fpgaDev->numBuffers-1; i >= 0; i--) {
		if (fpgaDev->bufMem[i] != NULL)
			munmap(fpgaDev->bufMem[i], IPIF_BAR_SIZE);
		fpgaDev->bufMem[i] = NULL;
	}
	if (fpgaDev->cfgMem != NULL)
		munmap(fpgaDev->cfgMem, PCI_BAR_0_SIZE);
	fpgaDev->cfgMem = NULL;

	// Close the device file.
	if (fpgaDev->fd >= 0)
		close(fpgaDev->fd);
	fpgaDev->fd = -1;
}


/* Utility functions. */
unsigned int fpga_read_word(unsigned char * mptr) {
	return *((unsigned int *)mptr);
}


void fpga_write_word(unsigned char * mptr, unsigned int val) {
	*((unsigned int *)mptr) = val;
}


unsigned int fpga_flip_endian(unsigned int val) {
	return ( (val & 0x000000FF) << 24 | (val & 0x0000FF00) << 8 | 
						(val & 0x00FF0000) >> 8 | (val & 0xFF000000) >> 24 );
}


/* Full "function call" type functions. */
int fpga_call_args_data(fpga_dev * fpgaDev, int channel, unsigned int arg0, 
	unsigned int arg1, int argc, unsigned char * senddata, int sendlen, 
	unsigned char * recvdata, int recvlen) {
	int rtn;
	if ((rtn = fpga_send_args_data(fpgaDev, channel, arg0, arg1, argc, senddata, 
		sendlen, 1)) < 0)
		return rtn;
	return fpga_recv_data(fpgaDev, channel, recvdata, recvlen);
}


int fpga_call_args(fpga_dev * fpgaDev, int channel, unsigned int arg0, 
	unsigned int arg1, int argc, unsigned char * recvdata, int recvlen) {
	return fpga_call_args_data(fpgaDev, channel, arg0, arg1, argc, NULL, 0, 
		recvdata, recvlen);
}


int fpga_call_data(fpga_dev * fpgaDev, int channel, unsigned char * senddata, 
	int sendlen, unsigned char * recvdata, int recvlen) {
	return fpga_call_args_data(fpgaDev, channel, 0, 0, 0, senddata, sendlen, 
		recvdata, recvlen);
}


int fpga_call(fpga_dev * fpgaDev, int channel, unsigned char * recvdata, 
	int recvlen) {
	return fpga_call_args_data(fpgaDev, channel, 0, 0, 0, NULL, 0, recvdata, 
		recvlen);
}


/* Sending args/data functions. */
int fpga_send_args_data(fpga_dev * fpgaDev, int channel, unsigned int arg0, 
	unsigned int arg1, int argc, unsigned char * senddata, int sendlen, 
	int start) {
	unsigned int args[2];
	int rtn;

	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;

	// When writing to the file, the length parameter must encode whether we are 
	// sending args, if this is a doorbell request, error, and the actual length. 
	// The format is:
	// { A (30 bits) | B (1 bit) | C (1 bit) }
	// If A == 0:
	//   BC == 00: request to just wait for a EVENT_DATA_SENT msg.
	//   BC == 01: invalid.
	//   BC == 10: request to doorbell the IP core with no error.
	//   BC == 11: request to doorbell the IP core with error.
	// If A != 0:
	//   BC == 00: write A bytes to FPGA, doorbell after every transfer with num bytes transferred.
	//   BC == 01: invalid.
	//   BC == 10: write A args to FPGA, no doorbells.
	//   BC == 11: invalid.

	// Write args (if any) first.
	if (argc > 0) {
		args[0] = arg0;
		args[1] = arg1;
		if ((rtn = write(fpgaDev->intrFds[channel], args, (argc<<2 | 1<<1))) < 0)
			return rtn;
		if (rtn != ((argc > 2 ? 2 : argc) * sizeof(unsigned int)))
			return -EFAULT;
	}

	// Send data.
	if (sendlen > 0) {
		if ((rtn = write(fpgaDev->intrFds[channel], senddata, (sendlen<<2))) < 0)
			return rtn;
	}

	if (start) {
		return write(fpgaDev->intrFds[channel], NULL, (1<<1));
	}

	return 0;
}


int fpga_send_args(fpga_dev * fpgaDev, int channel, unsigned int arg0, 
	unsigned int arg1, int argc, int start) {
	return fpga_send_args_data(fpgaDev, channel, arg0, arg1, argc, NULL, 0, 
		start);
}


int fpga_send_data(fpga_dev * fpgaDev, int channel, unsigned char * senddata, 
	int sendlen, int start) {
	return fpga_send_args_data(fpgaDev, channel, 0, 0, 0, senddata, sendlen, 
		start);
}


int fpga_send_doorbell(fpga_dev * fpgaDev, int channel, int err) {
	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;

	// When writing to the file, the length parameter must encode whether we are 
	// sending args, if this is a doorbell request, error, and the actual length. 
	// The format is:
	// { A (30 bits) | B (1 bit) | C (1 bit) }
	// If A == 0:
	//   BC == 00: request to just wait for a EVENT_DATA_SENT msg.
	//   BC == 01: invalid.
	//   BC == 10: request to doorbell the IP core with no error.
	//   BC == 11: request to doorbell the IP core with error.
	// If A != 0:
	//   BC == 00: write A bytes to FPGA, doorbell after every transfer with num bytes transferred.
	//   BC == 01: invalid.
	//   BC == 10: write A args to FPGA, no doorbells.
	//   BC == 11: invalid.
	return write(fpgaDev->intrFds[channel], NULL, (1<<1 | (err ? 1: 0)));
}


/* Asynchronous sending data functions. */
/*
 * Thread function to send data and return the value from fpga_send_data. The 
 * only argument is a pointer to a thread_args on the fpga_dev.
 */
void* fpga_send_data_thread(void* arg) {
	thread_args * targs = (thread_args *)arg;
	long rtn;

	// Wait for all the data to be sent, and return the value from fpga_send_data.	
	rtn = fpga_send_data(targs->fpgaDev, targs->channel, targs->data,	targs->len, 
		targs->start);
	pthread_exit((void *)rtn);
}

int fpga_send_data_begin(fpga_dev * fpgaDev, int channel, 
	unsigned char * senddata, int sendlen, int start) {
	pthread_attr_t attr;

	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;
	// Check that we haven't already created a thread.
	if (fpgaDev->sendThreadArgs[channel].fpgaDev != NULL)
		return -EFAULT;
	// Create a thread to send data.	
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
	pthread_attr_setscope(&attr, PTHREAD_SCOPE_SYSTEM);
	fpgaDev->sendThreadArgs[channel].fpgaDev = fpgaDev;
	fpgaDev->sendThreadArgs[channel].channel = channel;
	fpgaDev->sendThreadArgs[channel].data = senddata;
	fpgaDev->sendThreadArgs[channel].len = sendlen;
	fpgaDev->sendThreadArgs[channel].start = start;
	return pthread_create(&fpgaDev->sendThreads[channel], &attr, 
		&fpga_send_data_thread, &fpgaDev->sendThreadArgs[channel]);		
}


int fpga_send_data_end(fpga_dev * fpgaDev, int channel) {
	int rtn;
	void * status;

	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;
	// Check that a thread was created.
	if (fpgaDev->sendThreadArgs[channel].fpgaDev == NULL)
		return -ESRCH;
	rtn = pthread_join(fpgaDev->sendThreads[channel], &status);
	fpgaDev->sendThreadArgs[channel].fpgaDev = NULL;
	if (rtn < 0)
		return rtn;
	else
		return (long)status;
}


/* Receiving data functions. */
int fpga_recv_data(fpga_dev * fpgaDev, int channel, unsigned char * recvdata, 
	int recvlen) {
	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;
	// Read from the driver.
	return read(fpgaDev->intrFds[channel], recvdata, recvlen);
}


int fpga_wait_interrupt(fpga_dev * fpgaDev, int channel) {
	return fpga_recv_data(fpgaDev, channel, NULL, 0);
}


/* Asynchronous receiving data functions. */
/*
 * Thread function to receive data and return the number of bytes received. The
 * only argument is a pointer to a thread_args on the fpga_dev.
 */
void* fpga_recv_data_thread(void* arg) {
	thread_args * targs = (thread_args *)arg;
	long rtn;

	// Wait for all the data to be recieved, and return the nbytes.	
	rtn = fpga_recv_data(targs->fpgaDev, targs->channel, targs->data, targs->len);
	pthread_exit((void *)rtn);
}


int fpga_recv_data_begin(fpga_dev * fpgaDev, int channel, 
	unsigned char * recvdata, int recvlen) {
	pthread_attr_t attr;

	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;
	// Check that we haven't already created a thread.
	if (fpgaDev->recvThreadArgs[channel].fpgaDev != NULL)
		return -EFAULT;
	// Create a thread to receive data.	
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
	pthread_attr_setscope(&attr, PTHREAD_SCOPE_SYSTEM);
	fpgaDev->recvThreadArgs[channel].fpgaDev = fpgaDev;
	fpgaDev->recvThreadArgs[channel].channel = channel;
	fpgaDev->recvThreadArgs[channel].data = recvdata;
	fpgaDev->recvThreadArgs[channel].len = recvlen;
	return pthread_create(&fpgaDev->recvThreads[channel], &attr, 
		&fpga_recv_data_thread, &fpgaDev->recvThreadArgs[channel]);		
}


int fpga_recv_data_end(fpga_dev * fpgaDev, int channel) {
	int rtn;
	void * status;

	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;
	// Check that a thread was created.
	if (fpgaDev->recvThreadArgs[channel].fpgaDev == NULL)
		return -EFAULT;
	rtn = pthread_join(fpgaDev->recvThreads[channel], &status);
	fpgaDev->recvThreadArgs[channel].fpgaDev = NULL;
	if (rtn < 0)
		return rtn;
	else
		return (long)status;
}


/* Configuration setting functions. */
int fpga_config_read(fpga_dev * fpgaDev, int offset, unsigned int * val) {
	if (offset < 0 || offset > PCI_BAR_0_SIZE-4)
		return -EFAULT;
	*val = fpga_flip_endian(fpga_read_word(fpgaDev->cfgMem + ((offset>>2)<<2)));
	return 0;
}


int fpga_config_write(fpga_dev * fpgaDev, int offset, unsigned int val) {
	if (offset < 0 || offset > PCI_BAR_0_SIZE-4)
		return -EFAULT;
	fpga_write_word(fpgaDev->cfgMem + ((offset>>2)<<2), fpga_flip_endian(val));
	return 0;
}


/* Low level data transferring and buffer management functions. */
int fpga_mem_copy(fpga_dev * fpgaDev, int channel, unsigned int srcaddr, 
	unsigned int dstaddr, unsigned int len, int doorbell, int wait) {
	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;

	// Write to the DMA_REG_OFF to set src, dst, & len. Formats are:
	// src: { src_addr (32 bits) }
	// dst: { dst_addr (32 bits) }
	// len: { err (1 bit) | doorbell (1 bit) | transfer_bytes (30 bits) }
	fpga_write_word(fpgaDev->cfgMem + DMA_SRC_REG_OFF + (CHANNEL_REG_INC*channel), 
		fpga_flip_endian(srcaddr));
	fpga_write_word(fpgaDev->cfgMem + DMA_DST_REG_OFF + (CHANNEL_REG_INC*channel), 
		fpga_flip_endian(dstaddr));
	fpga_write_word(fpgaDev->cfgMem + DMA_LEN_REG_OFF + (CHANNEL_REG_INC*channel), 
		fpga_flip_endian( ((doorbell ? 1 : 0)<<30 | len) ));

	// When writing to the file, the length parameter must encode whether we are 
	// sending args, if this is a doorbell request, error, and the actual length. 
	// The format is:
	// { A (30 bits) | B (1 bit) | C (1 bit) }
	// If A == 0:
	//   BC == 00: request to just wait for a EVENT_DATA_SENT msg.
	//   BC == 01: invalid.
	//   BC == 10: request to doorbell the IP core with no error.
	//   BC == 11: request to doorbell the IP core with error.
	// If A != 0:
	//   BC == 00: write A bytes to FPGA, doorbell after every transfer with num bytes transferred.
	//   BC == 01: invalid.
	//   BC == 10: write A args to FPGA, no doorbells.
	//   BC == 11: invalid.
	if (wait)
		return write(fpgaDev->intrFds[channel], NULL, 0);

	return 0;
}

int fpga_remote_buf_allocate(fpga_dev * fpgaDev, int channel, int * size,
	unsigned int * remoteAddr) {
	int rtn;
	unsigned int info;

	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;
	rtn = ioctl(fpgaDev->intrFds[channel], IOCTL_GET_FPGA_BUF, &info);
	*remoteAddr = (info & 0xFFFFFFE0);
	*size = (int)(1<<(info & 0x1f));
	return rtn;
}

int fpga_internal_buf_allocate(fpga_dev * fpgaDev, int channel, int * size,
	unsigned int * remoteAddr, unsigned char ** buf, int * bar, int * segment) {
	int rtn;
	unsigned int info[2];

	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;
	rtn = ioctl(fpgaDev->intrFds[channel], IOCTL_ALLC_PC_BUF, info);
	*bar = info[0];
	*segment = info[1];
	*remoteAddr = (IPIF_BAR_ADDR + (IPIF_BAR_ADDR_INC*info[0]) + (BUF_SIZE*info[1]));
	*size = BUF_SIZE;
	*buf = fpgaDev->bufMem[info[0]] + (BUF_SIZE*info[1]);
	return rtn;
}

int fpga_internal_buf_free(fpga_dev * fpgaDev, int channel, int bar, int segment) {
	unsigned int info[2];

	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;
	info[0] = bar;
	info[1] = segment;
	return ioctl(fpgaDev->intrFds[channel], IOCTL_FREE_PC_BUF, info);
}

/* Channel opening/closing/configuring functions. */
int fpga_channel_open(fpga_dev * fpgaDev, int channel, int timeout) {
	int fd;
	char buf[50];

	if (fpgaDev->intrFds[channel] >= 0)
		return 0;
	sprintf(buf, "%s/%s%02d", FPGA_INTR_PATH, IRQ_FILE, channel);
	fd = open(buf, O_RDWR);
	if (fd < 0)
		return fd;
	fpgaDev->intrFds[channel] = fd;
	fpgaDev->sendThreadArgs[channel].fpgaDev = NULL;
	fpgaDev->recvThreadArgs[channel].fpgaDev = NULL;

	if (timeout >= 0)
		return ioctl(fpgaDev->intrFds[channel], IOCTL_SET_TIMEOUT, timeout);

	return 0;
}


void fpga_channel_close(fpga_dev * fpgaDev, int channel) {
	if (fpgaDev->intrFds[channel] >= 0) {
	  close(fpgaDev->intrFds[channel]);
		fpgaDev->intrFds[channel] = -1;
	}
}


int fpga_channel_timeout(fpga_dev * fpgaDev, int channel, int timeout) {
	// Check that the channel is open.
	if (fpgaDev->intrFds[channel] < 0)
		return -EACCES;
	return ioctl(fpgaDev->intrFds[channel], IOCTL_SET_TIMEOUT, timeout);
}


