module drunmeta.expressions.bodmas;
import drunmeta.common;
import drunmeta.expression;
import drunmeta.value;
import std.math;
import std.conv;

enum BodmasOperations {
	Power,
	SqrRoot,
	Multiply,
	Divide,
	Addition,
	Subtraction
}

class BodmasExpression : Expression {
	protected {
		BodmasOperations operation_;
	}

	@disable this(Value[] expression ...) {
		this.expression = expression;
	}

	this(BodmasOperations operation, Value[] expression ...) {
		this.expression = expression;
		this.operation_ = operation;
		this.type = ValueType.Float;
		expressionType_ = ExpressionType.Bodmas;
	}

	@property {
		BodmasOperations operation() {
			return operation_;
		}
	}

	void handle(Code code) {
		float pVal = 0f;
		bool first = true;
		bool afterFirst = false;
		foreach (v; expression) {
			v.accessing(code);
			if (operation_ == BodmasOperations.Power) {
				if (v.type == ValueType.Integer) {
					if (first)
						pVal = v.i;
					else
						pVal = pVal.pow(v.i);
				} else if (v.type == ValueType.Float) {
					if (first)
						pVal = v.f;
					else
						pVal = pVal.pow(v.f);
				} else if (v.type ==  ValueType.Boolean) {
					if (!v.b)
						pVal = 0f;
				} else if (v.type == ValueType.String) {
					try {
						if (first)
							pVal = pVal.pow(to!float(v.s));
						else
							pVal = pVal.pow(to!float(v.s));
					} catch (ConvOverflowException cofe) {}
				}
			} else if (operation_ == BodmasOperations.SqrRoot) {
				if (v.type == ValueType.Integer) {
					if (afterFirst)
						pVal *= sqrt(cast(float)v.i);
					else
						pVal = sqrt(cast(float)v.i);
				} else if (v.type == ValueType.Float) {
					if (afterFirst)
						pVal *= sqrt(v.f);
					else
						pVal = sqrt(v.f);
				} else if (v.type ==  ValueType.Boolean) {
					if (!v.b)
						pVal = 0f;
				} else if (v.type == ValueType.String) {
					try {
						if (afterFirst)
							pVal *= sqrt(to!float(v.s));
						else
							pVal = sqrt(to!float(v.s));
					} catch (ConvOverflowException cofe) {}
				}
			} else if (operation_ == BodmasOperations.Multiply) {
				if (v.type == ValueType.Integer) {
					if (afterFirst)
						pVal *= cast(float)v.i;
					else
						pVal = cast(float)v.i;
				} else if (v.type == ValueType.Float) {
					if (afterFirst)
						pVal *= v.f;
					else
						pVal = v.f;
				} else if (v.type ==  ValueType.Boolean) {
					if (!v.b)
						pVal = 0f;
				} else if (v.type == ValueType.String) {
					try {
						if (afterFirst)
							pVal *= to!float(v.s);
						else
							pVal = to!float(v.s);
					} catch (ConvOverflowException cofe) {}
				}
			} else if (operation_ == BodmasOperations.Divide) {
				if (v.type == ValueType.Integer) {
					if (afterFirst) {
						if (v.i != 0) {
							pVal /= cast(float)v.i;
						}
					} else {
						pVal = cast(float)v.i;
					}
				} else if (v.type == ValueType.Float) {
					if (afterFirst) {
						if (v.f != 0) {
							pVal /= v.f;
						}
					} else {
						pVal = v.f;
					}
				} else if (v.type ==  ValueType.Boolean) {
					if (!v.b) {
						pVal = 0f;
					}
				} else if (v.type == ValueType.String) {
					try {
						if (afterFirst) {
							if (to!float(v.s) != 0) {
								pVal /= to!float(v.s);
							}
						} else {
							pVal = to!float(v.s);
						}
					} catch (ConvOverflowException cofe) {}
				}
			} else if (operation_ == BodmasOperations.Addition) {
				if (v.type == ValueType.Integer) {
					if (afterFirst) {
						pVal += cast(float)v.i;
					} else {
						pVal = cast(float)v.i;
					}
				} else if (v.type == ValueType.Float) {
					if (afterFirst) {
						pVal += v.f;
					} else {
						pVal = v.f;
					}
				} else if (v.type ==  ValueType.Boolean) {
					if (v.b) {
						pVal += 1f;
					}
				} else if (v.type == ValueType.String) {
					try {
						if (afterFirst) {
							pVal += to!float(v.s);
						} else {
							pVal = to!float(v.s);
						}
					} catch (ConvOverflowException cofe) {}
				}
			} else if (operation_ == BodmasOperations.Subtraction) {
				if (v.type == ValueType.Integer) {
					if (afterFirst) {
						pVal -= cast(float)v.i;
					} else {
						pVal = cast(float)v.i;
					}
				} else if (v.type == ValueType.Float) {
					if (afterFirst) {
						pVal -= v.f;
					} else {
						pVal = v.f;
					}
				} else if (v.type ==  ValueType.Boolean) {
					if (v.b) {
						pVal -= 1f;
					}
				} else if (v.type == ValueType.String) {
					try {
						if (afterFirst) {
							pVal -= to!float(v.s);
						} else {
							pVal = to!float(v.s);
						}
					} catch (ConvOverflowException cofe) {}
				}
			}

			if (first) afterFirst = true;
			first = false;
		}

		this.f = pVal;
	}
}

unittest {
	import drunmeta.statements.assignment;
	
	Code code = new Code();
	code.statements ~= new VariableAssignment("0", new BodmasExpression(BodmasOperations.SqrRoot, new Value(4f)));
	code.statements ~= new VariableAssignment("1", new BodmasExpression(BodmasOperations.Power, new Value(2f), new Value(2f)));
	code.statements ~= new VariableAssignment("2", new BodmasExpression(BodmasOperations.Multiply, new Value(2f), new Value(2f)));
	code.statements ~= new VariableAssignment("3", new BodmasExpression(BodmasOperations.Divide, new Value(4f), new Value(2f)));
	code.statements ~= new VariableAssignment("4", new BodmasExpression(BodmasOperations.Addition, new Value(4f), new Value(2f)));
	code.statements ~= new VariableAssignment("5", new BodmasExpression(BodmasOperations.Subtraction, new Value(6f), new Value(2f)));
	code.execute();

	assert(code.variables["0"].f == 2f);
	assert(code.variables["1"].f == 4f);
	assert(code.variables["2"].f == 4f);
	assert(code.variables["3"].f == 2f);
	assert(code.variables["4"].f == 6f);
	assert(code.variables["5"].f == 4f);
}