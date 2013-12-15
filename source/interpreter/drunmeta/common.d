module drunmeta.common;
import drunmeta.value;
import drunmeta.functions;

class Code {
	Statement[] statements;
	Value[string] variables;
	Function[string] functions;
	string stdOut;

	this() {
		registerCommonFunctions(this);
	}

	void execute() {
		foreach(s; statements) {
			s.handle(this);
		}
	}
}

struct DebugInfo {
	string text;
	ushort line;
	ushort charactor;
}

enum StatementType : string {
	Output = "Output",
	IfCondition = "IfCondition",
	Assignment = "Assignment",
	FunctionCall = "FunctionCall",
	Function = "Function"
}

interface IStatement {
	@property {
		StatementType statementType();
		void statementType(StatementType);

		DebugInfo debugInfo();
		void debugInfo(DebugInfo info);
	}

	void handle(Code code);

	void nextFunction(Statement[] statements, Code code);
}

abstract class Statement : IStatement {
	protected{
		StatementType statementType_;
		DebugInfo debugInfo_;
	}

	@property {
		StatementType statementType() {
			return this.statementType_;
		}

		void statementType(StatementType st) {
			this.statementType_ = st;
		}

		DebugInfo debugInfo() {
			return debugInfo_;
		}

		void debugInfo(DebugInfo info) {
			debugInfo_ = info;
		}
	}

	void nextFunction(Statement[] statements, Code code) {
		foreach(s; statements) {
			s.handle(code);
		}
	}
}

class Function : Statement {
	Statement[] statements;

	string mangledReturnName = "";
	string[] argsNames;
	string[string] mangledArgsNames;
	string name;

	bool dCode;

	this(this T)() {
		name = T.stringof;
		dCode = false;
		this.statementType = StatementType.Function;
		if (mangledReturnName == "") {
			mangledReturnName = T.stringof ~ "ReturnValue";
			foreach(a; argsNames) {
				mangledArgsNames[a] = T.stringof ~ a;
			}
		}
	}

	void handle(Code code) {
		nextFunction(statements, code);
	}
}