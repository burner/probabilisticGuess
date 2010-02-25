private import graphWriter;
private import graphpkg;
private import util;
private import tango.io.Stdout;
private import Float = tango.text.convert.Float;

private import systempkg : System;

void main() {
	Graph foo = null;
	uint it = 0;
	do {
		foo = new Graph(25,1,4);
		it++;
	} while(!foo.validate());
	debug(6) {
		Stdout.formatln("It took {} iterations to find a graph", it);
	}
	//debug(16) {
	//	Stdout.formatln("saveGraph");
	//}
	//foo.saveGraph("test.txt");
	//debug(16) {
	//	Stdout.formatln("new system");
	//}
	//System sys = new System(foo, 10, 3,5,10000);
	//debug(16) {
	//	Stdout.formatln("system write");
	//}
	////sys.write();
	//debug(16) {
	//	Stdout.formatln("system simulate");
	//}
	//sys.simulate();
}
