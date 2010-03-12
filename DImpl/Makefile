#ldc *.d -ofmain -d-debug=1 -O5

all: main

DC=ldc
LDFLAGS=-ofmain -d-debug=8 -O5
DFLAGS= -c -d-debug=8 -O5

OBJS=graphpkg.o nodepkg.o peerpkg.o probsetpkg.o resultsetpkg.o systempkg.o util.o graphWriter.o printerpkg.o quickpkg.o

main: main.d $(OBJS)
	$(DC) $(LDFLAGS) main.d $(OBJS) 

quickpkg.o: quickpkg.d
	$(DC) $(DFLAGS) quickpkg.d

printerpkg.o: printerpkg.d
	$(DC) $(DFLAGS) printerpkg.d

graphpkg.o: graphpkg.d util.o graphWriter.o
	$(DC) $(DFLAGS) graphpkg.d

nodepkg.o: nodepkg.d 
	$(DC) $(DFLAGS) nodepkg.d

peerpkg.o: peerpkg.d nodepkg.o
	$(DC) $(DFLAGS) peerpkg.d

probsetpkg.o: probsetpkg.d
	$(DC) $(DFLAGS) probsetpkg.d

resultsetpkg.o: resultsetpkg.d
	$(DC) $(DFLAGS) resultsetpkg.d

systempkg.o: systempkg.d graphpkg.o peerpkg.o probsetpkg.o resultsetpkg.o
	$(DC) $(DFLAGS) systempkg.d

util.o: util.d
	$(DC) $(DFLAGS) util.d

graphWriter.o: graphWriter.d 
	$(DC) $(DFLAGS) graphWriter.d

clean:
	rm -rf main
	rm -rf *.o	
