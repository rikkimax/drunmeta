module drunmeta.functions.math;
import drunmeta.common;
import drunmeta.value;

import std.datetime;
import std.math;

class MathRandomFunction : Function {
	@disable Statement[] statements;

	this() {
		argsNames = ["Start", "End"];
		super();
		dCode = true;
	}
	
	override void handle(Code code) {
		float start = 1, end = 100;
		
		if (MathRandomFunction.mangledArgsNames["Start"] in code.variables) {
			Value s = code.variables[MathRandomFunction.mangledArgsNames["Start"]];
			if (s.type == ValueType.Integer) start = cast(float)s.i;
			else if (s.type == ValueType.Float) start = s.f;
		}
		if (MathRandomFunction.mangledArgsNames["End"] in code.variables) {
			Value e = code.variables[MathRandomFunction.mangledArgsNames["End"]];
			if (e.type == ValueType.Integer) end = cast(float)e.i;
			else if (e.type == ValueType.Float) end = e.f;
		}

		if (end < start) {
			float temp = end;
			end = start;
			start = temp;
		}

		float expPow;
		int exp;

		frexp(cast(real)end, exp);
		exp = exp / 3;
		expPow = pow(10f, exp - 1f);
		
		float value = (Clock.currTime().toUnixTime() % (end - (start - expPow))) + start;
		value = round(value, cast(int)((exp - 1f) * -1f));

		if (value < start) value = start;
		else if (value > end) value = end;

		code.variables[MathRandomFunction.mangledReturnName] = new Value(value);
	}
}

unittest {
	import drunmeta.statements.call;

	Code code = new Code();
	code.statements ~= new CallFunction("random");
	code.execute();

	assert(code.variables[code.functions["random"].mangledReturnName].f >= 1);
	assert(code.variables[code.functions["random"].mangledReturnName].f <= 100);
}

unittest {
	import drunmeta.statements.call;
	import drunmeta.statements.assignment;

	Code code = new Code();
	code.statements ~= new VariableAssignment(code.functions["random"].mangledArgsNames[code.functions["random"].argsNames[1]], new Value(2));
	code.statements ~= new CallFunction("random");
	code.execute();

	assert(code.variables[code.functions["random"].mangledReturnName].f >= 1);
	assert(code.variables[code.functions["random"].mangledReturnName].f <= 2);
}

unittest {
	import drunmeta.statements.call;
	import drunmeta.statements.assignment;
	
	Code code = new Code();
	code.statements ~= new VariableAssignment(code.functions["random"].mangledArgsNames[code.functions["random"].argsNames[0]], new Value(.01));
	code.statements ~= new VariableAssignment(code.functions["random"].mangledArgsNames[code.functions["random"].argsNames[1]], new Value(.1));
	code.statements ~= new CallFunction("random");
	code.execute();

	assert(code.variables[code.functions["random"].mangledReturnName].f >= .01);
	assert(code.variables[code.functions["random"].mangledReturnName].f <= .1);
}

float round(float value, int precision) {
	float mult = pow(10f, precision);
	int value2 = cast(int)(value * mult);
	return cast(float)(value2 / mult);
}

unittest {
	import std.conv : text;

	assert(text(round(0.5, 1)) == "0.5");
	assert(text(round(12, 0)) == "12");
	assert(text(round(12, -1)) == "10");
	assert(text(round(34.568, 1)) == "34.5");
}

class MathModFunction : Function {
	@disable Statement[] statements;

	this() {
		argsNames = ["X", "Devisor"];
		super();
		dCode = true;
	}
	
	override void handle(Code code) {
		float x = 0, devisor = 1;
		
		if (mangledArgsNames["X"] in code.variables) {
			Value s = code.variables[mangledArgsNames["X"]];
			if (s.type == ValueType.Integer) x = cast(float)s.i;
			else if (s.type == ValueType.Float) x = s.f;
		}
		if (mangledArgsNames["Devisor"] in code.variables) {
			Value e = code.variables[mangledArgsNames["Devisor"]];
			if (e.type == ValueType.Integer) devisor = cast(float)e.i;
			else if (e.type == ValueType.Float) devisor = e.f;
		}

		if (devisor <= 0) {
			code.variables[mangledReturnName] = new Value(0);
		} else {
			code.variables[mangledReturnName] = new Value(x % devisor);
		}
	}
}

unittest {
	import drunmeta.statements.call;
	import drunmeta.statements.assignment;

	Code code = new Code();
	code.statements ~= new VariableAssignment(code.functions["mod"].mangledArgsNames[code.functions["mod"].argsNames[0]], new Value(1));
	code.statements ~= new VariableAssignment(code.functions["mod"].mangledArgsNames[code.functions["mod"].argsNames[1]], new Value(2));
	code.statements ~= new CallFunction("mod");
	code.execute();

	assert(code.variables[code.functions["mod"].mangledReturnName].f == 1);
}

class MathRoundFunction : Function {
	@disable Statement[] statements;
	
	this() {
		argsNames = ["X", "Precision"];
		super();
		dCode = true;
	}
	
	override void handle(Code code) {
		float x = 0;
		int precision = 0;
		
		if (mangledArgsNames["X"] in code.variables) {
			Value s = code.variables[mangledArgsNames["X"]];
			if (s.type == ValueType.Integer) x = cast(float)s.i;
			else if (s.type == ValueType.Float) x = s.f;
		}
		if (mangledArgsNames["Precision"] in code.variables) {
			Value e = code.variables[mangledArgsNames["Precision"]];
			if (e.type == ValueType.Integer) precision = e.i;
			else if (e.type == ValueType.Float) precision = cast(int)e.f;
		}
		
		if (x == 0) {
			code.variables[mangledReturnName] = new Value(0);
		} else {
			code.variables[mangledReturnName] = new Value(round(x, precision));
		}
	}
}

unittest {
	import std.conv : text;
	import drunmeta.statements.call;
	import drunmeta.statements.assignment;
	
	Code code = new Code();
	code.statements ~= new VariableAssignment(code.functions["round"].mangledArgsNames[code.functions["round"].argsNames[0]], new Value(12.34));
	code.statements ~= new VariableAssignment(code.functions["round"].mangledArgsNames[code.functions["round"].argsNames[1]], new Value(1));
	code.statements ~= new CallFunction("round");
	code.execute();
	
	assert(text(code.variables[code.functions["round"].mangledReturnName].f) == "12.3");
}