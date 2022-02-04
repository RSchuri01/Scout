import scout;
ExtractsResultsFromWUByWS(STRING clusterIP, STRING WuId) := FUNCTION

    nameattrrec := record
        string name {xpath('@name')};
    end;
    
    datasetdsrec := record
        dataset(nameattrrec) names {xpath('/Dataset')};
    end;
    
    resultDsrec := record
        datasetdsrec Result {xpath('Result')};
    end;
    
    StatusRec := RECORD
        String Results {xpath('Results')};
        String wuid {xpath('Wuid')};
    END;

    WUresultsresponse := SOAPCALL
        (
            clusterIP + '/WsWorkunits/',
            'WUFullResult',
            {
                STRING      Wuid               {XPATH('Wuid')} := WuId;
            },
            StatusRec,
            XPATH('WUFullResultResponse')
        );
                                                                                                
    wuResponse := FROMXML(resultDsrec, '<Row>' + WUresultsresponse.Results + '</Row>');

    RETURN wuResponse.Result.names;//[COUNT(wuResponse.Result.names)];

END;

wuResults := ExtractsResultsFromWUByWS( scout.common.constants.fido_dev_ip, 'W20180330-112758');

// wuResults[LENGTH(WuResults)];

wuResults;

COUNT(wuResults);
