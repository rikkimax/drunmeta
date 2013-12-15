module drunmeta.examples.expressions.concat;
import drunmeta;
import std.stdio;

struct ConcatExpressionExample_ {
	void one() {
		/*
		 * output "first" ~ " " ~ "second"
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new ConcatExpression(new Value("first"), new Value(" "), new Value("second")));
		
		code.execute();
		writeln(code.stdOut);
	}
}

ConcatExpressionExample_ ConcatExpressionExample;