import Graph
import Peer
import Node
import util

import random

class System(object):
	def __init__(self, graph, numPeers, minNumWr, maxNumWr, testReads, timeIcr, timesCTest, times):
		self.graph = graph
		self.numPeers = numPeers
		self.minNumWr = minNumWr
		self.maxNumWr = maxNumWr
		self.testReads = testReads

		#init peers
		self.peers = []
		i = 0
		while i < numPeers:
			self.peers.append(Peer.Peer(self.graph))
			i+=1

		#in what timesteps to increment
		self.timeIcr = timeIcr
		self.time = 0
	
		#how often to test a time
		self.timesCTest
		self.timesCTestCnt = 0

		#how many incre steps
		self.times
		self.timesCnt = 0

	def write(self):
		idx = random.randint(0, len(self.peers))
		self.peers[idx].write(self.graph)		
		
	def increTime(self):
		if self.timeCTestCnt >= self.timesCTest:
			self.timeCTestCnt = 0
			self.time+=self.timeIcr
			self.timesCnt+=1
		else:
			self.timeCTestCnt+=1

