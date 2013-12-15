module drunmeta.json.value;
import drunmeta.json.exceptions;
import drunmeta;
import vibe.data.json;

class JsonValue {
	this() {
		type = ValueType.Null;
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
	
	this(JsonValue[string] a...) {
		type = ValueType.Array;
		this.a = a;
	}

	this(Value[string] a...) {
		type = ValueType.Array;
		foreach(k, v; a) {
			this.a[k] = new JsonValue(v);
		}
	}

	this(Value v) {
		type = v.type;

		VariableValue vv = null;
		try {vv = cast(VariableValue)v;}
		catch (Exception e) {}

		Expression ev = null;
		try {ev = cast(Expression)v;}
		catch(Exception e) {}

		if (vv !is null) {
			type = ValueType.Variable;
			name = (cast(VariableValue)v).name;
			key = (cast(VariableValue)v).key;
		} else if (ev !is null) {
			try {
				BodmasExpression be = cast(BodmasExpression)v;
				assert(be !is null);

				arguments ~= new JsonValue(be.operation.stringof);
			} catch (Exception e){
			} catch (Error e) {}
			
			try {
				ConditionalExpression ce = cast(ConditionalExpression)v;
				assert(ce !is null);
				
				arguments ~= new JsonValue(cast(string)ce.cType);
				
				if (ce.aPtr !is null) {
					Value a = *ce.aPtr;
					arguments ~= new JsonValue(a);
					
					if (ce.bPtr !is null) {
						Value b = *ce.bPtr;
						arguments ~= new JsonValue(b);
					}
				}
			} catch (Exception e){
			} catch (Error e) {}
			
			expressionType = ev.expressionType;
			
			foreach(a; ev.arguments) {
				arguments ~= new JsonValue(a);
			}
		} else {
			switch(type) {
				case ValueType.Integer:
					i = v.i;
					break;
				case ValueType.String:
					s = v.s;
					break;
				case ValueType.Float:
					f = v.f;
					break;
				case ValueType.Null:
					break;
				case ValueType.Boolean:
					b = v.b;
					break;
				case ValueType.Array:
					foreach(k, v2; v.a) {
						a[k] = new JsonValue(v2);
					}
					break;
				default:
					// TODO throw an exception
					throw new InvalidValueTypeException(DebugInfo.init);
			}
		}
	}

	ValueType type;
	@optional {
		JsonValue[] arguments; // damn expression wouldn't serialize this
		DebugInfo debugInfo; // damn expression wouldn't serialize this
		ExpressionType expressionType;

	//union {
		//union {
			int i;
			string s;
			float f;
			bool b;
			JsonValue[string] a;
		//}
		//struct {
			string key;
			string name;
		//}
	//}
	}

	Value opCast(T : Value)() {
		Value ret = new Value;

		ret.type = type;
		switch(type) {
			case ValueType.Array:
				foreach(k, v; a) {
					ret.a[k] = cast(Value)v;
				}
				break;
			case ValueType.Boolean:
				ret.b = b;
				break;
			case ValueType.Float:
				ret.f = f;
				break;
			case ValueType.Integer:
				ret.i = i;
				break;
			case ValueType.String:
				ret.s = s;
				break;
			case ValueType.Variable:
				ret = new VariableValue(key, name);
				break;
			default:
				ret.type = ValueType.Null;
				break;
		}

		// TODO expressions!

		return ret;
	}
}