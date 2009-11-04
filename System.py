import Graph
import Peer
import Node
import util

import random

class System(object):
	def __init__(self, graph, numPeers, minNumWr, maxNumWr, numTests):
		self.graph = graph
		self.numPeers = numPeers
		self.minNumWr = minNumWr
		self.maxNumWr = maxNumWr
		self.numTests = numTests
		self.tests = []
		self.right = []

		#init peers
		self.peers = []
		i = 0
		while i < numPeers:
			self.peers.append(Peer.Peer(self.graph))
			i+=1

	def write(self):
		wrCnt = random.randint(self.minNumWr, self.maxNumWr)
		self.tests.append(wrCnt)
		i = 0
		while i < wrCnt:
			idx = random.randint(0, len(self.peers))
			self.peers[idx].write(self.graph)
			i+=1

	def sim(self):
		i = 0
		while i < self.numTests:
			self.write()
			self.guess()

	def guess(self):
		idx = random.randint(0, len(self.peers))
		tf = self.peers[idx].guess(self.graph)
		self.right.append(tf)
