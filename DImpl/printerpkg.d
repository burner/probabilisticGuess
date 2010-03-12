module printerpkd;

import tango.io.Stdout;

class Printer {
	public static synchronized void print(char[] toPrint) {
		Stdout.formatln("{}", toPrint);
	}
}
