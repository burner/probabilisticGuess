# License: MIT (see COPYING file)

# Import graphviz
import sys
import pydot

# Import pygraph
from pygraph.classes.graph import graph
from pygraph.classes.digraph import digraph
from pygraph.algorithms.searching import breadth_first_search
from pygraph.readwrite.dot import write

# Graph creation
gr = digraph()

# Add nodes and edges
gr.add_nodes(["Portugal","Spain","France","Germany","Belgium","Netherlands","Italy"])
gr.add_nodes(["Switzerland","Austria","Denmark","Poland","Czech Republic","Slovakia","Hungary"])
gr.add_nodes(["England","Ireland","Scotland","Wales"])

gr.add_edge("Portugal", "Spain", 0.5, "0.5")
gr.add_edge("Spain","France")
gr.add_edge("France","Belgium")
gr.add_edge("France","Germany")
gr.add_edge("France","Italy",)
gr.add_edge("Belgium","Netherlands")
gr.add_edge("Germany","Belgium")
gr.add_edge("Germany","Netherlands")
gr.add_edge("England","Wales")
gr.add_edge("England","Scotland")
gr.add_edge("Scotland","Wales")
gr.add_edge("Switzerland","Austria")
gr.add_edge("Switzerland","Germany")
gr.add_edge("Switzerland","France")
gr.add_edge("Switzerland","Italy")
gr.add_edge("Austria","Germany")
gr.add_edge("Austria","Italy")
gr.add_edge("Austria","Czech Republic")
gr.add_edge("Austria","Slovakia")
gr.add_edge("Austria","Hungary")
gr.add_edge("Denmark","Germany")
gr.add_edge("Poland","Czech Republic")
gr.add_edge("Poland","Slovakia")
gr.add_edge("Poland","Germany")
gr.add_edge("Czech Republic","Slovakia")
gr.add_edge("Czech Republic","Germany")
gr.add_edge("Slovakia","Hungary")

# Draw as PNG
dot = write(gr)
f = open("test.dot", 'w')
f.write(dot)
f.close()
