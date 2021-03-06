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

module systempkg;

private import tango.util.container.LinkedList;
private import tango.io.Stdout;
private import tango.time.Time;
private import tango.time.Clock;
private import tango.math.random.Random;
private import tango.math.Math;
private import Float = tango.text.convert.Float;
private import Integer = tango.text.convert.Integer;
private import tango.text.xml.Document;
private import tango.text.xml.DocPrinter;
private import tango.io.stream.TextFile;

private import graphpkg : Graph;
private import nodepkg : Node;
private import peerpkg : Peer;
private import probsetpkg : ProbSet;
private import resultsetpkg : ResultSet;
private import util;
private import printerpkg;

class System {
	//desc
	private Graph graph;
	private uint numPeers;
	private uint minNumWr;
	private uint maxNumWr;
	private uint avgWr;
	private uint numTests;
	private uint id;

	//runtime
	private Random rand;
	private real currentTime;
	private Node current;
	private Peer[] peers;

	//result
	private LinkedList!(ResultSet) writeResult;
	private LinkedList!(ResultSet) readResult;

	private real timeDeltaBig = 0.0;
	private real timeDeltaSmall = 10.0;

	private real prob;
	private uint test;

	private uint readCount;
	private uint readSuccess;

	private uint writeCount;
	private uint writeOperations;

	
	this(Graph graph, uint numPeers, uint minNumWr, uint maxNumWr, uint numTests, real prob, uint id, uint test) {
		this.rand = new Random();
		//save given parameter
		this.graph = graph;
		this.numPeers = numPeers;
		this.minNumWr = minNumWr;
		this.maxNumWr = maxNumWr;
		this.numTests = numTests;

		//calc average write count per time unit
		this.avgWr = cast(uint)(this.maxNumWr+this.minNumWr)/2;

		//create peers
		this.peers = new Peer[this.numPeers];
		for(int i = 0; i < this.peers.length; i++) {
			this.peers[i] = new Peer(0.0, this.graph.getFirst(),i);
		}
		
		//create resultset linkedlists
		//this.writeResult = new LinkedList!(ResultSet);
		//this.readResult = new LinkedList!(ResultSet);
		this.readCount = 0;
		this.readSuccess = 0;
		this.writeCount = 0;
		this.writeOperations = 0;

		//set current value to the first element of the graph
		this.current = graph.getFirst();
		this.currentTime = 0.0;

		this.prob = prob;

		//system id
		this.id = id;
		this.test = test;
	}
	
	~this() {
		debug(8) {
			Stdout.formatln("System destructor");
		}
		delete this.writeResult;
		delete this.readResult;
	}

	public Document!(char) result() {
		uint success = 0;
		uint readCount = 0;
		uint writeCount = 0;
		//foreach(it;this.readResult) {
		//	if(it.readOperationSuccess) success++;
		//	readCount += it.accessCount;
		//}
		//foreach(it;this.writeResult) {
		//	writeCount += it.accessCount;
		//}
		debug(18) {
			Stdout.formatln("Operation read success {}/{} == {}", success, this.readResult.size(), Float.format(new char[32],(cast(real)success)/this.readResult.size(),10,10));
			Stdout.formatln("Operation read count {}/{} == {}", readCount, this.readResult.size(), Float.format(new char[32],(cast(real)readCount)/this.readResult.size(),10,10));
			Stdout.formatln("Operation write count {}/{} == {}", writeCount, this.writeResult.size(), Float.format(new char[32],(cast(real)writeCount)/this.writeResult.size(),10,10));
			Stdout.formatln("smallest Time Delta {}; biggest Time Delta {}, prob {}", this.timeDeltaSmall, this.timeDeltaBig, this.prob);
		}

		Document!(char) doc = new Document!(char);
		doc.header;
		doc.tree.element(null, "ResultSet").
			element(null, "System")
				.attribute(null, "Peers", Integer.toString(this.numPeers)).
				attribute(null, "ProbSuccess", Float.format(new char[32],this.prob,10,10)).
				attribute(null, "MinWrites", Integer.toString(this.minNumWr)).
				attribute(null, "MaxWrites", Integer.toString(this.maxNumWr)).
				attribute(null, "AvgWrites", Integer.toString(this.avgWr)).
				attribute(null, "NumberOfTests", Integer.toString(this.numTests)).
				attribute(null, "readOperations", Integer.toString(this.numTests)).
				attribute(null, "readWorked", Integer.toString(this.readCount)).
				attribute(null, "readSuccess", Integer.toString(this.readSuccess)).
				attribute(null, "writeOperations", Integer.toString(this.writeOperations)).
				attribute(null, "writeSuccess", Integer.toString(this.writeCount)).
				attribute(null, "testcast", Integer.toString(this.test)).
			element(null, "GraphDesc").attribute(null, "Size", Integer.toString(this.graph.getSize)).
				attribute(null, "MinConnections", Integer.toString(this.graph.getMinConnections)).
				attribute(null, "MaxConncetions", Integer.toString(this.graph.getMaxConnections)).
				attribute(null, "FileName", this.graph.getName);
		TextFileOutput output = new TextFileOutput("System"~Integer.toString(this.id)~Integer.toString(this.test));
		DocPrinter!(char) print = new DocPrinter!(char);
		output.formatln(print(doc));
		debug(18) {
			output.flush.close;
			Stdout(print(doc)).newline;
		}
		return doc;
	}
			

