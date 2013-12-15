module drunmeta.expressions.concat;
import drunmeta.common;
import drunmeta.value;
import drunmeta.expression;
import std.conv;

class ConcatExpression : Expression {
	this(Value[] expression ...) {
		type = ValueType.String;
		this.expression = expression;
		expressionType_ = ExpressionType.Concat;
	}

	void handle(Code code) {
		s = "";

		foreach(v; expression) {
			v.accessing(code);
			if (v.type == ValueType.String) {
				s ~= v.s;
			} else if (v.type == ValueType.Integer) {
				s ~= to!string(v.i);
			} else if (v.type == ValueType.Float) {
				s ~= to!string(v.f);
			} else if (v.type == ValueType.Boolean) {
				if (v.b) {
					s ~= "true";
				} else {
					s ~= "false";
				}
			}
		}
	}
}

unittest {
	import drunmeta.statements.output;

	Code code = new Code();
	code.statements ~= new Output(new ConcatExpression(new Value("a"), new Value(1), new Value(true)), "0");
	code.execute();

	assert(code.variables["0"].s == "a1true");
}