EXES := \
	AdderChannel \
	AdderMismatch \
	AdderBlocking \
	AdderService \
	Processes \
	Process \
	ProcessState \
	ProcessGeneric

all: ${EXES}

AdderChannel: AdderChannel.idr
	time idris -o $@ $<

AdderMismatch: AdderMismatch.idr
	time idris -o $@ $<

AdderBlocking: AdderBlocking.idr
	time idris -o $@ $<

AdderService: AdderService.idr
	time idris -o $@ $<

Processes: Processes.idr
	time idris -o $@ $<

Process: Process.idr
	time idris -o $@ $<

ProcessState: ProcessState.idr
	time idris -o $@ $<

ProcessGeneric: ProcessGeneric.idr
	time idris -o $@ $<

.PHONY: clean
clean:
	-rm *.ibc
	-rm ${EXES}
