# Redis Module Toolkit (krmt) Makefile
#
# The more colorful parts of this Makefile were
# taken from the primary Redis Makefile.
#
# Place a checkout of the Dynamic Redis source tree
# at ../redis or alter REDIS_BASE to point
# to your redis source tree checkout.

REDIS_BASE=../redis
LUA_SRC=$(REDIS_BASE)/deps/lua/src
REDIS_SRC=$(REDIS_BASE)/src

CFLAGS=-O2 -g -Wall -pedantic -std=c99
FINAL_CFLAGS=$(CFLAGS) -I$(LUA_SRC) -I$(REDIS_SRC)

# Flags for .so compiling; OS X be crazy
ifeq ($(shell uname -s),Darwin)
	SHARED_FLAGS=-fPIC -dynamiclib -Wl,-undefined,dynamic_lookup
else
	SHARED_FLAGS=-fPIC -shared
endif

CCCOLOR="\033[34m"
SRCCOLOR="\033[33m"
BINCOLOR="\033[37;1m"
CLEANCOLOR="\033[32;1m"
ENDCOLOR="\033[0m"

# Run with "make VERBOSE=1" if you want full command output
ifndef VERBOSE
QUIET_CC = @printf '    %b %b\n' $(CCCOLOR)CC$(ENDCOLOR) $(SRCCOLOR)$@$(ENDCOLOR) 1>&2;
QUIET_CLEAN = @printf '    %b %b\n' $(CLEANCOLOR)CLEAN$(ENDCOLOR) $(BINCOLOR)$^$(ENDCOLOR) 1>&2;
endif

.PHONY: all clean
.SUFFIXES: .so

SRC=$(wildcard *.c)
OBJ=$(SRC:.c=.so)

all: $(OBJ)

%.so: %.c
	$(QUIET_CC) $(CC) $(SHARED_FLAGS) $(FINAL_CFLAGS) -o $@ $^

clean:
	$(QUIET_CLEAN) rm -rf *.so *.dSYM