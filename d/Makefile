% : %.d
	dmd $@

programs := hello
objects := $(programs:=.o)

.PHONY: all
all: ${programs}

.PHONY: clean
clean: 
	@rm -f ${programs} ${objects}
