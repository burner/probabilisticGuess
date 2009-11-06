from util import randBoolRange as probTrue
 
class Peer(object):
	def __init__(self, initValue):
		self.value = initValue
		self.time = 0

	def write(self, graph, time):
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

		if foundIdx != -1:
			value = graph._nodes[foundIdx].name
			graph.curValue = value
			self.value = value
			self.time = graph.curTime+time
			graph.curTime+=time
		else:
			value = graph._nodes[smallIdx].name
			graph.curValue = value
			self.value = value
			self.time = graph.curTime+time
			graph.curTime+=time

	def guess(self, graph, wrCntAvg):
		deltaTime = graph.curTime - self.time
		guessWrCnt = deltaTime*wrCntAvg
		
		#if stepcnt suggests no steps has been taken
		if deltaTime <= 0.0:
			#print "\tEqual Time" + str(guessWrCnt)
			return (True, self.value, graph.curValue)
		
		#call all following noods within the graph
		i = 0
		probSets = []
		while i < len(graph._nodes[self.value].next):
			#print "\tPeer Guess"
			graph._nodes[self.value].next[i].guess(0, guessWrCnt, probSets, graph._nodes[self.value]._proNext[i])
			i+=1

		#get biggest value from list
		prob = 0.0
		idx = 0
		for x in probSets:
			if x[1] > prob:
				idx = x[0]
		
		if graph._nodes[idx].name == graph.curValue:
			return (True, idx, graph.curValue)
		else:
			return (False, idx, graph.curValue)	

	def read(self):
		return self.value
