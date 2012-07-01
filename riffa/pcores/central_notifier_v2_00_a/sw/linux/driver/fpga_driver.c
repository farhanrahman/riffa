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
 * Filename: fpga_driver.c
 * Version: 0.9
 * Description: Linux PCIe device driver for RIFFA. Uses Linux kernel APIs in
 *  version 2.6.27+ (tested on version 2.6.32 - 3.3.0).
 * History: @mattj: Initial pre-release. Version 0.9.
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/device.h>
#include <linux/major.h>
#include <linux/err.h>
#include <linux/fs.h>
#include <linux/pci.h>
#include <linux/mm.h>
#include <linux/vmalloc.h>
#include <linux/interrupt.h>
#include <linux/dma-mapping.h>
#include <linux/irq.h>
#include <linux/proc_fs.h>
#include <linux/poll.h>
#include <linux/sched.h>
#include <linux/time.h>
#include <linux/param.h>
#include <asm/uaccess.h>
#include "fpga_driver.h"
#include "circ_queue.h"

MODULE_LICENSE("Dual BSD/GPL");
MODULE_DESCRIPTION("PCIe driver for FPGA (2.6.27+)");
MODULE_AUTHOR("Matt Jacobsen, Patrick Lai");

struct class *mymodule_class;
EXPORT_SYMBOL(mymodule_class);

struct irq_file {
  wait_queue_head_t readwait;
  wait_queue_head_t writewait;
	int channel;
	atomic_t timeout;
	atomic_t bufreqs;
	struct circ_queue * readmsgs;
	struct circ_queue * writemsgs;
	struct circ_queue * buffers;
};

struct fpga_sc {
  unsigned long irq;
  void __iomem *bar0;
  unsigned long bar0_addr;
  unsigned long bar0_len;
  unsigned long bar0_flags;  
  char name[16];
  struct irq_file file[NUM_CHANNEL];
};

atomic_t gBarSegment[NUM_IPIF_BAR][NUM_IPIF_BAR_SEG];
char *gDMABuffer[NUM_IPIF_BAR];
dma_addr_t gDMAHWAddr[NUM_IPIF_BAR];
int gAllocatedBARs;
dev_t devt;
struct fpga_sc *gsc;
static struct proc_dir_entry *proc_dir;
static struct proc_dir_entry *count_file;


///////////////////////////////////////////////////////
// MEMORY ALLOCATION & HELPER FUNCTIONS
///////////////////////////////////////////////////////

/**
 * Filps the endianness of a 4 byte int. Returns the int value flipped.
 */
static inline int flip(int val)
{
  return ( (val & 0x000000FF) << 24 | (val & 0x0000FF00) << 8 | 
					(val & 0x00FF0000) >> 8 | (val & 0xFF000000) >> 24 );
}

/** 
 * Reads the interrupt vector from the FPGA.
 */
static inline unsigned int read_interrupt_vector(void)
{
	// Read the IRQ_REG_OFF. Format is:
	// { PC_send_intr_15-0 (16 bit) | PC_recv_intr_15-0 (16 bit) }
  return flip(readl(gsc->bar0 + IRQ_REG_OFF));
}

/** 
 * Clears the interrupt vector on the FPGA by writing the read vector back.
 */
static inline void clear_interrupt_vector(unsigned int vect)
{
  writel(flip(vect), gsc->bar0 + IRQ_REG_OFF);
}

/** 
 * Reads the recv interrupt 4 byte data from the FPGA for the specified channel.
 */
static inline unsigned int read_intr_info(int channel)
{
	// Read the recv info. Format is:
	// { err (1 bit) | need_buf (1 bit) | transfer_bytes (30 bits) }
  return flip(readl(gsc->bar0 + INTR_INFO_REG_OFF + (CHANNEL_REG_INC*channel)));
}

/** 
 * Reads the send interrupt 4 byte data from the FPGA for the specified channel.
 */
static inline unsigned int read_sent_info(int channel)
{
	// Read the sent info. Format is:
	// { err (1 bit) | doorbell'd (1 bit) | transfer_bytes (30 bits) }
  return flip(readl(gsc->bar0 + SENT_INFO_REG_OFF + (CHANNEL_REG_INC*channel)));
}

/** 
 * Returns the FPGA addr for the specified buffer.
 */
static inline unsigned int get_buffer_addr(int bar, int segment)
{
	return (IPIF_BAR_ADDR + (IPIF_BAR_ADDR_INC*bar) + (BUF_SIZE*segment));
}

/** 
 * Returns the FPGA addr/size info for the specified buffer.
 */
static inline unsigned int get_buffer_info(int bar, int segment)
{
	return (get_buffer_addr(bar, segment) | LOG_BUF_SIZE);
}

/** 
 * Reads the FPGA buffer allocation info from the FPGA for the specified channel.
 */
static inline unsigned int read_buffer_info(int channel)
{
	// Read from the BUF_INFO_REG_OFF. Format is:
	// { addr_shift (27 bits) | log2_size (5 bits) }
	return flip(readl(gsc->bar0 + BUF_INFO_REG_OFF + (CHANNEL_REG_INC*channel)));
}

