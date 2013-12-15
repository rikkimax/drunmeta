module drunmeta.exceptions;
import drunmeta.common;
import std.conv;

class DRunMetaException : Exception {
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

class InvalidValueException : DRunMetaException {
	this(DebugInfo info) {
		if (info == DebugInfo.init) {
			super("Value given was invalid.");
		} else {
			super("Value given was invalid at line #" ~ to!string(info.line) ~ ":" ~ to!string(info.charactor) ~ " for code " ~ info.text);
		}
	}
}

class InvalidFunctionNameException : DRunMetaException {
	this(DebugInfo info) {
		if (info == DebugInfo.init) {
			super("Specified function is not defined.");
		} else {
			super("Specified function is not defined at line #" ~ to!string(info.line) ~ ":" ~ to!string(info.charactor) ~ " for code " ~ info.text);
		}
	}
}

class InvalidNumberOfValuesException : DRunMetaException {
	this(DebugInfo info) {
		if (info == DebugInfo.init) {
			super("Invalid number of values passed.");
		} else {
			super("Invalid number of values passed at line #" ~ to!string(info.line) ~ ":" ~ to!string(info.charactor) ~ " for code " ~ info.text);
		}
	}
}

unittest {
	import drunmeta.statements.call;

	Code code;

	code = new Code();
	code.statements ~= new CallFunction("test");

	try {
		code.execute();
		assert(0);
	} catch(InvalidFunctionNameException ifne) {
		assert(1);
	}

	code = new Code();
	CallFunction cf = new CallFunction("test");
	cf.debugInfo = DebugInfo("test();", 0, 0);
	code.statements ~= cf;
	
	try {
		code.execute();
		assert(0);
	} catch(InvalidFunctionNameException ifne) {
		assert(ifne.msg == "Specified function is not defined at line #0:0 for code test();");
	}
}