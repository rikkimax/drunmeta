module drunmeta.expression;
import drunmeta.common;
import drunmeta.value;

enum ExpressionType : string {
	NotExpression = "NotExpression",
	ArrayKeys = "ArrayKeys",
	Bodmas = "Bodmas",
	Concat = "Concat",
	Conditional = "Conditional",
	IndexOf = "IndexOf",
	Length = "Length",
	StringRange = "StringRange"
}

abstract class Expression : Value, IStatement {
	protected {
		Value[] expression;
		StatementType statementType_;
		DebugInfo debugInfo_;
		ExpressionType expressionType_;
	}

	this(Value[] expression ...) {
		this.expression = expression;
	}

	void nextFunction(Statement[] statements, Code code) {
		foreach(s; statements) {
			s.handle(code);
		}
	}

	override void accessing(Code code) {
		handle(code);
	}
	
	@property {
		@disable StatementType statementType() {
			return this.statementType_;
		}
		
		@disable void statementType(StatementType st) {
			this.statementType_ = st;
		}

		ExpressionType expressionType() {
			return expressionType_;
		}

		DebugInfo debugInfo() {
			return debugInfo_;
		}
		
		void debugInfo(DebugInfo info) {
			debugInfo_ = info;
		}

		Value[] arguments() {
			return expression;
		}
	}
}