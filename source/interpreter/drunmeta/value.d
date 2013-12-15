module drunmeta.value;
import drunmeta.common;

enum ValueType : string {
	Integer = "Integer",
	String = "String",
	Float = "Float",
	Null = "Null",
	Boolean = "Boolean",
	Array = "Array",
	Variable = "Variable"
}

class Value {
	ValueType type;
	union {
		int i;
		string s;
		float f;
		bool b;
		Value[string] a;
	}

	this(int i) {
		type = ValueType.Integer;
		this.i = i;
	}

	this(string s) {
		type = ValueType.String;
		this.s = s;
	}

	this(float f) {
		type = ValueType.Float;
		this.f = f;
	}

	this(bool b) {
		type = ValueType.Boolean;
		this.b = b;
	}

	this(Value[string] a...) {
		type = ValueType.Array;
		this.a = a;
	}

	this() {
		type = ValueType.Null;
	}

	void accessing(Code code) {}
	void modified(Code code) {}
	void remove(Code code) {}

	static Value ArrayType() {
		Value ret = new Value();
		ret.type = ValueType.Array;
		Value[string] a;
		ret.a = a;

		return ret;
	}
}

class VariableValue : Value {
	string name;
	string key;

	@disable this(int i) {}
	
	this(string name, string key = null) {
		this.name = name;
		this.key = key;
	}
	
	@disable this(float f) {}
	
	@disable this(bool b) {}
	
	@disable this(Value[] a...) {}
	
	@disable this() {}

	override void accessing(Code code) {
		if (key is null) {
			type = code.variables[name].type;

			s = code.variables[name].s;
			f = code.variables[name].f;
			b = code.variables[name].b;
			a = code.variables[name].a;
		} else {
			if (name in code.variables) {
				if (key in code.variables[name].a) {
					type = code.variables[name].a[key].type;
					
					s = code.variables[name].a[key].s;
					f = code.variables[name].a[key].f;
					b = code.variables[name].a[key].b;
					a = code.variables[name].a[key].a;
				}
			}
		}
	}

	override void modified(Code code) {
		if (key is null) {
			code.variables[name].type = type;
			
			code.variables[name].s = s;
			code.variables[name].f = f;
			code.variables[name].b = b;
			code.variables[name].a = a;
		} else {
			if (name in code.variables) {
				if (key in code.variables[name].a) {
					code.variables[name].a[key].type = type;
					
					code.variables[name].a[key].s = s;
					code.variables[name].a[key].f = f;
					code.variables[name].a[key].b = b;
					code.variables[name].a[key].a = a;
				}
			}
		}
	}

	override void remove(Code code) {
		if (name in code.variables) {
			if (key in code.variables[name].a) {
				code.variables[name].a.remove(key);
			}
		}
	}
}