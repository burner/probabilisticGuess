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

class ImageDis(wx.ScrolledWindow):
	def __init__(self, parent, id):
		wx.Panel.__init__(self, parent, id)
		try:
			imageFile = "dotGr.jpg"
			jpg1 = wx.Image(imageFile, wx.BITMAP_TYPE_JPEG).Scale(1024,650)
			tmp = jpg1.ConvertToBitmap()
			wx.StaticBitmap(self, -1, tmp, (0,0))
		except IOError:
			print "Image file %s not found" % imageFile
			raise SystemExit

		#self.SetScrollBars(0,jpg1.getWidth(), 0,jpg1.getHeigth())

app = wx.PySimpleApp()
frame1 = wx.Frame(None, -1, "Probabilistic Guess", size = (1024,700))
ImageDis(frame1, -1)
frame1.Show(1)
app.MainLoop()
