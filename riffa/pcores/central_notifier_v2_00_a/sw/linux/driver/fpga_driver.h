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
 * Filename: fpga_driver.h
 * Version: 0.9
 * History: @mattj: Initial pre-release. Version 0.9.
 */

#ifndef FPGA_DRIVER_H
#define FPGA_DRIVER_H

#include <linux/ioctl.h>

/* 
 * The major device number. We can't rely on dynamic 
 * registration any more, because ioctls need to know 
 * it. 
 */
#define MAJOR_NUM 100

/* Prefix for the interrupt files. */
#define IRQ_FILE "irqnotify"

/* 
 * Set the message of the device driver 
 */
#define IOCTL_GET_TIMEOUT _IOR(MAJOR_NUM, 1, int *)
#define IOCTL_SET_TIMEOUT _IOR(MAJOR_NUM, 2, int)
#define IOCTL_ALLC_PC_BUF _IOR(MAJOR_NUM, 3, int *)
#define IOCTL_FREE_PC_BUF _IOR(MAJOR_NUM, 4, int *)
#define IOCTL_GET_FPGA_BUF _IOR(MAJOR_NUM, 5, unsigned int *)
/*
 * _IOR means that we're creating an ioctl command 
 * number for passing information from a user process
 * to the kernel module. 
 *
 * The first arguments, MAJOR_NUM, is the major device 
 * number we're using.
 *
 * The second argument is the number of the command 
 * (there could be several with different meanings).
 *
 * The third argument is the type we want to get from 
 * the process to the kernel.
 */

/* 
 * The name of the device file 
 */
#define DEVICE_NAME "fpga"

/* These parameters need to be changed to reflect the specific card 
   with which we are communicating. To find the relevant information, 
   open the EDK project system.mhs file and look for the block:
BEGIN plbv46_pcie
 ...
 PARAMETER C_DEVICE_ID = 0x0506
 PARAMETER C_VENDOR_ID = 0x10EE
 ...
END
*/
#define VENDOR_ID 0x10EE
#define DEVICE_ID 0x0509

/*
 * Size definitions.
 */
#define PCI_BAR_0_SIZE          (8*1024)	// size of FPGA PCI BAR 0 config region
#define IPIF_BAR_SIZE		(4*1024*1024)	// size of each IPIF BAR

#define BUF_SIZE		(1*1024*1024)	// size of PC buffer (must be pow of 2 & <= IPIF_BAR_SIZE)
#define LOG_BUF_SIZE		20		// size of log2 of PC buffer (must be pow of 2 & <= IPIF_BAR_SIZE)

#define NUM_CHANNEL		16		// number of channels
#define NUM_IPIF_BAR		6		// number of IPIF BARs to attempt to allocate
#define NUM_IPIF_BAR_SEG	(IPIF_BAR_SIZE/BUF_SIZE)	// number of buf segments per IPIF BAR 

#define BUF_QUEUE_DEPTH		((NUM_IPIF_BAR*NUM_IPIF_BAR_SEG)+1) // Depth of the PC buffer info queue
#define READ_QUEUE_DEPTH	50 // Depth of the read msg queue
#define WRITE_QUEUE_DEPTH	50 // Depth of the write msg queue

/*
 * Locations and config space offsets.
 */
#define IPIF_BAR_ADDR		0xA0000000	// base address for IPIF BARs on FPGA
#define IPIF_BAR_ADDR_INC	0x00400000	// addr increment for each IPIF BAR region

#define IRQ_REG_OFF		0x2FC	// config offset for interrupt reg

#define IPIF_BAR_HW_REG_OFF	0x200	// config offset for IPIF BAR 0 HW reg
#define IPIF_BAR_HW_REG_INC	0x004	// config increment for IPIF BAR HW regs

#define CHANNEL_REG_INC					0x020	// config increment for channel registers
#define INTR_INFO_REG_OFF				0x01C	// config offset for FPGA->PC info
#define SENT_INFO_REG_OFF				0x00C	// config offset for PC->FPGA info
#define SENT_ARG_REG_OFF				0x010	// config offset for PC->FPGA arg data
#define SENT_ARG_REG_INC				0x004	// config increment for PC->FPGA arg data
#define BUF_INFO_REG_OFF				0x018	// config offset for buffer info
#define DMA_SRC_REG_OFF					0x004	// config offset for DMA transfer info
#define DMA_DST_REG_OFF					0x008	// config offset for DMA transfer info
#define DMA_LEN_REG_OFF					0x000	// config offset for DMA transfer info


/*
 * Message events for readmsgs/writemsgs queues.
 */
#define EVENT_DATA_RECV				0
#define EVENT_BUF_ALLOCATE			1
#define EVENT_DATA_SENT				2


#endif
