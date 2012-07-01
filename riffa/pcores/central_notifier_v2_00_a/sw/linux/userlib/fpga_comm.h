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
 * Filename: fpga_comm.h
 * Version: 0.9
 * Description: Linux PCIe communications API for RIFFA. Uses RIFFA kernel
 *  driver defined in "fpga_driver.h".
 * History: @mattj: Initial pre-release. Version 0.9.
 */

#ifndef FPGA_COMM_H
#define FPGA_COMM_H

#include <fpga_driver.h>

#ifdef __cplusplus
extern "C" {
#endif


/* Paths in proc and dev filesystems */
#define FPGA_INTR_PATH "/proc/" DEVICE_NAME
#define FPGA_DEV_PATH "/dev/" DEVICE_NAME

struct thread_args;
typedef struct thread_args thread_args;
struct fpga_dev;
typedef struct fpga_dev fpga_dev;

/**
 * Initializes the FPGA memory/resources and updates the pointers in the 
 * fpga_dev struct. Returns 0 on success.
 * On error, returns:
 * -1 if could not open the virtual device file (check errno for details).
 * -ENOMEM if could not map the internal buffer memory to user space.
 */
int fpga_init(fpga_dev ** fpgaDev);

/**
 * Cleans up memory/resources for the FPGA virtual files.
 */
void fpga_free(fpga_dev * fpgaDev);

/**
 * Flips an integer (32 bits) endian-ness.
 */
unsigned int fpga_flip_endian(unsigned int val);

/**
 * These functions initiate a transfer of data and/or 4 byte arg values to the
 * FPGA on channel, channel. Any args will first be written. Then any specified 
 * data will be written, possibly over several transfers. After each transfer, 
 * the IP core connected to the channel will receive a doorbell with the 
 * transfer length (in bytes). After the final transfer, the IP core will 
 * receive a zero length doorbell to signal a start. When the IP core has 
 * completed processing, any return data will be transferred from the FPGA and 
 * copied into the recvdata pointer. 
 * Note: this call and return protocol is not enforced on the FPGA IP core. So
 * please be sure to design the IP core state machine accordingly. 
 * Up to argc args are sent and up to sendlen bytes from the senddata pointer 
 * are transferred to the FPGA. Any return data, up to recvlen, will be copied 
 * into the recvdata pointer. Therefore, recvdata must accomodate at least 
 * recvlen bytes. On success, the total number of received bytes will be
 * returned. The amount of bytes written to the recvdata pointer will be the 
 * minimum of the return value and recvlen. 
 * The endianness of sent and received data is not changed, but the endianness
 * of sent args is flipped.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -ETIMEDOUT if timeout is non-zero and expires before all data is received.
 * -EREMOTEIO if the transfer sequence takes too long, data is lost/dropped,
 * or some other error is encountered during transfer.
 * -ERESTARTSYS if a signal interrupts the thread.
 * -ENOMEM if the driver runs out of buffers for data transfers.
 * -EFAULT if internal queues are exhausted or on bad address access.
 */
int fpga_call_args_data(fpga_dev * fpgaDev, int channel, unsigned int arg0, 
	unsigned int arg1, int argc, unsigned char * senddata, int sendlen, 
	unsigned char * recvdata, int recvlen);

int fpga_call_args(fpga_dev * fpgaDev, int channel, unsigned int arg0, 
	unsigned int arg1, int argc, unsigned char * recvdata, int recvlen);

int fpga_call_data(fpga_dev * fpgaDev, int channel, unsigned char * senddata, 
	int sendlen, unsigned char * recvdata, int recvlen);

int fpga_call(fpga_dev * fpgaDev, int channel, unsigned char * recvdata, 
	int recvlen);

/**
 * Writes 4 byte arg values and data to the FPGA on channel, channel. Up to argc
 * args will be written (up to max of 2). After all the args have been written, 
 * sendlen bytes from the senddata pointer will be written, possibly over 
 * multiple transfers. After each transfer, the IP core connected to the channel
 * will receive a doorbell with the transfer length (in bytes). If start == 1, 
 * then after the final transfer, the IP core will receive a zero length 
 * doorbell to signal start. Returns 0 on success.
 * The endianness of sent data is not changed, but the endianness of sent args
 * is flipped.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -ETIMEDOUT if timeout is non-zero and expires before all data is received.
 * -EREMOTEIO if the transfer sequence takes too long, data is lost/dropped,
 * or some other error is encountered during transfer.
 * -ERESTARTSYS if a signal interrupts the thread.
 * -ENOMEM if the driver runs out of buffers for data transfers.
 * -EFAULT if internal queues are exhausted or on bad address access.
 */
int fpga_send_args_data(fpga_dev * fpgaDev, int channel, unsigned int arg0, 
	unsigned int arg1, int argc, unsigned char * senddata, int sendlen, 
	int start);

/**
 * Writes 4 byte arg values to the FPGA on channel, channel. Up to argc args 
 * will be written (up to max of 2). After all the args have been written, if
 * start == 1, the IP core connected to the channel will receive a zero length 
 * doorbell to signal start. Returns 0 on success.
 * The endianness of sent args is flipped.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -ETIMEDOUT if timeout is non-zero and expires before all data is received.
 * -EREMOTEIO if the transfer sequence takes too long, data is lost/dropped,
 * or some other error is encountered during transfer.
 * -ERESTARTSYS if a signal interrupts the thread.
 * -ENOMEM if the driver runs out of buffers for data transfers.
 * -EFAULT if internal queues are exhausted or on bad address access.
 */
int fpga_send_args(fpga_dev * fpgaDev, int channel, unsigned int arg0, 
	unsigned int arg1, int argc, int start);

/**
 * Writes data to the FPGA on channel, channel. All sendlen bytes from the 
 * senddata pointer will be written (possibly over multiple transfers). After 
 * each transfer, the IP core connected to the channel will receive a doorbell 
 * with the transfer length (in bytes). If start == 1, then after the final 
 * transfer, the IP core will receive a zero length doorbell to signal start. 
 * Returns 0 on success.
 * The endianness of sent data is not changed.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -ETIMEDOUT if timeout is non-zero and expires before all data is received.
 * -EREMOTEIO if the transfer sequence takes too long, data is lost/dropped,
 * or some other error is encountered during transfer.
 * -ERESTARTSYS if a signal interrupts the thread.
 * -ENOMEM if the driver runs out of buffers for data transfers.
 * -EFAULT if internal queues are exhausted or on bad address access.
 */
int fpga_send_data(fpga_dev * fpgaDev, int channel, unsigned char * senddata, 
	int sendlen, int start);

/**
 * Sends a zero length doorbell to the IP core connected to the channel. If
 * err == 1, an error will be signaled along with the doorbell. Returns 0 on 
 * success.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -ETIMEDOUT if timeout is non-zero and expires before all data is received.
 * -EREMOTEIO if the transfer sequence takes too long, data is lost/dropped,
 * or some other error is encountered during transfer.
 * -ERESTARTSYS if a signal interrupts the thread.
 * -ENOMEM if the driver runs out of buffers for data transfers.
 * -EFAULT if internal queues are exhausted or on bad address access.
 */
int fpga_send_doorbell(fpga_dev * fpgaDev, int channel, int err);

/**
 * Spawns an internal thread to send data to the FPGA on channel, channel, from 
 * the senddata pointer. Up to sendlen bytes will be copied from the senddata 
 * pointer, possibly over multiple transfers. After each transfer, the IP core 
 * connected to the channel will receive a doorbell with the transfer length (in
 * bytes). If start == 1, then after the final transfer, the IP core will 
 * receive a zero length doorbell to signal start. Returns 0 on success. 
 * The function fpga_send_data_end can be used to wait for completion using the 
 * same channel. This function will return immediately.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -EAGAIN if an internal thread cannot be created.
 */
int fpga_send_data_begin(fpga_dev * fpgaDev, int channel, 
	unsigned char * senddata, int sendlen, int start);

/**
 * Waits for an internal thread created by the fpga_send_data_begin function to 
 * send all data to the FPGA on channel, channel. Returns 0 on success. This 
 * function will block until all data on the channel is sent.
 * The endianness of received data is not changed.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -EINVAL if the thread is not joinable.
 * -ESRCH if no send thread has been created for the channel.
 * -EDEADLK if deadlock was detected.
 */
int fpga_send_data_end(fpga_dev * fpgaDev, int channel);

/**
 * Reads data from the FPGA on channel, channel, to the recvdata pointer. Up to 
 * recvlen bytes will be copied to the recvdata pointer (possibly over multiple 
 * transfers). Therefore, recvdata must accomodate at least recvlen bytes. The 
 * number of bytes actually received on the channel are returned. The number of 
 * bytes written to the recvdata pointer will be the minimum of return value and
 * recvlen.
 * The endianness of received data is not changed.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -ETIMEDOUT if timeout is non-zero and expires before all data is received.
 * -EREMOTEIO if the transfer sequence takes too long, data is lost/dropped,
 * or some other error is encountered during transfer.
 * -ERESTARTSYS if a signal interrupts the thread.
 * -ENOMEM if the driver runs out of buffers for data transfers.
 * -EFAULT if internal queues are exhausted or on bad address access.
 */
int fpga_recv_data(fpga_dev * fpgaDev, int channel, unsigned char * recvdata, 
	int recvlen);

/**
 * Waits for an interrupt to be recieved on the channel. Equivalent to waiting 
 * for a zero length receive data interrupt. Returns 0 on success.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -ETIMEDOUT if timeout is non-zero and expires before all data is received.
 * -EREMOTEIO if the transfer sequence takes too long, data is lost/dropped,
 * or some other error is encountered during transfer.
 * -ERESTARTSYS if a signal interrupts the thread.
 * -ENOMEM if the driver runs out of buffers for data transfers.
 * -EFAULT if internal queues are exhausted or on bad address access.
 */
int fpga_wait_interrupt(fpga_dev * fpgaDev, int channel);

/**
 * Spawns an internal thread to receive data from the FPGA on channel, channel, 
 * to the recvdata pointer. Up to recvlen bytes will be copied to the recvdata 
 * pointer, possibly over multiple transfers. Therefore, recvdata must 
 * accomodate at least recvlen bytes. Returns 0 on success. The function 
 * fpga_recv_data_end can be used to wait for completion using the same channel.
 * This function will return immediately.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -EAGAIN if an internal thread cannot be created.
 */
int fpga_recv_data_begin(fpga_dev * fpgaDev, int channel, 
	unsigned char * recvdata, int recvlen);

/**
 * Waits for an internal thread created by the fpga_recv_data_begin function to 
 * recieve all data from the FPGA on channel, channel. On success, the number of
 * bytes actually received on the channel are returned. The number of bytes 
 * written to the original recvdata pointer will be the minimum of the returned 
 * value and the original recvlen value (see the fpga_recv_data_begin function).
 * This function will block until all data on the channel is received.
 * The endianness of received data is not changed.
 * On error, returns:
 * -EACCES if the channel is not open.
 * -EINVAL if the thread is not joinable.
 * -ESRCH if no receive thread has been created for the channel.
 * -EDEADLK if deadlock was detected.
 */
int fpga_recv_data_end(fpga_dev * fpgaDev, int channel);


/**
 * Reads the FPGA config space value specified at offset, wordoffset, into the 
 * val pointer. The offset specifies the number of bytes from the start of the 
 * config address space. Returns 0 on success.
 * The endianness of read data is flipped.
 * Note: this function accesses the FPGA config space, so you should know what
 * you're doing when using this.
 * On error, returns:
 * -EFAULT if wordoffset is not within the config space.
 */
int fpga_config_read(fpga_dev * fpgaDev, int offset, unsigned int * val);

/**
 * Writes the value of val to the FPGA config space at offset. The value of 
 * offset specifies the number of bytes from the start of the config address 
 * space. Returns 0 on success.
 * The endianness of written data is filpped.
 * Note: this function accesses the FPGA config space, so you should know what
 * you're doing when using this.
 * On error, returns:
 * -EFAULT if wordoffset is not within the config space.
 */
int fpga_config_write(fpga_dev * fpgaDev, int offset, unsigned int val);

/**
 * Requests a transfer of data from srcaddr to dstaddr on the FPGA of length 
 * len, using channel, channel. All len bytes will be copied in a single 
 * transfer. After the transfer, if doorbell == 1, the IP core connected to the 
 * channel will receive a doorbell with the transfer length (in bytes). If 
 * wait == 1, this function will wait until the transfer has completed before 
 * returning. Otherwise, this function will return immediately after initiating  
 * the transfer. 
 * The endianness of copied data is not changed.
 * Note: this function takes FPGA bus addresses and thus assumes you know what
 * you're doing.
 * Returns 0 on success. On error, returns:
 * -EACCES if the channel is not open.
 * -ETIMEDOUT if timeout is non-zero and expires before all data is received.
 * -EREMOTEIO if the transfer sequence takes too long, data is lost/dropped,
 * or some other error is encountered during transfer.
 * -ERESTARTSYS if a signal interrupts the thread.
 * -ENOMEM if the driver runs out of buffers for data transfers.
 * -EFAULT if internal queues are exhausted or on bad address access.
 */
int fpga_mem_copy(fpga_dev * fpgaDev, int channel, unsigned int srcaddr, 
	unsigned int dstaddr, unsigned int len, int doorbell, int wait);

/**
 * Request a FPGA buffer to be allocated. The address segment will be specified 
 * on success. The remoteAddr a FPGA bus address and can be used with the
 * fpga_mem_copy function. The Returns 0 on success.
 * On error, returns a non-zero value.
 */
int fpga_remote_buf_allocate(fpga_dev * fpgaDev, int channel, int * size, 
	unsigned int * remoteAaddr);


/**
 * Request an internal buffer to be allocated. The address, size, bar, and 
 * segment will be specified on success. The bar and segment are needed to free
 * the buffer after use. The remoteAddr is a FPGA bus address and can be used 
 * with the fpga_mem_copy function. The buf pointer points to the buffer in user
 * space. Returns 0 on success.
 * On error, returns a non-zero value.
 */
int fpga_internal_buf_allocate(fpga_dev * fpgaDev, int channel, int * size, 
	unsigned int * remoteAddr, unsigned char ** buf, int * bar, int * segment);

/**
 * Frees the internal buffer so that it can be used again. The bar and segment 
 * values are returned from the fpga_buf_allocate function and specify the 
 * buffer. Returns 0 on success.
 * On error, returns a non-zero value.
 */
int fpga_internal_buf_free(fpga_dev * fpgaDev, int channel, int bar, 
	int segment);

/**
 * Opens the specified channel. Valid channels are in the range [0,15]. The
 * timeout value sets a threshold in ms for blocking for all channel operations.
 * It is meant to avoid infinite blocking in case of errors. When the timeout is
 * exceeded, the operation returns a failure code. The timeout will not reliably
 * return partial results or execute partial sends of any data. A value of 0
 * indicates an indefinite wait (no timeout). Only non-negative values are 
 * valid. Returns 0 on success.
 * On error, returns:
 * -1 if could not open the virtual file (check errno for details).
 */
int fpga_channel_open(fpga_dev * fpgaDev, int channel, int timeout);

/**
 * Closes the specified channel and releases any internal resources.
 */
void fpga_channel_close(fpga_dev * fpgaDev, int channel);

/**
 * Sets the channel timeout to the new value. The timeout value sets a threshold
 * in ms for blocking for all channel operations. It is meant to avoid infinite 
 * blocking in case of errors. When the timeout is exceeded, the operation 
 * returns a failure code. The timeout will not reliably return partial results 
 * or execute partial sends of any data. A value of 0 indicates an indefinite 
 * wait (no timeout). Only non-negative values are valid. Returns 0 on success.
 * On error, returns a non-zero value.
 */
int fpga_channel_timeout(fpga_dev * fpgaDev, int channel, int timeout);

#ifdef __cplusplus
}
#endif

#endif
