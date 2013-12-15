module drunmeta.examples.statements.output;
import drunmeta;
import std.stdio;

struct OutputExample_ {
	void one() {
		/*
		 * output "a value"
		 * output 79
		 * output true
		 * output 8.7
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new Value("a value"));
		code.statements ~= new Output(new Value(79));
		code.statements ~= new Output(new Value(true));
		code.statements ~= new Output(new Value(8.7));
		
		code.execute();
		writeln(code.stdOut);
	}
}

OutputExample_ OutputExample;