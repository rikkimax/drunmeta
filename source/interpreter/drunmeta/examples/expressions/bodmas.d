module drunmeta.examples.expressions.bodmas;
import drunmeta;
import std.stdio;

struct BodmasExpressionExample_ {
	void one() {
		/*
		 * output √4.0
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new BodmasExpression(BodmasOperations.SqrRoot, new Value(4f)));
		
		code.execute();
		writeln(code.stdOut);
	}

	void two() {
		/*
		 * output 2^2
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new BodmasExpression(BodmasOperations.Power, new Value(2f), new Value(2f)));

		code.execute();
		writeln(code.stdOut);
	}

	void three() {
		/*
		 * output 2 * 2
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new BodmasExpression(BodmasOperations.Multiply, new Value(2f), new Value(2f)));
		
		code.execute();
		writeln(code.stdOut);
	}

	void four() {
		/*
		 * output 4 / 2
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new BodmasExpression(BodmasOperations.Divide, new Value(4f), new Value(2f)));
		
		code.execute();
		writeln(code.stdOut);
	}

	void five() {
		/*
		 * output 4 + 2
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new BodmasExpression(BodmasOperations.Addition, new Value(4f), new Value(2f)));
		
		code.execute();
		writeln(code.stdOut);
	}

	void six() {
		/*
		 * output 6 - 2
		 */
		
		Code code = new Code();
		code.statements ~= new Output(new BodmasExpression(BodmasOperations.Subtraction, new Value(6f), new Value(2f)));
		
		code.execute();
		writeln(code.stdOut);
	}
}

BodmasExpressionExample_ BodmasExpressionExample;