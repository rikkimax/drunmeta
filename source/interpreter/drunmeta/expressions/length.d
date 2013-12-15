module drunmeta.expressions.length;
import drunmeta.expression;
import drunmeta.common;
import drunmeta.value;

class LengthExpression : Expression {
	this(Value[] expression ...) {
		this.expression = expression;
		this.type = ValueType.Integer;
		expressionType_ = ExpressionType.Length;
	}

	void handle(Code code) {
		if (expression.length == 0) {
			this.i = 0;
		} else if (expression.length == 1) {
			switch(expression[0].type) {
				case ValueType.String:
					this.i = expression[0].s.length;
					break;
				case ValueType.Array:
					this.i = expression[0].a.length;
					break;
				case ValueType.Float:
				case ValueType.Integer:
				case ValueType.Boolean:
					this.i = 1;
					break;
				default:
					this.i = 0;
					break;
			}
		} else {
			this.i = expression.length;
		}
	}
}