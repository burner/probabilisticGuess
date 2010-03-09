module peerpkg;

private import tango.math.random.Random;

private import nodepkg : Node;

class Peer {
	private uint id;
	private real time;
	private Node value;
	private Random rand;
	private static real avail;

	this(real time, Node value, uint id) {
		this.time = time;
		this.value = value;
		this.id = id;
		this.rand = new Random;
	}

	public real getTime() {
		return this.time;
	}

	public Node getValue() {
		return this.value;
	}

	public void setNode(Node value, real time) {
		this.time = time;
		this.value = value;
	}

	public uint getID() {
		return this.id;
	}

	public bool isAvailable() {
		return rand.uniform!(real) < this.avail;
	}

	public static void setAvailability(real avail = 0.9){
		Peer.avail = avail;
	}
}
