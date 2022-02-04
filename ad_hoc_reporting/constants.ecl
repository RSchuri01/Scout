﻿
EXPORT constants := MODULE
  /* *******************************************************************************
   *  Blocked Accounts - Any LoginID that is in this list will not be pulled       *
   * from the logs.  These are largely test Login ID's that are useless counts.    *
   ******************************************************************************* */
  /********************************************************************************
   * THESE MUST ALL BE LOWERCASE IN ORDER TO PROPERLY WORK!!!!!                   *
  ******************************************************************************* */
  
    EXPORT IgnoredLogins := ['', 'webapp_roxie_test', 'webapp_roxie_qateam', 'etradetestxml', 'cp_api_iidqa3cb', 'msoftdevxml'];

    EXPORT IgnoredAccountIDs := [1005199, 1006061, 	1338645,1518852,1739057,1739097,1519022,1315061,1695840,1518932,1215930,1518862,1469904,1547976,
		1513012,1351635,1536030,1228764,1371375,1556505,1739087,1351705,1594670,1514202,1518812,
		1639440,1519012,1474324,1007104,1541752,1395854,1581950,1341435,1701277,1028725,1383514,
		1518912,1575120,1013745,1516032,1323255,1557506,6664923,1028726,1446858,1514482,1338645,
		1339454,1737807,1514452,1691410,1755937,1495875,1689190,1469887,1006061,1483815,1534616,
		1493070,1512015,1217530, 2, 101570 ];

END;