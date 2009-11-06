import Graph
from System import System as System

#num Nodes, min Edges, max Edges
foo = Graph.Graph(60,4,8)
#uncommit this to print graph to dotGr.jpg
#foo.printGraph()

#print foo._nodes[0]._proNext
#print "\n\n\n"

# numPeers, minNumWr, maxNumWr, numTests
bar = System(foo, 50, 2, 15, 400)
bar.sim()
bar.makeResult()

rightCnt = 0
for x in bar.right:
	if x[0]:
		rightCnt+=1
print "\n\nRight " + str(rightCnt) + " of " + str(bar.numTests)
