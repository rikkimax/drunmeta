module drunmeta.json.code;
import drunmeta.json.statement;
import drunmeta.json.value;
import drunmeta.json.exceptions;
import drunmeta;
import vibe.data.json;

class JsonCode {
	// plain old data
	this() {
	}

	this(Code code) {
		foreach(k, v; code.variables) {
			variables[k] = new JsonValue(v);
		}

		foreach(k, v; code.functions) {
			if (!v.dCode)
				functions[k] = new JsonStatement(v);
		}

		foreach(v; code.statements) {
			statements ~= new JsonStatement(v);
		}
	}

	Code opCast(T : Code)() {
		Code ret = new Code;
		foreach(k, v; variables) {
			ret.variables[k] = cast(Value)v;
		}
		
		foreach(k, v; functions) {
			ret.functions[k] = cast(Function)(v);
		}
		
		foreach(v; statements) {
			ret.statements ~= cast(Statement)(v);
		}
		return ret;
	}

	@optional {
		JsonStatement[] statements;
		JsonStatement[string] functions;
		JsonValue[string] variables;
	}
}