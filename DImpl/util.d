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

module util;

private import Float = tango.text.convert.Float;
private import tango.io.Stdout;
private import tango.math.random.Random;

private import nodepkg : Node;

Node[] pickUnique(uint toPick, Node[] pickFrom) {
	Random rnd = new Random();
	Node[] ret = new Node[toPick];
	uint fnd = 0;
	while(fnd < toPick) {
		uint pick = rnd.uniformR(pickFrom.length);
		bool tst = true;
		debug(16) Stdout.formatln("foo {}", pick);
		foreach(it;ret) {
			if(it !is null && it.getID() == pick) {
				tst = false;
				break;
			}
		}
		if(tst) {
			ret[fnd] = pickFrom[pick];
			fnd++;
		} else {
			continue;
		}	
	}
	delete rnd;
	return ret;
}

//very important that the given array is of length 1
void fillArrayToOne(real[] toFill) {
	Random rnd = new Random();
	real sum = 0.0;
	for(int i = 0; i < toFill.length-1; i++) {
		real tmp = rnd.uniformR(1.0-sum);
		toFill[i] = tmp;
		sum += tmp;
	}
	toFill[toFill.length-1] = 1.0-sum;
	delete rnd;
}

void testRandomGen(int iterations = 10000) {
	Stdout.formatln("Testing random Generator with {} iterations.", iterations);
	Random rand = new Random();
	int[20] a;
	for(int i = 0; i < iterations; i++) {
		a[rand.uniformR(20)]++;
	}
	int low;
	int high;
	for(int i = 0; i < a.length; i++) {
		if(a[i] > high) high = a[i];
		if(low == 0) low = a[i];
		else if(a[i] < low) low = a[i];
	}	
	Stdout.formatln("\nRandom Generator Test low = {}; high = {}
0 = {}, 1 = {}, 2 = {}, 3 = {}, 4 = {}, 5 = {}, 6 = {}, 7 = {}, 8 = {}, 9 = {},
10 = {}, 11 = {}, 12 = {}, 13 = {}, 14 = {}, 15 = {}, 16 = {}, 17 = {}, 18 = {}, 19 = {}", low, high,
		a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13],
		a[14],a[15],a[16],a[17],a[18],a[19]);
	
	int[11] b;
	for(int i = 0; i < iterations; i++) {
		float tmp = rand.uniformR(1f);
		if(tmp > 1.0f) b[9]++;
		else if(tmp > 0.9f) b[8]++;
		else if(tmp > 0.8f) b[7]++;
		else if(tmp > 0.7f) b[6]++;
		else if(tmp > 0.6f) b[5]++;
		else if(tmp > 0.5f) b[4]++;
		else if(tmp > 0.4f) b[3]++;
		else if(tmp > 0.3f) b[2]++;
		else if(tmp > 0.2f) b[1]++;
		else if(tmp > 0.1f) b[0]++;
		else b[10]++;
	}
	long sum = 0;
	long sumWeigth = 0;
	for(int i = 0; i < b.length; i++) {
		sum+= b[i];
		sumWeigth += i * b[i];
	}
		
	Stdout.formatln("\nRandom Genrator Test float between 0.0 and 1.0
> 0.0 = {}, > 0.1 = {}, > 0.2 = {}, > 0.3 = {}, > 0.4 = {}, > 0.5 = {}, > 0.6 = {}, > 0.7 = {}, > 0.8 = {}, > = 0.9 {}
sum = {}, avg = {}",
	b[10], b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], sum, sumWeigth/cast(float)sum);
}
