IMPORT SCOUT;

EXPORT ReInitPackageMapsForScoutQueries := 
sequential(
    scout.logs.RemovePackageMapsForScoutQueries,
    scout.logs.InitPackageMapsForScoutQueries
);
    