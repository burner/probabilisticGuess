#realburner@gmx.de gpl3
import random
from util import randintuni as randintuni
from util import randMakeOne as randMakeOne

class Node(object):
	def __init__(self, name):
		self.name = name
		self.next = []

	def addEdges(self, gr):
		i = 0
		for x in self.next:
			gr.add_edge(self.name, x.name, self._proNext[i], str(self._proNext[i]))
			i+=1

	def makeConnections(self, list, maxC, minC):
		con = random.randint(minC, maxC)
		listIdx = []
		x = 0
		while x < con:
			listIdx.append(randintuni(listIdx,0, len(list)-1))
			x+=1

		for x in listIdx:
			self.next.append(list[x])

		self._proNext = randMakeOne(len(self.next))
		random.shuffle(self._proNext)

	def guess(self, d, minD, list, prob):
		i = 0
		rnLngth = len(self.next)
		#if the guessed max number of write steps has been reached
		#append the result probability to the result list
		if d+1 == int(minD):
			while i < rnLngth:
				if self._proNext[i]*prob < 0.2: # 0.2 is just a hack should be median or arith middle
					i+=1
					continue
				list.append( (self.next[i].name, self._proNext[i]*prob))
				i+=1
		else:
			while i < rnLngth:
				if self._proNext[i]*prob < 0.2:
					i+=1
					continue
				self.next[i].guess(d+1, minD, list, self._proNext[i]*prob)
				i+=1

		return list
