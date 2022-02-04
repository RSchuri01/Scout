EXPORT fn_addSubToSuper(STRING super, STRING sub, BOOLEAN deleteSub = false) := FUNCTION
    IMPORT STD;
    RETURN SEQUENTIAL(
        STD.File.StartSuperFileTransaction(),
        STD.File.CreateSuperFile(super, false, true),
        STD.File.FinishSuperFileTransaction(),
        STD.File.StartSuperFileTransaction(),
        IF(deleteSub, STD.File.ClearSuperFile(super, TRUE)),
        STD.File.FinishSuperFileTransaction(),
        STD.File.StartSuperFileTransaction(),
        STD.File.AddSuperFile(super, sub),
        STD.File.FinishSuperFileTransaction()
    );
END;