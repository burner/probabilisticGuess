import random
from util import randintuni as randintuni
from util import randMakeOne as randMakeOne

class Node(object):
	def __init__(self, name):
		self.name = name
		self.next = []

	def makeConnections(self, list, maxC, minC):
		con = random.randint(minC, maxC)
		listIdx = []
		x = 0
		while x < con:
			listIdx.append(randintuni(listIdx,0, len(list)-1))
			x+=1

		for x in listIdx:
			#print self.name, x
			self.next.append(list[x])

		self._proNext = randMakeOne(len(self.next))
		random.shuffle(self._proNext)

	def addEdges(self, gr):
		i = 0
		for x in self.next:
			#print self.name, x.name
			gr.add_edge(self.name, x.name, self._proNext[i], str(self._proNext[i]))
			i+=1

	def guess(self, d, minD, list, prob):
		i = 0
		if d+1 == int(minD):
			while i < len(self.next):
				if self._proNext[i]*prob < 0.2:
					i+=1
					continue
				list.append( (self.next[i].name, self._proNext[i]*prob))
				i+=1
		else:
			while i < len(self.next):
				if self._proNext[i]*prob < 0.2:
					i+=1
					continue
				self.next[i].guess(d+1, minD, list, self._proNext[i]*prob)
				i+=1

		return list