/** 
 * Sends the PC buffer allocation info to the FPGA for the specified channel.
 */
static inline void send_buffer_info(int channel, unsigned int bufinfo)
{
	// Write to the BUF_INFO_REG_OFF. Format is:
	// { addr_shift (27 bits) | log2_size (5 bits) }
	writel(flip(bufinfo), gsc->bar0 + BUF_INFO_REG_OFF + (CHANNEL_REG_INC*channel));
}

/** 
 * Sends a doorbell to the FPGA for the specified channel. An error is signaled
 * if err == 1.
 */
static inline void send_doorbell(int channel, int err)
{
	// Write to the DMA_LEN_REG_OFF for starting transfers. Format is:
	// { err (1 bit) | doorbell (1 bit) | transfer_bytes (30 bits) }
	writel(flip(err<<31 | 1<<30), gsc->bar0 + DMA_LEN_REG_OFF + 
		(CHANNEL_REG_INC*channel));
}

/** 
 * Sends a "function call" style 4 byte argument to the FPGA for the specified 
 * channel.
 */
static inline void send_arg(int channel, int argnum, unsigned int arg)
{
	writel(flip(arg), gsc->bar0 + SENT_ARG_REG_OFF + (CHANNEL_REG_INC*channel) + 
		(argnum*SENT_ARG_REG_INC));
}

/** 
 * Sends parameters to initiate a DMA transfer to the FPGA for the specified 
 * channel.
 */
static inline void transfer_data(int channel, unsigned int srcaddr, 
	unsigned int dstaddr, unsigned int len, int err, int signal)
{
	// Write to the DMA_REG_OFF to set src, dst, & len. Formats are:
	// src: { src_addr (32 bits) }
	// dst: { dst_addr (32 bits) }
	// len: { err (1 bit) | doorbell (1 bit) | transfer_bytes (30 bits) }
	writel(flip(srcaddr), gsc->bar0 + DMA_SRC_REG_OFF + (CHANNEL_REG_INC*channel));
	writel(flip(dstaddr), gsc->bar0 + DMA_DST_REG_OFF + (CHANNEL_REG_INC*channel));
	writel(flip(err<<31 | signal<<30 | (len & 0x3FFFFFFF)), 
		gsc->bar0 + DMA_LEN_REG_OFF + (CHANNEL_REG_INC*channel));
}

/** 
 * Allocates a BUF_SIZE sized chunk of BAR memory. Returns 0 on success, 
 * non-zero if no memory is available. Upon success, the bar & segment values 
 * will be set according to the allocated memory location.
 */
static inline int allocate_buffer(int * bar, int * segment)
{
	int b, s;
	for (b = 0; b < gAllocatedBARs; b++) {
		for (s = 0; s < NUM_IPIF_BAR_SEG; s++) {
			if (!atomic_xchg(&gBarSegment[b][s], 1)) {
				*bar = b;
				*segment = s;
				return 0;
			}
		}
	}
	return 1;
}


/** 
 * Frees the specified BAR memory. Returns 0 upon success, non-zero otherwise.
 */
static inline int free_buffer(int bar, int segment)
{
	int i;

	if (bar >= 0 && bar < gAllocatedBARs && segment >= 0 && segment < NUM_IPIF_BAR_SEG) {
		if (atomic_xchg(&gBarSegment[bar][segment], 0) == 1) {
			for (i = 0; i < NUM_CHANNEL; ++i)
				wake_up(&gsc->file[i].readwait);
			return 0;
		}
		else {
			return -EFAULT;
		}
	}
	else {
		return -EINVAL;
	}
}

/**
 * Releases all buffers in the specified circ_queue.
 */
static inline void free_buffers(struct irq_file *irqfile)
{
	int bar, segment;

	while (!pop_circ_queue(irqfile->buffers, &bar, &segment))
		free_buffer(bar, segment);
}


///////////////////////////////////////////////////////
// INTERRUPT HANDLER
///////////////////////////////////////////////////////

/**
 * Interrupt handler for all interrupts on all files. Reads data/values
 * from FPGA and wakes up waiting threads to process the data.
 */
