module drunmeta.examples.statements.call;
import drunmeta;
import std.stdio;

struct CallExample_ {
	void one() {
		/*
		 * $name = "MyNameIsHello"
		 * call outputName
		 * 
		 * function outputName do
		 * 		output $name
		 * end
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new Value("MyNameIsHello"), "name");
		code.statements ~= new CallFunction("outputName");
		
		Function outputName = new Function();
		outputName.statements ~= new Output(new VariableValue("name"));
		code.functions["outputName"] = outputName;
		
		code.execute();
		writeln(code.stdOut);
	}
}

CallExample_ CallExample;