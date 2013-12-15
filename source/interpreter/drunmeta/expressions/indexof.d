module drunmeta.expressions.indexof;
import drunmeta.expression;
import drunmeta.common;
import drunmeta.value;
import drunmeta.exceptions;

class IndexOfExpression : Expression {
	this(Value[] expression ...) {
		this.expression = expression;
		this.type = ValueType.String;
		expressionType_ = ExpressionType.IndexOf;
	}
	
	void handle(Code code)
	in {
		if (expression.length != 2) {
			throw new InvalidNumberOfValuesException(debugInfo);
		}
	} body {
		if (expression.length == 2) {
			if (expression[0].type != ValueType.Array && expression[1].type == ValueType.Array) {
				switch(expression[0].type) {
					case ValueType.String:
						foreach(string i, Value v; expression[1].a) {
							if (v.type == ValueType.String) {
								if (expression[0].s == v.s) {
									this.s = i;
									return;
								}
							}
						}
						break;
					case ValueType.Float:
						foreach(string i, Value v; expression[1].a) {
							if (v.type == ValueType.Float) {
								if (expression[0].f == v.f) {
									this.s = i;
									return;
								}
							}
						}
						break;
					case ValueType.Integer:
						foreach(string i, Value v; expression[1].a) {
							if (v.type == ValueType.Integer) {
								if (expression[0].i == v.i) {
									this.s = i;
									return;
								}
							}
						}
						break;
					case ValueType.Boolean:
						foreach(string i, Value v; expression[1].a) {
							if (v.type == ValueType.Boolean) {
								if (expression[0].b == v.b) {
									this.s = i;
									return;
								}
							}
						}
						break;
					case ValueType.Array:
					default:
						this.s = "";
						break;
				}
			}
		}

		this.s = "";
	}
}

unittest {
	import drunmeta.statements.assignment;

	/*
	 * $0 = [0 : "bye", 1 : "hi"].indexOf("hi")
	 * 
	 */

	Code code = new Code();
	code.statements ~= new VariableAssignment("0", new IndexOfExpression(new Value("hi"), new Value(["0" : new Value("bye"), "1" : new Value("hi")])));
	code.execute();

	assert(code.variables["0"].s == "1");
}