static irqreturn_t intrpt_handler(int irq, void *dev_id) {
  int i, bar, segment;
	unsigned int irqreg, info;
	struct irq_file *irqfile;

	// Validate that this is our interrupt to handle
	if (dev_id != gsc) {
		printk(KERN_INFO "intrpt_handler received interrupt not intended for FPGA driver.\n");
		return IRQ_NONE;
	}

	// Read the IRQ_REG_OFF. Format is:
	// { PC_send_intr_15-0 (16 bit) | PC_recv_intr_15-0 (16 bit) }
  irqreg = read_interrupt_vector();

  // Examine each bit for data received.
  for (i = 0; i < NUM_CHANNEL; ++i) {
    if (irqreg & (1<<i)) {
			// For each bit, read the corresponding interrupt info word. Format is:
			// { err (1 bit) | need_buf (1 bit) | transfer_bytes (30 bits) }
			irqfile = &gsc->file[i];
			info = read_intr_info(irqfile->channel);
			if (info & 0x40000000) { // Needs a buffer?
				if (allocate_buffer(&bar, &segment)) {
					atomic_inc(&irqfile->bufreqs);
				}
				else {
					// EVENT_BUF_ALLOCATE format:
					// { bar (16 bit) | segment (16 bits) }
					if (push_circ_queue(irqfile->readmsgs, EVENT_BUF_ALLOCATE, (bar<<16 | segment))) {
						printk(KERN_ERR "intrpt_handler, msg queue full for irq %d\n", irqfile->channel);
						send_buffer_info(irqfile->channel, 0); // 0 == error.
						if (free_buffer(bar, segment))
							printk(KERN_ERR "intrpt_handler cannot free buffer: %d %d.\n", bar, segment);
					}
					else {
						send_buffer_info(irqfile->channel, get_buffer_info(bar, segment));
					}
				}
			}
			else {
				// Pump this data event to the thread.
				if (push_circ_queue(irqfile->readmsgs, EVENT_DATA_RECV, info))
					printk(KERN_ERR "intrpt_handler, msg queue full for irq %d\n", irqfile->channel);
			}
			// Wake up the thread.
	    wake_up(&irqfile->readwait);
		}
	}

  // Examine each bit for data sent.
  for (i = 0; i < NUM_CHANNEL; ++i) {
    if (irqreg & (1<<(NUM_CHANNEL+i))) {
			// For each bit, read the sent info.
			irqfile = &gsc->file[i];
			info = read_sent_info(irqfile->channel);
			// Pump this data event to the thread.
			if (push_circ_queue(irqfile->writemsgs, EVENT_DATA_SENT, info))
				printk(KERN_ERR "intrpt_handler, msg queue full for irq %d\n", irqfile->channel);
			// Wake up the thread.
	    wake_up(&irqfile->writewait);
		}
	}

  // Acknowledge/clear the irq request.
	clear_interrupt_vector(irqreg);

  //printk(KERN_INFO "Interrupt called on irq: %d, with val: %08x\n", irq, irqreg);
  return IRQ_HANDLED;
}


///////////////////////////////////////////////////////
// IRQ PROC FILE HANDLERS
///////////////////////////////////////////////////////
/**
 * Attempts to read a message out of the readmsgs circ_queue and reads the 
 * current value of the bufreqs counter. Returns 0 if a message was retrieved or
 * the bufreqs counter is greater than zero. Returns non-zero otherwise.
 */
static inline int readmsgs(struct irq_file *irqfile, unsigned int * msg,
	unsigned int * info, unsigned int * bufreqs, int * nomsg)
{
	*bufreqs = (unsigned int)atomic_read(&irqfile->bufreqs);
	*nomsg = pop_circ_queue(irqfile->readmsgs, msg, info);

	return ((*nomsg) && (*bufreqs) == 0);
}

/**
 * Reads data from the FPGA. Will block until all the data is received from the
 * FPGA unless a non-zero timeout is configured. Then the function will block 
 * until the timeout expires. On success, the received data will be copied into 
 * the user buffer, up to len bytes. The number of bytes received are returned. 
 * Error return values:
 * -ETIMEDOUT: if timeout is non-zero and expires before all data is received.
 * -EREMOTEIO: if the transfer sequence takes too long, data is lost/dropped,
 * or some other error is encountered during transfer.
 * -ERESTARTSYS: if a signal interrupts the thread.
 * -ENOMEM: if the driver runs out of buffers for data transfers.
 * -EFAULT: if internal queues are exhausted or on bad address access.
 */
