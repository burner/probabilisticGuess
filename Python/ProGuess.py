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

import wx
import Graph
import sys

wx.SetDefaultPyEncoding("iso-8859-15")

class MainFrame(wx.Frame):
	def __init__(self, parent=None, id=-1, title='Probabilistic Guess'):
		#self._jpg = wx.Image("dotGr.jpg", wx.BITMAP_TYPE_JPEG).Scale(700,500)
		self._jpg = wx.Image("dotGr.jpg", wx.BITMAP_TYPE_JPEG)
		self._bmp = self._jpg.ConvertToBitmap()
		wx.Frame.__init__(self, parent, id, title, size=(800, 650))
		self.size = (400, 400)
		self.zoomfactor = 100
		panel = wx.Panel(self, -1, size=self.size)
		txt_zoom = wx.StaticText(panel, -1, 'zoom:')
		choices = ('12%', '25%', '50%', '75%', '100%', '200%', '400%')
		self.zoom_selection = wx.ComboBox(panel, -1, size=(60, 23),
			choices=choices, style=wx.TE_PROCESS_ENTER)
		self.zoom_selection.SetSelection(4)
		close_button = wx.Button(panel, -1, 'Quit')
		self.scrollw = wx.ScrolledWindow(panel, -1,
			style=wx.SUNKEN_BORDER, size=(800, 580))
		self.scrollw.SetScrollbars(1, 1, self._jpg.GetWidth(),self._jpg.GetHeight() )
		numBoxLa = wx.StaticText(panel, -1, 'num Nodes:')
		self.numText = wx.TextCtrl(panel, -1)
		numMinLa = wx.StaticText(panel, -1, 'min Con:')
		self.numMin = wx.TextCtrl(panel, -1)
		numMaxLa = wx.StaticText(panel, -1, 'max Con:')
		self.numMax = wx.TextCtrl(panel, -1)
		lineZero = wx.BoxSizer(wx.HORIZONTAL)
		#lineZero.Add((20, 0))
		lineZero.Add(txt_zoom)
		#lineZero.Add((10, 10))
		lineZero.Add(self.zoom_selection)
		#lineZero.Add((0,10))
		lineZero.Add(numBoxLa)
		#lineZero.Add((0,10))
		lineZero.Add(self.numText)
		#lineZero.Add((0,10))
		lineZero.Add(numMinLa)
		#lineZero.Add((0,10))
		lineZero.Add(self.numMin)
		#lineZero.Add((0,10))
		lineZero.Add(numMaxLa)
		#lineZero.Add((0,10))
		lineZero.Add(self.numMax)
		newGraph = wx.Button(panel, -1, 'New Graph')
		#lineZero.Add((0,10))
		lineZero.Add(newGraph)

		simButton = wx.Button(panel, -1, 'Simulate')
		lineZero.Add(simButton)

		lineOne = wx.BoxSizer(wx.HORIZONTAL)
		lineOne.Add(close_button)
		self.mnumWrPerT = wx.TextCtrl(panel, -1)
		mnumWrPerTL = wx.StaticText(panel, -1, 'Max Datawrite per Timeunit:')
		lineOne.Add(mnumWrPerTL)
		lineOne.Add(self.mnumWrPerT)
		self.inumWrPerT = wx.TextCtrl(panel, -1)
		inumWrPerTL = wx.StaticText(panel, -1, 'Min Datawrite per Timeunit:')
		lineOne.Add(inumWrPerTL)
		lineOne.Add(self.inumWrPerT)
		self.numTest = wx.TextCtrl(panel, -1)
		numTestL = wx.StaticText(panel, -1, 'Number of tests')
		lineOne.Add(numTestL)
		lineOne.Add(self.numTest)
		
		mainsizer = wx.BoxSizer(wx.VERTICAL)
		#mainsizer.Add((0, 10))
		mainsizer.Add(lineZero, 0, wx.ALIGN_LEFT)
		#mainsizer.Add((0, 10))
		mainsizer.Add(lineOne, 0, wx.ALIGN_LEFT)
		#mainsizer.Add((0, 10))
		mainsizer.Add(self.scrollw, 0, wx.ALIGN_LEFT)

		topsizer = wx.BoxSizer(wx.HORIZONTAL)
		topsizer.Add(mainsizer, 0, wx.ALIGN_LEFT)

		panel.SetSizer(topsizer)
		self.Bind(wx.EVT_BUTTON, self.close, close_button)
		self.Bind(wx.EVT_COMBOBOX, self.setZoom, self.zoom_selection)
		self.Bind(wx.EVT_TEXT_ENTER, self.setZoom, self.zoom_selection)
		self.Bind(wx.EVT_BUTTON, self.newGraphMethode, newGraph)
		self.Bind(wx.EVT_BUTTON, self.simulate, simButton)
		self.action()

	def newGraphMethode(self, event):
		tmp = Graph.Graph(int(self.numText.GetValue()), int(self.numMin.GetValue()), int(self.numMax.GetValue()))
		tmp.printGraph()
		jpg = wx.Image("dotGr.jpg", wx.BITMAP_TYPE_JPEG)
		h = (int((jpg.GetWidth()/100.0)*self.zoomfactor), int((jpg.GetHeight()/100.0)*self.zoomfactor))
		print h
		bmp = jpg.Scale(h[0], h[1]).ConvertToBitmap()
		self._jpg = jpg
		self._bmp = bmp

	def simulate(self, event):
		print "simulate stub"

	def action(self, event=None):
		#print self.zoomfactor
		h = (int((self._jpg.GetWidth()/100.0)*self.zoomfactor), int((self._jpg.GetHeight()/100.0)*self.zoomfactor))
		#print h
		self._bmp = self._jpg.Scale(h[0], h[1]).ConvertToBitmap()
		#self._bmp = self._jpg.Scale(int(100*self._jpg.GetWidth()/self.zoomfactor), int(100*self._jpg.GetHeight()/self.zoomfactor)).ConvertToBitmap()
		#self._bmp = self.get_base_bitmap()
		self.scrollw.SetScrollbars(1,1, h[0], h[1])
		self.scrollw.Bind(wx.EVT_PAINT, self.on_paint)
		self.drawPicture()
		self.Refresh()

	def get_base_bitmap(self):
		dc = wx.MemoryDC(self._bmp)
		#dc.SetBackground(wx.WHITE_BRUSH)
		#dc.Clear()
		#dc.SelectObject(wx.NullBitmap)
		return self._bmp

	def on_paint(self, event=None):
		wx.BufferedPaintDC(self.scrollw, self._bmp, style=wx.BUFFER_VIRTUAL_AREA)

	def setZoom(self, event=None):
		z = self.zoom_selection.GetValue().replace('%','')
		try:
			self.zoomfactor = int(z)
			#print self.zoomfactor
			#self.zoomfactor=1.0/self.zoomfactor
			#print self.zoomfactor
		except ValueError:
			pass
		self.action()

	def drawPicture(self):
		dc = wx.MemoryDC(self._bmp)
		#gap = self.zoomfactor / 5
		#for y in xrange(5, 401, gap):
		#	dc.DrawLine(5, y, 395, y)
		#for x in xrange(5, 401, gap):
		#	dc.DrawLine(x, 5, x, 395)
		#dc.SelectObject(wx.NullBitmap)

	def close(self, event):
		self.Destroy()

def main():
	if 1 < len(sys.argv):
		foo = Graph.Graph(int(sys.argv[1]),int(sys.argv[2]),int(sys.argv[3]))
		foo.printGraph()
	app = wx.PySimpleApp()
	frame = MainFrame()
	frame.Show()
	app.MainLoop()

if __name__ == "__main__":
	main() 
