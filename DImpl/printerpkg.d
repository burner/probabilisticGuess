/* Copyright (C) 2010 - Robert Schadek
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
* 
*/

module printerpkd;

import tango.io.Stdout;
import Time = tango.time.Time;
import tango.time.Clock;
import tango.text.locale.Locale;

class Printer {
	static Locale layout;
	static this() {
		layout = new Locale;
	}
	public static synchronized void print(char[] toPrint) {
		char[] time = layout("{:HH:mm:ss}", Clock.now);
		Stdout.formatln("{}  ::  {}",time , toPrint);
	}
}