static ssize_t irq_proc_read(struct file *filp, char  __user *bufp, size_t len, loff_t *ppos)
{
  struct irq_file *irqfile = (struct irq_file *)filp->private_data;
  long timeout;
	int nodata, nomsg;
	int bar, segment;
	unsigned int msg, info, bufreqs;
	unsigned int amt = 0;
	int copyd = 0;
	int recvd = 0;

  DEFINE_WAIT(wait);

	// Read timeout & convert to jiffies.
	timeout = (long)atomic_read(&irqfile->timeout);
	timeout = (timeout == 0 ? MAX_SCHEDULE_TIMEOUT : timeout * HZ/1000);

	while (1) {
		// Loop until we get a message, need to allocate a buffer, or timeout.
		while ((nodata = readmsgs(irqfile, &msg, &info, &bufreqs, &nomsg))) {
			prepare_to_wait(&irqfile->readwait, &wait, TASK_INTERRUPTIBLE);
			// Another check before we schedule.
			if ((nodata = readmsgs(irqfile, &msg, &info, &bufreqs, &nomsg)))
				timeout = schedule_timeout(timeout);
			finish_wait(&irqfile->readwait, &wait);
			if (signal_pending(current))
				return -ERESTARTSYS;
			if (!nodata)
				break;
			if (timeout == 0) {
				printk(KERN_ERR "irq_proc_read timed out.\n");
				free_buffers(irqfile);
				return -ETIMEDOUT;
			}
		}

		if (bufreqs > 0) {
			// Allocate buffer.
			if (!allocate_buffer(&bar, &segment)) {
				if (push_circ_queue(irqfile->buffers, bar, segment)) {
					printk(KERN_ERR "irq_proc_read cannot save buf info, queue full.\n");
					send_buffer_info(irqfile->channel, 0); // 0 == error.
					if (free_buffer(bar, segment))
						printk(KERN_ERR "irq_proc_read cannot free buffer: %d %d.\n", bar, segment);
					return -EFAULT;
				}
				else {
					// Send the allocation info.
					atomic_dec(&irqfile->bufreqs);
					send_buffer_info(irqfile->channel, get_buffer_info(bar, segment));
				}
			}
		}

		if (!nomsg) {
			// Process the message.
			switch (msg) {
			case EVENT_DATA_RECV: 
				// { err (1 bit) | need_buf (1 bit) | transfer_bytes (30 bits) }
				if (info & 0x80000000) { // Error?
					printk(KERN_ERR "irq_proc_read encountered remote i/o error.\n");
					free_buffers(irqfile);
					return -EREMOTEIO;
				}
				if (info & 0x40000000) { // Needed a buffer?
					// A EVENT_BUF_ALLOCATE will be in the queue for this.
					// need_buf requests will never have a non-zero transfer_bytes value.
					break;
				}
				amt = (info & 0x3FFFFFFF);
				if (amt) { // Data != 0 
					if (pop_circ_queue(irqfile->buffers, &bar, &segment)) { 
						printk(KERN_ERR "irq_proc_read cannot find allocated buffer in queue.\n");
						send_doorbell(irqfile->channel, 1);
						return -EFAULT;
					}
					// Copy received data to the user buffer (if necessary/possible).
					recvd += amt;
					amt = (len-copyd < amt ? len-copyd : amt);
					if (amt > 0) {
						if (copy_to_user(bufp+copyd, gDMABuffer[bar] + segment*BUF_SIZE, amt)) {
							printk(KERN_ERR "irq_proc_read cannot copy to user buffer.\n");
							send_doorbell(irqfile->channel, 1);
							if (free_buffer(bar, segment))
								printk(KERN_ERR "irq_proc_read cannot free buffer: %d %d.\n", bar, segment);
							return -EFAULT;
						}
						copyd += amt;
					}
					// Free the buf.
					if (free_buffer(bar, segment)) {
						printk(KERN_ERR "irq_proc_read cannot free buffer: %d %d.\n", bar, segment);
						return -EFAULT;
					}
				}
				else { // Data == 0
					// Return the amount received.
					return recvd;
				}
				break;
			case EVENT_BUF_ALLOCATE:
				// { bar (15 bit) | segment (16 bits) }
				if (push_circ_queue(irqfile->buffers, (info>>16) & 0xFFFF, info & 0xFFFF)) {
					printk(KERN_ERR "irq_proc_read cannot save allocated buf info, queue full.\n");
					return -EFAULT;
				}
				break;
			default: 
				printk(KERN_ERR "irq_proc_read unexpectedly received msg type %d\n", msg);
				break;
			}
		}
	}
  return 0;
}

/**
 * Acquires a FPGA buffer and issues a data transfer request using the specified
 * PC buffer and the FPGA buffer addresses on the specified channel. Returns the
 * number of bytes transferred or a negative value in the event of error.
 */
static inline int write_data(struct irq_file *irqfile, const char  __user *bufp,
	int bar, int segment, int len, int copyd)
{
	unsigned int info, addr, size;
	unsigned int amt = 0;

	// Buffer info is encoded as:
	// { addr_shift (27 bits) | log2_size (5 bits) }
	info = read_buffer_info(irqfile->channel); 
	if (!info) { // 0 indicates error.
		printk(KERN_ERR "irq_proc_write received bad fpga buffer: %x.\n", info);
		return -EREMOTEIO;
	}
	addr = (info & 0xFFFFFFE0);
	size = (1<<(info & 0x1F));

	// Copy data to buf.
	amt = (len-copyd < size ? len-copyd : size);
	amt = (BUF_SIZE < amt ? BUF_SIZE : amt);
	if (amt > 0) {
		if (copy_from_user(gDMABuffer[bar] + segment*BUF_SIZE, bufp+copyd, amt)) {
			printk(KERN_ERR "irq_proc_write cannot read user buffer.\n");
			return -EFAULT;
		}
	}
	// Transfer buf data to FPGA.
	transfer_data(irqfile->channel, get_buffer_addr(bar, segment), addr, amt, 0, 
		1); 

	return amt;
}

/**
 * Writes data to the FPGA. Will block until all the data is sent to the FPGA
 * unless a non-zero timeout is configured. Then the function will block until 
 * the timeout expires. On success, the user data will be copied from the user 
 * buffer, up to len bytes, and sent to the FPGA. The number of byte sent are 
 * returned. 
 * When writing to the file, the length parameter must encode whether we are 
 * sending args, if this is a doorbell request, error, and the actual length. 
 * The format is:
 * { A (30 bits) | B (1 bit) | C (1 bit) }
 * If A == 0:
 *   BC == 00: request to just wait for a EVENT_DATA_SENT msg.
 *   BC == 01: invalid.
 *   BC == 10: request to doorbell the IP core with no error.
 *   BC == 11: request to doorbell the IP core with error.
 * If A != 0:
 *   BC == 00: write A bytes to FPGA, doorbell after every transfer with num bytes transferred.
 *   BC == 01: invalid.
 *   BC == 10: write A args to FPGA, no doorbells.
 *   BC == 11: invalid.
 * Error return values:
 * -ETIMEDOUT: if timeout is non-zero and expires before all data is received.
 * -EREMOTEIO: if the transfer sequence takes too long, data is lost/dropped,
 * or some other error is encountered during transfer.
 * -ERESTARTSYS: if a signal interrupts the thread.
 * -ENOMEM: if the driver runs out of buffers for data transfers.
 * -EFAULT: if internal queues are exhausted or on bad address access.
 */
