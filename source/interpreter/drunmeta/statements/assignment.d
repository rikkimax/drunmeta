module drunmeta.statements.assignment;
import drunmeta.common;
import drunmeta.value;
import drunmeta.exceptions;

class VariableAssignment : Statement {
	protected {
		string name_;
		string key_;
	}

	Value* aPtr;

	private {
		Value aV;
	}
	this(string name, Value* a) {
		statementType = StatementType.Assignment;
		this.name_ = name;
		this.key_ = null;
		aPtr = a;
	}
	
	this(string name, Value a) {
		statementType = StatementType.Assignment;
		this.name_ = name;
		this.key_ = null;
		aV = a;
		aPtr = &aV;
	}

	this(string name, string key, Value* a) {
		statementType = StatementType.Assignment;
		this.name_ = name;
		this.key_ = key;
		aPtr = a;
	}
	
	this(string name, string key, Value a) {
		statementType = StatementType.Assignment;
		this.name_ = name;
		this.key_ = key;
		aV = a;
		aPtr = &aV;
	}

	@property {
		string name() {
			return name_;
		}

		string key() {
			return key_;
		}
	}
	
	void handle(Code code)
	in {
		if (aPtr is null) {
			throw new InvalidValueException(debugInfo);
		}
	} body {
		aV = *aPtr;

		aV.accessing(code);
		if (key_ is null) {
			code.variables[name] = aV;
		} else {
			if (name_ !in code.variables) {
				code.variables[name_] = Value.ArrayType;
			}

			code.variables[name_].a[key_] = aV;
		}
	}
}

unittest {
	import drunmeta.statements.output;

	/*
	 * $test["hi"] = "something"
	 * output $test["hi"]
	 * 
	 * $test = "blah"
	 * output $test
	 */

	Code code = new Code();

	code.statements ~= new VariableAssignment("test", "hi", new Value("something"));
	code.statements ~= new Output(new VariableValue("test", "hi"), "0");

	code.statements ~= new VariableAssignment("test", new Value("blah"));
	code.statements ~= new Output(new VariableValue("test"), "1");

	code.execute();

	assert(code.variables["0"].s == "something");
	assert(code.variables["1"].s == "blah");
}