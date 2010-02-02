module nodepkg;

class Node {
	private class NextNode {
		public real prob;
		public Node next;
		public this(Node next, real prob) {
			this.prob = prob;
			this.next = next;
		}
	}

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
}
