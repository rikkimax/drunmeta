module drunmeta.expressions.stringrange;
import drunmeta.common;
import drunmeta.value;
import drunmeta.expression;
import drunmeta.exceptions;

class StringRangeExpression : Expression {
	this(Value[] expression ...) {
		this.expression = expression;
		this.type = ValueType.String;
		expressionType_ = ExpressionType.StringRange;
	}
	
	void handle(Code code)
	in {
		if (expression.length <= 1 || expression.length > 3) {
			throw new InvalidNumberOfValuesException(debugInfo);
		}
	} body {
		this.s = "";

		if (expression.length == 2) {
			if (expression[0].type == ValueType.String && expression[1].type == ValueType.Integer) {
				if (expression[1].i < expression[0].s.length && expression[1].i >= 0) {
					this.s = expression[0].s[cast(size_t)expression[1].i .. $];
				}
			} else if (expression[0].type == ValueType.String && expression[1].type == ValueType.Float) {
				if (expression[1].f < expression[0].s.length && expression[1].f >= 0) {
					this.s = expression[0].s[cast(size_t)expression[1].f .. $];
				}
			}
		} else if (expression.length == 3) {
			size_t start, end;

			switch(expression[1].type) {
				case ValueType.Integer:
					start = cast(size_t) expression[1].i;
					break;
				case ValueType.Float:
					start = cast(size_t) expression[1].f;
					break;
				default:
					return;
			}
			switch(expression[2].type) {
				case ValueType.Integer:
					end = cast(size_t) expression[2].i;
					break;
				case ValueType.Float:
					end = cast(size_t) expression[2].f;
					break;
				default:
					return;
			}

			if (start > 0 && start < end) {} else return;
			if (end < expression[0].s.length && end > start) {} else return;

			this.s = expression[0].s[start .. end];
		}
	}
}

unittest {
	import drunmeta.statements.assignment;

	/*
	 * $0 = "abcdefg".rangeOf(5)
	 * $1 = "abcdefg".rangeOf(1, 4)
	 * $2 = "abcdefg".rangeOf(1, 2)
	 */

	Code code = new Code();
	code.statements ~= new VariableAssignment("0", new StringRangeExpression(new Value("abcdefg"), new Value(5)));
	code.statements ~= new VariableAssignment("1", new StringRangeExpression(new Value("abcdefg"), new Value(1), new Value(4)));
	code.statements ~= new VariableAssignment("2", new StringRangeExpression(new Value("abcdefg"), new Value(1), new Value(2)));
	code.execute();

	assert(code.variables["0"].s == "fg");
	assert(code.variables["1"].s == "bcd");
	assert(code.variables["2"].s == "b");
}