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
		outFile.formatln("{} -> {}  [label=\"{}\"];", graph[i][0], graph[i][1], Float.format(new char[16],prob[i],10,10));
	}
	outFile.formatln("}");
	outFile.flush.close;
}
