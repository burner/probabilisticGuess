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
