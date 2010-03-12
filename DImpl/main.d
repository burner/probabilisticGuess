private import tango.core.ThreadPool;
private import tango.core.Exception;
private import tango.sys.Process;
private import tango.io.Stdout;
private import tango.time.Clock;
private import tango.time.WallClock;
private import Integer = tango.text.convert.Integer;
private import Float = tango.text.convert.Float;
private import Path = tango.io.Path;
private import Time = tango.time.Time;
private import tango.io.FileSystem;
private import tango.text.locale.Locale;
private import tango.text.xml.Document;
private import tango.text.xml.DocPrinter;
private import tango.io.stream.TextFile;
private import systempkg : System;
private import peerpkg : Peer;
private import graphWriter;
private import graphpkg;
private import util;

void main() {
	Locale layout = new Locale;
	char[] timeChar = layout("{:yyyy:MM:dd-HH:mm:ss}", Clock.now);
	Path.createFolder(timeChar);
	FileSystem.setDirectory(timeChar);
	
	Graph foo = new Graph(20,2,5);
	foo.saveGraph(true);
	Document!(char) rs;

	//prob that the peers is living 
	real prob = 0.9;
	
	void func(Graph foo, int i, real prob) {
		System sys = new System(foo, i, 2,7,500000, prob, i);
		Peer.setAvailability(prob);
		sys.simulate();
		rs = sys.result();
	}

	auto pool = new ThreadPool!(Graph,int,real)(1);
	for(int i = 6; i < 7; i++) {
		pool.append(&func, foo, i, prob);
	}
	pool.finish();
/*
	for(int i = 5; i < 20; i++) {
		System sys = new System(foo, i, 2,7,500000, prob, i);
		Peer.setAvailability(prob);
		sys.simulate();
		rs = sys.result();
	}
*/
	FileSystem.setDirectory("..");
	//char[] cmd ="python printResult "~timeChar;
	char[] cmd ="python printResult ";
	Process pro = new Process(cmd, null);
	try {
		pro.execute();
		auto result = pro.wait();
		Stdout.formatln("exceuted {}", result);
	} catch(ProcessException e) {
		Stdout.formatln("Graph Created");
	}
}



void writeToFile(Document!(char) toWrite, char[] fileName) {
	TextFileOutput output = new TextFileOutput(fileName);
	DocPrinter!(char) print = new DocPrinter!(char);
	output.formatln(print(toWrite));
	output.flush.close;
}
