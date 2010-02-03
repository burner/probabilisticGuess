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
	//LinkedList!(ResultSet) writeResult;
	//LinkedList!(ResultSet) readResult;

	private ResultSet[] resultSet;
	
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
		//this.writeResult = new LinkedList!(ResultSet);
		//this.readResult = new LinkedList!(ResultSet);
		this.resultSet = new ResultSet[0];
	}

	public void simulate() {

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

	public void write(real time, uint steps) {
		Peer writePeer = this.getRandomPeer();
		Node tmp = this.current;
		for(uint i = 0; i < steps; i++) {
			tmp = Graph.getNext(tmp);
		}
		writePeer.setNode(tmp, time);
		this.current = tmp;
	}

	public void read() {
		//for now get random peer
		Peer readPeer = this.getRandomPeer();
		real timeDelta = this.currentTime - readPeer.getTime();
		real steps = timeDelta * this.avgWr;
		debug(8) {
			Stdout.formatln("System.read() timeDelta = {} guessed Steps = {}", timeDelta, steps);
		}

		//if no steps have been made
		if(steps <= 0.00000001) {
			if(readPeer.getValue().getID() == this.current.getID()) {
					
			}		

		}	
	}

	private Peer getRandomPeer() {
		Random rand = new Random();
		Peer ret = rand.uniformEl(this.peers);
		return ret;
	}
}
