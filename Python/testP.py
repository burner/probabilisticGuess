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
import random
from System import System as System
import matplotlib.pyplot as plt

#foo = Graph.Graph(10,2,3)
#num Nodes, min Edges, max Edges
#uncommit this to print graph to dotGr.jpg
#foo.printGraph()

# numPeers, minNumWr, maxNumWr, numberOfTimeSteps
#bar = System(foo,150, 2, 15, 400)
#bar.sim()
#bar.makeResult()
#rs = bar.makeResultSet()

plt.ylabel("result 0.0-1.0")
plt.xlabel("#peers")

k = 1
j = 1
while j < 8:
	x = []
	y = []
	i = 1
	#num Nodes, min Edges, max Edges
	foo = Graph.Graph(10*j,2+k,4*k)
	foo.printGraph(str(j))
	while i < 800:
		#numPeers, minNumWr, maxNumWr, numberOfTimeSteps
		tmp = System(foo, i, 2, 15, 4000)
		tmp.sim()
		rs = tmp.makeResultSet()
		x.append(i)
		y.append(rs[1])
		i+=1
	plt.plot(x,y, color=(random.random(), random.random(), random.random()), label="#Node = " +str(10*j) + ", minCon = " + str(2+k) + ", maxCon = " + str(3*k))

	print str(j) + " done"
	j+=1
	k+=1

plt.legend()
plt.show()
