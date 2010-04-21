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

module quickpkg;

import tango.io.Stdout;
import tango.math.random.Random;
import tango.util.container.LinkedList;
import Float = tango.text.convert.Float;

private import probsetpkg : ProbSet;

//void main() {
//	Random rand = new Random();
//	LinkedList!(real) f = new LinkedList!(real);
//	for(int i = 0; i < 11; i++) {
//		f.add(rand.uniformR(10.0));
//	}
//	print(f);
//	real t = median(f, 0.5);
//	Stdout.formatln("{} ", t);
//	print(f);
//}

public void print(LinkedList!(real) ll) {
	int i = 0;
	foreach(it;ll) {
		Stdout.format("{}{}", it, (i == ll.size()-1 ? "\n" : " "));
		i++;
	}
}

private int cmp(ref ProbSet a, ref ProbSet b) {
	if(a.getProb() > b.getProb()) {
		return 1;
	} else if(a.getProb() == b.getProb()) {
		return 0;
	} else {
		return -1;
	}
}

public real median(LinkedList!(ProbSet) lst, real med) {
	lst.sort(&cmp);
	if(lst.size() == 0) return 0.0;
	if(lst.size() % 2 == 1) {
		real r = lst.get(cast(int)(lst.size()*med)).getProb();
		//Stdout.formatln("median {}", Float.format(new char[16],r,10,10));
		return r;
	} else {
		real a = lst.get(cast(int)(lst.size()*med)-1).getProb();
		real b = lst.get(cast(int)(lst.size()*med)).getProb();
		real r = (a+b)/2.0;
		//Stdout.formatln("median {} {} {}", Float.format(new char[16],r,10,10),Float.format(new char[16],a,10,10),Float.format(new char[16],b,10,10));
		return r;
	}
}

public void quick(real array[], int start, int end){
	if(start < end){
		int l=start+1, r=end;
		real p = array[start];
		while(l<r){
			if(array[l] <= p)
				l++;
			else if(array[r] >= p)
				r--;
			else {
				real t = array[l];
				array[l] = array[r];
				array[r] = t;
			}
		}
		if(array[l] < p){
			real t = array[l];
			array[l] = array[start];
			array[start] = t;
			l--;
		}
		else{
			l--;
			real t = array[l];
			array[l] = array[start];
			array[start] = t;
		}
		quick(array, start, l);
		quick(array, r, end);
	}
}
