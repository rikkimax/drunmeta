module drunmeta.functions;
import drunmeta.common;
public import drunmeta.functions.currenttime;
public import drunmeta.functions.math;

void registerCommonFunctions(Code code) {
	code.functions["currentTime"] = new CurrentTimeFunction;
	code.functions["random"] = new MathRandomFunction;
	code.functions["mod"] = new MathModFunction;
	code.functions["round"] = new MathRoundFunction;
}