module drunmeta.examples.statements.ifcondition;
import drunmeta;
import std.stdio;

struct IfConditionExample_ {
	void one() {
		/*
		 * if "abc" equals "def" then
		 * 		output "equal"
		 * else
		 * 		output "not equal"
		 */
		
		Code code = new Code();
		IfCondition ifc = new IfCondition(ConditionType.Equals, new Value("abc"), new Value("def"));
		ifc.truePath ~= new Output(new Value("equal"));
		ifc.falsePath ~= new Output(new Value("not equal"));
		code.statements ~= ifc;
		
		code.execute();
		writeln(code.stdOut);
	}

	void two() {
		/*
		 * if "abc" equals "def" then
		 * 		output "equal"
		 * else
		 * 		output "not equal: \"" ~ "abc" ~ "\" != \"" ~ "def" ~ "\""
		 */
		
		Code code = new Code();
		IfCondition ifc = new IfCondition(ConditionType.Equals, new Value("abc"), new Value("def"));
		ifc.truePath ~= new Output(new Value("equal"));
		ifc.falsePath ~= new Output(new ConcatExpression(new Value("not equal: \""), new Value("abc"), new Value("\" != \""), new Value("def"), new Value("\"")));
		code.statements ~= ifc;
		
		code.execute();
		writeln(code.stdOut);
	}
}

IfConditionExample_ IfConditionExample;