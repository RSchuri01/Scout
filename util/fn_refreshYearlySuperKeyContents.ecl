export fn_refreshYearlySuperKeyContents(String idxName, String yearlyName ) := function
IMPORT STD, Scout, DataMgmt;

    firstDay := std.date.DatesForMonth().startDate;

    superFile := scout.common.app_constants.key_file_prefix + IF(yearlyName = '2YEARS', '2YearsSuper::', '7YearsSuper::')  + idxName;

    monthlySuperNames := Dataset([scout.common.app_constants.key_file_prefix  + idxName] ,{string name}) +
                         Dataset( IF(yearlyName = '2YEARS', 25, 84), 
                                Transform({string name},
                                tempMon := (String)Std.Date.AdjustDate(firstDay, month_delta := (-1 * (Counter )));
                                self.name := scout.common.app_constants.key_file_prefix + 'monthly::' +  tempMon[1..4] + '::' + tempMon[5..6] + '::' + idxName)
                        ) ;

    addAllFiles := NOTHOR( APPLY(
                       monthlySuperNames,
                       IF(STD.File.FileExists('~' + name),
                            STD.File.AddSuperFile(
                                superFile,
                                '~' + name
                            )
                       )
                )
    );



    packageSuper :=  scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(idxName);

    removeOldFiles := SEQUENTIAL(
                        STD.File.ClearSuperFile(superFile);
                        std.File.ClearSuperFile(DataMgmt.Common.CurrentPath(packageSuper))
                      );
                      
    twoYearsSubFiles := 
        PROJECT(NOTHOR(std.File.SuperFileContents(superFile, true)),
            TRANSFORM({String _child, STRING _father},
                SELF._father := DataMgmt.Common.CurrentPath(packageSuper), SELF._child := '~' + LEFT.name
            )
        );


    appendToPackageMap := SEQUENTIAL(
            // DataMgmt.GenIndex.WriteSubkey(
            //     scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
            //         idxName
            //     ),
            //     GLOBAL('~' + twoYearsSubFiles[1].name, FEW),
            //     scout.common.constants.fido_prod_ip
            // ),
             
             NOTHOR(Apply(twoYearsSubFiles, 
                    SEQUENTIAL(
                        std.file.StartSuperFileTransaction(),
                        std.file.AddSuperFile(_father, _child)
                        ,std.file.FinishSuperFileTransaction()
                    )
             )
        )
        // ,

        // NOTHOR(
        //     Apply(
        //         twoYearsSubFiles[2..],
        //         DataMgmt.GenIndex.AppendSubkey(
        //             _father,
        //             _child,
        //             scout.common.constants.fido_prod_ip
        //         )
        //     ) 
        // )
    );
    
    return SEQUENTIAL(
               
               std.file.CreateSuperFile(superFile, allowExist := true),

               removeOldFiles,

               addAllFiles,
            
               appendToPackageMap
    );

end;
