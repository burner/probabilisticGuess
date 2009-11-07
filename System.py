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
			self.peers.append(Peer.Peer(0))
			i+=1

	def write(self):
		wrCnt = random.randint(self.minNumWr, self.maxNumWr)
		self.tests.append(wrCnt)
		times = util.randMakeOne(wrCnt)
		i = 0
		while i < wrCnt:
			idx = random.randint(0, len(self.peers)-1)
			self.peers[idx].write(self.graph, times[i])
			i+=1

	def sim(self):
		i = 0
		while i < self.numTests:
			#print "Iteration " + str(i) + " of " + str(self.numTests)
			self.write()
			#print "Guess"
			self.guess()
			i+=1

	def guess(self):
		idx = random.randint(0, len(self.peers)-1)
		tf = self.peers[idx].guess(self.graph, self.maxNumWr-self.minNumWr, self.tests[-1])
		self.right.append(tf)

	def makeResult(self):
		print "Steps"
		print self.tests
		print "\n"
		print "Results"
		print self.right
	
	def makeResultSet(self):
		sumR = []
		sum = []
		for x in range(self.maxNumWr-self.minNumWr):
			sum.append(0)
			sumR.append(0)

		sumCnt = 0.0
		sumRCnt = 0.0
		i = 0
		while i < len(self.right):
			sum[self.right[i][3]-self.minNumWr-1]+=1
			sumCnt+=1
			if self.right[i][0]:
				sumR[self.right[i][3]-self.minNumWr-1]+=1
				sumRCnt+=1
			i+=1

		self.result = []
		#print sumRCnt
		#print sumCnt
		self.avg = sumRCnt/float(sumCnt)
		i = 0
		while i < len(sumR):
			self.result.append(float(sumR[i])/sum[i])
			i+=1

		return (self.result, self.avg, self.tests, self.minNumWr, self.maxNumWr, self.numPeers, self.numTests)
