from Node import Node as Node
from pygraph.classes.digraph import digraph
from pygraph.algorithms.searching import breadth_first_search
from pygraph.readwrite.dot import write

import subprocess

class Graph(object):
	def __init__(self, numNodes, minC, maxC):
		self._nodes = []
		it = 0
		while it < numNodes:
			self._nodes.append(Node(it))
			it+=1

		for x in self._nodes:
			x.makeConnections(self._nodes, maxC, minC)
		
		self.curValue = self._nodes[0].name

	def printGraph(self):
		gr = digraph()
		for x in self._nodes:
			gr.add_node(x.name)
		
		for x in self._nodes:
			x.addEdges(gr)

		dot = write(gr)
		f = open("dotGr", 'w')
		f.write(dot)
		f.close()

		proc = subprocess.Popen('dot -Tjpg dotGr -o dotGr.jpg', shell=True, stdout=subprocess.PIPE,)
		r = proc.communicate()[0]
		print r

	def getNodes(self):
		return self._nodes