	public void simulate() {
		debug(14) {
			static uint min;
			static uint max;
			min = this.maxNumWr;
			max = this.minNumWr;
		}
		//init the peers
		for(int i = 0; i < 1000; i++) {
			real[] times = new real[rand.uniformR2(this.minNumWr,this.maxNumWr+1)];
			this.writeOperations += times.length;
			fillArrayToOne(times);
			foreach(it;times) {
				this.write(it);
				//save the current time to the system time
				this.currentTime += it;
			}
			delete times;
		}

		for(uint i = 0; i < this.numTests; i++) {
			debug(8) {
				if(i % 25000 == 0) {
					//Stdout.formatln("{} from {} done", i, this.numTests);
					Printer.print(Integer.toString(this.id) ~ " " ~ Integer.toString(this.test) ~ " "~ Integer.toString(i) ~ " from " ~ Integer.toString(this.numTests));
					
				}
			}
			//create time array
			real[] times = new real[rand.uniformR2(this.minNumWr,this.maxNumWr+1)];

			debug(14) {
				max = times.length > max ? times.length : max;
				min = times.length < min ? times.length : min;
			}
			
			//fill the time array up to one
			fillArrayToOne(times);
			this.writeOperations += times.length;

			debug(18) {
				Stdout.formatln("before write");
			}
			
			//create the array	
			foreach(it;times) {
				this.write(it);
				this.currentTime += it;
			}
			delete times;
	
			debug(18) {
				Stdout.formatln("before read");
			}
			
			this.read();
		}

		debug(14) {
			Stdout.formatln("min = {}; max = {}", min, max);
		}
	}

	public void write(real time) {
		Peer writePeer;
		uint lwriteCount = 0;
		do {
			lwriteCount++;
			writePeer = this.getRandomPeer();
		} while(!writePeer.isAvailable());
		debug(16) {
			Stdout.formatln("WritePeer after getRandom");
			Stdout.formatln("node id {}", writePeer.getValue().getID());
		}
		Node tmp = Graph.getNext(this.current);
		this.current = tmp;
		writePeer.setNode(this.current, this.currentTime + time);
		this.writeCount += lwriteCount;
		//this.writeResult.add(new ResultSet(false, writeCount, true, false, 0,0));
	}

	public void read() {
		uint readCnt = 0;
		//for now get random peer
		uint steps = 0;
		real timeDelta;
		Peer readPeer;
		LinkedList!(uint) allreadyTested = new LinkedList!(uint);
		do {
			readCnt++;
			readPeer = this.getRandomPeer(allreadyTested);

			timeDelta = this.currentTime - readPeer.getTime();
			if(timeDelta == 0.0) {
				steps = 0;
			} else if(timeDelta < 1.0) {
				steps = cast(uint)round(this.avgWr);
			} else {
				steps = cast(uint)round(timeDelta * this.avgWr);
			}
			this.timeDeltaBig = this.timeDeltaBig < timeDelta ? timeDelta : this.timeDeltaBig;
			this.timeDeltaSmall = this.timeDeltaSmall > timeDelta ?  timeDelta : this.timeDeltaSmall;
		} while(steps > 7.0 || !readPeer.isAvailable());
		debug(16) {
			Stdout.formatln("System.read() timeDelta = {} guessed Steps = {}; readCount = {}", timeDelta, steps, readCnt);
		}
		delete allreadyTested;

		//if no steps have been made
		ProbSet high = null;	
		if(steps == 0) {
			if(readPeer.getValue().getID() == this.current.getID()) {
				this.readCount += readCnt;
				this.readSuccess += readPeer.getValue().getID == this.current.getID() ? 1 : 0;

				//this.readResult.add(new ResultSet(true,readCnt,true,readPeer.getValue().getID == this.current.getID(), readPeer.getValue().getID, this.current.getID()));	
				debug(16) {
					Stdout.formatln("min step occured");
				}
			}		
		} else {
			debug(16) {
				Stdout.formatln("normal step occured with {} steps", steps);
			}
			LinkedList!(ProbSet) probList = new LinkedList!(ProbSet);
			readPeer.getValue().getProbNext(steps, probList, 1.0);
			ProbSet highProb = null;
			debug(16) {
				Stdout.formatln("this.current.getID() = {}", this.current.getID());
			}
			real probSum = 0.0;
			foreach(it;probList) {
				debug(16) {
					Stdout.formatln("prob = {}; guess = {}", it.getProb(),it.getNode().getID());
				}
				if(highProb is null) {
					highProb = it;
					continue;
				}
				probSum+= it.getProb();
				if(highProb.getProb() < it.getProb()) {
					highProb = it;
				}
			}
			debug(16) {
				Stdout.formatln("this.current.getID() = {}", this.current.getID());
				Stdout.formatln("guess prob = {}; guess = {}; probSum = {}", highProb.getProb(), highProb.getNode().getID(), probSum);
			}
			//the first true is to say it is a read, readCount, say if the action was an succes
			this.readCount += readCnt;
			this.readSuccess += readPeer.getValue().getID == this.current.getID() ? 1 : 0;
			//this.readResult.add(new ResultSet(true,readCnt,true, 							
			//					highProb.getNode().getID == this.current.getID(), 
			//					highProb.getNode().getID, this.current.getID()));
			delete probList;
				
			//Stdout.formatln("{} ?? {}", this.readResult.get(0).guessed, this.writeResult.get(0).searched);
		}	
	}

	private Peer getRandomPeer() {
		Peer ret = rand.uniformEl(this.peers);
		return ret;
	}
	
	private Peer getRandomPeer(LinkedList!(uint) toAvoid) {
		do {
			Peer ret = rand.uniformEl(this.peers);
			foreach(it;toAvoid) {
				if(ret.getID() == it) {
					debug(18) {
						Stdout.formatln("continue in getRandomPeer {} == {}",ret.getID(), it);
					}
					continue;
				}
			}
			debug(18) {
				Stdout.formatln("found one");
			}
			toAvoid.append(ret.getID());
			return ret;
		} while(true);
		assert(false); 
		return null;
	}
}
