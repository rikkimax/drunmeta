module drunmeta.json.statement;
public import drunmeta.common : StatementType, DebugInfo;
import drunmeta;
import drunmeta.json.exceptions;
import drunmeta.json.value;
import drunmeta.json.code;
import vibe.data.json;

class JsonStatement {
	this() {
	}

	this(Statement statement) {
		statementType = statement.statementType;
		debugInfo = statement.debugInfo;
		switch(statement.statementType) {
			case StatementType.Output:
				Output t;
				try {t = cast(Output)statement;}
				catch(Exception e) {throw new InvalidValueTypeException(debugInfo);}

				arguments ~= new JsonValue(t.value);
				arguments ~= new JsonValue(t.output);
				break;
			case StatementType.IfCondition:
				IfCondition t;
				try {t = cast(IfCondition)statement;}
				catch(Exception e) {throw new InvalidValueTypeException(debugInfo);}

				foreach(p; t.truePath) {
					children["truePath"] ~= new JsonStatement(p);
				}
				foreach(p; t.falsePath) {
					children["falsePath"] ~= new JsonStatement(p);
				}
				arguments ~= new JsonValue(t.type);

				if (t.aPtr !is null) {
					Value a = *t.aPtr;
					arguments ~= new JsonValue(a);

					if (t.bPtr !is null) {
						Value b = *t.bPtr;
						arguments ~= new JsonValue(b);
					}
				}

				break;
			case StatementType.Assignment:
				VariableAssignment t;
				try {t = cast(VariableAssignment)statement;}
				catch(Exception e) {throw new InvalidValueTypeException(debugInfo);}

				arguments ~= new JsonValue(t.name);
				arguments ~= new JsonValue(t.key);
				arguments ~= new JsonValue(*t.aPtr);

				break;
			case StatementType.FunctionCall:
				CallFunction t;
				try {t = cast(CallFunction)statement;}
				catch(Exception e) {throw new InvalidValueTypeException(debugInfo);}

				arguments ~= new JsonValue(t.name);

				break;
			case StatementType.Function:
				Function t;
				try {t = cast(Function)statement;}
				catch(Exception e) {throw new InvalidValueTypeException(debugInfo);}

				if (!t.dCode) { // this is assumed but meh
					functionName = t.name;
					foreach(p; t.statements) {
						children["statements"] ~= new JsonStatement(p);
					}
				}
				break;
			default:
				// TODO throw exception
				throw new InvalidValueTypeException(debugInfo);
		}
	}

	StatementType statementType;
		
	@optional {
		JsonStatement[][string] children;
		JsonValue[] arguments;
		DebugInfo debugInfo;
		string functionName;
	}

	Statement opCast(T : Statement)() {
		IStatement ret = null;

		switch(statementType) {
			case StatementType.Output:
				if (arguments.length == 1)
					ret = new Output(cast(Value)arguments[0]);
				else if (arguments.length == 2)
					if (arguments[1].type == ValueType.String)
						ret = new Output(cast(Value)arguments[0], arguments[1].s);
				break;
			case StatementType.IfCondition:
				IfCondition ifc;
				if (arguments.length == 2)
					if (arguments[0].type == ValueType.String)
						ifc = new IfCondition(cast(ConditionType)arguments[0].s, cast(Value)arguments[1]);
				if (arguments.length == 3)
					if (arguments[0].type == ValueType.String)
						ifc = new IfCondition(cast(ConditionType)arguments[0].s, cast(Value)arguments[1], cast(Value)arguments[2]);

				if (ifc !is null) {
					foreach(s; children.get("truePath", []))
						ifc.truePath ~= cast(Statement)s;
					foreach(s; children.get("falsePath", []))
						ifc.falsePath ~= cast(Statement)s;
				}

				ret = ifc;
				break;
			case StatementType.FunctionCall:
				if (arguments.length == 1)
					if (arguments[0].type == ValueType.String)
						ret = new CallFunction(arguments[0].s);
				break;
			case StatementType.Assignment:
				if (arguments.length == 2) {
					Value arg1 = cast(Value)arguments[1];
					if (arguments[0].type == ValueType.String)
						ret = new VariableAssignment(arguments[0].s, &arg1);
				}
				break;
			default:
				break;
		}

		return cast(Statement)ret;
	}

	Function opCast(T : Function)() {
		Function ret = null;

		// TODO umm how do we determine which function we are?
		if (functionName == "Function") {
			// ok so we are of a user type.
			ret = new Function();
			foreach(s; children.get("statements", []))
				ret.statements ~= cast(Statement)s;
		}

		return cast(Function)ret;
	}
}