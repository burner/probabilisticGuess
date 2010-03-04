module systempkg;

private import tango.util.container.LinkedList;
private import tango.io.Stdout;
private import tango.time.Time;
private import tango.time.Clock;
private import tango.math.random.Random;
private import tango.math.Math;

private import graphpkg : Graph;
private import nodepkg : Node;
private import peerpkg : Peer;
private import probsetpkg : ProbSet;
private import resultsetpkg : ResultSet;
private import util;

class System {
	//desc
	private Graph graph;
	private uint numPeers;
	private uint minNumWr;
	private uint maxNumWr;
	private uint avgWr;
	private uint numTests;

	//runtime
	private real currentTime;
	private Node current;
	private Peer[] peers;

	//result
	LinkedList!(ResultSet) writeResult;
	LinkedList!(ResultSet) readResult;

	real timeDeltaBig = 0.0;
	real timeDeltaSmall = 10.0;
	
	this(Graph graph, uint numPeers, uint minNumWr, uint maxNumWr, uint numTests) {
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
			this.peers[i] = new Peer(0.0, this.graph.getFirst());
		}
		
		//create resultset linkedlists
		this.writeResult = new LinkedList!(ResultSet);
		this.readResult = new LinkedList!(ResultSet);

		//set current value to the first element of the graph
		this.current = graph.getFirst();
		this.currentTime = 0.0;
	}

	public void result() {
		uint success = 0;
		foreach(it;this.readResult) {
			if(it.readOperationSuccess) success++;
		}
		Stdout.formatln("{}/{} == {}", success, this.readResult.size(), (cast(real)success)/this.readResult.size());
		Stdout.formatln("smallest Time Delta {}; biggest Time Delta {}", this.timeDeltaSmall, this.timeDeltaBig);
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
			fillArrayToOne(times);
			foreach(it;times) {
				this.write(it);
				//save the current time to the system time
				this.currentTime += it;
			}
		}

		Random rand = new Random();
		for(uint i = 0; i < this.numTests; i++) {
			if(i % 10000 == 0) {
				Stdout.formatln("{} from {} done", i, this.numTests);
			}
			debug(18) {
				Stdout.formatln("before time fill");
			}
			//create time array
			real[] times = new real[rand.uniformR2(this.minNumWr,this.maxNumWr+1)];

			debug(14) {
				max = times.length > max ? times.length : max;
				min = times.length < min ? times.length : min;
			}
			
			//fill the time array up to one
			fillArrayToOne(times);
	
			debug(18) {
				Stdout.formatln("before write");
			}
			
			//create the array	
			foreach(it;times) {
				this.write(it);
				this.currentTime += it;
			}
	
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
		Peer writePeer = this.getRandomPeer();
		debug(16) {
			Stdout.formatln("WritePeer after getRandom");
			Stdout.formatln("node id {}", writePeer.getValue().getID());
		}
		this.current = Graph.getNext(this.current);
		writePeer.setNode(this.current, this.currentTime + time);
	}

	public void read() {
		uint readCnt = 0;
		//for now get random peer
		uint steps = 0;
		real timeDelta;
		Peer readPeer;
		do {
			readCnt++;
			readPeer = this.getRandomPeer();
			timeDelta = this.currentTime - readPeer.getTime();
			if(timeDelta == 0.0) {
				steps = 0;
			} else if(timeDelta < 1.0) {
				steps = cast(uint)round(this.avgWr);
			} else {
				steps = cast(uint)round(timeDelta * this.avgWr);
			}
		} while(steps > 7.0);
		this.timeDeltaBig = this.timeDeltaBig < timeDelta ? timeDelta : this.timeDeltaBig;
		this.timeDeltaSmall = this.timeDeltaSmall > timeDelta ?  timeDelta : this.timeDeltaSmall;
		debug(16) {
			Stdout.formatln("System.read() timeDelta = {} guessed Steps = {}; readCount = {}", timeDelta, steps, readCnt);
		}

		//if no steps have been made
		ProbSet high = null;	
		if(steps == 0) {
			if(readPeer.getValue().getID() == this.current.getID()) {
				this.readResult.add(new ResultSet(true,1,true,readPeer.getValue().getID == this.current.getID(), readPeer.getValue().getID, this.current.getID()));	
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
			this.readResult.add(new ResultSet(true,1,true,highProb.getNode().getID == this.current.getID(), highProb.getNode().getID, this.current.getID()));	
				
			//Stdout.formatln("{} ?? {}", this.readResult.get(0).guessed, this.writeResult.get(0).searched);
		}	
	}

	private Peer getRandomPeer() {
		Random rand = new Random();
		Peer ret = rand.uniformEl(this.peers);
		return ret;
	}
}
