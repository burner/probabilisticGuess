private import graphWriter;
private import graphpkg;
private import util;
private import tango.io.Stdout;
private import Float = tango.text.convert.Float;

private import systempkg : System;

void main() {
	//int a[][] = new int[][](1,2);
	//a[0][0] = 1;
	//a[0][1] = 3;
	//real[] c = new real[](1);
	//c[0] = 0.3123412;
	//
	//writeGraph("Test.txt", a,c);
	//testRandomGen(10);

	//real[10] b;
	//real sum = 0.0;
	//fillArrayToOne(b);
	//for(int i = 0; i < b.length;i++) {
	//	sum += b[i];
	//	Stdout.formatln("{}", Float.format(new char[16], b[i],10,10));
	//}
	//Stdout.formatln("sum {}", sum);
	Graph foo;
	uint it = 0;
	do {
		foo = new Graph(14,2,4);
		it++;
	} while(!foo.checkForUnreachability());
	Stdout.formatln("It took {} iterations to find a graph", it);
	foo.saveGraph("test.txt");
	System sys = new System(foo, 10, 3,3,10000);
	sys.write();
}
