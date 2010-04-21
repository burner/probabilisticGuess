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

module nodepkg;

private import systempkg : System;
private import probsetpkg : ProbSet;
private import quickpkg;

private import tango.util.container.LinkedList;
private import tango.io.Stdout;
private import Float = tango.text.convert.Float;

class Node {
	private class NextNode {
		public real prob;
		public Node next;
		public this(Node next, real prob) {
			this.prob = prob;
			this.next = next;
		}
	}

	private static real quantil;

	private uint id;
	private NextNode[] next;

	public this(uint id) {
		this.id = id;
	}

	public uint getID() {
		return this.id;
	}

	public void assignNext(Node[] nxt, real[] nxtProb) {
		this.next = new NextNode[nxt.length];
		for(int i = 0; i < nxt.length; i++) {
			this.next[i] = new NextNode(nxt[i], nxtProb[i]);
		}	
	}
	
	public real[] getProbs() {
		real[] ret = new real[this.next.length];
		for(int i = 0; i < ret.length; i++) {
			ret[i] = next[i].prob;
		}
		return ret;
	}
	
	public uint[][] getConnections() {
		uint[][] ret = new uint[][](this.next.length, 2);
		for(int i = 0; i < this.next.length; i++) {
			ret[i][0] = this.id;
			ret[i][1] = this.next[i].next.getID();
		}
		return ret;
	}

	public bool checkConnections(Node toCheck) {
		foreach(it;this.next) {
			if(toCheck.getID() == it.next.getID() && toCheck.getID() != this.id) {
				return true;
			}
		}
		return false;
	}

	public Node getNext(uint id) {
		foreach(it; next) {
			if(it.next.getID() == id) {
				return it.next;
			}
		}	
	}

	public Node[] getNext() {
		Node[] ret = new Node[this.next.length];
		foreach(i,it;this.next) {
			ret[i] = it.next;
		}
		return ret;
	}

	public static void setQuantil(real quantil_in) {
		Node.quantil = quantil_in;
	}

	public LinkedList!(ProbSet) getProbNext(uint depth, LinkedList!(ProbSet) list, real prob) {
		debug(16) {
			static uint maxDepth;
			if(depth > maxDepth) {
				maxDepth = depth;
				Stdout.formatln("getProbNext depth = {}", maxDepth);
			}
		}
		if(depth-1 <= 0) {
			foreach(i,it; this.next) {
				list.add(new ProbSet(it.next, it.prob*prob));
			}
		} else {
			//real mid = calcAritMiddle(list)*prob;
			real mid = median(list, Node.quantil);
			//Stdout.formatln("{}", mid);
			if(mid <= prob) {	
				foreach(i,it; this.next) {
					it.next.getProbNext(depth-1, list, it.prob*prob);	
				}
			}
		}
		return list;
	}

	private static real calcAritMiddle(LinkedList!(ProbSet) probSets) {
		if(probSets.size() == 0) return 0.0;
		real sum = 0.0;
		foreach(it;probSets) {
			sum += it.getProb();
		}
		debug(18) {
			Stdout.formatln("AritMiddle = {}", Float.format(new char[32],sum/probSets.size(),10,10));
		}
		return sum/probSets.size();
	}
		

	public bool checkConnectionsRecursive(uint toFind, LinkedList!(uint) visited) {
		visited.add(this.id);
		foreach(i,it;this.next) {
			//if the next is the one your looking for
			if(it.next.getID() == toFind) {
				return true;
			}
			//else search everyone else if not searched befor
			if(!checkIfInLinkedList(visited, it.next.getID())) {
				bool result = it.next.checkConnectionsRecursive(toFind, visited);
				if(result) {
					return true;
				}
			}
		}
		return false;
	}

	private bool checkIfInLinkedList(LinkedList!(uint) toCheck, uint toFind) {
		foreach(it;toCheck) {
			if(it == toFind) {
				return true;
			}
		}
		return false;
	}
}
