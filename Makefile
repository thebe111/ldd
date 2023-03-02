# To build modules outside of the kernel tree, we run "make" in the kernel source tree. The Makefile these then includes
# this Makefile once again. This conditional selects whether we are being included from the kernel Makefile or not.

LDDINC=$(PWD)/../include
EXTRA_CFLAGS += -I$(LDDINC)

ifeq ($(KERNELRELEASE),)
	# Assume the source tree is where the running kernel was built you should set KERNELDIR in the environment if it's
	# elsewhere
	KERNELDIR ?= /lib/modules/$(shell uname -r)/build
	# The current directory is passed to sub-makes as argument
	PWD := $(shell pwd)

.PHONY: modules
modules:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

.PHONY: modules_install
modules_install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

.PHONY: clean
clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions *.mod modules.order *.symvers
else
	# Called from kernel build system. Just declare what our modules are
	obj-m := hello.o 
endif


