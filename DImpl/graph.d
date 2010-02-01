module Graphpkg;

private import Nodepkg : Node;
private import util;
private import graphWriter;

private import tango.util.container.LinkedList;
private import tango.math.random.Random;
private import tango.io.Stdout;

class Graph {
	private Node[] nodes;

	public this(uint size, uint min, uint max) {
		this.nodes = new Node[size];
		//create nodes
		for(uint i = 0; i < size; i++) {
			this.nodes[i] = new Node(i);	
		}

		//connect nodes
		Random rand = new Random();
		foreach(it; this.nodes) {
			uint nxt = rand.uniformR2(min,max);
			real[] nxtProbs = new real[nxt];
			fillArrayToOne(nxtProbs);
			Node[] nxtNodes = new Node[nxt];
			nxtNodes = pickUnique(nxt, this.nodes);
	
			it.assignNext(nxtNodes, nxtProbs);

			debug(1) {
				for(int i = 0; i < nxtProbs.length; i++) {
					Stdout.formatln("{} = {}",nxtNodes[i].getID(), nxtProbs[i]);
				}
				Stdout.formatln("\n");
			}
		}
	}

	public void saveGraph(char[] fileName) {
		LinkedList!(int[]) n = new LinkedList!(int[]);
		LinkedList!(real) p = new LinkedList!(real);
		foreach(it; this.nodes) {
			int[][] nt = it.getConnections();
			real[] pt = it.getProbs();
			for(int i = 0; i < nt.length; i++) {
				n.add(nt[i]);
			}
			for(int i = 0; i < pt.length; i++) {
				p.add(pt[i]);
			}
		}
		writeGraph(fileName, n.toArray(), p.toArray());
	}

	public bool checkForUnreachability() {
		bool[] rslt = new bool[nodes.length];
		for(int i = 0; i < rslt.length; i++) {
			bool[] tmp = new bool[nodes.length];
			foreach(j,it;this.nodes) {
				tmp[j] = it.checkConnections(this.nodes[i]);	
			}
			foreach(it;tmp) {
				if(it) {
					rslt[i] = true;
					break;
				}
			}
		}
		foreach(i,it;rslt) {
			if(!it) {
				Stdout.formatln("There is no connection to {}", i);
				return false;
			}
		}
		return true;
	}
}
