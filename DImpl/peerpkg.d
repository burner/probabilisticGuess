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