static ssize_t irq_proc_write(struct file *filp, const char  __user *bufp, size_t len, loff_t *ppos)
{
  struct irq_file *irqfile = (struct irq_file *)filp->private_data;
  long timeout;
	int i, rtn, nomsg, length, doorbell, err, sendargs;
	int bar = -1;
	int segment = -1;
	unsigned int msg, info;
	int copyd = 0;

  DEFINE_WAIT(wait);

	// Read timeout once & convert to jiffies.
	timeout = (long)atomic_read(&irqfile->timeout);
	timeout = (timeout == 0 ? MAX_SCHEDULE_TIMEOUT : timeout * HZ/1000);

	// Parse the len value.
	length = (len>>2);
	doorbell = (length == 0 && (len & 0x2));
	err = (len & 0x1);
	sendargs = (length != 0 && (len & 0x2));

	//printk(KERN_ERR "irq_proc_write length:%d doorbell:%d err:%d sendargs:%d.\n", length, doorbell, err, sendargs);

	if (sendargs) { // Write arguments
		// In this case length should correspond to number of words, not bytes.
		for (i = 0; i < length && i < 2; i++) {
			if (copy_from_user(&info, bufp+(i*4), 4)) {
				printk(KERN_ERR "irq_proc_write cannot read user buffer.\n");
				send_doorbell(irqfile->channel, 1);
				return -EFAULT;
			}
			send_arg(irqfile->channel, i, info);
		}
		return i*4;
	}

	if (doorbell) { // Doorbell request
		send_doorbell(irqfile->channel, err);
		return 0;
	}

	if (length > 0) { // Need to transfer data.
		if (allocate_buffer(&bar, &segment)) { // Get a buffer.
			printk(KERN_ERR "irq_proc_write cannot allocate a buffer, all used.\n");
			send_doorbell(irqfile->channel, 1);
			return -ENOMEM;
		}
	}

	// Send initial transfer request.
	if (copyd < length) {
		if ((rtn = write_data(irqfile, bufp, bar, segment, length, copyd)) < 0) {
			free_buffer(bar, segment);
			send_doorbell(irqfile->channel, 1);
			return rtn;
		}
		copyd += rtn;
	}

	while (1) {
		// Loop until we get a message or timeout.
		while ((nomsg = pop_circ_queue(irqfile->writemsgs, &msg, &info))) {
			prepare_to_wait(&irqfile->writewait, &wait, TASK_INTERRUPTIBLE);
			// Another check before we schedule.
			if ((nomsg = pop_circ_queue(irqfile->writemsgs, &msg, &info)))
				timeout = schedule_timeout(timeout);
			finish_wait(&irqfile->writewait, &wait);
			if (signal_pending(current))
				return -ERESTARTSYS;
			if (!nomsg)
				break;
			if (timeout == 0) {
				printk(KERN_ERR "irq_proc_write timed out.\n");
				free_buffer(bar, segment);
				send_doorbell(irqfile->channel, 1);
				return -ETIMEDOUT;
			}
		}

		// Process the message.
		switch (msg) {
		case EVENT_DATA_SENT:
			// { err (1 bit) | doorbell'd (1 bit) | transfer_bytes (30 bits) }
			if (info & 0x80000000) { // Error?
				printk(KERN_ERR "irq_proc_write encountered remote i/o error.\n");
				free_buffer(bar, segment);
				return -EREMOTEIO;
			}
			if (copyd < length) {
				// Initiate next data transfer.
				if ((rtn = write_data(irqfile, bufp, bar, segment, length, copyd)) < 0) {
					free_buffer(bar, segment);
					send_doorbell(irqfile->channel, 1);
					return rtn;
				}
				copyd += rtn;
			}
			else {
				free_buffer(bar, segment);
				return copyd;
			}
			break;
		default: 
			printk(KERN_ERR "irq_proc_write unexpectedly received msg type %d\n", msg);
			break;
		}
	}
  return 0;
}

/**
 * Called to set the timeout value, allocate a buffer, and release
 * a buffer. Return value depends on ioctlnum and expected behavior.
 */
