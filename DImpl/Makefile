#ldc *.d -ofmain -d-debug=1 -O5

all: main

DC=ldc
LDFLAGS=-ofmain -d-debug=8 -g
DFLAGS=-d-debug=1 -c -d-debug=8 -g

OBJS=graphpkg.o nodepkg.o peerpkg.o probsetpkg.o resultsetpkg.o systempkg.o util.o graphWriter.o

main: main.d $(OBJS)
	$(DC) $(LDFLAGS) main.d $(OBJS) 

graphpkg.o: graphpkg.d nodepkg.o util.o graphWriter.o
	$(DC) $(DFLAGS) graphpkg.d

nodepkg.o: nodepkg.d 
	$(DC) $(DFLAGS) nodepkg.d

peerpkg.o: peerpkg.d nodepkg.o
	$(DC) $(DFLAGS) peerpkg.d

probsetpkg.o: probsetpkg.d
	$(DC) $(DFLAGS) probsetpkg.d

resultsetpkg.o: resultsetpkg.d
	$(DC) $(DFLAGS) resultsetpkg.d

systempkg.o: systempkg.d graphpkg.o nodepkg.o peerpkg.o probsetpkg.o resultsetpkg.o
	$(DC) $(DFLAGS) systempkg.d

util.o: util.d nodepkg.o
	$(DC) $(DFLAGS) util.d

graphWriter.o: graphWriter.d 
	$(DC) $(DFLAGS) graphWriter.d

clean:
	rm -rf main
	rm -rf *.o	
