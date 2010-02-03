module probsetpkg;

import nodepkg : Node;

class ProbSet {
	private real prob;
	private Node node;
	
	this(Node node, real prob) {
		this.prob = prob;
		this.node = node;
	}

	real getProb() {
		return this.prob;
	}

	Node getNode() {
		return this.node;
	}
}

