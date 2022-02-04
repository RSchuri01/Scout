import std;

export fn_copyroxie(string sourceLogicalname) := function

dali_dev  := '10.194.169.1:7070';
dali_prod := '10.194.93.1:7070';

destinationLogicalname := sourceLogicalname + '_roxie';
destinationGroup       := 'roxie_fido_dev';

copy_roxie := STD.File.Copy(sourceLogicalname, 
               destinationGroup , 
               destinationLogicalname, 
                dali_dev,//scrDali ] 
							  ,//timeout ] 
							  ,//espserverIPport ] 
							  ,//maxConnections ] 
							  ,//allowoverwrite ] 
							  ,//replicate ] 
							  true,//asSuperfile ] 
							  true,//compress ] 
							  ,//forcePush ] 
							  ,//transferBufferSize ]
								);
								
return 	copy_roxie;
end;							