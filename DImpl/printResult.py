import sys
import os
import xml.dom.minidom
from xml.dom.minidom import Node
import random
import matplotlib.pyplot as plt

def main():
	rs = []
	os.chdir(sys.argv[1])
	print "Now in ", sys.argv[1]
	for x in os.listdir("."):
		if x[:6] == "System":
			doc = xml.dom.minidom.parse(x)
			l = doc.getElementsByTagName("ResultSet")[0].getElementsByTagName("System")[0]
			rs.append( (int(str(l.getAttribute("Peers"))), int(str(l.getAttribute("MinWrites"))), int(str(l.getAttribute("MaxWrites"))),
			#int(str("readOperations")),
			float(str(l.getAttribute("readWorked"))), 
			float(str(l.getAttribute("readSuccess"))), 
			float(str(l.getAttribute("readOperations"))), 
			float(str(l.getAttribute("writeOperations"))), 
			float(str(l.getAttribute("writeSuccess"))),
			float(str(l.getAttribute("ProbSuccess"))) ) )
			#rs.append( (int(l.getAttribute("Peers")), int(l.getAttribute("MinWrites")), int(l.getAttribute("MaxWrites")) ) )
	rs.sort(lambda x, y: x[0] - y[0])
	i = []
	j = []
	for x in rs:
		print x
		i.append(x[0])
		j.append(x[4]/x[5])

	plt.plot(i,j, color=(random.random(), random.random(), random.random()))
	plt.savefig(sys.argv[1]+".png", format = 'png')
	plt.show()


if __name__ == "__main__":
	main()
