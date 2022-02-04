IMPORT SCOUT;

tableInput := Table(
    
    SCOUT.logs.keys.attributes.riskviewalertcode_Attr.superFileData()(datetime[1..6] = '201808'),
    {transaction_id , dt := datetime[1..8]},
    transaction_id , datetime[1..8]
);

Table(

    tableInput,
    {dt, count(group)},
    dt
);

#STORED('filedate', '20180801');

inputDs := scout.logs.files_stg.online_daily_stg_ds;

tblOut := Table(

    inputDs,
    {esp_method, datetime[1..8], count(group)},
    esp_method, datetime[1..8]
);

OUtput(tblOut, ,'~scout::key::test::missing::attributes', overwrite, EXPIRE(1));

