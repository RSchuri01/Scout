/* Contains Common Functions Used in SAOT */

IMPORT scout, std;

EXPORT Common := MODULE

Shared string Addr1FromComponents(string prim_range, string predir, string prim_name,
                                  string suffix, string postdir, string unit_desig, string sec_range) :=
IF(prim_range<>'',trim(prim_range)+' ','') +
IF(predir<>'',trim(predir)+' ','') +
IF(prim_name<>'',trim(prim_name)+' ','') +
IF(suffix<>'',trim(suffix)+' ','') +
IF(postdir<>'',trim(postdir)+' ','') +
IF(unit_desig<>'' and sec_range<>'',trim(unit_desig)+' ','') +
trim(sec_range);

	// Takes in the Year/Month/Day from ESP results and formats it as YYYYMMDD
	EXPORT ParseDate(STRING In_Year, STRING In_Month, STRING In_Day) := FUNCTION
		Today := (STRING8)Std.Date.Today();
		Month := INTFORMAT((INTEGER)TRIM(In_Month), 2, 1);
		Day := INTFORMAT((INTEGER)TRIM(In_Day), 2, 1);
		YearTemp := INTFORMAT((INTEGER)TRIM(In_Year), 4, 1);
		Year := MAP((INTEGER)In_Year <= 0 => '',
								(INTEGER)YearTemp[1..2] > 0 => YearTemp,
								(INTEGER)YearTemp[1..2] = 0 AND (INTEGER)YearTemp[3..4] > (INTEGER)Today[3..4] => ((STRING)((INTEGER)Today[1..2] - 1)) + YearTemp[3..4], // Last 2 digits indicates we are probably in 19**
								(INTEGER)YearTemp[1..2] = 0 AND (INTEGER)YearTemp[3..4] <= (INTEGER)Today[3..4] => Today[1..2] + YearTemp[3..4], // Last 2 digits indicates we are probably in 20**
								'');
		Combined := IF((INTEGER)Year = 0 OR (INTEGER)Month = 0 OR (INTEGER)Day = 0, '', Year + Month + Day); // Blank it out if we can't calculate a full YYYYMMDD
		
		RETURN(Combined);
	END;
	
	EXPORT ParseSSN(STRING In_SSN, Integer1 Num_Length = 9) := IF((INTEGER)In_SSN <> 0, In_SSN, '');
	
	EXPORT ParseZIP(STRING In_Zip5) := IF((INTEGER)In_Zip5 <> 0, INTFORMAT((INTEGER)(In_Zip5[1..5]), 5, 1), '');
	
	EXPORT ParseAddress(STRING In_StreetAddress1, STRING In_StreetAddress2 = '', STRING In_Num = '', STRING In_PreDir = '', STRING In_Name = '', STRING In_Suffix = '', STRING In_PostDir = '', STRING UnitDesig = '', STRING UnitNum = '') := FUNCTION
		ParsedAddress := Addr1FromComponents(TRIM(In_Num), TRIM(In_PreDir), TRIM(In_Name), TRIM(In_Suffix), TRIM(In_PostDir), TRIM(UnitDesig), TRIM(UnitNum));
		UnparsedAddress := TRIM(In_StreetAddress1 + ' ' + In_StreetAddress2);
		
		RETURN (IF(UnparsedAddress <> '', UnparsedAddress, ParsedAddress));
	END;
	
	EXPORT ParsePhone(STRING In_Phone10) := IF((INTEGER)In_Phone10 <> 0, INTFORMAT((INTEGER)In_Phone10, 10, 1), '');
    
    //dataset of Scout key, dataset of XML key, String of ProductName
    EXPORT ProcessRawXML(ScoutFile, XMLFile, Product) := FunctionMacro
    
        //Could possibly have multiple rows because of large xml responses
        LogFile_sorted := sort(XMLFile, transaction_id, seq_num, local);
        // Output(choosen(LogFile_sorted,eyeball), named('Sample_log_pre_rolled'));

        //roll outputxml field back into one field
        Recordof(XMLFile) roll_outputxml(Recordof(XMLFile) l, Recordof(XMLFile) r) := transform
            self.outputxml_len := l.outputxml_len + r.outputxml_len;
            self.outputxml := l.outputxml + r.outputxml;
            self := l;
        end;

        rolled_LogFile := rollup(LogFile_sorted, left.transaction_id = right.transaction_id, roll_outputxml(left, right));
        // Output(Choosen(rolled_LogFile, eyeball), named('Sample_rolled_xml_recs'));
    
        // In order to join the parsed input and output together I need to force the transaction id into the inputxml, and I needed a root XML node for the outputxml.  This seemed like the most reasonable way to do that.
        {RECORDOF(XMLFile), STRING30 TransactionID, STRING15 AccountID, STRING20 LoginID, STRING8 TransactionDate, Boolean validinputxml, Boolean validoutputxml}
        xform_logs1(Recordof(ScoutFile) l, Recordof(XMLFile) r) := TRANSFORM
            tempinputxml := STD.Str.FindReplace(r.inputxml, Product+'Request', Product); //change new tags to match old format, should get both begining and ending tags
            SELF.inputxml := STD.Str.FindReplace(tempinputxml, '<'+Product+'>', '<'+Product+'><TransactionId>' + l.Transaction_Id + '</TransactionId>'); //add transactionid
            //check to see if product is a riskwise query
                isRiskWise := IF(STD.STR.Find(Product, 'RiskWise') > 0, true, false);
                riskwise_outputxml := '<TransactionId>' + l.Transaction_Id + '</TransactionId>' + r.outputxml; //add transactionid to the start of the xml
            SELF.outputxml := IF(isRiskWise,
                                 '<'+Product+'>' + riskwise_outputxml + '</'+Product+'>', //if a riskwise query take the modified xml
                                 '<'+Product+'>' + r.outputxml + '</'+Product+'>'); //if newgen stuff, just keep what is there
            SELF.TransactionID := l.Transaction_ID;
            SELF.AccountID := (String)l.company_id;
            SELF.LoginID := l.login_id;
            SELF.TransactionDate := l.DateTime[1..8];
            SELF.validinputxml := IF(scout.logs.util.fn_validate_XML(self.inputxml) = 1, true, false);
            SELF.validoutputxml := IF(scout.logs.util.fn_validate_XML(self.outputxml) = 1, true, false);
            SELF := r;
        END;

        Logs_1 := JOIN(ScoutFile, rolled_LogFile, left.Transaction_ID = right.Transaction_ID, xform_logs1(left, right));             
        // OUTPUT(CHOOSEN(Logs_1, eyeball), NAMED('Sample_Raw_Logs_1'));
        
        
        Logs := Dedup(Sort(Logs_1, Transaction_id), Transaction_id);
        
        Return Logs;
    
    ENDMacro;
    
    
    
    
    
    
END;