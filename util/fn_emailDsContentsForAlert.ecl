/**
 *  fn_emailDsContentsForAlert is useful functionMacroto send the dataset contents as Email's Attachment, 
 *  all the fields of the dataset is concatenated with comma separated as the first of Record
 *  of the Attachment, and the dataset records are written after the Header record
 *  
 *  sendFrom              String   Email_From_ID
 *  sendTo                String   Email_To_ID
 *  emailSub              String   Subject of the Email
 *  emailMsg              String   Email Message
 *  dsForEmailAttach      Dataset  Dataset, whose data to be attached in Email
 *  attachmentFilename    String   Name of the Email attachment file
 *
 **/
EXPORT fn_emailDsContentsForAlert(sendfrom, 
                          sendTo, 
													emailSub, 
													emailMsg, 
													dsForEmailAttach, 
													attachmentFilename,
													fieldSep) := FUNCTIONMACRO
    IMPORT Std, lib_fileservices;

    LOADXML('<xml/>');
     #EXPORTXML(fields, RECORDOF(dsForEmailAttach))
	   #Declare(allFields);
	   #Declare(dummy);
		 #Declare(Ndx);
	   #SET(allFields, '');
	   #SET(dummy, '');
		 #SET(Ndx, '0');
	   

		#FOR(fields)
				#FOR(Field)
						#APPEND(allFields, fieldSep + %'@name'%);
						#IF(%Ndx% = 0 )
						  #IF(fieldSep = ',')
						     #APPEND(dummy, '\'"\' + ' + 'TRIM((STRING)LEFT.' + %'@name'%  + ',LEFT, RIGHT)' + ' + \'"\' ');
						  #ELSE
						     #APPEND(dummy, 'TRIM((STRING)LEFT.' + %'@name'%  + ',LEFT, RIGHT)');
						  #END
						#ELSE
						  #IF(fieldSep = ',')
   					         #APPEND(dummy, ' + \'' + fieldSep + '\' + ' + '\'"\' + ' + 'TRIM((STRING)LEFT.' + %'@name'% + ',LEFT, RIGHT)' + ' + \'"\' ');
						  #ELSE
						     #APPEND(dummy, ' + \'' + fieldSep + '\' + ' + 'TRIM((STRING)LEFT.' + %'@name'% + ',LEFT, RIGHT)');
						  #END
						#END
						#SET(Ndx, 1);
				#END
		#END

		completeData := //DATASET([{%'allFields'%[2..]}], {string contents}) +
		 PROJECT
        (
            dsForEmailAttach,
            TRANSFORM
                (
                    {string contents},
                    SELF.contents := %dummy%; 
                )
        );
				
		emailDataContents := ROLLUP(completeData, 
		           TRUE, 
							 TRANSFORM(RECORDOF(completeData),
								   SELF.contents := IF(LEFT.contents <> '',  LEFT.contents + '\r\n' + RIGHT.contents,  '\r\n' + LEFT.contents);
							 )
	       );
				 
		RETURN lib_fileservices.FileServices.SendEmailAttachData(sendTo,
							emailSub,
							emailMsg,
							(data)emailDataContents[1].contents, 
							'text/csv',  
							attachmentFilename,
							'appmail.risk.regn.net',
							, 
							sendFrom
					);
ENDMACRO;
