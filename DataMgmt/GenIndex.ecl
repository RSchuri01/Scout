IMPORT DataMgmt, SCOUT;
IMPORT Std;

EXPORT GenIndex := MODULE(DataMgmt.Common)

    //--------------------------------------------------------------------------
    // Internal Declarations and Functions
    //--------------------------------------------------------------------------

    SHARED ROXIE_PACKAGEMAP_NAME := 'hipie';
    SHARED DEFAULT_ROXIE_TARGET := 'roxie_prod';
    SHARED DEFAULT_ROXIE_PROCESS := '*';
    EXPORT DALI_LOCK_DELAY := 300; // milliseconds

    SHARED _CleanName(STRING s) := REGEXREPLACE('::+', Std.Str.ToLowerCase(TRIM(Std.Str.FilterOut(s, '~'), LEFT, RIGHT)), '_');
    SHARED _VirtualSuperkeyPathForDataStore(STRING indexStorePath) := 'virtual_' + _CleanName(indexStorePath);
    SHARED _PackageMapNameForQuery(STRING roxieQueryName) := 'query_' + _CleanName(roxieQueryName) + '.pkg';
    SHARED _PackageNameForSuperkeyPath(STRING superkeyPath) := 'data_' + _CleanName(superkeyPath) + '.pkg';
    SHARED _PartNameForSuperkeyPath(STRING superkeyPath) := 'part_' + _CleanName(superkeyPath) + '.pkg';

    SHARED  FilePathLayout := RECORD
        STRING      path;
    END;

    /**
     * Local helper function that creates a Roxie packagemap string that defines
     * the base package names for all datastores that a Roxie query references.
     *
     * @param   roxieQueryName      The name of the Roxie query for which we are
     *                              building this packagemap; REQUIRED
     * @param   superkeyPathList    A dataset in DATASET(FilePathLayout) format
     *                              defining the physical superkeys that the
     *                              query will reference; these physical
     *                              superkey paths will be used to construct
     *                              data package names, which are what are
     *                              actually written to the packagemap;
     *                              REQUIRED
     *
     * @return  String in Roxie packagemap format defining the data packages
     *          that will be created and used to manage the actual superkey
     *          references
     *
     * @see     CreateSuperkeyPackageMapString
     */
    SHARED  CreateRoxieBasePackageMapString(STRING roxieQueryName,
                                            DATASET(FilePathLayout) superkeyPathList) := FUNCTION
        StringRec := RECORD
            STRING  s;
        END;

        // Create packagemap-compatible string fragments that reference the
        // data packages
        basePackageDefinitions := PROJECT
            (
                superkeyPathList,
                TRANSFORM
                    (
                        StringRec,
                        SELF.s := '<Base id="' + _PackageNameForSuperkeyPath(LEFT.path) + '"/>';
                    )
            );

        // Collapse to a single string
        basePackageDefinitionStr := Std.Str.CombineWords((SET OF STRING)SET(basePackageDefinitions, s), '');

        // Wrap the query definition (query package name plus references to
        // data packages)
        queryDefinition := '<Package id="' + roxieQueryName + '">' + basePackageDefinitionStr + '</Package>';

        // Wrap the entire thing up with the right XML tag
        finalDefinition := '<RoxiePackages>' + queryDefinition + '</RoxiePackages>';

        RETURN finalDefinition;
    END;

    /**
     * Local helper function that creates a Roxie packagemap-compatible
     * data package string.  The data package will contain virtual superkey
     * pathnames (which should be used by the Roxie queries to access the
     * indexes) along with individual citations for all physical subkeys
     * given.  The data package itself is referenced by the packagemap
     * created with CreateRoxieBasePackageMapString().
     *
     * @param   indexStorePath          The full path of the generational data
     *                                  store; REQUIRED
     * @param   subkeys                 A dataset in
     *                                  DATASET(Std.File.FsLogicalFileNameRecord)
     *                                  format containing full paths to
     *                                  physical subkeys that should be
     *                                  included in the data package;
     *                                  REQUIRED
     *
     * @return  String in Roxie packagemap format defining the contents of
     *          one data package.
     *
     * @see     CreateRoxieBasePackageMapString
     */
    SHARED CreateSuperkeyPackageMapString(STRING indexStorePath,
                                          DATASET(Std.File.FsLogicalFileNameRecord) subkeys) := FUNCTION
        StringRec := RECORD
            STRING  s;
        END;

        superkeyPath := CurrentPath(indexStorePath);

        // Create packagemap-compatible string fragments that reference the
        // subkeys
        subkeyDefinitions := PROJECT
            (
                subkeys,
                TRANSFORM
                    (
                        StringRec,
                        SELF.s := '<SubFile value="' + LEFT.name + '"/>';
                    )
            );

        // Collapse to a single string
        subkeyDefinitionStr0 := Std.Str.CombineWords((SET OF STRING)SET(subkeyDefinitions, s), '');

        // Make sure an empty subfile tag is included if we have no subkeys
        subkeyDefinitionStr := IF(EXISTS(subkeyDefinitions), subkeyDefinitionStr0, '<SubFile/>');

        // Wrap the subkey declarations in a superfile tag
        superkeyDefinitionStr := '<SuperFile id="' + _VirtualSuperkeyPathForDataStore(indexStorePath) + '">' + subkeyDefinitionStr + '</SuperFile>';

        // Wrap the query definition (query package name plus references to
        // data packages)
        queryDefinition := '<Package id="' + _PackageNameForSuperkeyPath(superkeyPath) + '">' + superkeyDefinitionStr + '</Package>';

        // Wrap the entire thing up with the right XML tag
        finalDefinition := '<RoxiePackages>' + queryDefinition + '</RoxiePackages>';

        RETURN finalDefinition;
    END;

    /**
     * Helper function that adds or updates a packagemap part via web service
     * calls.
     *
     * Note that this function requires HPCC 6.0.0 or later to succeed.
     *
     * This function returns a value but will likely often need to be called
     * in an action context, such as within a SEQUENTIAL set of commands
     * that includes superfile management.  You can wrap the call to this
     * function in an EVALUATE() to allow that construct to work.
     *
     * @param   packagePartName             The name to use when creating this
     *                                      packagemap string, typically from
     *                                      a call to _PartNameForSuperkeyPath();
     *                                      it is important to use the same
     *                                      name when referencing the same
     *                                      data package, as updates are
     *                                      applied at the data package level
     *                                      and they completely override any
     *                                      previous settings; REQUIRED
     * @param   packageMapString            The constructed packagemap string
     *                                      to send; REQUIRED
     * @param   espURL                      The full URL to the ESP service,
     *                                      which is the same as the URL used
     *                                      for ECL Watch; REQUIRED
     * @param   roxieTargetName             The name of the target Roxie that
     *                                      will receive the new packagemap;
     *                                      REQUIRED
     * @param   roxieProcessName            The name of the specific Roxie
     *                                      process to target; REQUIRED
     * @param   sendActivateCommand         If TRUE, an ActivatePackage web
     *                                      service call is made after the
     *                                      packagemap is sent (this is
     *                                      required for some packagemap
     *                                      instantiations, such as those from
     *                                      the CreateRoxieBasePackageMapString()
     *                                      call); REQUIRED
     *
     * @return  A numeric code indicating success (zero = success).
     */
    SHARED AddPackageMapPart(STRING packagePartName,
                             STRING packageMapString,
                             STRING espURL,
                             STRING roxieTargetName,
                             STRING roxieProcessName,
                             BOOLEAN sendActivateCommand) := FUNCTION
        espHost := REGEXREPLACE('/+$', espURL, '');

        StatusRec := RECORD
            INTEGER     code            {XPATH('Code')};
            STRING      description     {XPATH('Description')};
        END;

        addPartToPackageMapResponse := SOAPCALL
            (
                espHost + '/WsPackageProcess/',
                'AddPartToPackageMap',
                {
                    STRING      targetCluster               {XPATH('Target')} := roxieTargetName;
                    STRING      targetProcess               {XPATH('Process')} := roxieProcessName;
                    STRING      packageMapID                {XPATH('PackageMap')} := ROXIE_PACKAGEMAP_NAME;
                    STRING      partName                    {XPATH('PartName')} := packagePartName;
                    STRING      packageMapData              {XPATH('Content')} := packageMapString;
                    BOOLEAN     deletePreviousPackagePart   {XPATH('DeletePrevious')} := TRUE;
                    STRING      daliIP                      {XPATH('DaliIp')} := Std.System.Thorlib.DaliServer();
                },
                StatusRec,
                XPATH('AddPartToPackageMapResponse/status')
            );

        activatePackageResponse := SOAPCALL
            (
                espHost + '/WsPackageProcess/',
                'ActivatePackage',
                {
                    STRING      targetCluster               {XPATH('Target')} := roxieTargetName;
                    STRING      targetProcess               {XPATH('Process')} := roxieProcessName;
                    STRING      packageMapID                {XPATH('PackageMap')} := ROXIE_PACKAGEMAP_NAME;
                },
                StatusRec,
                XPATH('ActivatePackageResponse/status')
            );

        finalResponse := IF
            (
                addPartToPackageMapResponse.code = 0 AND sendActivateCommand,
                activatePackageResponse,
                addPartToPackageMapResponse
            );

        RETURN finalResponse.code;
    END;

    /**
     * Helper function that removes a packagemap part via a web service call.
     *
     * Note that this function requires HPCC 6.0.0 or later to succeed.
     *
     * This function returns a value but will likely often need to be called
     * in an action context, such as within a SEQUENTIAL set of commands
     * that includes superfile management.  You can wrap the call to this
     * function in an EVALUATE() to allow that construct to work.
     *
     * @param   packagePartName             The name of the packagemap part
     *                                      to remove, typically from a call
     *                                      to _PartNameForSuperkeyPath();
     *                                      REQUIRED
     * @param   espURL                      The full URL to the ESP service,
     *                                      which is the same as the URL used
     *                                      for ECL Watch; REQUIRED
     * @param   roxieTargetName             The name of the target Roxie that
     *                                      will receive the new packagemap;
     *                                      REQUIRED
     *
     * @return  A numeric code indicating success (zero = success).
     */
    SHARED RemovePackageMapPart(STRING packagePartName,
                                STRING espURL,
                                STRING roxieTargetName) := FUNCTION
        espHost := REGEXREPLACE('/+$', espURL, '');

        StatusRec := RECORD
            INTEGER     code            {XPATH('Code')};
            STRING      description     {XPATH('Description')};
        END;

        removePartFromPackageMapResponse := SOAPCALL
            (
                espHost + '/WsPackageProcess/',
                'RemovePartFromPackageMap',
                {
                    STRING      targetCluster               {XPATH('Target')} := roxieTargetName;
                    STRING      packageMapID                {XPATH('PackageMap')} := ROXIE_PACKAGEMAP_NAME;
                    STRING      partName                    {XPATH('PartName')} := packagePartName;
                },
                StatusRec,
                XPATH('RemovePartFromPackageMapResponse/status')
            );

        RETURN removePartFromPackageMapResponse.code;
    END;

    /**
     * Helper function that removes the entire packagemap managed by this code.
     *
     * Note that this function requires HPCC 6.0.0 or later to succeed.
     *
     * This function returns a value but will likely often need to be called
     * in an action context, such as within a SEQUENTIAL set of commands
     * that includes superfile management.  You can wrap the call to this
     * function in an EVALUATE() to allow that construct to work.
     *
     * @param   espURL                      The full URL to the ESP service,
     *                                      which is the same as the URL used
     *                                      for ECL Watch; REQUIRED
     * @param   roxieTargetName             The name of the target Roxie that
     *                                      will receive the new packagemap;
     *                                      REQUIRED
     * @param   roxieProcessName            The name of the specific Roxie
     *                                      process to target; REQUIRED
     *
     * @return  A numeric code indicating success (zero = success).
     */
    SHARED RemovePackageMap(STRING espURL,
                            STRING roxieTargetName,
                            STRING roxieProcessName) := FUNCTION
        espHost := REGEXREPLACE('/+$', espURL, '');

        StatusRec := RECORD
            INTEGER     code            {XPATH('Code')};
            STRING      description     {XPATH('Description')};
        END;

        deletePackageResponse := SOAPCALL
            (
                espHost + '/WsPackageProcess/',
                'RemovePartFromPackageMap',
                {
                    STRING      targetCluster               {XPATH('Target')} := roxieTargetName;
                    STRING      targetProcess               {XPATH('Process')} := roxieProcessName;
                    STRING      packageMapID                {XPATH('PackageMap')} := ROXIE_PACKAGEMAP_NAME;
                },
                StatusRec,
                XPATH('DeletePackageResponse/status')
            );

        RETURN deletePackageResponse.code;
    END;

    //--------------------------------------------------------------------------
    // Exported Functions
    //--------------------------------------------------------------------------

    /**
     * Exported helper function that can be used to delay processing while
     * Dali is updating its internal database after an update.  This is
     * particularly important when dealing with locked files.
     *
     * @param   daliDelayMilliseconds   Delay in milliseconds to pause
     *                                  execution; OPTIONAL, defaults to
     *                                  DALI_LOCK_DELAY
     *
     * @return  An ACTION that simply sleeps for a short while.
     */
    EXPORT WaitForDaliUpdate(UNSIGNED2 daliDelayMilliseconds = DALI_LOCK_DELAY) := Std.System.Debug.Sleep(daliDelayMilliseconds);

    /**
     * Function that creates, or recreates, all packagemaps needed that will
     * allow a Roxie query to access the current generation of data in one or
     * more index stores via virtual superkeys.  This function is generally
     * called after Init() is called to create the superkey structure within
     * the index store.
     *
     * @param   roxieQueryName          The name of the Roxie query for which
     *                                  we are building this packagemap;
     *                                  REQUIRED
     * @param   indexStorePaths         A SET OF STRING value containing full
     *                                  paths for every index store that
     *                                  roxieQueryName will reference;
     *                                  REQUIRED
     * @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     * @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     * @param   roxieProcessName        The name of the specific Roxie process
     *                                  to target; OPTIONAL, defaults to '*'
     *                                  (all processes)
     *
     * @return  An ACTION that performs all packagemap initializations via
     *          web service calls.
     */
    EXPORT InitRoxiePackageMap(STRING roxieQueryName,
                               SET OF STRING indexStorePaths,
                               STRING espURL,
                               STRING roxieTargetName = DEFAULT_ROXIE_TARGET,
                               STRING roxieProcessName = DEFAULT_ROXIE_PROCESS) := FUNCTION
        TempRec := RECORD(FilePathLayout)
            STRING                                      indexStorePath;
            DATASET(Std.File.FsLogicalFileNameRecord)   subkeys;
            STRING                                      packageMapStr;
        END;

        withSubkeys := NOTHOR
            (
                PROJECT
                    (
                        GLOBAL(DATASET(indexStorePaths, {STRING s}), FEW),
                        TRANSFORM
                            (
                                TempRec,
                                SELF.indexStorePath := LEFT.s,
                                SELF.path := CurrentPath(LEFT.s),
                                SELF.subkeys := _AllSuperfileContents(SELF.path),
                                SELF.packageMapStr := ''
                            )
                    )
            );

        packagemapNamesOfAllAttributes := 
            PROJECT(
                GLOBAL(DATASET(scout.common.constants.attributesNameList, {STRING s}), FEW),
                TRANSFORM({string packMapName}, SELF.packMapName := scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(LEFT.s))
            );

        allAttributeSubkeys :=  ROLLUP(
                                    withSubkeys(indexStorePath IN SET(packagemapNamesOfAllAttributes, packMapName)),
                                    TRUE,
                                    TRANSFORM(TempRec, SELF.subkeys := LEFT.subkeys + RIGHT.subkeys, SELF:=LEFT)
                                );

        withSubkeys1 := PROJECT(
            DATASET
                    (
                        [
                            {
                                scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(scout.common.constants.key_scorelogs_attributes_keyName),
                                allAttributeSubkeys[1].subkeys,
                                ''
                            }
                        ]
                        ,
                        {TempRec - FilePathLayout}
                    ),
            TRANSFORM(TempRec, SELF := LEFT; SELF.path := CurrentPath(LEFT.indexStorePath))
        );

        withPackageMapStr := PROJECT
            (
                withSubkeys + withSubkeys1,
                TRANSFORM
                    (
                        RECORDOF(LEFT),
                        SELF.packageMapStr := CreateSuperkeyPackageMapString(LEFT.indexStorePath, LEFT.subkeys),
                        SELF := LEFT
                    )
            );

        baseRoxiePackageMapStr := CreateRoxieBasePackageMapString(roxieQueryName, withPackageMapStr);

        createBaseRoxiePackageAction := AddPackageMapPart
            (
                _PackageMapNameForQuery(roxieQueryName),
                baseRoxiePackageMapStr,
                espURL,
                roxieTargetName,
                roxieProcessName,
                sendActivateCommand := TRUE
            );

        createSuperkeyPackagesAction := APPLY
            (
                withPackageMapStr,
                EVALUATE
                    (
                        AddPackageMapPart
                            (
                                _PartNameForSuperkeyPath(path),
                                packageMapStr,
                                espURL,
                                roxieTargetName,
                                roxieProcessName,
                                sendActivateCommand := FALSE
                            )
                    )
            );

        allActions := ORDERED
            (
                createBaseRoxiePackageAction;
                createSuperkeyPackagesAction;
            );

        RETURN allActions;
    END;

    /**
     * Function that removes all packagemaps used for the given Roxie query
     * and all referenced index stores.
     *
     * @param   roxieQueryName          The name of the Roxie query; REQUIRED
     * @param   indexStorePaths         A SET OF STRING value containing full
     *                                  paths for every index store that
     *                                  roxieQueryName references; REQUIRED
     * @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     * @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     *
     * @return  An ACTION that performs all packagemap removals via web
     *          service calls.
     */
    EXPORT RemoveRoxiePackageMap(STRING roxieQueryName,
                                 SET OF STRING indexStorePaths,
                                 STRING espURL,
                                 STRING roxieTargetName = DEFAULT_ROXIE_TARGET) := FUNCTION
        TempRec := RECORD(FilePathLayout)
            STRING                                      indexStorePath;
            DATASET(Std.File.FsLogicalFileNameRecord)   subkeys;
        END;

        withSubkeys := NOTHOR
            (
                PROJECT
                    (
                        GLOBAL(DATASET(indexStorePaths, {STRING s}), FEW),
                        TRANSFORM
                            (
                                TempRec,
                                SELF.indexStorePath := LEFT.s,
                                SELF.path := CurrentPath(LEFT.s),
                                SELF.subkeys := DATASET([], Std.File.FsLogicalFileNameRecord)
                            )
                    )
            );

        baseRoxiePackageMapStr := CreateRoxieBasePackageMapString(roxieQueryName, withSubkeys);

        removeBaseRoxiePackageAction := RemovePackageMapPart
            (
                _PackageMapNameForQuery(roxieQueryName),
                espURL,
                roxieTargetName
            );

        removeSuperkeyPackagesAction := APPLY
            (
                withSubkeys,
                EVALUATE
                    (
                        RemovePackageMapPart
                            (
                                _PartNameForSuperkeyPath(path),
                                espURL,
                                roxieTargetName
                            )
                    )
            );

        allActions := ORDERED
            (
                removeSuperkeyPackagesAction;
                removeBaseRoxiePackageAction;
            );

        RETURN allActions;
    END;

    /**
     * Function removes all packagemaps maintained by this bundle.
     *
     * @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     * @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     * @param   roxieProcessName        The name of the specific Roxie process
     *                                  to target; OPTIONAL, defaults to '*'
     *                                  (all processes)
     *
     * @return  An ACTION that performs removes the packagemap maintained by
     *          this bundle via web service calls.
     */
    EXPORT DeleteManagedRoxiePackageMap(STRING espURL,
                                        STRING roxieTargetName = DEFAULT_ROXIE_TARGET,
                                        STRING roxieProcessName = DEFAULT_ROXIE_PROCESS) := FUNCTION
        RETURN EVALUATE(RemovePackageMap(espURL, roxieTargetName, roxieProcessName));
    END;

    /**
     * Return a virtual superkey path that references the current generation
     * of data managed by an index store.  Roxie queries should use virtual
     * superkeys when accessing indexes in order to always read the most up
     * to date data.
     *
     * @param   indexStorePath  The full path of the generational index store;
     *                          REQUIRED
     *
     * @return  A STRING that can be used by Roxie queries to access the current
     *          generation of data within an index store.
     */
    EXPORT VirtualSuperkeyPath(STRING indexStorePath) := _VirtualSuperkeyPathForDataStore(indexStorePath);

    /**
     * Construct a path for a new index for the index store.  Note that
     * the returned value will have time-oriented components in it, therefore
     * callers should probably mark the returned value as INDEPENDENT if name
     * will be used more than once (say, creating the index via BUILD and then
     * calling WriteSubkey() here to store it) to avoid a recomputation of
     * the name.
     *
     * @param   indexStorePath  The full path of the generational index store;
     *                          REQUIRED
     *
     * @return  A STRING representing a new index that may be added to the
     *          index store.
     */
    EXPORT NewSubkeyPath(STRING indexStorePath) := _NewSubfilePath(indexStorePath);

    /**
     * Function updates the data package associated with the current generation
     * of the given index store.  The current generation's file contents are
     * used to create the data package.
     *
     * This function assumes that a base packagemap for queries using this
     * index store has already been created, such as with InitRoxiePackageMap().
     *
     * @param   indexStorePath          The full path of the generational index
     *                                  store; REQUIRED
     * @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     * @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     * @param   roxieProcessName        The name of the specific Roxie process
     *                                  to target; OPTIONAL, defaults to '*'
     *                                  (all processes)
     *
     * @return  An ACTION that updates the data package representing the data
     *          store's current generation of data.
     */
    EXPORT UpdateRoxie(STRING indexStorePath,
                       STRING espURL,
                       STRING roxieTargetName = DEFAULT_ROXIE_TARGET,
                       STRING roxieProcessName = DEFAULT_ROXIE_PROCESS) := FUNCTION
        dataPath := CurrentPath(indexStorePath);
        subkeys := NOTHOR(_AllSuperfileContents(NOFOLD(dataPath)));
        packageMapStr := CreateSuperkeyPackageMapString(indexStorePath, subkeys);
        updateAction := EVALUATE
            (
                AddPackageMapPart
                    (
                        _PartNameForSuperkeyPath(dataPath),
                        packageMapStr,
                        espURL,
                        roxieTargetName,
                        roxieProcessName,
                        sendActivateCommand := FALSE
                    )
            );

        RETURN updateAction;
    END;
    /**
     *  UpdateAttributesSubKeys helps to update the packageMapPart for master attributes
     *  it Reads all the attribute superkeys below to master AttributeKey, and extracts their
     *  subKeys, and the packageMapPart is built for attributekey with all those subkeys together
     *  and the PackageMapPart will be updated in Scout PackageMap XML
     *  @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     *  @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     *  @param   roxieProcessName        The name of the specific Roxie process
     *                                  to target; OPTIONAL, defaults to '*'
     *                                  (all processes)
     *
     *  @return  An ACTION that updates the data package representing the data
     *          store's current generation of data.
     **/
    EXPORT UpdateAttributesSubKeys(STRING espURL,
                       STRING roxieTargetName = DEFAULT_ROXIE_TARGET,
                       STRING roxieProcessName = DEFAULT_ROXIE_PROCESS) := FUNCTION

        TempRec := RECORD(FilePathLayout)
            STRING                                      indexStorePath;
            DATASET(Std.File.FsLogicalFileNameRecord)   subkeys;
            STRING                                      packageMapStr;
        END;

        withSubkeys := NOTHOR
            (
                PROJECT
                    (
                        GLOBAL(DATASET(Scout.common.constants.attributesNameList, {STRING s}), FEW),
                        TRANSFORM
                            (
                                TempRec,
                                SELF.indexStorePath := scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(LEFT.s ),
                                
                                SELF.path := CurrentPath(SELF.indexStorePath),
                                SELF.subkeys :=  _AllSuperfileContents(SELF.path),
                                SELF.packageMapStr := ''
                            )
                    )
            );

        packagemapNamesOfAllAttributes := 
            PROJECT(
                GLOBAL(DATASET(scout.common.constants.attributesNameList, {STRING s}), FEW),
                TRANSFORM({string packMapName}, SELF.packMapName := scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(LEFT.s))
            );

        allAttributeSubkeys :=  ROLLUP(
                                    withSubkeys(indexStorePath IN SET(packagemapNamesOfAllAttributes, packMapName)),
                                    TRUE,
                                    TRANSFORM(TempRec, SELF.subkeys := LEFT.subkeys + RIGHT.subkeys, SELF:=LEFT)
                                );

        withSubkeys1 := PROJECT(
            DATASET
                    (
                        [
                            {
                                scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(scout.common.constants.key_scorelogs_attributes_keyName),
                                allAttributeSubkeys[1].subkeys,
                                ''
                            }
                        ]
                        ,
                        {TempRec - FilePathLayout}
                    ),
            TRANSFORM(TempRec, SELF := LEFT; SELF.path := CurrentPath(LEFT.indexStorePath))
        );

        packageMapStr := CreateSuperkeyPackageMapString(withSubkeys1[1].indexStorePath, withSubkeys1[1].subkeys);

        updateAction := EVALUATE
            (
                AddPackageMapPart
                    (
                        _PartNameForSuperkeyPath(CurrentPath(withSubkeys1[1].indexStorePath)),
                        packageMapStr,
                        espURL,
                        roxieTargetName,
                        roxieProcessName,
                        sendActivateCommand := FALSE
                    )
            );

        RETURN updateAction;
    END;
    /**
     * Make the given subkey the first generation of index for the index store,
     * bump all existing generations of subkeys to the next level, then update
     * the associated data package with the contents of the first generation.
     * Any subkeys stored in the last generation will be deleted.
     *
     * This function assumes that a base packagemap for queries using this
     * index store has already been created, such as with InitRoxiePackageMap().
     *
     * @param   indexStorePath          The full path of the generational index
     *                                  store; REQUIRED
     * @param   newSubkeyPath           The full path of the new subkey to
     *                                  insert into the index store as the new
     *                                  current generation of data; REQUIRED
     * @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     * @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     * @param   roxieProcessName        The name of the specific Roxie process
     *                                  to target; OPTIONAL, defaults to '*'
     *                                  (all processes)
     * @param   daliDelayMilliseconds   Delay in milliseconds to pause
     *                                  execution; OPTIONAL, defaults to
     *                                  DALI_LOCK_DELAY
     *
     * @return  An ACTION that inserts the given subkey into the index store.
     *          Existing generations of subkeys are bumped to the next
     *          generation, and any subkey(s) stored in the last generation will
     *          be deleted.
     *
     * @see     AppendSubkey
     */
    EXPORT WriteSubkey(STRING indexStorePath,
                       STRING newSubkeyPath,
                       STRING espURL,
                       STRING roxieTargetName = DEFAULT_ROXIE_TARGET,
                       STRING roxieProcessName = DEFAULT_ROXIE_PROCESS,
                       UNSIGNED2 daliDelayMilliseconds = DALI_LOCK_DELAY) := FUNCTION
        dataPath := CurrentPath(indexStorePath);
        subkeys := DATASET([newSubkeyPath], Std.File.FsLogicalFileNameRecord);
        packageMapStr := NOTHOR(CreateSuperkeyPackageMapString(indexStorePath, subkeys));
        updateAction := EVALUATE
            (
                AddPackageMapPart
                    (
                        _PartNameForSuperkeyPath(dataPath),
                        packageMapStr,
                        espURL,
                        roxieTargetName,
                        roxieProcessName,
                        sendActivateCommand := FALSE
                    )
            );
        promoteAction := _WriteFile(indexStorePath, newSubkeyPath);
        allActions := SEQUENTIAL
            (
                IF(espURL != '', ORDERED(updateAction, WaitForDaliUpdate(daliDelayMilliseconds)));
                promoteAction;
            );

        RETURN allActions;
    END;

    /**
     * Adds the given subkey to the first generation of subkeys for the index
     * store.  This does not replace any existing subkey, nor bump any subkey
     * generations to another level.  The record structure of the new subkey
     * must be the same as the other subkeys in the index store.
     *
     * This function assumes that a base packagemap for queries using this
     * index store has already been created, such as with InitRoxiePackageMap().
     *
     * @param   indexStorePath          The full path of the generational index
     *                                  store; REQUIRED
     * @param   newSubkeyPath           The full path of the new subkey to
     *                                  append to the current generation of
     *                                  subkeys; REQUIRED
     * @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     * @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     * @param   roxieProcessName        The name of the specific Roxie process
     *                                  to target; OPTIONAL, defaults to '*'
     *                                  (all processes)
     *
     * @return  An ACTION that appends the given subkey to the current
     *          generation of subkeys.
     *
     * @see     WriteSubkey
     */
    EXPORT AppendSubkey(STRING indexStorePath,
                        STRING newSubkeyPath,
                        STRING espURL,
                        STRING roxieTargetName = DEFAULT_ROXIE_TARGET,
                        STRING roxieProcessName = DEFAULT_ROXIE_PROCESS) := FUNCTION
        updateRoxieAction := UpdateRoxie(indexStorePath, espURL, roxieTargetName, roxieProcessName);
        promoteAction := _AppendFile(indexStorePath, newSubkeyPath);
        allActions := SEQUENTIAL
            (
                promoteAction;
                IF(espURL != '', updateRoxieAction);
            );

        RETURN allActions;
    END;

    /**
     * Method promotes all subkeys associated with the first generation into the
     * second, promotes the second to the third, and so on.  The first
     * generation of subkeys will be empty after this method completes.
     *
     * Note that if you have multiple subkeys associated with a generation,
     * as via AppendSubkey(), all of those subkeys will be deleted
     * or moved as appropriate.
     *
     * This function assumes that a base packagemap for queries using this
     * index store has already been created, such as with InitRoxiePackageMap().
     *
     * @param   indexStorePath          The full path of the generational index
     *                                  store; REQUIRED
     * @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     * @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     * @param   roxieProcessName        The name of the specific Roxie process
     *                                  to target; OPTIONAL, defaults to '*'
     *                                  (all processes)
     * @param   daliDelayMilliseconds   Delay in milliseconds to pause
     *                                  execution; OPTIONAL, defaults to
     *                                  DALI_LOCK_DELAY
     *
     * @return  An ACTION that performs the generational promotion.
     *
     * @see     RollbackGeneration
     */
    EXPORT PromoteGeneration(STRING indexStorePath,
                             STRING espURL,
                             STRING roxieTargetName = DEFAULT_ROXIE_TARGET,
                             STRING roxieProcessName = DEFAULT_ROXIE_PROCESS,
                             UNSIGNED2 daliDelayMilliseconds = DALI_LOCK_DELAY) := FUNCTION
        dataPath := CurrentPath(indexStorePath);
        subkeys := DATASET([], Std.File.FsLogicalFileNameRecord);
        packageMapStr := NOTHOR(CreateSuperkeyPackageMapString(indexStorePath, subkeys));
        updateAction := EVALUATE
            (
                AddPackageMapPart
                    (
                        _PartNameForSuperkeyPath(dataPath),
                        packageMapStr,
                        espURL,
                        roxieTargetName,
                        roxieProcessName,
                        sendActivateCommand := FALSE
                    )
            );
        promoteAction := _PromoteGeneration(indexStorePath);
        allActions := SEQUENTIAL
            (
                IF(espURL != '', ORDERED(updateAction, WaitForDaliUpdate(daliDelayMilliseconds)));
                promoteAction;
            );

        RETURN allActions;
    END;

    /**
     * Method deletes all subkeys associated with the current (first)
     * generation, moves the second generation of subkeys into the first
     * generation, then repeats the process for any remaining generations.  This
     * functionality can be thought of as restoring older version of subkeys
     * to the current generation.
     *
     * Note that if you have multiple subkeys associated with a generation,
     * as via AppendSubkey(), all of those subkeys will be deleted
     * or moved as appropriate.
     *
     * This function assumes that a base packagemap for queries using this
     * index store has already been created, such as with InitRoxiePackageMap().
     *
     * @param   indexStorePath          The full path of the generational index
     *                                  store; REQUIRED
     * @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     * @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     * @param   roxieProcessName        The name of the specific Roxie process
     *                                  to target; OPTIONAL, defaults to '*'
     *                                  (all processes)
     * @param   daliDelayMilliseconds   Delay in milliseconds to pause
     *                                  execution; OPTIONAL, defaults to
     *                                  DALI_LOCK_DELAY
     *
     * @return  An ACTION that performs the generational rollback.
     *
     * @see     PromoteGeneration
     */
    EXPORT RollbackGeneration(STRING indexStorePath,
                              STRING espURL,
                              STRING roxieTargetName = DEFAULT_ROXIE_TARGET,
                              STRING roxieProcessName = DEFAULT_ROXIE_PROCESS,
                              UNSIGNED2 daliDelayMilliseconds = DALI_LOCK_DELAY) := FUNCTION
        dataPath := CurrentPath(indexStorePath);
        emptySubkeys := DATASET([], Std.File.FsLogicalFileNameRecord);
        emptySubkeysPackageMapStr := CreateSuperkeyPackageMapString(indexStorePath, emptySubkeys);
        emptySubkeysUpdateAction := EVALUATE
            (
                AddPackageMapPart
                    (
                        _PartNameForSuperkeyPath(dataPath),
                        emptySubkeysPackageMapStr,
                        espURL,
                        roxieTargetName,
                        roxieProcessName,
                        sendActivateCommand := FALSE
                    )
            );
        rollbackAction := _RollbackGeneration(indexStorePath);
        postRollbackSubkeys := NOTHOR(_AllSuperfileContents(dataPath));
        postRollbackPackageMapStr := CreateSuperkeyPackageMapString(indexStorePath, postRollbackSubkeys);
        postRollbackUpdateAction := EVALUATE
            (
                AddPackageMapPart
                    (
                        _PartNameForSuperkeyPath(dataPath),
                        postRollbackPackageMapStr,
                        espURL,
                        roxieTargetName,
                        roxieProcessName,
                        sendActivateCommand := FALSE
                    )
            );
        allActions := SEQUENTIAL
            (
                IF(espURL != '', ORDERED(emptySubkeysUpdateAction, WaitForDaliUpdate(daliDelayMilliseconds)));
                rollbackAction;
                IF(espURL != '', postRollbackUpdateAction);
            );

        RETURN allActions;
    END;

    /**
     * Delete all subkeys associated with the index store, from all generations,
     * but leave the surrounding superkey structure intact.
     *
     * This function assumes that a base packagemap for queries using this
     * index store has already been created, such as with InitRoxiePackageMap().
     *
     * @param   indexStorePath          The full path of the generational index
     *                                  store; REQUIRED
     * @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     * @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     * @param   roxieProcessName        The name of the specific Roxie process
     *                                  to target; OPTIONAL, defaults to '*'
     *                                  (all processes)
     * @param   daliDelayMilliseconds   Delay in milliseconds to pause
     *                                  execution; OPTIONAL, defaults to
     *                                  DALI_LOCK_DELAY
     *
     * @return  An ACTION performing the delete operations.
     *
     * @see     DeleteAll
     */
    EXPORT ClearAll(STRING indexStorePath,
                    STRING espURL,
                    STRING roxieTargetName = DEFAULT_ROXIE_TARGET,
                    STRING roxieProcessName = DEFAULT_ROXIE_PROCESS,
                    UNSIGNED2 daliDelayMilliseconds = DALI_LOCK_DELAY) := FUNCTION
        subkeysToDelete := NOTHOR
            (
                PROJECT
                    (
                        NOTHOR(_AllSuperfileContents(indexStorePath)),
                        TRANSFORM
                            (
                                {
                                    STRING  owner,
                                    STRING  subkey
                                },
                                SELF.subkey := '~' + LEFT.name,
                                SELF.owner := '~' + Std.File.LogicalFileSuperOwners(SELF.subkey)[1].name
                            )
                    )
            );
        removeOldSubkeysAction := NOTHOR
            (
                APPLY
                    (
                        GLOBAL(subkeysToDelete, FEW),
                        Std.File.RemoveSuperFile(owner, subkey, del := TRUE)
                    )
            );
        dataPath := CurrentPath(indexStorePath);
        subkeys := DATASET([], Std.File.FsLogicalFileNameRecord);
        packageMapStr := NOTHOR(CreateSuperkeyPackageMapString(indexStorePath, subkeys));
        updateAction := EVALUATE
            (
                AddPackageMapPart
                    (
                        _PartNameForSuperkeyPath(dataPath),
                        packageMapStr,
                        espURL,
                        roxieTargetName,
                        roxieProcessName,
                        sendActivateCommand := FALSE
                    )
            );
        allActions := SEQUENTIAL
            (
                IF(espURL != '', ORDERED(updateAction, WaitForDaliUpdate(daliDelayMilliseconds)));
                removeOldSubkeysAction;
            );

        RETURN allActions;
    END;

    /**
     * Delete generational index store and all referenced subkeys.  This
     * function also updates the packagemap so that it references no subkeys.
     *
     * This function assumes that a base packagemap for queries using this
     * index store has already been created, such as with InitRoxiePackageMap().
     *
     * @param   indexStorePath          The full path of the generational index
     *                                  store; REQUIRED
     * @param   espURL                  The URL to the ESP service on the
     *                                  cluster, which is the same URL as used
     *                                  for ECL Watch; REQUIRED
     * @param   roxieTargetName         The name of the Roxie cluster to send
     *                                  the information to; OPTIONAL, defaults
     *                                  to 'roxie'
     * @param   roxieProcessName        The name of the specific Roxie process
     *                                  to target; OPTIONAL, defaults to '*'
     *                                  (all processes)
     *
     * @return  An action performing the delete operations.
     *
     * @see     ClearAll
     */
    EXPORT DeleteAll(STRING indexStorePath,
                     STRING espURL,
                     STRING roxieTargetName = DEFAULT_ROXIE_TARGET,
                     STRING roxieProcessName = DEFAULT_ROXIE_PROCESS) := FUNCTION
        clearAction := ClearAll(indexStorePath, espURL, roxieTargetName, roxieProcessName);
        deleteAction := _DeleteAll(indexStorePath);
        allActions := SEQUENTIAL
            (
                clearAction;
                deleteAction;
            );

        RETURN allActions;
    END;

    //--------------------------------------------------------------------------

    EXPORT Tests(STRING test_esp_url) := MODULE

        SHARED indexStoreName := '~genindex::test::' + Std.System.Job.WUID();
        SHARED numGens := 5;
        SHARED testRoxieQueryName := '_test_roxie_query_name';

        SHARED subkeyPath := NewSubkeyPath(indexStoreName) : INDEPENDENT;

        SHARED TestRec := {INTEGER1 n};
        SHARED TestIDX(DATASET(TestRec) ds, STRING path) := INDEX(ds, {n}, {}, path);
        SHARED CurrentIDX := INDEX({TestRec.n}, {}, DataMgmt.Common.CurrentPath(indexStoreName), OPT);

        SHARED testInit := SEQUENTIAL
            (
                Init(indexStoreName, numGens);
                IF(test_esp_url != '', InitRoxiePackageMap(testRoxieQueryName, [indexStoreName], test_esp_url));
                EVALUATE(NumGenerationsAvailable(indexStoreName));
                TRUE;
            );

        SHARED testInsertFile1 := FUNCTION
            ds1 := DATASET(10, TRANSFORM(TestRec, SELF.n := RANDOM()));
            idx1Path := subkeyPath + '-testInsertFile1';
            idx1 := TestIDX(ds1, idx1Path);

            RETURN SEQUENTIAL
                (
                    BUILD(idx1);
                    WriteSubkey(indexStoreName, idx1Path, test_esp_url);
                    ASSERT(DataMgmt.Common.NumGenerationsInUse(indexStoreName) = 1);
                    ASSERT(COUNT(CurrentIDX) = 10)
                );
        END;

        SHARED testInsertFile2 := FUNCTION
            ds2 := DATASET(20, TRANSFORM(TestRec, SELF.n := RANDOM()));
            idx2Path := subkeyPath + '-testInsertFile2';
            idx2 := TestIDX(ds2, idx2Path);

            RETURN SEQUENTIAL
                (
                    BUILD(idx2);
                    WriteSubkey(indexStoreName, idx2Path, test_esp_url);
                    ASSERT(DataMgmt.Common.NumGenerationsInUse(indexStoreName) = 2);
                    ASSERT(COUNT(CurrentIDX) = 20)
                );
        END;

        SHARED testAppendFile1 := FUNCTION
            ds3 := DATASET(15, TRANSFORM(TestRec, SELF.n := RANDOM()));
            idx3Path := subkeyPath + '-testAppendFile1';
            idx3 := TestIDX(ds3, idx3Path);

            RETURN SEQUENTIAL
                (
                    BUILD(idx3);
                    AppendSubkey(indexStoreName, idx3Path, test_esp_url);
                    ASSERT(DataMgmt.Common.NumGenerationsInUse(indexStoreName) = 2);
                    ASSERT(COUNT(CurrentIDX) = 35)
                );
        END;

        SHARED testPromote := SEQUENTIAL
            (
                PromoteGeneration(indexStoreName, test_esp_url);
                ASSERT(DataMgmt.Common.NumGenerationsInUse(indexStoreName) = 3);
                ASSERT(NOT EXISTS(CurrentIDX))
            );

        SHARED testRollback1 := SEQUENTIAL
            (
                RollbackGeneration(indexStoreName, test_esp_url);
                ASSERT(DataMgmt.Common.NumGenerationsInUse(indexStoreName) = 2);
                ASSERT(COUNT(CurrentIDX) = 35)
            );

        SHARED testRollback2 := SEQUENTIAL
            (
                RollbackGeneration(indexStoreName, test_esp_url);
                ASSERT(DataMgmt.Common.NumGenerationsInUse(indexStoreName) = 1);
                ASSERT(COUNT(CurrentIDX) = 10)
            );

        SHARED testClearAll := SEQUENTIAL
            (
                ClearAll(indexStoreName, test_esp_url);
                ASSERT(DataMgmt.Common.NumGenerationsInUse(indexStoreName) = 0);
            );

        SHARED testDeleteAll := SEQUENTIAL
            (
                DeleteAll(indexStoreName, test_esp_url);
                ASSERT(NOT Std.File.SuperFileExists(indexStoreName));
            );

        SHARED removePackagemapPart := SEQUENTIAL
            (
                IF(test_esp_url != '', RemoveRoxiePackageMap(testRoxieQueryName, [indexStoreName], test_esp_url ));
            );

        EXPORT DoAll := SEQUENTIAL
            (
                testInit;
                Std.System.Debug.Sleep(DALI_LOCK_DELAY);
                testInsertFile1;
                Std.System.Debug.Sleep(DALI_LOCK_DELAY);
                testInsertFile2;
                Std.System.Debug.Sleep(DALI_LOCK_DELAY);
                testAppendFile1;
                Std.System.Debug.Sleep(DALI_LOCK_DELAY);
                testPromote;
                Std.System.Debug.Sleep(DALI_LOCK_DELAY);
                testRollback1;
                Std.System.Debug.Sleep(DALI_LOCK_DELAY);
                testRollback2;
                Std.System.Debug.Sleep(DALI_LOCK_DELAY);
                testClearAll;
                Std.System.Debug.Sleep(DALI_LOCK_DELAY);
                testDeleteAll;
                Std.System.Debug.Sleep(DALI_LOCK_DELAY);
                removePackagemapPart;
            );
    END;

END;