static long irq_proc_ioctl(struct file *filp, unsigned int ioctlnum, 
	unsigned long ioctlparam)
{
  struct irq_file *irqfile = (struct irq_file *)filp->private_data;
	int bar, segment;
	unsigned int info;

	switch (ioctlnum) {
		case IOCTL_GET_TIMEOUT:
			put_user(atomic_read(&irqfile->timeout), (int *)ioctlparam);
			break;
		case IOCTL_SET_TIMEOUT:
			atomic_set(&irqfile->timeout, (int)ioctlparam);
			break;
		case IOCTL_ALLC_PC_BUF:
			if (allocate_buffer(&bar, &segment))
				return -ENOMEM;
			put_user(bar, (int *)ioctlparam);
			put_user(segment, ((int *)ioctlparam) + 1);
			break;
		case IOCTL_FREE_PC_BUF:
			get_user(bar, (int *)ioctlparam);
			get_user(segment, ((int *)ioctlparam) + 1);
			if (free_buffer(bar, segment))
				return -EFAULT;
			break;
		case IOCTL_GET_FPGA_BUF:
			info = read_buffer_info(irqfile->channel);
			if (!info)
				return -EREMOTEIO;
			put_user(info, (unsigned int *)ioctlparam);
			break;
	}
	return 0;
}

/**
 * Sets the virtual file pointers for the opened file struct. Returns 0.
 */
static int irq_proc_open(struct inode *inop, struct file *filp)
{
  int i;
  struct proc_dir_entry *ent;
  //struct irq_file *irqfile;

  ent = PDE(inop);
  i = (unsigned long)ent->data;
  filp->private_data = (void *)&gsc->file[i];

	// Send reset when the channel is opened in case the previous access left the
	// FPGA channel in a bad state?
  //irqfile = (struct irq_file *)&gsc->file[i];
	//send_doorbell(irqfile->channel, 1);
	
  return 0;
}

/**
 * Clears the virtual file pointers for the opened file struct. Returns 0.
 */
static int irq_proc_release(struct inode *inop, struct file *filp)
{
  (void)inop;
  filp->private_data = NULL;
  return 0;
}


///////////////////////////////////////////////////////
// FPGA DEVICE HANDLERS
///////////////////////////////////////////////////////

