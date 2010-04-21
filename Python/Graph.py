#realburner@gmx.de gpl3
from Node import Node as Node
from pygraph.classes.digraph import digraph
from pygraph.algorithms.searching import breadth_first_search
from pygraph.readwrite.dot import write
from threading import Thread
from threading import Semaphore as Sem
import subprocess
import random
import os

class Graph(object):
	def __init__(self, numNodes, minC, maxC):
		self.curTime = 0.0
		self._nodes = []
		it = 0
		while it < numNodes:
			self._nodes.append(Node(it))
			it+=1
		
		random.shuffle(self._nodes)

		for x in self._nodes:
			x.makeConnections(self._nodes, maxC, minC)
		
		self.curValue = self._nodes[0].name

	def printGraph(self, name, dir):
		dTh = PrintGraphThread(dir, name, self._nodes)
		dTh.start()


dirLck = Sem(1) 

class PrintGraphThread(Thread):
	def __init__(self,dir,filename,nodes):
		Thread.__init__(self)	
		self.dir = dir
		self.filename = filename
		self.nodes = nodes
	
	def run(self):
		#print "save graph in dir"
		gr = digraph()
		for x in self.nodes:
			gr.add_node(x.name)
		
		for x in self.nodes:
			x.addEdges(gr)
		
		dirLck.acquire()
		if not os.path.isdir(self.dir):
			if -1 == os.getcwd().find(self.dir):
				os.mkdir(self.dir)
		dirLck.release()
			
		if -1 == os.getcwd().find(self.dir):
			os.chdir(self.dir)

		dot = write(gr)
		f = open(self.filename, 'w')
		f.write(dot)
		f.close()

		proc = subprocess.Popen('dot -Tjpg ' + self.filename +' -o ' +  self.filename + '.jpg', shell=True, stdout=subprocess.PIPE,)
		r = proc.communicate()[0]
		print ""
