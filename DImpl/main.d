private import graphWriter;
private import graphpkg;
private import util;
private import tango.io.Stdout;
private import Float = tango.text.convert.Float;

private import systempkg : System;

void main() {
	Graph foo = new Graph(20,2,5);
	foo.saveGraph("test.txt");
	System sys = new System(foo, 40, 2,7,10000);
	//System sys = new System(foo, 20, 3,5,10);
	sys.simulate();
	sys.result();
}
