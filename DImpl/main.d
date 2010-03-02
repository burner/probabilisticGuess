private import graphWriter;
private import graphpkg;
private import util;
private import tango.io.Stdout;
private import Float = tango.text.convert.Float;

private import systempkg : System;

void main() {
	Graph foo = new Graph(15,2,4);
	foo.saveGraph("test.txt");
	System sys = new System(foo, 10, 3,5,10000);
	sys.simulate();
	sys.result();
}
