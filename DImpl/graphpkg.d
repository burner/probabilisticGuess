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

module graphpkg;

private import nodepkg : Node;
private import util;
private import graphWriter;

private import tango.core.Exception;
private import tango.util.container.LinkedList;
private import tango.math.random.Random;
private import tango.io.Stdout;
private import tango.sys.Process;
private import tango.time.Time;
private import tango.time.Clock;
private import Integer = tango.text.convert.Integer;

class Graph {
	private Node[] nodes;
	private uint size;
	private uint min;
	private uint max;
	private static Random rand;

	public this(uint size, uint min, uint max) {
		Graph.rand = new Random();
		this.size = size;
		this.min = min;
		this.max = max;
		uint cit = 0;
		//the constructor runs till a valid graph is created
		do {
			this.nodes = new Node[size];
			//create nodes
			for(uint i = 0; i < size; i++) {
				this.nodes[i] = new Node(i);	
			}

			//connect nodes
			foreach(it; this.nodes) {
				uint nxt = rand.uniformR2(min,max);
				real[] nxtProbs = new real[nxt];
				fillArrayToOne(nxtProbs);
				Node[] nxtNodes = new Node[nxt];
				nxtNodes = pickUnique(nxt, this.nodes);
	
				it.assignNext(nxtNodes, nxtProbs);

				debug(16) {
					for(int i = 0; i < nxtProbs.length; i++) {
						Stdout.formatln("{} = {}",nxtNodes[i].getID(), nxtProbs[i]);
					}
					Stdout.formatln("\n");
				}
			}
			cit++;
		//validate created graph
		} while(!this.validate());
		debug(6) {
			Stdout.formatln("It took {} iterations to find a graph", cit);
		}
	}
	
	public Node getFirst() {
		return this.nodes[0];
	}

	public static Node getNext(Node current) {
		real[] probs = current.getProbs();
		for(uint i = 0; i < probs.length;i++) {
			debug(16) {
				Stdout.formatln("Iteration {}", i);
			}
			if(rand.uniformR(1.0) > probs[i]) {
				debug(16) {
					Stdout.formatln("found i = {}; adr = {}", i, current.getNext(current.getConnections()[i][1]));
				}
				return current.getNext(current.getConnections()[i][1]);
			}
		}
		return current.getNext(current.getConnections()[rand.uniformR(probs.length)][1]);	
	}
	public void saveGraph(bool create = false) {
		Stdout.formatln("saveGraph with name {}", this.getName);
		this.saveGraph(this.getName);
		if(create) {
			this.createGraph(this.getName);
		}
	}

	public char[] getName() {
		return Integer.toString(this.size) ~ "-" ~ Integer.toString(min) ~ "-" ~ Integer.toString(max) ~ ".graph";
	}

	public void saveGraph(char[] fileName) {
		LinkedList!(uint[]) n = new LinkedList!(uint[]);
		LinkedList!(real) p = new LinkedList!(real);
		foreach(it; this.nodes) {
			uint[][] nt = it.getConnections();
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

	private void createGraph(char[] name) {
		char[] cmd = "dot -Tjpg " ~ name ~ " -o " ~ name[0..name.length-5] ~ "jpg";
		debug(6) {
			Stdout.formatln("{}", cmd);
		}
		Process pro = new Process(cmd, null);
		try {
			pro.execute();
			auto result = pro.wait();
			Stdout.formatln("Process {}, pid {}, finished {}",pro.programName, pro.pid, result.toString());
		} catch(ProcessException e) {
			Stdout.formatln("{}", e.toString());
		}
	}

	public bool validate() {
		if(!this.checkForUnreachability()) {
			debug(16) {
				Stdout.formatln("Not Reachable");
			}
			return false;
		}
		if(!this.checkForWeaklyConnected()) {
			debug(16) {
				Stdout.formatln("Not WeaklyConnected");
				Stdout.formatln("{}", Clock.now.unix.millis);
				this.saveGraph(Integer.toString(Clock.now.unix.millis));
			}
			return false;
		}
		return true;
	}

	private bool checkForUnreachability() {
		bool[] rslt = new bool[nodes.length];
		for(int i = 0; i < rslt.length; i++) {
			//bool array containing value of connectivity
			bool[] tmp = new bool[nodes.length];
			//check for every node if it's connected to the current node
			//represented by i
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
				debug(16) {
					Stdout.formatln("There is no connection to {}", i);
				}
				return false;
			}
		}
		return true;
	}

	private bool checkForWeaklyConnected() {
		//check every node for connection to every other node
		foreach(i,it;this.nodes) {
			foreach(j,jt;this.nodes) {
				//LL of already visited nodes
				LinkedList!(uint) visited = new LinkedList!(uint);
				visited.add(it.getID());

				bool found = false;
				//check every outgoing connection of the currently checked node. (it)
				foreach(kt;it.getNext()) {
					if(kt.getID() == jt.getID()) {
						found = true;
						break;
					}
					if(kt.checkConnectionsRecursive(jt.getID(), visited)) {
						found = true;
						break;
					}
				}
				if(!found) {
					debug(16) {
						Stdout.formatln("{} -> {}", it.getID(), jt.getID());
					}
					return false;
				}
			}
		}
		return true;
	}

	public uint getSize() {
		return this.size;
	}
	public uint getMinConnections() {
		return this.min;
	}
	public uint getMaxConnections() {
		return this.max;
	}
}
