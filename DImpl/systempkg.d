module systempkg;

private import tango.io.Stdout;
private import tango.time.Time;
private import tango.time.Clock;

private import graphpkg : Graph;
private import nodepkg : Node;

class System {
	private Graph graph;
	private uint numPeers;
	private uint minNumWr;
	private uint maxNumWr;
	private uint numTests;
	private Node curret;
	
	this(Graph graph, uint numPeers, uint minNumWr, uint maxNumWr, uint numTests) {
		this.graph = graph;
		this.numPeers = numPeers;
		this.minNumWr = minNumWr;
		this.maxNumWr = maxNumWr;
		this.numTests = numTests;
	}

	void simulate() {

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

	void read() {

	}
}
