private import graphWriter;
private import graphpkg;
private import util;
private import tango.io.Stdout;
private import Float = tango.text.convert.Float;
private import Path = tango.io.Path;
private import Time = tango.time.Time;
private import tango.time.Clock;
private import Integer = tango.text.convert.Integer;
private import tango.io.FileSystem;

private import systempkg : System;
private import peerpkg : Peer;

void main() {
	long time = Clock.now.ticks;
	char[] timeChar = Integer.toString(time);
	Path.createFolder(timeChar);
	FileSystem.setDirectory(timeChar);
	
	Graph foo = new Graph(20,2,5);
	foo.saveGraph(true);
	System sys = new System(foo, 10, 2,7,10);
	Peer.setAvailability(0.5);
	//System sys = new System(foo, 20, 3,5,10);
	sys.simulate();
	sys.result();
}
