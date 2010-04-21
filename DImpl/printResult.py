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

import sys
import os
import xml.dom.minidom
from xml.dom.minidom import Node
import random
import matplotlib.pyplot as plt

def main():
	rs = []
	for i in range(5):
		rs.append([])

	os.chdir(sys.argv[1])
	print "Now in ", sys.argv[1]
	for x in os.listdir("."):
		if x[:6] == "System":
			doc = xml.dom.minidom.parse(x)
			l = doc.getElementsByTagName("ResultSet")[0].getElementsByTagName("System")[0]
			rs[int(l.getAttribute("testcast"))].append( (
			int(str(l.getAttribute("Peers"))), 
			int(str(l.getAttribute("MinWrites"))), 
			int(str(l.getAttribute("MaxWrites"))),
			float(str(l.getAttribute("readOperations"))),
			float(str(l.getAttribute("readWorked"))), 
			float(str(l.getAttribute("readSuccess"))), 
			float(str(l.getAttribute("writeOperations"))), 
			float(str(l.getAttribute("writeSuccess"))),
			float(str(l.getAttribute("ProbSuccess"))) ) )
			#rs.append( (int(l.getAttribute("Peers")), int(l.getAttribute("MinWrites")), int(l.getAttribute("MaxWrites")) ) )
	for x in rs:
		x.sort(lambda x, y: x[0] - y[0])
	for y in rs:
		i = []
		j = []
		k = []
		l = []
		print y
		c = (random.random(), random.random(), random.random())
		for x in y:
			i.append(x[0])
			j.append(x[5]/x[3])
			k.append(x[7]/x[6])
			l.append(x[4]/x[3])
			print x[5]/x[3], x[5], x[3]

		plt.plot(i,j, color=c)
		plt.plot(i,k, color=c)
		plt.plot(i,l, color=c)

	plt.savefig(sys.argv[1]+".png", format = 'png')
	plt.show()


if __name__ == "__main__":
	main()
