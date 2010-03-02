module systempkg;

private import tango.util.container.LinkedList;
private import tango.io.Stdout;
private import tango.time.Time;
private import tango.time.Clock;
private import tango.math.random.Random;

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
	
	this(Graph graph, uint numPeers, uint minNumWr, uint maxNumWr, uint numTests) {
		this.graph = graph;
		this.numPeers = numPeers;
		this.minNumWr = minNumWr;
		this.maxNumWr = maxNumWr;
		this.numTests = numTests;
		this.avgWr = cast(uint)(this.maxNumWr+this.minNumWr)/2;
		this.peers = new Peer[this.numPeers];
		for(int i = 0; i < this.peers.length; i++) {
			this.peers[i] = new Peer(0.0, this.graph.getFirst());
		}
		this.writeResult = new LinkedList!(ResultSet);
		this.readResult = new LinkedList!(ResultSet);
		this.current = graph.getFirst();
	}

	public void result() {
		uint success = 0;
		foreach(it;this.readResult) {
			if(it.readOperationSuccess) success++;
		}
		Stdout.formatln("{}/{} == {}", success, this.readResult.size(), success/this.readResult.size());
	}
			

	public void simulate() {
		Random rand = new Random();
		for(uint i = 0; i < this.numTests; i++) {
			real[] times = new real[rand.uniformR2(this.minNumWr,this.maxNumWr)];
			fillArrayToOne(times);
	
			debug(18) {
				Stdout.formatln("before write");
			}
	
			foreach(it;times) {
				this.write(it);
			}
	
			debug(18) {
				Stdout.formatln("before read");
			}
	
			this.read();
		}
	}

	void write() {
		debug(16) {
			Stdout.formatln("System.write in");
		}

		uint[] rslt = new uint[this.numTests];
		Node node = this.graph.getFirst();

		debug(16) {
			Stdout.formatln("System.write after node");
		}
		Time start = Clock.now;
		for(int i = 0; i < this.numTests; i++) {
			rslt[i] = node.getID();
			node = this.graph.getNext(node);	
		}

		debug(16) {
			Stdout.formatln("System.write after result fill");
		}

		foreach(it; rslt) {
			//Stdout.format("{} ", it);
		}
		Stdout.formatln("Time to travel {} nodes in ms {}.", numTests, (Clock.now-start).millis);
	}

	public void write(real time) {
		Peer writePeer = this.getRandomPeer();
		debug(16) {
			Stdout.formatln("WritePeer after getRandom");
			Stdout.formatln("node id {}", writePeer.getValue().getID());
		}
		this.current = Graph.getNext(this.current);
		writePeer.setNode(this.current, time);
	}

	public void write(real time, uint steps) {
		Peer writePeer = this.getRandomPeer();
		debug(16) {
			Stdout.formatln("WritePeer after getRandom");
			Stdout.formatln("node id {}", writePeer.getValue().getID());
		}
		Node tmp = writePeer.getValue();
		Node tmo = this.current;
		Stdout.format("{} ",tmp.getID());
		for(uint i = 0; i < steps; i++) {
			tmp = Graph.getNext(tmp);
			debug(16) {
				Stdout.formatln("write step i = {}", i);
				Stdout.format("{} ", tmp.getID());
			}
		}
		debug(16) {
			Stdout.formatln("WritePeer after get next");
		}
		writePeer.setNode(tmp, time);
		this.current = tmp;
	}

	public void read() {
		//for now get random peer
		Peer readPeer = this.getRandomPeer();
		real timeDelta = this.currentTime - readPeer.getTime();
		real steps = timeDelta * this.avgWr;
		debug(16) {
			Stdout.formatln("System.read() timeDelta = {} guessed Steps = {}", timeDelta, steps);
		}

		//if no steps have been made
		ProbSet high = null;	
		if(steps <= 0.00000001) {
			if(readPeer.getValue().getID() == this.current.getID()) {
				this.readResult.add(new ResultSet(true,1,true,readPeer.getValue().getID == this.current.getID(), readPeer.getValue().getID, this.current.getID()));	
				debug(18) {
					Stdout.formatln("min step occured");
				}
			}		
		} else {
			debug(18) {
				Stdout.formatln("normal step occured");
			}
			LinkedList!(ProbSet) probList = new LinkedList!(ProbSet);
			readPeer.getValue().getProbNext(this.avgWr, probList, 1.0);
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
