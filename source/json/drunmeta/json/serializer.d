module drunmeta.json.serializer;
import drunmeta.json.code;
import vibe.data.json;

JsonCode getCodeFromJson(string text) {
	JsonCode ret;
	Json json = parseJsonString(text);
	deserializeJson(ret, json);
	return ret;
}

string getJsonFromCode(JsonCode code) {
	Json json = serializeToJson(code);
	return json.toString;
}

unittest {
	import drunmeta.json.statement;

	JsonCode js = deserializeJson!JsonCode(
		Json(["statements" : Json([
			Json([
				"statementType" : Json("Output")
			])
		])])
	);

	string text = serializeToJson(js).toString;
	js = getCodeFromJson(text);
	assert(serializeToJson(js).toString == text);
}

unittest {
	import drunmeta;

	Code code = new Code();
	JsonCode jCode;

	IfCondition ifc = new IfCondition(ConditionType.NotEquals, new Value("abc"), new Value("abc"));
	ifc.truePath ~= new Output(new Value("not equal"), "0");
	ifc.falsePath ~= new Output(new Value("equal"), "0");
	code.statements ~= ifc;

	code.statements ~= new Output(new ConcatExpression(new Value("a"), new Value(1), new Value(true)), "0");

	code.statements ~= new CallFunction("random");

	code.statements ~= new VariableAssignment("1", new BodmasExpression(BodmasOperations.SqrRoot, new Value(4f)));

	code.statements ~= new VariableAssignment("2", new ConditionalExpression(ConditionType.Boolean, new Value(true)));

	code.execute();

	jCode = new JsonCode(code);

	// output as required
	// import std.stdio; writeln(getJsonFromCode(jCode));
}

unittest {
	import drunmeta;
	
	Code code = new Code();
	JsonCode jCode;

	code.variables["name"] = new Value("rikki");
	code.statements ~= new CallFunction("random");

	Function outputName = new Function();
	outputName.statements ~= new Output(new VariableValue("name"));
	code.functions["outputName"] = outputName;

	jCode = new JsonCode(code);
	code = cast(Code)jCode;
	jCode = new JsonCode(code);

	import std.stdio; writeln(getJsonFromCode(jCode));
}