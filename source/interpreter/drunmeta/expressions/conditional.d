module drunmeta.expressions.conditional;
import drunmeta.expression;
import drunmeta.common;
import drunmeta.value;
import drunmeta.exceptions;
import std.uni;
import std.conv;

class ConditionalExpression : Expression {
	@disable this(Value[] expression ...) {
		this.expression = expression;
	}

	this(ConditionType cType_, Value* a, Value* b) {
		this.type = ValueType.Boolean;
		this.cType_ = cType_;
		aPtr = a;
		bPtr = b;
		expressionType_ = ExpressionType.Conditional;
	}
	
	this(ConditionType cType_, Value a, Value b) {
		this.type = ValueType.Boolean;
		this.cType_ = cType_;
		aV = a;
		bV = b;
		aPtr = &aV;
		bPtr = &bV;
		expressionType_ = ExpressionType.Conditional;
	}
	
	this(ConditionType cType_, Value* a) {
		this.type = ValueType.Boolean;
		this.cType_ = cType_;
		aPtr = a;
		bPtr = null;
		expressionType_ = ExpressionType.Conditional;
	}
	
	this(ConditionType cType_, Value a) {
		this.type = ValueType.Boolean;
		this.cType_ = cType_;
		aV = a;
		aPtr = &aV;
		bPtr = null;
		expressionType_ = ExpressionType.Conditional;
	}

	Value* aPtr;
	Value* bPtr;
	
	protected {
		Value aV;
		Value bV;
		ConditionType cType_;
	}

	@property {
		ConditionType cType() {
			return cType_;
		}
	}

	void handle(Code code)
	in {
		if (aPtr is null) {
			throw new InvalidValueException(debugInfo);
		}
	} body {
		Value aVC = *aPtr;
		aVC.accessing(code);
		if (bPtr is null) {
			b = conditionalResult(cType_, aVC);
		} else {
			Value bVC = *bPtr;
			bVC.accessing(code);
			b = conditionalResult(cType_, aVC, bVC);
		}
	}
}

unittest {
	import drunmeta.statements.assignment;
	
	Code code = new Code();
	code.statements ~= new VariableAssignment("0", new ConditionalExpression(ConditionType.Boolean, new Value(true)));
	code.statements ~= new VariableAssignment("1", new ConditionalExpression(ConditionType.Equals, new Value(2f), new Value(2f)));
	code.statements ~= new VariableAssignment("2", new ConditionalExpression(ConditionType.MoreThen, new Value(2f), new Value(2f)));
	code.execute();
	
	assert(code.variables["0"].b == true);
	assert(code.variables["1"].b == true);
	assert(code.variables["2"].b == false);
}

enum ConditionType : string {
	NotEquals = "NotEquals",
	Equals = "Equals",
	MoreThen = "MoreThen",
	LessThen = "LessThen",
	Boolean = "Boolean",
	Or = "Or",
	And = "And"
}

pure bool conditionalResult(ConditionType type, Value a, Value b = null) {
	if (b is null) {
		switch (type) {
			case ConditionType.Boolean:
				if (a.type == ValueType.Boolean) {
					if (a.b) {
						return true;
					} else {
						return false;
					}
				} else if (a.type == ValueType.String) {
					if (a.s.toLower() == "true") {
						return true;
					} else {
						return false;
					}
				} else if (a.type == ValueType.Integer) {
					if (a.i == 1) {
						return true;
					} else {
						return false;
					}
				} else if (a.type == ValueType.Float) {
					if (a.f == 1) {
						return true;
					} else {
						return false;
					}
				}
				break;
			default:
				break;
		}
	} else if (a.type == b.type && a.type == ValueType.String) {
		if (type == ConditionType.Equals)
			return a.s == b.s;
		else if (type == ConditionType.NotEquals)
			return a.s != b.s;
	} else {
		float x, y;
		switch(a.type) {
			case ValueType.Integer:
				x = a.i;
				break;
			case ValueType.Float:
				x = a.f;
				break;
			case ValueType.Boolean:
				if (a.b)
					x = 1;
				else
					x = 0;
				break;
			case ValueType.String:
				try {
					x = to!float(a.s);
				} catch (ConvException cofe) {
					return false;
				}
				break;
			default:
				return false;
		}
		switch(b.type) {
			case ValueType.Integer:
				y = b.i;
				break;
			case ValueType.Float:
				y = b.f;
				break;
			case ValueType.Boolean:
				if (b.b)
					y = 1;
				else
					y = 0;
				break;
			case ValueType.String:
				try {
					y = to!float(b.s);
				} catch (ConvException ce) {
					return false;
				}
				break;
			default:
				return false;
		}

		switch(type) {
			case ConditionType.Equals:
				return x == y;
			case ConditionType.NotEquals:
				return x != y;
			case ConditionType.MoreThen:
				return x > y;
			case ConditionType.LessThen:
				return x < y;
			default:
				break;
		}
	}
	
	return false;
}