/* Copyright (C) 2010 - Robert Schadek
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
* 
*/

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
private import nodepkg : Node;
private import graphWriter;
private import graphpkg;
private import util;
private import tango.core.Memory;

void main() {
	Locale layout = new Locale;
	char[] timeChar = layout("{:yyyy:MM:dd-HH:mm:ss}", Clock.now);
	Path.createFolder(timeChar);
	FileSystem.setDirectory(timeChar);
	
	Graph foo = new Graph(20,2,5);
	Node.setQuantil(0.85);
	foo.saveGraph(true);
	Document!(char) rs;

	//prob that the peers is living 
	real prob = 0.9;
	real[] probs = [0.9999, 0.9, 0.75, 0.5, 0.25];
/*	
	void func(Graph foo, int i, real prob, uint testcase) {
		System sys = new System(foo, i, 2,7,500000, prob, i, testcase);
		//System sys = new System(foo, i, 2,7,50, prob, i, testcase);
		Peer.setAvailability(prob);
		sys.simulate();
		rs = sys.result();
	}
	auto pool = new ThreadPool!(Graph,int,real,uint)(2);
	for(int j = 0; j < 4; j++) {
		for(int i = 6; i < 16; i++) {
			pool.append(&func, foo, i, probs[j],j);
		}
	}
	pool.finish();
*/
	System sys;
	for(int j = 0; j < 4; j++) {
		for(int i = 6; i < 16; i++) {
			sys = new System(foo, i, 2,7,500000, probs[j], i, j);
			Peer.setAvailability(probs[j]);
			sys.simulate();
			rs = sys.result();
			delete sys;
			tango.core.Memory.GC.collect();
		}
	}
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
