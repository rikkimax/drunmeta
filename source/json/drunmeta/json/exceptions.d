module drunmeta.json.exceptions;
import drunmeta.common;
import std.conv;

class DRunMetaJsonException : Exception {
	private this(string s) {
		super(s);
	}
	
	DebugInfo debugInfo;
	
	this(DebugInfo info) {
		debugInfo = info;
		if (info == DebugInfo.init) {
			super("Error.");
		} else {
			super("Error at line #" ~ to!string(info.line) ~ ":" ~ to!string(info.charactor) ~ " for code " ~ info.text);
		}
	}
}

class InvalidValueTypeException : DRunMetaJsonException {
	this(DebugInfo info) {
		if (info == DebugInfo.init) {
			super("Value type given was invalid.");
		} else {
			super("Value type given was invalid at line #" ~ to!string(info.line) ~ ":" ~ to!string(info.charactor) ~ " for code " ~ info.text);
		}
	}
}