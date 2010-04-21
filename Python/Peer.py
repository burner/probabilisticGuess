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

from util import randBoolRange as probTrue
import math
 
class Peer(object):
	def __init__(self, initValue, lam):
		self.value = initValue
		self.time = 0
		self.lfStt = True
		self.sttTm = 0
		self.lam = lam

	def write(self, graph, time):
		#get the probability off the next written value
		probList = graph._nodes[graph.curValue]._proNext
		i = 0
		foundIdx = -1
		high = 0.0
		highIdx = -1
		rnLngth = len(probList)
		while i < rnLngth:
			#pick the value which should be written next according by its
			#probability (util.randBoolRange
			if probTrue(probList[i]):
				foundIdx = i
				break
			#get the highest just in case no ones find
			if probList[i] > high:
				high = probList[i]
				highIdx = i
			i+=1
		
		if foundIdx != -1:
			value = graph._nodes[foundIdx].name
			graph.curValue = value
			self.value = value
			self.time = graph.curTime+time
			graph.curTime+=time
		else:
			value = graph._nodes[highIdx].name
			graph.curValue = value
			self.value = value
			self.time = graph.curTime+time
			graph.curTime+=time

	def guess(self, graph, wrCntAvg, wrCnt):
		#calc timediff to current System time and the number of
		#properly writes
		deltaTime = graph.curTime - self.time
		guessWrCnt = deltaTime*wrCntAvg
		
		#if stepcnt suggests no steps has been taken
		#or this is the last peer written
		if deltaTime <= 0.0:
			#print "\tEqual Time" + str(guessWrCnt)
			return (True, self.value, graph.curValue, wrCnt)
		
		#call all following noods within the graph
		i = 0
		probSets = []
		rnLngth = len(graph._nodes[self.value].next)
		while i < rnLngth:
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
			return (True, graph._nodes[idx].name, graph.curValue, wrCnt)
		else:
			return (False, graph._nodes[idx].name, graph.curValue, wrCnt)	
