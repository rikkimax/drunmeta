module drunmeta.functions.currenttime;
import drunmeta.common;
import drunmeta.value;

import std.datetime;

class CurrentTimeFunction : Function {
	@disable Statement[] statements;
	static string[] argsNames;

	this() { super();  dCode = true; }

	override void handle(Code code) {
		code.variables[mangledReturnName] = new Value(Clock.currTime().toUnixTime());
	}
}