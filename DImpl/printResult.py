import sys
import os
import xml.dom.minidom
from xml.dom.minidom import Node

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
			int(str(l.getAttribute("readWorked"))), 
			int(str(l.getAttribute("readSuccess"))), 
			int(str(l.getAttribute("readOperations"))), 
			int(str(l.getAttribute("writeOperations"))), 
			int(str(l.getAttribute("writeSuccess"))),
			float(str(l.getAttribute("ProbSuccess"))) ) )
			#rs.append( (int(l.getAttribute("Peers")), int(l.getAttribute("MinWrites")), int(l.getAttribute("MaxWrites")) ) )
	rs.sort(lambda x, y: x[0] - y[0])
	for x in rs:
		print x


if __name__ == "__main__":
	main()
