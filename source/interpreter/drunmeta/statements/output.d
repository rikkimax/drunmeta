module drunmeta.statements.output;
import drunmeta.common;
import drunmeta.value;
import drunmeta.exceptions;
import std.conv;

class Output : Statement {
	protected {
		Value value_;
		string output_ = null;
	}

	this(Value value) {
		this.value_ = value;
	}

	this(Value value, string output) {
		this.value_ = value;
		this.output_ = output;
	}

	@property {
		Value value() {
			return value_;
		}

		string output() {
			return output_;
		}
	}

	void handle(Code code) {
		value.accessing(code);
		if (output_ !is null) {
			string str;
			grabOutput(debugInfo, value_, str);
			code.variables[output_] = new Value(str);
		} else {
			grabOutput(debugInfo, value_, code.stdOut);
			code.stdOut ~= "\n";
		}
	}
}

void grabOutput(DebugInfo debugInfo, Value value, ref string ret)
in {
	if (value is null) {
		throw new InvalidValueException(debugInfo);
	}
} body {
	switch(value.type) {
		case ValueType.Integer:
			ret ~= to!string(value.i);
			break;
		case ValueType.String:
			ret ~= value.s;
			break;
		case ValueType.Float:
			ret ~= to!string(value.f);
			break;
		case ValueType.Boolean:
			ret ~= to!string(value.b);
			break;
		case ValueType.Array:
			bool first = true;
			foreach(k, v; value.a) {
				ret ~= (first ? "[" : ", ") ~ k ~ " : ";
				grabOutput(debugInfo, v, ret);
				first = false;
			}
			ret ~= "]";
			break;
		default:
			break;
	}
}

unittest {
	/*
	 * $0 = [0 : "bye", 1 : "hi"]
	 * output $0
	 */

	Code code = new Code();
	code.statements ~= new Output(new Value(["0" : new Value("bye"), "1" : new Value("hi")]), "0");
	code.execute();

	assert(code.variables["0"].s == "[0 : bye, 1 : hi]");
}