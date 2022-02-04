EXPORT fn_clean := MODULE

	EXPORT nullset := ['none','NONE','','NULL','null','UNKNOWN','unknown', 'UKNOWN', 'Null','\'N', '\\N', '\'\\N', '\\'];

	EXPORT CleanFields(inputFile,outputFile) := macro

		LOADXML('<xml/>');

		#EXPORTXML(doCleanFieldMetaInfo, recordof(inputFile))

		#uniquename(myCleanFunction)

		STRING %myCleanFunction%(STRING x) := TRIM(std.str.findreplace(std.str.findreplace(std.str.touppercase(
																					MAP(TRIM(x,all) in scout.logs.util.fn_clean.nullset => '', 
																						  std.str.cleanspaces(x))), '&amp;', '&'), '\\N',''), LEFT, RIGHT);
		#uniquename(tra)
		inputFile %tra%(inputFile le) :=
			TRANSFORM

			#IF (%'doCleanFieldText'%='')
			 #DECLARE(doCleanFieldText)
			#END
			#SET (doCleanFieldText, false)
			#FOR (doCleanFieldMetaInfo)
			 #FOR (Field)
				#IF (%'@type'% = 'string')
				#SET (doCleanFieldText, 'SELF.' + %'@name'%)
					#APPEND (doCleanFieldText, ':= ' + %'myCleanFunction'% + '(le.')
				#APPEND (doCleanFieldText, %'@name'%)
				#APPEND (doCleanFieldText, ');\n')
				%doCleanFieldText%;
				#END
			 #END
			#END
				SELF := le;
		END;

		outputFile := PROJECT(inputFile, %tra%(LEFT));
	ENDMACRO;

END;