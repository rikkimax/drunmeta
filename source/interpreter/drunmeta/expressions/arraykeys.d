module drunmeta.expressions.arraykeys;
import drunmeta.expression;
import drunmeta.common;
import drunmeta.value;
import drunmeta.exceptions;
import std.conv;

class ArrayKeysExpression : Expression {
	this(Value[] expression ...) {
		this.expression = expression;
		this.type = ValueType.Array;
		expressionType_ = ExpressionType.ArrayKeys;
	}

	void handle(Code code)
	in {
		if (expression.length != 1) {
			throw new InvalidNumberOfValuesException(debugInfo);
		}
	} body {
		if (expression[0].type == ValueType.Array) {
			Value[string] ret;
			foreach(i, v; expression[0].a.keys) {
				ret[to!string(i)] = new Value(v);
			}
			this.a = ret;
		}
	}
}

unittest {
	import drunmeta.statements.output;

	/*
	 * $0 = [0 : "bye", 1 : "hi"].keys
	 */

	Code code = new Code();
	code.statements ~= new Output(new ArrayKeysExpression(new Value(["0" : new Value("bye"), "1" : new Value("hi")])), "0");
	code.execute();

	assert(code.variables["0"].s == "[0 : 0, 1 : 1]");
}