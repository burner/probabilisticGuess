# Copyright (C) 2010 - Robert Schadek
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
# 

import Graph
import Peer
import Node
import util
import random
from threading import Thread

class System(Thread):
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
		#i is the data of the peer as well as the key
		i = 0
		while i < numPeers:
			self.peers.append(Peer.Peer(i,0))
			i+=1

		self.done = False
		Thread.__init__(self)

	def write(self):
		wrCnt = random.randint(self.minNumWr, self.maxNumWr)
		self.tests.append(wrCnt)
		times = util.randMakeOne(wrCnt)
		i = 0
		while i < wrCnt:
			idx = random.randint(0, len(self.peers)-1)
			self.peers[idx].write(self.graph, times[i])
			i+=1

	def run(self):
		print "run start"
		self.sim()
		print "run done"
		self.done = True

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
		rnLngth = len(self.right)
		while i < rnLngth:
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
