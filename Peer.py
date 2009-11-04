from util import randBoolRange as probTrue

class Peer(object):
	def __init__(self, initValue):
		self.value = initValue
		self.time = 0

	def write(self, graph:
		probList = graph._nodes[graph.curValue]._proNext
		i = 0
		foundIdx = -1
		small = 2.0
		smallIdx = -1
		while i < len(probList):
			if probTrue(probList[i]):
				foundIdx = i
				break
			if probList[i] < small:
				small = probList[i]
				smallIdx = i
			i+=1

		if foundIdx not -1:
			value = graph._nodes[graph.curValue]._proNext[foundIdx].name
			graph.curValue = value
			self.value = value
			self.time = graph.curTime+1
			graph.curTime+=1
		else:
			value = graph._nodes[graph.curValue]._proNext[smallIdx].name
			graph.curValue = value
			self.value = value
			self.time = graph.curTime+1
			graph.curTime+=1

	def guess(self, graph):

	def read(self):
		return self.value
