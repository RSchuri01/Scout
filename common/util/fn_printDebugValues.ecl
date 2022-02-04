EXPORT fn_printDebugValues(debugDataVaulesToPrint) := functionMacro
	return WHEN(debugDataVaulesToPrint, OUTPUT(debugDataVaulesToPrint, NAMED(RANDOM() + '_' + #TEXT(debugDataVaulesToPrint))));
ENDMacro;