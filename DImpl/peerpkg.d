module peerpkg;

import nodepkg : Node;

class Peer {
	private real time;
	private Node value;

	this(real time, Node value) {
		this.time = time;
		this.value = value;
	}

	real getTime() {
		return this.time;
	}

	Node getValue() {
		return this.value;
	}
}
