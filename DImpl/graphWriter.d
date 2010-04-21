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

module graphWriter;

private import tango.io.stream.TextFile;
private import tango.io.Stdout;
private import Float = tango.text.convert.Float;

void writeGraph(char[] fileName, uint[][] graph, real[] prob) {
	assert(graph.length == prob.length);
	debug(128) {
		Stdout.formatln("wirteGraph graph.length {}; prob.length {}", graph[].length, prob.length);
	}
		
	TextFileOutput outFile = new TextFileOutput(fileName);
	outFile.formatln("digraph graphname {{");
	for(int i = 0; i < graph.length; i++) {
		outFile.formatln("{} -> {}  [label=\"{}\",weight={}];", graph[i][0], graph[i][1], Float.format(new char[16],prob[i],10,10),1000);
	}
	outFile.formatln("}");
	outFile.flush.close;
}
