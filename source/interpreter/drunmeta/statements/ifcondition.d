module drunmeta.statements.ifcondition;
import drunmeta.value;
import drunmeta.common;
import drunmeta.expressions.conditional;
import drunmeta.exceptions;

class IfCondition : Statement {
	this(ConditionType type, Value* a, Value* b) {
		statementType = StatementType.IfCondition;
		this.type = type;
		aPtr = a;
		bPtr = b;
	}

	this(ConditionType type, Value a, Value b) {
		statementType = StatementType.IfCondition;
		this.type = type;
		aV = a;
		bV = b;
		aPtr = &aV;
		bPtr = &bV;
	}

	this(ConditionType type, Value* a) {
		statementType = StatementType.IfCondition;
		this.type = type;
		aPtr = a;
		bPtr = null;
	}
	
	this(ConditionType type, Value a) {
		statementType = StatementType.IfCondition;
		this.type = type;
		aV = a;
		aPtr = &aV;
		bPtr = null;
	}
	
	ConditionType type;
	Value* aPtr;
	Value* bPtr;

	private {
		Value aV;
		Value bV;
	}
	
	Statement[] truePath;
	Statement[] falsePath;

	void handle(Code code)
	in {
		if (aPtr is null) {
			throw new InvalidValueException(debugInfo);
		}
	} body {
		Value a = *aPtr;
		a.accessing(code);
		if (bPtr is null) {
			if (conditionalResult(type, a)) {
				nextFunction(truePath, code);
			} else {
				nextFunction(falsePath, code);
			}
		} else {
			Value b = *bPtr;
			b.accessing(code);

			if (conditionalResult(type, a, b)) {
				nextFunction(truePath, code);
			} else {
				nextFunction(falsePath, code);
			}
		}
	}
}

unittest {
	import drunmeta.statements.output;
	Code code = new Code();
	IfCondition ifc;

	// ConditionType.Equals

	ifc = new IfCondition(ConditionType.Equals, new Value("abc"), new Value("def"));
	ifc.truePath ~= new Output(new Value("equal"), "0");
	ifc.falsePath ~= new Output(new Value("not equal"), "0");
	code.statements ~= ifc;

	ifc = new IfCondition(ConditionType.Equals, new Value("abc"), new Value("abc"));
	ifc.truePath ~= new Output(new Value("equal"), "1");
	ifc.falsePath ~= new Output(new Value("not equal"), "1");
	code.statements ~= ifc;

	// ConditionType.NotEquals

	ifc = new IfCondition(ConditionType.NotEquals, new Value("abc"), new Value("abc"));
	ifc.truePath ~= new Output(new Value("not equal"), "2");
	ifc.falsePath ~= new Output(new Value("equal"), "2");
	code.statements ~= ifc;

	ifc = new IfCondition(ConditionType.NotEquals, new Value("abc"), new Value("def"));
	ifc.truePath ~= new Output(new Value("not equal"), "3");
	ifc.falsePath ~= new Output(new Value("equal"), "3");
	code.statements ~= ifc;

	// ConditionType.Boolean

	ifc = new IfCondition(ConditionType.Boolean, new Value(true));
	ifc.truePath ~= new Output(new Value("true"), "4");
	ifc.falsePath ~= new Output(new Value("false"), "4");
	code.statements ~= ifc;

	ifc = new IfCondition(ConditionType.Boolean, new Value(false));
	ifc.truePath ~= new Output(new Value("true"), "5");
	ifc.falsePath ~= new Output(new Value("false"), "5");
	code.statements ~= ifc;

	code.execute();

	// ConditionType.Equals
	assert(code.variables["0"].s == "not equal");
	assert(code.variables["1"].s == "equal");

	// ConditionType.NotEquals
	assert(code.variables["2"].s == "equal");
	assert(code.variables["3"].s == "not equal");

	// ConditionType.Boolean
	assert(code.variables["4"].s == "true");
	assert(code.variables["5"].s == "false");
}