module drunmeta.statements.call;
import drunmeta.common;
import drunmeta.exceptions;

class CallFunction : Statement {
	protected {
		string name_;
	}
	
	this(string name) {
		statementType = StatementType.FunctionCall;
		this.name_ = name;
	}

	@property {
		string name() {
			return name_;
		}
	}

	void handle(Code code)
	in {
		if (name_ !in code.functions) {
			throw new InvalidFunctionNameException(debugInfo);
		}
	} body {
		code.functions[name_].handle(code);
	}
}

unittest {
	import drunmeta.statements.output;
	import drunmeta.value;
	
	Code code = new Code();
	code.statements ~= new Output(new Value("rikki"), "name");
	code.statements ~= new CallFunction("outputName");

	Function outputName = new Function();
	outputName.statements ~= new Output(new VariableValue("name"));
	code.functions["outputName"] = outputName;

	code.execute();
}