static int fpga_probe(struct pci_dev *dev, const struct pci_device_id *id) {
  int i, j, error, irqreg;
  struct fpga_sc *sc;
   
  // Setup the PCIe device.
  error = pci_enable_device(dev);
  if (error < 0) {
    printk(KERN_ERR "pci_enable_device returned %d\n", error);
    return (-ENODEV);
  }
	
  // Allocate necessary structures.
  sc = kzalloc(sizeof(*sc), GFP_KERNEL);
  if (sc == NULL) {
    printk(KERN_ERR "Not enough memory to allocate sc");
    pci_disable_device(dev);
    return (-ENOMEM);
  }
  memset(sc, 0, sizeof(*sc));
  snprintf(sc->name, sizeof(sc->name), "%s%d", pci_name(dev), 0);

	// Create irq_file structs.
  for (i = 0; i < NUM_CHANNEL; ++i) {
    init_waitqueue_head(&sc->file[i].readwait);
    init_waitqueue_head(&sc->file[i].writewait);
		atomic_set(&sc->file[i].timeout, 0);
		atomic_set(&sc->file[i].bufreqs, 0);
    sc->file[i].channel = i;
  }
  for (i = 0; i < NUM_CHANNEL; ++i) {
		if ((sc->file[i].readmsgs = init_circ_queue(READ_QUEUE_DEPTH)) == NULL) {
			for (j = i-1; j >= 0; j--)
				free_circ_queue(sc->file[j].readmsgs);
		  pci_disable_device(dev);
			kfree(sc);
		  return (-ENOMEM);
		}
  }
  for (i = 0; i < NUM_CHANNEL; ++i) {
		if ((sc->file[i].writemsgs = init_circ_queue(WRITE_QUEUE_DEPTH)) == NULL) {
			for (j = 0; j < NUM_CHANNEL; ++j)
				free_circ_queue(sc->file[j].readmsgs);
			for (j = i-1; j >= 0; j--)
				free_circ_queue(sc->file[j].writemsgs);
		  pci_disable_device(dev);
			kfree(sc);
		  return (-ENOMEM);
		}
  }
  for (i = 0; i < NUM_CHANNEL; ++i) {
		if ((sc->file[i].buffers = init_circ_queue(BUF_QUEUE_DEPTH)) == NULL) {
			for (j = 0; j < NUM_CHANNEL; ++j)
				free_circ_queue(sc->file[j].readmsgs);
			for (j = 0; j < NUM_CHANNEL; ++j)
				free_circ_queue(sc->file[j].writemsgs);
			for (j = i-1; j >= 0; j--)
				free_circ_queue(sc->file[j].buffers);
		  pci_disable_device(dev);
			kfree(sc);
		  return (-ENOMEM);
		}
  }
  printk(KERN_INFO "FPGA PCIe endpoint name: %s\n", sc->name);

  // Setup the memory regions
  error = pci_request_regions(dev, sc->name);
  if (error < 0) {
    printk(KERN_ERR "pci_request_regions returned %d\n", error);
    pci_disable_device(dev);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].readmsgs);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].writemsgs);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].buffers);
    kfree(sc);
    return (-ENODEV);
  }
	
	// PCI BAR 0
  sc->bar0_addr = pci_resource_start(dev, 0);
  sc->bar0_len = pci_resource_len(dev, 0);
  sc->bar0_flags = pci_resource_flags(dev, 0);
  sc->bar0 = ioremap(sc->bar0_addr, sc->bar0_len);
  printk(KERN_INFO "BAR 0 address: %lx\n", sc->bar0_addr);
  printk(KERN_INFO "BAR 0 length: %ld\n", sc->bar0_len);

  // Setup MSI interrupts 
  error = pci_enable_msi(dev);
  if (error != 0) {
    printk(KERN_ERR "pci_enable_msi failed, returned %d\n", error);
    if (sc->bar0) 
			iounmap(sc->bar0);
    pci_release_regions(dev);
    pci_disable_device(dev);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].readmsgs);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].writemsgs);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].buffers);
    kfree(sc);
    return error;
  }
  error = request_irq(dev->irq, intrpt_handler, 0, sc->name, sc);
  if (error != 0) {
    printk(KERN_ERR "request_irq(%d) failed, returned %d\n", dev->irq, error);
    if (sc->bar0) 
			iounmap(sc->bar0);
    pci_release_regions(dev);
    pci_disable_device(dev);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].readmsgs);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].writemsgs);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].buffers);
    kfree(sc);
    return error;
  }
  sc->irq = dev->irq;
  printk(KERN_INFO "MSI setup on irq %d\n", dev->irq);

  // Allocate the DMA buffers and get the addresses.
	gAllocatedBARs = 0;
	for (i = 0; i < NUM_IPIF_BAR; i++) {
		for (j = 0; j < NUM_IPIF_BAR_SEG; j++)
			atomic_set(&gBarSegment[i][j], 0);
	}
	for (i = 0; i < NUM_IPIF_BAR; i++) {
	  gDMABuffer[i] = pci_alloc_consistent(dev, IPIF_BAR_SIZE, &(gDMAHWAddr[i]));
		if (gDMABuffer[i] == NULL) {
		  printk(KERN_ERR "pci_alloc_consistent() failed for DMA buffer %d\n", i);
			break;
		}
		if ( (((unsigned long)gDMAHWAddr[i]) & (IPIF_BAR_SIZE-1)) > 0 )
			printk(KERN_ERR "gDMAHWBuffer %d not aligned on IPIF_BAR_SIZE boundary\n", i);
		printk(KERN_INFO "gDMABuffer %d: %p -> %p\n", i, gDMABuffer[i], (void *)gDMAHWAddr[i]);
		// Write the HW address for the allocated DMA buffer to the FPGA.
		writel(flip(gDMAHWAddr[i]), sc->bar0 + IPIF_BAR_HW_REG_OFF + (i*IPIF_BAR_HW_REG_INC));
		// Keep track of the number of IPIF BARs we allocate.
		gAllocatedBARs++;
	}

	// Fail if we could not map any IPIF BARs.
	if (gAllocatedBARs == 0) {
		printk(KERN_ERR "ERROR, pci_alloc_consistent() failed for all DMA buffers.\n");
		if (sc->bar0) 
			iounmap(sc->bar0);
		pci_release_regions(dev);
		pci_disable_device(dev);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].readmsgs);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].writemsgs);
		for (j = 0; j < NUM_CHANNEL; ++j)
			free_circ_queue(sc->file[j].buffers);
		kfree(sc);
		return -1;
	}

  // Save pointer to structure 
  pci_set_drvdata(dev, sc);
  gsc = sc;

  // Clear any pending interrupts. DO THIS LAST. 
  if ((irqreg = flip(readl(sc->bar0 + IRQ_REG_OFF))) > 0) {
    writel(flip(irqreg), sc->bar0 + IRQ_REG_OFF);
    printk(KERN_INFO "Cleared pending interrupt: %08x\n", irqreg);
  }

  return 0;
}

static void fpga_remove(struct pci_dev *dev) {
  struct fpga_sc *sc;
	int i;

  // Free memory allocated to our Endpoint
	for (i = 0; i < gAllocatedBARs; i++)
	  pci_free_consistent(dev, IPIF_BAR_SIZE, gDMABuffer[i], gDMAHWAddr[i]);
  
  sc = pci_get_drvdata(dev);
  if (sc == NULL) {
    return;
  }
  
  if (sc->bar0)
    iounmap(sc->bar0);
  free_irq(dev->irq, sc);
  pci_disable_msi(dev);
  pci_release_regions(dev);
  pci_disable_device(dev);
	for (i = 0; i < NUM_CHANNEL; ++i)
		free_circ_queue(sc->file[i].readmsgs);
	for (i = 0; i < NUM_CHANNEL; ++i)
		free_circ_queue(sc->file[i].writemsgs);
	for (i = 0; i < NUM_CHANNEL; ++i)
		free_circ_queue(sc->file[i].buffers);
  kfree(sc);
  pci_set_drvdata(dev, NULL);
}


///////////////////////////////////////////////////////
// DEV FILE HANDLERS
///////////////////////////////////////////////////////

static int xc_open(struct inode *inode, struct file *filp)
{
  try_module_get(THIS_MODULE);
	filp->private_data = (void *)gsc; 
  return 0;
}

static int xc_release(struct inode *inode, struct file *filp)
{
  module_put(THIS_MODULE);
	filp->private_data = NULL;
  return 0;
}

