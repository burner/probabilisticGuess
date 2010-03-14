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
