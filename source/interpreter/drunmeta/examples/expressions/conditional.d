module drunmeta.examples.expressions.conditional;
import drunmeta;
import std.stdio;

struct ConditionalExpressionExample_ {
	void one() {
		/*
		 * output "abc" == "def"
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new ConditionalExpression(ConditionType.Equals, new Value("abc"), new Value("def")));
		
		code.execute();
		writeln(code.stdOut);
	}

	void two() {
		/*
		 * output true
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new ConditionalExpression(ConditionType.Boolean, new Value(true)));
		
		code.execute();
		writeln(code.stdOut);
	}
}

ConditionalExpressionExample_ ConditionalExpressionExample;