static int xc_mmap(struct file *filp, struct vm_area_struct *vma)
{
	// We can only mmap contiguous memory regions. So each mapping call can only 
	// map regions within either the PCI_BAR_0 or IPIF_BARs. Use the page offset 
	// in the vma to determine which to map. Note that the caller must know the 
	// sizes of each region. The PCI_BAR_0 is always 8KB == 2 pages and IPIF_BARs
	// are always 4MB = 1024 pages. The caller will treat the different memory
	// regions as one large contiguous address space in the vma, with PCI_BAR_0 
	// first, followed by each IPIF_BAR region.
  struct fpga_sc * sc = (struct fpga_sc *)filp->private_data;
	unsigned long off = (vma->vm_pgoff<<PAGE_SHIFT);
	unsigned long len = vma->vm_end - vma->vm_start;
	unsigned long addr;
	int i;

	if (off < sc->bar0_len) {
		// Map PCI BAR 0.
		addr = ((unsigned long)sc->bar0_addr) >> PAGE_SHIFT;
		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
		if (remap_pfn_range(vma, vma->vm_start, addr, len, PAGE_SHARED) != 0) {
		  printk(KERN_INFO "Couldn't mmap PCI BAR 0 memory.\n");
		  return -EAGAIN;
		}
		return 0;
	}
	else {
		for (i = 0; i < gAllocatedBARs; i++) {
			if (off < ((IPIF_BAR_SIZE*(i+1)) + sc->bar0_len)) {
				// Map DMA IPIF_BAR region.
				addr = (((unsigned long)virt_to_phys((void *)gDMABuffer[i])) >> PAGE_SHIFT);
				vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
				if (remap_pfn_range(vma, vma->vm_start, addr, len, PAGE_SHARED) != 0) {
					printk(KERN_INFO "Couldn't mmap IPIF BAR %d memory.\n", i);
					return -EAGAIN;
				}
				return 0;
			}
		}
	}
  
  return -EAGAIN;
}

///////////////////////////////////////////////////////
// MODULE INIT/EXIT FUNCTIONS
///////////////////////////////////////////////////////

struct pci_device_id fpga_ids[] = {
  {PCI_DEVICE(VENDOR_ID, DEVICE_ID)},
  {0},
};

//MODULE_DEVICE_TABLE(pci, fpga_ids);
struct pci_driver fpga_driver = {
  .name 	= DEVICE_NAME,
  .id_table	= fpga_ids,
  .probe	= fpga_probe,
  .remove	= fpga_remove
};

static const struct file_operations fpga_fops = {
  .owner       	= THIS_MODULE,
  .open					= xc_open,
  .release			= xc_release,
  .mmap					= xc_mmap,
};

static struct file_operations irq_proc_file_operations = {
  .owner        = THIS_MODULE,
  .read         = irq_proc_read,
  .write        = irq_proc_write,
  .open         = irq_proc_open,
  .release      = irq_proc_release,
	.unlocked_ioctl	= irq_proc_ioctl,
};

static int fpga_init(void) {	
  /* Register the PCIe endppoint */
  int i, error;
  char buf[20];

  error = pci_register_driver(&fpga_driver);
  if (error != 0) {
    printk(KERN_INFO "pci_module_register returned %d", error);
    return (error);
  }
  
  error = register_chrdev(MAJOR_NUM, DEVICE_NAME, &fpga_fops);
  if (error < 0) {
    printk(KERN_INFO "register_chrdev() returned %d", error);
    return (error);
  }
  
  mymodule_class = class_create(THIS_MODULE, DEVICE_NAME);
  if (IS_ERR(mymodule_class)) {
    error = PTR_ERR(mymodule_class);
    printk(KERN_INFO "class_create() returned %d", error);
  }
  
  devt = MKDEV(MAJOR_NUM, 0);
  device_create(mymodule_class, NULL, devt, "%s", DEVICE_NAME);

  /* create the proc directory */
  proc_dir = proc_mkdir(DEVICE_NAME, NULL);
  if(proc_dir == NULL)
    return -ENOMEM;
  
  /* create the irq files */
  for (i = 0; i < NUM_CHANNEL; ++i) {
    sprintf(buf, "%s%02d", IRQ_FILE, i);
    count_file = create_proc_entry(buf, 0666, proc_dir);
    if(count_file == NULL) {
      remove_proc_entry(DEVICE_NAME, NULL);
      return -ENOMEM;
    }
    count_file->data = (void *)(unsigned long)i;
    count_file->read_proc = NULL;
    count_file->write_proc = NULL;
    count_file->proc_fops = &irq_proc_file_operations;
  }
  return (0);
}

static void fpga_exit(void) {
  int i;
  char buf[20];

  device_destroy(mymodule_class, devt); 
  class_destroy(mymodule_class);
  pci_unregister_driver(&fpga_driver);
  
  unregister_chrdev(MAJOR_NUM, DEVICE_NAME);
  for (i = 0; i < NUM_CHANNEL; ++i) {
    sprintf(buf, "%s%02d", IRQ_FILE, i);
    remove_proc_entry(buf, proc_dir);
  }
  remove_proc_entry(DEVICE_NAME, NULL);
}

module_init(fpga_init);
module_exit(fpga_exit);

